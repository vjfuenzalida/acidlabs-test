# frozen_string_literal: true

# Special error class to mock a request failure
class FakeError < StandardError
  attr_reader :data
  attr_reader :details
  def initialize(message = nil, object = {}, random)
    @message = message || 'How unfortunate! The API Request Failed'
    @data = object.dup
    @data[:timestamp] = DateTime.now.strftime('%Q')
    @data[:random] = random
    @coords = "(#{data[:latitude]}, #{data[:longitude]})"
    @details = "Request for #{data[:name]} #{@coords} forecast failed."
    super(@message)
  end
end

# This module is in charge of making requests to the weather API
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

  def self.forecast(data)
    forecast_url = "#{data[:latitude]},#{data[:longitude]}"
    response = get(forecast_url)
    random = rand(0.0..1.0)
    raise FakeError.new(nil, data, random) if random < 0.1

    if response.success?
      forecast = JSON.parse(response.body)
      return { status: :success, forecast: forecast }
    end

    { status: :failed } # won't raise the same FakeError
  rescue FakeError => e
    Rails.logger.error e.message
    Rails.logger.error e.details
    RedisHelper.save_error(e.data)
    { status: :failed }
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
