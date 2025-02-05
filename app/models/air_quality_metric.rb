class AirQualityMetric < ApplicationRecord
  # associations
  belongs_to :location

  # validations
  validates :so2, :no2, :pm2_5, :pm10, :o3, :recorded_at, presence: true # only validate presence for pollutant required for uk aqi calculation
  validates :so2, :no2, :pm2_5, :pm10, :o3, :nh3, numericality: { greater_than_or_equal_to: 0 }

  validates_uniqueness_of :recorded_at, scope: :location_id

  validate :recorded_at_cannot_be_in_the_future


  def uk_standard_pollutants
    self.attributes.slice(*UkAqi::CONSIDERED_POLLUTANTS.map(&:to_s))
  end

  private

  def recorded_at_cannot_be_in_the_future
    errors.add(:recorded_at, "can't be in the future") if recorded_at.present? && recorded_at > Time.current
  end
end
