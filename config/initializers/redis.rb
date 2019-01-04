# frozen_string_literal: true

$redis = Redis.new

cities = [
  {
    name: 'Auckland',
    country: 'NZ',
    latitude: '-36.84846',
    longitude: '174.763332'
  },
  {
    name: 'Georgia',
    country: 'USA',
    latitude: '32.165622',
    longitude: '-82.900075'
  },
  {
    name: 'London',
    country: 'UK',
    latitude: '51.507351',
    longitude: '-0.127758'
  },
  {
    name: 'Santiago',
    country: 'CL',
    latitude: '-33.43783',
    longitude: '-70.650449'
  },
  {
    name: 'Sydney',
    country: 'AU',
    latitude: '-33.86882',
    longitude: '151.209296'
  },
  {
    name: 'Zurich',
    country: 'CH',
    latitude: '47.376887',
    longitude: '8.541694'
  }
].freeze

# Clear previous values stored
RedisHelper.remove_cities

# Save the needed cities in the corresponding key
RedisHelper.save_cities(cities)
