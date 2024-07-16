# frozen_string_literal: true

require 'addressable/template'
require 'faraday'
require 'faraday/multipart'
require 'json'
require 'logger'

module Eversign
  class FileNotFoundException < StandardError
  end

  class Client
    attr_accessor :access_key
    attr_accessor :base_uri
    attr_accessor :business_id
    attr_accessor :token

    def initialize(access_key = Eversign.configuration.access_key)
      self.base_uri = Eversign.configuration.api_base || 'https://api.eversign.com'
      if access_key.start_with?('Bearer ')
        set_oauth_access_token(access_key)
      else
        self.access_key = access_key
      end
      self.business_id = Eversign.configuration.business_id
    end

    def set_oauth_access_token(oauthtoken)
      self.token =
        if oauthtoken.startswith('Bearer ')
          oauthtoken
        else
          "Bearer #{oauthtoken}"
        end
      get_businesses
    end

    def generate_oauth_authorization_url(options)
      check_arguments(%w[client_id state], options)
      template = Addressable::Template.new("#{Eversign.configuration.oauth_base}/authorize{?clinet_id,state}")
      return template.partial_expand(clinet_id: options['client_id'], state: options['state']).pattern
    end

    def request_oauth_token(options)
      check_arguments(%w[client_id client_secret code state], options)

      req = execute_request(:post, '/token', options)
      if req.status == 200
        response_obj = JSON.parse(req.body)

        raise(response_obj['message']) if response_obj.key?('success')

        return response_obj['access_token']

      end
      raise('no success')
    end

    def get_businesses
      response = execute_request(:get, "/api/business?access_key=#{access_key}")
      extract_response(response.body, Eversign::Mappings::Business)
    end

    def get_all_documents
      get_documents('all')
    end

    def get_completed_documents
      get_documents('completed')
    end

    def get_draft_documents
      get_documents('drafts')
    end

    def get_cancelled_documents
      get_documents('cancelled')
    end

    def get_action_required_documents
      get_documents('my_action_required')
    end

    def get_waiting_for_others_documents
      get_documents('waiting_for_others')
    end

    def get_templates
      get_documents('templates')
    end

    def get_archived_templates
      get_documents('templates_archived')
    end

    def get_draft_templates
      get_documents('template_draft')
    end

    def get_document(document_hash)
      path = "/api/document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}"
      response = execute_request(:get, path)
      extract_response(response.body, Eversign::Mappings::Document)
    end

    def create_document(document)
      document.files&.each do |file|
        next unless file.file_url

        file_response = upload_file(file.file_url)
        file.file_url = nil
        file.file_id = file_response.file_id
      end

      path = "/api/document?access_key=#{access_key}&business_id=#{business_id}"
      data = Eversign::Mappings::Document.representation_for(document)
      response = execute_request(:post, path, data)
      extract_response(response.body, Eversign::Mappings::Document)
    end

    def create_document_from_template(template)
      create_document(template)
    end

    def delete_document(document_hash)
      path = "/api/document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}"
      delete(path, document_hash)
    end

    def cancel_document(document_hash)
      path = "/api/document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}&cancel=1"
      delete(path, document_hash)
    end

    def download_raw_document_to_path(document_hash, path)
      sub_uri =
        "/api/download_raw_document?access_key=#{access_key}&business_id=#{business_id}&document_hash=#{document_hash}"
      download(sub_uri, path)
    end

    def download_final_document_to_path(document_hash, path, audit_trail = 1)
      sub_uri = [
        "/api/download_final_document?access_key=#{access_key}&business_id=#{business_id}&document_hash=",
        "#{document_hash}&audit_trail=#{audit_trail}"
      ].join('')
      download(sub_uri, path)
    end

    def upload_file(file_path)
      payload = { upload: Faraday::UploadIO.new(file_path, 'text/plain') }
      path = "/api/file?access_key=#{access_key}&business_id=#{business_id}"
      response = execute_request(:post, path, payload, true)
      extract_response(response.body, Eversign::Mappings::File)
    end

    def send_reminder_for_document(document_hash, signer_id)
      path = "/api/send_reminder?access_key=#{access_key}&business_id=#{business_id}"
      response = execute_request(:post, path, { document_hash: document_hash, signer_id: signer_id }.to_json)
      eval(response.body)[:success] ? true : extract_response(response.body)
    end

    private

      def execute_request(method, path, body = nil, multipart = false)
        @faraday ||= Faraday.new(base_uri) do |conn|
          conn.headers = {}
          conn.headers['User-Agent'] = 'Eversign_Ruby_SDK'
          conn.headers['Authorization'] = token if token
          conn.request(:multipart) if multipart
          conn.adapter(:net_http)
        end

        @faraday.__send__(method) do |request|
          request.url(path)
          request.body = body if body
        end
      end

      def check_arguments(arguments = [], options = {})
        arguments.each do |argument|
          raise("Please specify #{argument}") unless options.has_key?(argument.to_sym)
        end
      end

      def delete(path, _document_hash)
        response = execute_request(:delete, path)
        eval(response.body)[:success] ? true : extract_response(response.body)
      end

      def download(sub_uri, path)
        response = execute_request(:get, sub_uri)
        File.binwrite(path, response.body)
      end

      def get_documents(doc_type)
        path = "/api/document?access_key=#{access_key}&business_id=#{business_id}&type=#{doc_type}"
        response = execute_request(:get, path)
        extract_response(response.body, Eversign::Mappings::Document)
      end

      def extract_response(body, mapping = nil)
        data = JSON.parse(body)
        if data.is_a?(Array)
          mapping.extract_collection(body, nil)
        elsif data.key?('success')
          Eversign::Mappings::Exception.extract_single(body, nil)
        else
          mapping.extract_single(body, nil)
        end
      end
  end
end
