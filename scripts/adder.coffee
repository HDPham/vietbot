# Description:
#   Gives some information about weather
#
# Dependencies:
#
# Configuration:
#
#
# Commands:
#   hubot add <board, interns, all> - Adds board or interns to channel
#
# Notes:
#
# Author:
#   Hung Pham


request = require 'request'
SlackClient = require 'slack-api-client'

todd_key = process.env.TODD_SLACK_API_KEY
client_id = process.env.ADDER_CLIENT_ID
client_secret = process.env.ADDER_CLIENT_SECRET

test_token = process.env.API_TEST_TOKEN

module.exports = (robot) ->
    robot.respond /interns/i, (res) ->
        # request.get { uri: 'https://slack.com/oauth/authorize', client_id : client_id, scope : 'channels.write' }, (err, r, body) ->
        #

        # request.get { uri: 'https://slack.com/api/chat.postMessage', token: test_token, channel: '#hubot_test', text: 'hello'}, (err, r, body) ->
        #     console.log(body);
        #     res.send 'hello'


        # request.get { uri: 'https://slack.com/api/oauth.access', client_id : client_id, client_secret: client_secret }, (err, r, body) ->
        #     resp = body
        #     curr_time = resp.currently.time

        # res.send 'Copy and paste the list of interns into your chat and send the message. Then, accept all dialogues. (Click "Yes, show chanel history")'

        res.send 'There are no interns at the moment.'

    robot.respond /board/i, (res) ->
        res.send 'Copy and paste the list of board members into your chat and send the message. Then, accept all dialogues. (Click "Yes, show chanel history")'

        res.send '@tylertran @isaac_ngo98 @ericatran22 @kalsgomoo @hpham @ulneelia @apham @dpoon12 @cynosaur @baotranle98 @phidang @nicholasvo @christinatran'
