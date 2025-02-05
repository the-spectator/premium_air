class AirQualityImportCronJob < ApplicationJob
  queue_as :importer

  def perform(from = nil, to = nil)
    # get all data for past 1 hour
    from ||= 1.hour.ago
    to ||= Time.current

    jobs = Location.in_batches(of: 10).map do |relation|
      AirQualityImportJob.new(relation.pluck(:id), from, to)
    end

    ActiveJob.perform_all_later(jobs)
  end
end
