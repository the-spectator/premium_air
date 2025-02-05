class AirQualityMetric < ApplicationRecord
  # associations
  belongs_to :location

  has_one :state, through: :location

  # scopes
  scope :avg_aqi_between, ->(from, to) {
    where(recorded_at: from..to).avg_aqi_metrics
  }
  scope :avg_aqi_metrics, -> { select("avg(so2) as so2, avg(pm2_5) as pm2_5, avg(pm10) as pm10, avg(no2) as no2, avg(o3) as o3") }

  # NOTE: Had to handrole the lateral join because activerecord-has_some_of_many didn't work with through relation
  scope :avg_aqi_per_state, -> {
    sql = <<~SQL
      INNER JOIN LATERAL (
        SELECT
          avg(so2) as so2, avg(pm2_5) as pm2_5, avg(pm10) as pm10, avg(no2) as no2, avg(o3) as o3
        FROM
          "air_quality_metrics"
          inner join locations on locations.id = air_quality_metrics.location_id
        WHERE
          locations.state_id = "states"."id"
        LIMIT
          1
      ) lateral_table ON TRUE
    SQL

    selected_metrics = State
      .select("lateral_table.*, states.id as state_id_alias")
      .joins(State.sanitize_sql([ sql ]))

    from(selected_metrics, "air_quality_metrics")
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
