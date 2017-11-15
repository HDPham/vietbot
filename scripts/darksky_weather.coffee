# Description:
#   Gives information about the weather.
#
# Dependencies:
#   "chrono-node": "^1.2.5"
#
# Configuration:
#   DARKSKY_API_KEY
#
# Commands:
#   hubot weather <date> - Gives you weather about a specific date.
#
# Notes:
#   Uses Dark Sky
#
# Author:
#   Hung Pham


request = require 'request'
chrono = require 'chrono-node'
darksky_key = process.env.DARKSKY_API_KEY

module.exports = (robot) ->
    robot.respond /weather/i, (res) ->
        request.get { uri: 'https://api.darksky.net/forecast/' + darksky_key + '/40.1100,-88.2271', json : true }, (err, r, body) ->
            resp = body
            console.log resp.currently.time

    robot.respond /raincheck/i, (res) ->
        request.get { uri: 'https://api.darksky.net/forecast/' + darksky_key + '/40.1100,-88.2271', json : true }, (err, r, body) ->
            resp = body
            curr_time = resp.currently.time

    robot.respond /weather (.*)/i, (res) ->
        date = res.match[1]
        extra = (chrono.parseDate date)
        retval = "*Here is the weather for " + date + ":* \n"
        unixvalue = extra.getTime()/1000
        retval += extra + "\n"
        darkskyuri = 'https://api.darksky.net/forecast/' + darksky_key + '/40.1100,-88.2271,' + unixvalue
        retval += darkskyuri + "\n"

        request.get { uri: darkskyuri, json : true }, (err, r, body) ->
            resp = body
            # console.log resp.currently.time
            retval += ">" + resp.daily.data[0].summary + "\n"
            retval += ">High: " + (resp.daily.data[0].temperatureMax) + "°F"+ "\n"
            retval += ">Low: " + (resp.daily.data[0].temperatureMin) + "°F"+ "\n"
            retval += ">Precipitation: " + (resp.daily.data[0].precipProbability*100)+ "%\n"
            retval += ">Weather report powered by DarkSky https://darksky.net/poweredby/"
            res.send retval


    # robot.hear /(?:(((Jan(uary)?|Ma(r(ch)?|y)|Jul(y)?|Aug(ust)?|Oct(ober)?|Dec(ember)?)\ 31)|((Jan(uary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sept|Nov|Dec)(ember)?)\ (0?[1-9]|([12]\d)|30))|(Feb(ruary)?\ (0?[1-9]|1\d|2[0-8]|(29(?=,\ ((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))))))(\,|\ |$|\n|st|th|nd|rd)/i, (res) ->
    #     date = res.match[1]

    #     if((date.toLowerCase().indexOf "nov", 0) != -1 || (date.toLowerCase().indexOf "dec", 0) != -1)
    #         date += ", 2016"
    #     else
    #         date += ", 2017"

    #     retval = "*Here is some more info about " + date + ":* \n"
    #     extra = (chrono.parseDate date)
    #     retval += ">" + extra + "\n"
    #     unixvalue = extra.getTime()/1000
    #     # retval += extra
    #     darkskyuri = 'https://api.darksky.net/forecast/' + darksky_key + '/40.1100,-88.2271,' + unixvalue
    #     # retval += darkskyuri + "\n"

    #     request.get { uri: darkskyuri, json : true }, (err, r, body) ->
    #         resp = body
    #         # console.log resp.currently.time
    #         retval += ">" + resp.daily.data[0].summary + "\n"
    #         retval += ">High: " + (resp.daily.data[0].temperatureMax) + "°F"+ "\n"
    #         retval += ">Low: " + (resp.daily.data[0].temperatureMin) + "°F"+ "\n"
    #         retval += ">Precipitation: " + (resp.daily.data[0].precipProbability*100)+ "%\n"
    #         retval += ">Weather report powered by DarkSky https://darksky.net/poweredby/"
    #         res.send retval
