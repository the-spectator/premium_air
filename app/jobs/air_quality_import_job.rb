class AirQualityImportJob < ApplicationJob
  RetriableError = Class.new(StandardError)

  retry_on RetriableError, wait: 30.minutes, attempts: 2

  queue_as :importer

  def perform(location_ids, from_time, to_time)
    Location.where(id: location_ids).find_each do |location|
      Rails.logger.tagged("AirQualityImportJob", "location=[#{location.id}][#{location.name}] duration_start=#{from_time} duration_to=#{to_time}") do
        Rails.logger.info("Starting importing data at #{Time.current}")

        import(location, from_time, to_time)

        Rails.logger.info("Completed importing data at #{Time.current}")
      end
    end
  end

  private

  def import(location, from_time, to_time)
    AirQualityMetricImporter.import(location, from_time, to_time)
  rescue OpenWeather::BaseError => e
    Rails.logger.error("Client error - #{e.message}")
    raise RetriableError, e
  rescue AirQualityMetricImporter::ValidationError => e
    Rails.logger.error("Failed to import data with validation error - #{e.message}")
  rescue StandardError => e
    Rails.logger.error("Unexpected error #{e.class} - #{e.message} \n #{e.backtrace&.join("\n")}")
  end
end
