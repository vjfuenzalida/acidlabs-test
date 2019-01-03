# frozen_string_literal: true

require 'sidekiq-scheduler'

class WeatherWorker
  include Sidekiq::Worker

  sidekiq_options queue: :cron, unique_for: 30.minutes

  def perform
    puts '[Worker Job] TODO: fetch weather information for the requested cities'
  end
end
