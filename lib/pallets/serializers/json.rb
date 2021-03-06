require 'json'

module Pallets
  module Serializers
    class Json < Base
      def dump(data)
        JSON.generate(data)
      end

      def load(data)
        JSON.parse(data)
      end
    end
  end
end
