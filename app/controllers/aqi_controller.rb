class AqiController < ApplicationController
  def index
    @pagy, @records = pagy(Location.includes(:latest_aqi, :avg_aqi).all, limit: 10)
    @metric_count = AirQualityMetric.async_count
    @location_count = Location.async_count
    @state_count = State.async_count
    render :index
  end
end
