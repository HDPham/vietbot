# Description:
#   Fun, interactive hear/respond functions with Hubot.
#
# Board Commands:
#   hubot calendar - Sends link to event calendar.
#   hubot new event - Sends link to event form.
#
# Author:
#   Hung Pham

module.exports = (robot) ->
    robot.respond /open the (.*) doors/i, (res) ->
        doorType = res.match[1]
        if doorType is 'pod bay'
          res.reply 'I\'m afraid I can\'t let you do that.'
        else
          res.reply 'Opening ' + doorType + ' doors'

    robot.hear /^dying|[^a-z]dying/i, (res) ->
        res.send 'Dying? You mean turning up?'

    robot.hear /^thick|[^a-z]thick/i, (res) ->
        res.send '*THICC*'

    robot.hear /\(y\)/i, (res) ->
        res.send '👍'

    robot.respond /i love you/i, (res) ->
    	res.send 'I love Emilia'

    robot.respond /hold the door/i, (res) ->
        res.send 'hodor.'

    robot.respond /what time is it/i, (res) ->
        res.send 'It\'s high noon.'

    robot.respond /calendar/i, (res) ->
        role1 = 'board'
        role2 = 'intern'
        user = robot.brain.userForName(res.message.user.name)
        unless user?
            return res.reply 'You do not exist.'
        unless robot.auth.hasRole(user, role1) or robot.auth.hasRole(user, role2)
            return res.reply 'Access Denied. You need role \'' + role1 + '\' or \'' + role2 + '\' to perform this action.'
        res.send 'Calendar link: https://calendar.google.com/calendar/embed?src=85n5q7ok9hq1sa3hd8o1rs7qd8%40group.calendar.google.com&ctz=America/Chicago'

    robot.respond /new event/i, (res) ->
        role1 = 'board'
        role2 = 'intern'
        user = robot.brain.userForName(res.message.user.name)
        unless user?
            return res.reply 'You do not exist.'
        unless robot.auth.hasRole(user, role1) or robot.auth.hasRole(user, role2)
            return res.reply 'Access Denied. You need role \'' + role1 + '\' or \'' + role2 + '\' to perform this action.'
        res.send 'https://docs.google.com/forms/d/e/1FAIpQLScy68xsuzWPupzBneE6u-hWg5pcyQSzpJfKjgV3mZCd2GVJxQ/viewform'

    # robot.receiveMiddleware (context, next, done) ->
    #     pugBomb = /pug bomb/i
    #     if context.response.message.text?.match(pugBomb)
    #         console.log("finish")
    #         context.response.message.finish()
    #     else
    #         next(done)

    # robot.respond /msggen (.*)/i, (res) ->
    #     robot.messageRoom '#general', res.match[1]