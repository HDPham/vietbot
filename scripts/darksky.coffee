# Description:
#   Gives information about the weather.
#
# Dependencies:
#   "chrono-node": "^1.2.5"
#
# Configuration:
#   HUBOT_DARK_SKY_API_KEY
#
# Commands:
#   hubot weather - Gives weather for today.
#   hubot weather <date> - Gives weather for a specific date.
#
# Author:
#   Hung Pham


chrono = require 'chrono-node'

module.exports = (robot) ->
    robot.respond /weather ?(.+)?/i, (msg) ->
        date = msg.match[1]
        unless date
            date = 'today'
        parsed_date = (chrono.parseDate date)
        unixvalue = parsed_date.getTime()/1000
        darkskyuri = 'https://api.darksky.net/forecast/' + process.env.HUBOT_DARK_SKY_API_KEY + '/40.1100,-88.2271,' + unixvalue
        retval = '*Here is the weather for ' + date + ':*\n'
        retval += parsed_date + '\n'

        msg.http(darkskyuri)
            .header('Accept', 'application/json')
            .get() (err, res, body) ->
                # if res.getHeader('Content-Type') isnt 'application/json'
                #     msg.send 'Error: Didn\'t get back JSON'
                #     return

                data = null
                try
                    data = JSON.parse body
                catch err
                    msg.send 'Error: Ran into a problem parsing JSON'
                    return
                retval += '>' + data.daily.data[0].summary + '\n'
                retval += '>High: ' + (data.daily.data[0].temperatureMax) + '°F\n'
                retval += '>Low: ' + (data.daily.data[0].temperatureMin) + '°F\n'
                retval += '>Precipitation: ' + (data.daily.data[0].precipProbability*100)+ '%\n'
                msg.send retval


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