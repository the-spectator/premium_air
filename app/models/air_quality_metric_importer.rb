# frozen_string_literal: true

require "open_weather"

class AirQualityMetricImporter
  ValidationError = Class.new(StandardError)
  InvalidLocationError = Class.new(ValidationError)
  InvalidDurationError = Class.new(ValidationError)

  def self.import(...)
    new(...).import
  end

  def initialize(location, start_time, end_time)
    @location = location
    @client = OpenWeather::Client.new(api_key: Rails.application.credentials.open_weather[:api_key])
    @start_time = start_time
    @end_time = end_time
  end

  def import
    validate!

    # NOTE: SCOPE of improvement - Since upsert_all skips validations, should we add validation each datum?
    metrics = air_quality_data.metrics.map do |datum|
      {
        location_id: location.id,
        recorded_at: datum.recorded_at,
        co: datum.co,
        no: datum.no,
        no2: datum.no2,
        o3: datum.o3,
        so2: datum.so2,
        pm2_5: datum.pm2_5,
        pm10: datum.pm10,
        nh3: datum.nh3
      }
    end

    # NOTE: SCOPE of improvement - Upsert in batches of 500
    AirQualityMetric.upsert_all(metrics, unique_by: [ :recorded_at, :location_id ])
  end

  private

  attr_reader :location, :client, :start_time, :end_time

  # NOTE: SCOPE of improvement - Should we validate if the latitude and longitude are also valid values?
  def validate!
    raise InvalidLocationError, "latitue and longitude can't be empty" if location.blank? || location.latitude.blank? || location.longitude.blank?
    raise InvalidDurationError, "start_time and end_time can't be empty" if start_time.blank? || end_time.blank?
    raise InvalidDurationError, "start_time and end_time should be of type Time" unless start_time.is_a?(Time) && end_time.is_a?(Time)
    raise InvalidDurationError, "start_time can't be greater than end_time" if start_time > end_time
  end

  def air_quality_data
    client.air_pollution.history(location.latitude, location.longitude, start_time.to_i, end_time.to_i)
  end
end
