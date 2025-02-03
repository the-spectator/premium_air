# frozen_string_literal: true

module OpenWeather
  module Api
    class BaseApi
      private attr_reader :client

      def initialize(client)
        @client = client
      end
    end
  end
end
