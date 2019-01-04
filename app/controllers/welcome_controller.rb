# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @cities = RedisHelper.cities
    @forecasts = RedisHelper.forecasts.map do |city_name, forecast|
      [city_name, extract_data(forecast)]
    end.to_h
  end

  private

  def extract_data(forecast)
    timestamp = forecast[:currently][:time]
    temperature = forecast[:currently][:temperature].to_i
    timezone = forecast[:timezone]
    date = DateTime.strptime(timestamp.to_s, '%s').in_time_zone(timezone)
    {
      temperature: temperature,
      date: date
    }
  end
end
