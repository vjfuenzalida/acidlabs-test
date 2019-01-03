# frozen_string_literal: true

class WeatherController < ApplicationController
  def forecast
    puts 'get_updates'
    render json: { weather: '10º C' }
  end
end
