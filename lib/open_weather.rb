# frozen_string_literal: true

require "open_weather/client"

require "open_weather/api/base_api"
require "open_weather/api/air_pollution"

require "open_weather/resource/metric"
require "open_weather/resource/coordinate"
require "open_weather/resource/metric_collection"

module OpenWeather
  class BaseError < StandardError
    attr_reader :response

    def initialize(message, response = nil)
      super(message)
      @response = response
    end
  end

  ClientError = Class.new(BaseError)
  ServerError = Class.new(BaseError)
end
