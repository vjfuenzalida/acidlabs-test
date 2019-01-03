# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  # Home route
  root to: 'welcome#index'

  # endpoint to request updates
  get 'request', to: 'weather#request'

  # sidekiq manager
  mount Sidekiq::Web, at: '/sidekiq'
end
