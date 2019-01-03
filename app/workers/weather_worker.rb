# frozen_string_literal: true

require 'sidekiq-scheduler'

class WeatherWorker
  include Sidekiq::Worker

  sidekiq_options queue: :weather_worker, unique_for: 30.minutes

  def perform
    ActionCable.server.broadcast(
      'weather_channel',
      message: 'City Data'
    )
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(
      partial: 'forecasts/forecast',
      locals: { forecast: message }
    )
  end
end
