module Eversign
  module Models
    class Recipient
      attr_accessor :name
      attr_accessor :email
      attr_accessor :role

      def initialize(name = nil, email = nil, role = nil)
        self.name = name
        self.email = email
        self.role = role
      end
    end
  end
end
