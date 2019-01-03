# frozen_string_literal: true

Rails.application.routes.draw do
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  # Home route
  root to: 'welcome#index'
end
