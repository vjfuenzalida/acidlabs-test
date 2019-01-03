web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 5 -v -q weather_worker