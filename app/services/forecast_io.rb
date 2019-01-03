module ForecastIO

  DEFAULT_CONFIGS = {
    lang: "es",
    units: "si",
  }

  def self.api_endpoint
    @@api_endpoint ||= ENV['API_ENDPOINT']
  end

  def self.api_key
    @@api_key ||= ENV['API_KEY']
  end

  def self.connection
    url = "#{self.api_endpoint}/#{self.api_key}"
    @@connection ||= self.new_connection    
  end

  def self.forecast(latitude, longitude)
    forecast_url = "#{latitude},#{longitude}"
    forecast_response = self.get(forecast_url)
    if forecast_response.success?
      return JSON.parse(forecast_response.body)    
    end
  end

  def self.fake_forecast
    self.forecast(37.8267,-122.4233)
  end

  private

  def self.get(path, params = {})    
    self.connection.get do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
    end
  end

  def self.new_connection
    url = "#{self.api_endpoint}/#{self.api_key}"
    conn = Faraday.new(url: url) do |faraday|    
      self.add_params(faraday)
      faraday.request  :url_encoded
      faraday.adapter :typhoeus
    end
    conn
  end

  def self.add_params(faraday)
    DEFAULT_CONFIGS.each do |key, value|
      faraday.params[key] = value
    end
  end
  
end
