# frozen_string_literal: true

module Eversign
  module Models
    class Field
      ATTRIBUTES = %i[
        name type x y width height page signer identifier required readonly merge type
        validation_type text_style text_font text_size text_color value options group
      ].freeze

      attr_accessor(*ATTRIBUTES)

      def initialize(attrs = {})
        ATTRIBUTES.each do |attr|
          public_send(:"#{attr}=", attrs.fetch(attr, nil))
        end
      end
    end
  end
end
