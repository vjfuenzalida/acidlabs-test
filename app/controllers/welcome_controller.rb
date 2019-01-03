class WelcomeController < ApplicationController
  def index
    @cities = JSON.parse($redis.get "api.cities")    
  end
end
