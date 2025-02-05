namespace :aqi do
  desc "Import last 1 year of data"
  task import: :environment do
    AirQualityImportCronJob.perform_later(1.month.ago, Time.current)
  end
end
