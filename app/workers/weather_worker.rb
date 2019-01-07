# frozen_string_literal: true

require 'sidekiq-scheduler'

# This worker is in charge of fetching forecasts
# for the stored cities and then deliver them to
# the clients using a websocket channel
class WeatherWorker
  include Sidekiq::Worker

  sidekiq_options queue: :weather_worker, unique_for: 30.minutes

  def perform
    if ENV['UPDATE_FORECASTS'] == 'true'
      Rails.logger.info('Updating forecasts')
      forecasts = fetch_forecasts
      save_forecasts(forecasts)
    end
    ActionCable.server.broadcast('weather_channel', forecasts: forecasts_hash)
  end

  private

  def forecasts_hash
    RedisHelper.forecasts.map do |city_name, forecast|
      [city_name, extract_data(forecast)]
    end.to_h
  end

  def fetch_forecasts
    cities = RedisHelper.cities
    cities.map do |city_name, data|
      forecast = request_until_success(data)
      forecast[:name] = city_name
      forecast
    end
  end

  def request_until_success(data)
    response = ForecastIO.forecast(data)
    response = ForecastIO.forecast(data) while response[:status] == :failed
    return response[:forecast] if response[:status] == :success
  end

  def save_forecasts(forecasts)
    RedisHelper.save_forecasts(forecasts)
  end

  def extract_data(forecast)
    timestamp = forecast[:currently][:time]
    temperature = forecast[:currently][:temperature]
    timezone = forecast[:timezone]
    date = DateTime.strptime(timestamp.to_s, '%s').in_time_zone(timezone)
    { temperature: temperature, date: date }
  end
end
