# frozen_string_literal: true

module Eversign
  module Models
    class Document
      attr_accessor :document_hash
      attr_accessor :template_id
      attr_accessor :sandbox
      attr_accessor :is_draft
      attr_accessor :title
      attr_accessor :message
      attr_accessor :use_signer_order
      attr_accessor :reminders
      attr_accessor :require_all_signers
      attr_accessor :redirect
      attr_accessor :redirect_decline
      attr_accessor :client
      attr_accessor :expires
      attr_accessor :embedded_signing_enabled
      attr_accessor :requester_email
      attr_accessor :is_template
      attr_accessor :is_completed
      attr_accessor :is_archived
      attr_accessor :is_deleted
      attr_accessor :is_trashed
      attr_accessor :is_cancelled
      attr_accessor :embedded
      attr_accessor :in_person
      attr_accessor :permission
      attr_accessor :files
      attr_accessor :signers
      attr_accessor :recipients
      attr_accessor :meta
      attr_accessor :fields
      attr_accessor :use_hidden_tags

      def add_file(file)
        self.files ||= []
        self.files << file
      end

      def add_field(field)
        add_field_list([field])
      end

      def add_field_list(field_list)
        self.fields ||= []
        self.fields << field_list
      end

      def add_recipient(recipient)
        self.recipients ||= []
        self.recipients << recipient
      end

      def add_signer(signer)
        self.signers ||= []
        self.signers << signer
      end
    end
  end
end
