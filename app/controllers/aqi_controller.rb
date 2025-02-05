class AqiController < ApplicationController
  def index
    @pagy, @records = pagy(Location.includes(:latest_aqi).all, limit: 10)
    render :index
  end
end
