# Description:
#   Generates admin/board help commands for Hubot.
#
# Admin Commands:
#   hubot admin help - Displays all of the admin help commands that this bot knows about.
#   hubot admin help <query> - Displays all admin help commands that match <query>.
#
# Board Commands:
#   hubot <board, intern> - Displays all of the board help commands that this bot knows about.
#   hubot <board, intern> help <query> - Displays all board help commands that match <query>.
#
# Author:
#   Hung Pham


admin_cmds = [
    'hubot adapter - Reply with the adapter.',
    'hubot admin help - Displays all of the admin help commands that this bot knows about.',
    'hubot admin help <query> - Displays all admin help commands that match <query>.',
    'hubot auth <user> add <role> role - Assigns <role> to <user>.',
    'hubot auth <user> remove <role> role - Removes <role> from <user>.',
    'hubot auth <user> id - Gives <user> id from persistent storage.',
    # 'hubot auth <user> display name - Gives <user> name from persistent storage.',
    'hubot echo <text> - Reply back with <text>.',
    # 'hubot env current - Displays all current environment variables.',
    # 'hubot env current --prefix=[prefix] - Displays current environment variables with prefix.',
    # 'hubot env file - List name of files under HUBOT_ENV_BASE_PATH.',
    # 'hubot env flush all - Flush all current environment variables in process.env and redis.',
    # 'hubot env flush all --dry-run - Try flushing all current environment variables in process.env and redis.',
    # 'hubot env load --filename=[filename] - Loads [filename] of environment variables in process.env and redis.',
    # 'hubot env load --filename=[filename] --dry-run - Try loading [filename] of environment variables in process.env and redis.',
    'hubot ping - Reply with pong.',
    'hubot time - Reply with current time.'
]

board_cmds = [
    'hubot <board, interns> - Helps add <board> or <interns> to channel.',
    'hubot <board, intern> help - Displays all of the admin help commands that this bot knows about.',
    'hubot <board, intern> help <query> - Displays all admin help commands that match <query>.',
    'hubot auth list <role> assigned users - List users assigned to <role>.',
    'hubot auth list <user> roles - List assigned roles of <user>. ',
    'hubot auth list assignments - List names and their assigned roles.',
    'hubot auth list roles - List all assigned roles.',
    'hubot calendar - Sends link to event calendar.',
    'hubot new event - Sends link to event form.'
]

module.exports = (robot) ->
    robot.respond /admin help(?:\s*$|(?: (.+)))?/i, (res) ->
        role = 'admin'
        user = robot.brain.userForName(res.message.user.name)
        unless user?
            return res.reply 'You do not exist.'
        unless robot.auth.hasRole(user, role)
            return res.reply 'Access Denied. You need role \'' + role + '\' to perform this action.'
        query = res.match[1]
        if query
            admin_cmds = admin_cmds.filter (cmd) ->
                cmd.match new RegExp(query, 'i')
            if admin_cmds.length is 0
                res.send 'No available commands match' + query
                return

        robot_name = robot.alias or robot.name
        for i in [0...admin_cmds.length]
            admin_cmds[i] = admin_cmds[i].replace /hubot/, robot_name
        retval = admin_cmds.join '\n'
        res.send retval

    robot.respond /(?:board|intern) help(?:\s*$|(?: (.+)))?/i, (res) ->
        role1 = 'board'
        role2 = 'intern'
        user = robot.brain.userForName(res.message.user.name)
        unless user?
            return res.reply 'You do not exist.'
        unless robot.auth.hasRole(user, role1) or robot.auth.hasRole(user, role2)
            return res.reply 'Access Denied. You need role \'' + role1 + '\' or \'' + role2 + '\' to perform this action.'
        query = res.match[1]
        if query
            board_cmds = board_cmds.filter (cmd) ->
                cmd.match new RegExp(query, 'i')
            if board_cmds.length is 0
                res.send 'No available commands match' + query
                return

        robot_name = robot.alias or robot.name
        for i in [0...board_cmds.length]
            board_cmds[i] = board_cmds[i].replace /hubot/, robot_name
        retval = board_cmds.join '\n'
        res.send retval