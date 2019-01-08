# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # Home route
  root to: 'welcome#index'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  # endpoint to request updates
  get 'forecast', to: 'weather#forecast'

  # endpoint to display redis contents
  resources :dashboard, only: :index

  # sidekiq manager
  mount Sidekiq::Web, at: '/sidekiq'
end
