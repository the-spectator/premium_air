class State < ApplicationRecord
  # Associations
  has_many :locations
  has_many :air_quality_metrics, through: :locations

  has_one :avg_aqi, -> { avg_aqi_per_state }, class_name: "AirQualityMetric", foreign_key: :state_id_alias

  # Validations
  validates :name, presence: true

  # NOTE: Only supports India for now
  def country
    "India"
  end
end
