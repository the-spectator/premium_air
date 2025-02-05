class StatesController < ApplicationController
  def index
    @pagy, @records = pagy(State.includes(:avg_aqi).all, limit: 10)
    render :index
  end
end
