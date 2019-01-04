# frozen_string_literal: true

CITIES = 'api.cities'
FORECASTS = 'api.forecasts'
ERRORS = 'api.errors'

module RedisHelper
  def self.redis
    $redis
  end

  def self.forecasts
    redis_hash = redis.hgetall(FORECASTS)
    sanitize_hash(redis_hash)
  end

  def self.remove_forecasts
    redis.del(FORECASTS)
  end

  def self.get_forecast(city_name)
    redis_json = redis.hget(FORECASTS, city_name)
    sanitize_json(redis_json)
  end

  def self.save_forecasts(forecasts)
    items = generate_items(forecasts, :name)
    save_items(FORECASTS, items)
  end

  def self.save_forecast(forecast)
    save_item(FORECASTS, forecast[:name], forecast)
  end

  def self.cities
    redis_hash = redis.hgetall(CITIES)
    sanitize_hash(redis_hash)
  end

  def self.remove_cities
    redis.del(CITIES)
  end

  def self.get_city(city_name)
    redis_json = redis.hget(CITIES, city_name)
    sanitize_json(redis_json)
  end

  def self.save_cities(cities)
    items = generate_items(cities, :name)
    save_items(CITIES, items)
  end

  def self.save_city(city)
    save_item(CITIES, city[:name], city)
  end

  def self.errors
    redis_hash = redis.hgetall(ERRORS)
    sanitize_hash(redis_hash)
  end

  def self.remove_errors
    redis.del(ERRORS)
  end

  def self.get_error(error_timestamp)
    redis_json = redis.hget(ERRORS, error_timestamp)
    sanitize_json(redis_json)
  end

  def self.save_error(error)
    save_item(ERRORS, error[:timestamp], error)
  end

  def self.save_errors(errors)
    items = generate_items(errors, :timestamp)
    save_items(ERRORS, items)
  end

  def self.save_item(hash_name, key, value)
    redis.hset(hash_name, key.to_s, value.to_json)
  end

  def self.save_items(hash_name, items)
    redis.hmset(hash_name, items)
  end
end

def generate_items(list, key)
  list.map { |elem| [elem[key].to_s, elem.to_json] }.flatten
end

def sanitize_hash(redis_hash)
  redis_hash.map { |k, v| [k.to_s, sanitize_json(v)] }.to_h
end

def sanitize_json(redis_json)
  JSON.parse(redis_json).deep_symbolize_keys
end
