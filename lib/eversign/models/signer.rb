module Eversign
  module Models
    class Signer
      attr_accessor :id
      attr_accessor :name
      attr_accessor :email
      attr_accessor :order
      attr_accessor :pin
      attr_accessor :message
      attr_accessor :deliver_email
      attr_accessor :role

      def initialize(name = nil, email = nil, role = nil)
        self.name = name
        self.email = email
        self.role = role
      end
    end
  end
end
