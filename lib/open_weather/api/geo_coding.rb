# frozen_string_literal: true

module OpenWeather
  module Api
    class GeoCoding < BaseApi
      PATH = "/geo/1.0/direct"

      def get(city, state, limit: 1)
        q = [ city, state ].compact.join(",")
        client.get_request(PATH, params: { q: q, limit: limit })
      end
    end
  end
end
