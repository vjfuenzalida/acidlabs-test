# frozen_string_literal: true

module ForecastIO
  DEFAULT_CONFIGS = {
    lang: 'es',
    units: 'si'
  }.freeze

  def self.api_endpoint
    @@api_endpoint ||= ENV['API_ENDPOINT']
  end

  def self.api_key
    @@api_key ||= ENV['API_KEY']
  end

  def self.connection
    @@connection ||= new_connection
  end

  def self.forecast(latitude, longitude)
    forecast_url = "#{latitude},#{longitude}"
    forecast_response = get(forecast_url)
    return JSON.parse(forecast_response.body) if forecast_response.success?
  end

  def self.fake_forecast
    forecast(37.8267, -122.4233)
  end

  def self.get(path, _params = {})
    connection.get do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
    end
  end

  def self.new_connection
    url = "#{api_endpoint}/#{api_key}"
    conn = Faraday.new(url: url) do |faraday|
      add_params(faraday)
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
    conn
  end

  def self.add_params(faraday)
    DEFAULT_CONFIGS.each do |key, value|
      faraday.params[key] = value
    end
  end
end
