# frozen_string_literal: true

module OpenWeather
  class Client
    BASE_URL = "http://api.openweathermap.org"

    def initialize(api_key:)
      @api_key = api_key
    end

    def get_request(path, params:, headers: {})
      handle_response connection.get(path, params, headers)
    end

    def post_request(path, body:, headers: {})
      handle_response connection.get(path, body, headers)
    end

    def pollution
      @pollution ||= OpenWeather::Api::AirPollution.new(self)
    end

    private

    attr_reader :api_key

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        # authroization
        conn.params[:appid] = api_key

        # retry network issues & only for get requests
        conn.request :retry, max: 2, interval: 0.05, methods: %i[get]

        # parse response as json for content type JSON
        conn.response :json, content_type: /\bjson$/
        conn.response :logger do |logger|
          logger.filter(/(appid=)([^&]+)/, '\1[REDACTED]')
        end
      end
    end

    def handle_response(response)
      case response.status
      when (400...500) # error on client side i.e our side
        raise ClientError.new(response.body["message"], response)
      when (500...600)
        raise ServerError.new("something went wrong in openweather server", response)
      end

      response
    end
  end
end
