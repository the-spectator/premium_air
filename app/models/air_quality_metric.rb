class AirQualityMetric < ApplicationRecord
  # associations
  belongs_to :location

  # scopes
  scope :avg_aqi_between, ->(from, to) {
    where(recorded_at: from..to)
    .select("avg(so2) as so2, avg(pm2_5) as pm2_5, avg(pm10) as pm10, avg(no2) as no2, avg(o3) as o3")
  }

  # validations
  validates :so2, :no2, :pm2_5, :pm10, :o3, :recorded_at, presence: true # only validate presence for pollutant required for uk aqi calculation
  validates :so2, :no2, :pm2_5, :pm10, :o3, :nh3, numericality: { greater_than_or_equal_to: 0 }

  validates_uniqueness_of :recorded_at, scope: :location_id

  validate :recorded_at_cannot_be_in_the_future


  def uk_standard_pollutants
    self.attributes.slice(*UkAqi::CONSIDERED_POLLUTANTS.map(&:to_s))
  end

  def aqi
    @aqi ||= UkAqi.new(self).calculate_aqi
  end

  private

  def recorded_at_cannot_be_in_the_future
    errors.add(:recorded_at, "can't be in the future") if recorded_at.present? && recorded_at > Time.current
  end
end
