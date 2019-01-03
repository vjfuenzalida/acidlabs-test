# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @cities = JSON.parse($redis.get "api.cities")    
  end
end
