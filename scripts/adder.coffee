# Description:
#   Add group to channel.
#
# Board Commands:
#   hubot <board, interns> - Helps add <board> or <interns> to channel.
#
# Author:
#   Hung Pham


module.exports = (robot) ->
    robot.respond /interns\s*?$/i, (res) ->
        role1 = 'board'
        role2 = 'intern'
        user = robot.brain.userForName(res.message.user.name)
        unless user?
            return res.reply 'You do not exist.'
        unless robot.auth.hasRole(user, role1) or robot.auth.hasRole(user, role2)
            return res.reply 'Access Denied. You need role \'' + role1 + '\' or \'' + role2 + '\' to perform this action.'
        res.send 'There are no interns at the moment.'

    robot.respond /board\s*?$/i, (res) ->
        role1 = 'board'
        role2 = 'intern'
        user = robot.brain.userForName(res.message.user.name)
        unless user?
            return res.reply 'You do not exist.'
        unless robot.auth.hasRole(user, role1) or robot.auth.hasRole(user, role2)
            return res.reply 'Access Denied. You need role \'' + role1 + '\' or \'' + role2 + '\' to perform this action.'
        retval = 'Copy and paste the list of board members into your chat and send the message. Then, accept all dialogues (Click "Yes, show chanel history").\n'
        board = process.env.BOARD_NAMES.split ','
        for member, i in board
            board[i] = '@'.concat member
        retval += board.join(' ')
        res.send retval