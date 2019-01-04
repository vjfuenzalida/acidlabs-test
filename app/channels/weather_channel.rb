# frozen_string_literal: true

class WeatherChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'weather_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast 'weather_channel', message: data['message']
  end

end
