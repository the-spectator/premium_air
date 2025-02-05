class LocationsController < ApplicationController
  before_action :set_location, only: :show

  # NOTE: Scope of improvement - explore load_async
  def show
    @latest_aqi_card = AqiCard.new("Latest", @location.latest_aqi.aqi, @location.latest_aqi.uk_standard_pollutants)
    @current_month_card = AqiCard.new("Past Month", past_monthly_aqi.aqi, past_monthly_aqi.uk_standard_pollutants)
    @past_month_aqi_card = AqiCard.new("Current Month", current_month_aqi.aqi, current_month_aqi.uk_standard_pollutants)
    @avg_aqi_per_month = avg_aqi_per_month
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def past_monthly_aqi
    @past_monthly_aqi ||= begin
      previous_month_start = 1.month.before(Time.current.beginning_of_month)
      previous_month_end = previous_month_start.end_of_month

      @location.air_quality_metrics.avg_aqi_between(previous_month_start, previous_month_end).to_a.first
    end
  end

  def current_month_aqi
    @current_month_aqi ||= begin
      current_month_start = Time.current.beginning_of_month

      @location.air_quality_metrics.avg_aqi_between(current_month_start, Time.current).to_a.first
    end
  end

  def avg_aqi_per_month
    @location.air_quality_metrics.
      select("DATE_TRUNC('month', recorded_at)::date AS month, avg(so2) as so2, avg(pm2_5) as pm2_5, avg(pm10) as pm10, avg(no2) as no2, avg(o3) as o3").
      group("month").
      map { |a| [ a.month, a.aqi[:aqi] ] }.to_h
  end
end
