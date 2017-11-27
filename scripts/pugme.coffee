# Description:
#   Pugme is the most important thing in life
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot pug me - Receives a pug.
#   hubot pug bomb N - Gets N pugs (limited to 3).
#
# Author:
#   Hung Pham

module.exports = (robot) ->

  robot.respond /pug me/i, (msg) ->
    msg.http("http://pugme.herokuapp.com/random")
      .get() (err, res, body) ->
        # msg.send JSON.parse(body).pug
        msg.send JSON.parse(body).pug.replace(new RegExp('[0-9][0-9].media', 'g'), 'media')

  robot.respond /pug bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 3
    if parseInt(count) > 3
      msg.send "Sorry. That's too many pugs. Here's 3 of them instead";
      count = 3
    msg.http("http://pugme.herokuapp.com/bomb?count=" + count)
      .get() (err, res, body) ->
        msg.send pug.replace(new RegExp('[0-9][0-9].media', 'g'), 'media') for pug in JSON.parse(body).pugs

  robot.respond /how many pugs are there/i, (msg) ->
    msg.http("http://pugme.herokuapp.com/count")
      .get() (err, res, body) ->
        msg.send "There are #{JSON.parse(body).pug_count} pugs."

