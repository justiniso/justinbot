
request = require 'request'

URL = http://api.openweathermap.org/data/2.5/weather?zip=10016,us

class Weather

    onRain: (cb) ->
        return this
    onSnow: (cb) ->
        return this

request.get(URL, (err, res, body) ->
)