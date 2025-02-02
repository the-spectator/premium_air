# frozen_string_literal: true

module OpenWeather
  module Api
    class AirPollution < BaseApi
      PATH = "/data/2.5/air_pollution"

      def get(lat, lon)
        OpenWeather::Resource::MetricCollection.new(client.get_request(PATH, params: { lat:, lon: }))
      end

      def history(lat, lon, start_time, end_time)
        OpenWeather::Resource::MetricCollection.new(client.get_request("#{PATH}/history", params: { lat:, lon:, start: start_time, end: end_time }))
      end
    end
  end
end
