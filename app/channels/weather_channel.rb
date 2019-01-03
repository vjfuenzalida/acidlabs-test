# frozen_string_literal: true

class WeatherChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'weather'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast('weather', forecast: render_forecast(data['forecast']))
  end

  private

  def render_forecast(forecast)
    ApplicationController.render(partial: 'forecasts/forecast', locals: { forecast: forecast })
  end
end
