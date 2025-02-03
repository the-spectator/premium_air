# frozen_string_literal: true

module OpenWeather
  module Resource
    class Coordinate
      private attr_reader :json

      def initialize(json)
        @json = json
      end

      def latitude
        json["lat"]
      end

      def longitude
        json["lon"]
      end

      # NOTE: had to override inspect because of too verbose output
      def inspect
        "#<#{self.class.name}:#{object_id} latitude=#{latitude} longitude=#{longitude}>"
      end
    end
  end
end
