# frozen_string_literal: true

module OpenWeather
  module Resource
    class Metric
      POLLUTANTS = %w[co no no2 o3 so2 pm2_5 pm10 nh3].freeze

      private attr_reader :json

      def initialize(json)
        @json = json
      end

      POLLUTANTS.each do |pollutant|
        define_method(pollutant) do
          json.dig("components", pollutant)
        end
      end

      def recorded_at
        Time.zone.at(json["dt"])
      end

      def aqi
        json["main"]["aqi"]
      end

      # NOTE: had to override inspect because of too verbose output
      def inspect
        "#<#{self.class.name}:#{object_id} aqi=#{aqi} recorded_at=#{recorded_at}>"
      end
    end
  end
end
