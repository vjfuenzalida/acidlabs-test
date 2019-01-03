App.weather = App.cable.subscriptions.create "WeatherChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log("connected")

  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log("disconnected")

  received: (data) ->
    console.log("Received message:", data)
    # $('#forecasts').append data['message']

  speak: (message) ->
    @perform 'speak', message: message