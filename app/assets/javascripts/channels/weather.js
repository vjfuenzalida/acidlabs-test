App.weather = App.cable.subscriptions.create("WeatherChannel", {
  connected: () => console.log("connected"),
  disconnected: () => console.log("disconnected"),
  received: data => {
    const now = moment().format("hh:mm:ss A");
    console.log("Forecast update received at " + now)
    Object.entries(data.forecasts).forEach(([city, forecast]) => {
      const [tempElement, dayElement, hourElement] = getElements(city);
      const {temp, day, hour} = generateTexts(forecast);
      tempElement.text(temp);
      dayElement.text(day);
      hourElement.text(hour);
    });
  },
  speak: message => {
    return this.perform("speak", {
      message: message
    });
  }
});

function generateTexts(forecast) {
  const dateMoment = moment.parseZone(forecast.date);
  const degrees = parseInt(forecast.temperature);
  return {
    temp: `Temperature: ${degrees} ºC`,
    day: dateMoment.format("dddd, MMMM D, YYYY"),
    hour: dateMoment.format("hh:mm:ss A"),
  };
}

function getElements(city_name) {
  return [
    $(`.temp-${city_name}`),
    $(`.day-${city_name}`),
    $(`.hour-${city_name}`)
  ];
}
