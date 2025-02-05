class Location < ApplicationRecord
  # Associations
  belongs_to :state
  has_many :air_quality_metrics

  has_one_of_many :latest_aqi, -> { order(created_at: :desc) }, class_name: "AirQualityMetric"

  # Validations
  validates :name, :latitude, :longitude, presence: true
end
