# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.
require 'sidekiq/web'
require 'sidekiq-scheduler/web'
require_relative 'config/environment'

run Rails.application
run Sidekiq::Web
