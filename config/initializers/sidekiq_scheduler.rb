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
    Sidekiq.schedule = YAML.load_file(
      File.expand_path('../../config/scheduler.yml', __dir__)
    )
    Sidekiq::Scheduler.load_schedule!
  end
end
