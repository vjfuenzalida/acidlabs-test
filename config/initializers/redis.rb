$redis = Redis.new

CITIES = {
  Auckland: {
    country: "NZ",
    latitude: "-36.84846",
    longitude: "174.763332"
  },
  Georgia: {
    country: "USA", 
    latitude: "32.165622",
    longitude: "-82.900075"
  },
  London: {
    country: "UK",
    latitude: "51.507351",
    longitude: "-0.127758"
  },
  Santiago: {
    country: "CL",
    latitude: "-33.43783",
    longitude: "-70.650449"
  },
  Sydney: {
    country: "AU",
    latitude: "-33.86882",
    longitude: "151.209296"
  },
  Zurich: {
    country: "CH",
    latitude: "47.376887",
    longitude: "8.541694"
  },
}

# Clear previous values stored
$redis.del 'api.places'

# Save the needed cities in the corresponding key
$redis.set 'api.places', CITIES.to_json