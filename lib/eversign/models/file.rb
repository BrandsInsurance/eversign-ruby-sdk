# frozen_string_literal: true

require 'active_model'
module Eversign
  module Models
    class File
      include ActiveModel::Validations

      validate :only_one_option

      attr_accessor :name
      attr_accessor :file_id
      attr_accessor :file_url
      attr_accessor :file_base64
      attr_accessor :pages
      attr_accessor :total_pages

      def initialize(name = nil)
        self.name = name
      end

      def only_one_option
        error =
          if file_id && !file_id.empty?
            file_url || file_base64
          elsif file_url && !file_url.empty?
            file_id || file_base64
          elsif file_base64 && !file_base64.empty?
            file_id || file_url
          else
            true
          end
        errors.add('Please provide only one file option') if error
      end
    end
  end
end
