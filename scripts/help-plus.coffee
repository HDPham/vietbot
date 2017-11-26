# Description:
#   Generates admin/board help commands for Hubot.
#
# Admin Commands:
#   hubot admin help - Displays all of the admin help commands that this bot knows about.
#   hubot admin help <query> - Displays all admin help commands that match <query>.
#
# Board Commands:
#   hubot board help - Displays all of the board help commands that this bot knows about.
#   hubot board help <query> - Displays all board help commands that match <query>.


admin_cmds = [
    'vietbot <user> doesn\'t have <role> role - Removes a role from a user.',
    'vietbot <user> has <role> role - Assigns a role to a user.',
    'vietbot adapter - Reply with the adapter.',
    'vietbot admin help - Displays all of the admin help commands that this bot knows about.',
    'vietbot admin help <query> - Displays all admin help commands that match <query>.',
    'vietbot echo <text> - Reply back with <text>.',
    'vietbot env current - Displays all current environment variables.',
    'vietbot env current --prefix=[prefix] - Displays current environment variables with prefix.',
    'vietbot env file - List name of files under HUBOT_ENV_BASE_PATH.',
    'vietbot env flush all - Flush all current environment variables in process.env and redis.',
    'vietbot env flush all --dry-run - Try flushing all current environment variables in process.env and redis.',
    'vietbot env load --filename=[filename] - Loads [filename] of environment variables in process.env and redis.',
    'vietbot env load --filename=[filename] --dry-run - Try loading [filename] of environment variables in process.env and redis.',
    'vietbot list assigned roles - List all assigned roles.',
    'vietbot ping - Reply with pong.',
    'vietbot time - Reply with current time.',
    'vietbot what is my id - Tells you your id from persistent storage.',
    'vietbot what is my name - Tells you your name from persistent storage.',
    'vietbot what roles do I have - Find out what roles you have.',
    'vietbot what roles does <user> have - Find out what roles a user has.',
    'vietbot who has <role> role - Find out who has the given role.'
]

board_cmds = [
    'vietbot add <board, interns> - Helps add <board> or <interns> to channel.',
    'vietbot board help - Displays all of the admin help commands that this bot knows about.',
    'vietbot board help <query> - Displays all admin help commands that match <query>.',
    'vietbot calendar - Sends link to event calendar.',
    'vietbot new event - Sends link to event form.'
]

module.exports = (robot) ->
    robot.respond /admin help(?:\s*$|(?: (.+)))?/i, (res) ->
        query = res.match[1]
        if query
            admin_cmds = admin_cmds.filter (cmd) ->
                cmd.match new RegExp(query, 'i')
            if admin_cmds.length is 0
                res.send 'No available commands match' + query
                return
        
        retval = admin_cmds.join '\n'
        res.send retval

    robot.respond /board help(?:\s*$|(?: (.+)))?/i, (res) ->
        query = res.match[1]
        if query
            board_cmds = board_cmds.filter (cmd) ->
                cmd.match new RegExp(query, 'i')
            if board_cmds.length is 0
                res.send 'No available commands match' + query
                return

        retval = board_cmds.join '\n'
        res.send retval
