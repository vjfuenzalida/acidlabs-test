# frozen_string_literal: true

require 'sidekiq/scheduler'

redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/'

Sidekiq.configure_server do |config|
  config.redis = {
    url: redis_url
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: redis_url
  }
end

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = {
      weather_worker: {
        queue: 'weather_worker',
        class: 'WeatherWorker',
        every: ENV.fetch('REQUEST_FREQUENCY') { '10m' }
      }
    }
    Rails.logger.info 'Starting Sidekiq schedule!'
    Rails.logger.info Sidekiq.get_schedule
    Sidekiq::Scheduler.load_schedule!
  end
end
