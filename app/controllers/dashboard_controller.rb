# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @forecasts = RedisHelper.forecasts.map do |city, f|
      [city, f[:currently]]
    end.to_h
    @cities = RedisHelper.cities
    @errors = RedisHelper.errors
  end
end
