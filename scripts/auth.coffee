# Description
#   Assign roles to users and restrict command access in other scripts.
#
# Configuration:
#   HUBOT_AUTH_ADMIN - A comma separate list of user IDs
#
# Admin Commands:
#   hubot auth <user> add <role> role - Assigns <role> to <user>.
#   hubot auth <user> remove <role> role - Removes <role> from <user>.
#   hubot auth <user> id - Gives <user> id from persistent storage.
#   hubot auth <user> name - Gives <user> name from persistent storage.
#   hubot auth list <role> assigned users - List users assigned to <role>.
#   hubot auth list <user> roles - List assigned roles of <user>.
#   hubot auth list assignments - List names and their assigned roles.
#   hubot auth list roles - List all assigned roles.
#
# Notes:
#   * Call the method: robot.auth.hasRole(msg.envelope.user,'<role>')
#   * returns bool true or false
#
#   * the 'admin' role can only be assigned through the environment variable
#   * roles are all transformed to lower case
#
#   * The script assumes that user IDs will be unique on the service end as to
#     correctly identify a user. Names were insecure as a user could impersonate
#     a user
#
# Author:
#   Hung Pham

config =
  admin_list: process.env.HUBOT_AUTH_ADMIN

module.exports = (robot) ->

  unless config.admin_list?
    robot.logger.warning 'The HUBOT_AUTH_ADMIN environment variable not set'

  if config.admin_list?
    admins = config.admin_list.split ','
    for admin_id in admins
      user = robot.brain.userForId(admin_id)
      if user?
        user.roles or= []
        user.roles.push('admin')
  else
    admins = []

  class Auth
    isAdmin: (user) ->
      user.id.toString() in admins

    hasRole: (user, roles) ->
      userRoles = @userRoles(user)
      if userRoles?
        roles = [roles] if typeof roles is 'string'
        for role in roles
          return true if role in userRoles
      return false

    usersWithRole: (role) ->
      users = []
      for own key, user of robot.brain.data.users
        if @hasRole(user, role)
          users.push(user.name)
      users

    userRoles: (user) ->
      roles = []
      # if user? and robot.auth.isAdmin user
      #   roles.push('admin')
      if user.roles?
        roles = roles.concat user.roles
      roles

  robot.auth = new Auth


  robot.respond /auth @?(.+) add (["'\w: -_]+) role$/i, (msg) ->
    name = msg.match[1].trim()
    if name.toLowerCase() is 'i' then name = msg.message.user.name
    if name.match(/(.*)(?:don['’]t|doesn['’]t|do not|does not)/i) then return

    unless name.toLowerCase() in ['', 'who', 'what', 'where', 'when', 'why']
      unless robot.auth.isAdmin msg.message.user
        msg.reply 'Sorry, only admins can assign roles.'
      else
        newRole = msg.match[2].trim().toLowerCase()

        user = robot.brain.userForName(name)
        return msg.reply name + ' does not exist' unless user?
        user.roles or= []

        if newRole in user.roles
          msg.reply name + ' already has the \'' + newRole + '\' role.'
        else
          if newRole is 'admin'
            msg.reply 'Sorry, the \'admin\' role can only be defined in the HUBOT_AUTH_ADMIN env variable.'
          else
            myRoles = msg.message.user.roles or []
            user.roles.push(newRole)
            msg.reply 'OK, ' + name + ' has the \'' + newRole + '\' role.'

  robot.respond /auth @?(.+) remove (["'\w: -_]+) role$/i, (msg) ->
    name = msg.match[1].trim()
    if name.toLowerCase() is 'i' then name = msg.message.user.name

    unless name.toLowerCase() in ['', 'who', 'what', 'where', 'when', 'why']
      unless robot.auth.isAdmin msg.message.user
        msg.reply 'Sorry, only admins can remove roles.'
      else
        newRole = msg.match[2].trim().toLowerCase()

        user = robot.brain.userForName(name)
        return msg.reply name + ' does not exist' unless user?
        user.roles or= []

        if newRole is 'admin'
          msg.reply 'Sorry, the \'admin\' role can only be removed from the HUBOT_AUTH_ADMIN env variable.'
        else
          myRoles = msg.message.user.roles or []
          user.roles = (role for role in user.roles when role isnt newRole)
          msg.reply 'OK, ' + name + ' doesn\'t have the \'' + newRole + '\' role.'

  robot.respond /auth list @?(.+) roles?$/i, (msg) ->
    role1 = 'admin'
    role2 = 'board'
    role3 = 'intern'
    messanger = robot.brain.userForName(msg.message.user.name)
    unless messanger?
      return msg.reply 'You do not exist.'
    unless robot.auth.hasRole(messanger, role1) or robot.auth.hasRole(messanger, role2) or robot.auth.hasRole(messanger, role3)
      return msg.reply 'Access Denied.'

    name = msg.match[1].trim()
    if name.toLowerCase() is 'my' then name = msg.message.user.name
    user = robot.brain.userForName(name)
    return msg.reply name + ' does not exist' unless user?
    userRoles = robot.auth.userRoles(user)
    if userRoles.length == 0
      msg.reply name + ' has no roles.'
    else
      msg.reply name + ' has the following roles: ' + userRoles.join ', '

  robot.respond /auth list (["'\w: -_]+) assigned users?$/i, (msg) ->
    role1 = 'admin'
    role2 = 'board'
    role3 = 'intern'
    messanger = robot.brain.userForName(msg.message.user.name)
    unless messanger?
      return msg.reply 'You do not exist.'
    unless robot.auth.hasRole(messanger, role1) or robot.auth.hasRole(messanger, role2) or robot.auth.hasRole(messanger, role3)
      return msg.reply 'Access Denied.'
    
    role = msg.match[1]
    userNames = robot.auth.usersWithRole(role) if role?
    if userNames.length > 0
      msg.reply 'The following people have the \'' + role +  '\' role: ' + userNames.join ', '
    else
      msg.reply 'There are no people that have the \'' + role + '\' role.'

  robot.respond /auth list roles?$/i, (msg) ->
    role1 = 'admin'
    role2 = 'board'
    role3 = 'intern'
    messanger = robot.brain.userForName(msg.message.user.name)
    unless messanger?
      return msg.reply 'You do not exist.'
    unless robot.auth.hasRole(messanger, role1) or robot.auth.hasRole(messanger, role2) or robot.auth.hasRole(messanger, role3)
      return msg.reply 'Access Denied.'
    
    roles = []
    for i, user of robot.brain.data.users when user.roles
      roles.push role for role in user.roles when role not in roles
    if roles.length > 0
      msg.reply 'The following roles are available: ' + roles.join ', '
    else
      msg.reply 'No roles to list.'

  robot.respond /auth list assignments?$/i, (msg) ->
    role1 = 'admin'
    role2 = 'board'
    role3 = 'intern'
    messanger = robot.brain.userForName(msg.message.user.name)
    unless messanger?
      return msg.reply 'You do not exist.'
    unless robot.auth.hasRole(messanger, role1) or robot.auth.hasRole(messanger, role2) or robot.auth.hasRole(messanger, role3)
      return msg.reply 'Access Denied.'
    
    retval = '*Here is the list of names and roles*\n'
    for i, user of robot.brain.data.users when user.roles
      retval += '>' + user.name + ': ' + user.roles.join(', ') + '\n'
    msg.reply retval
  
  robot.respond /auth @?(.+) name\s*$/i, (msg) ->
    name = msg.match[1].trim()
    if name.toLowerCase() is 'my' then name = msg.message.user.name
    user = robot.brain.userForName(name)

    messanger = robot.brain.userForId(msg.envelope.user['id'])
    unless user and user['name']
      return msg.reply 'Your user could not be found in my Brain, sorry!'
    unless robot.auth.hasRole(messanger, 'admin')
      return msg.reply 'Access Denied. You need role \'admin\' to perform this action.'
    msg.reply name + '\'s name is: ' + user['name'] + '.'

  robot.respond /auth @?(.+) id\s*$/i, (msg) ->
    name = msg.match[1].trim()
    if name.toLowerCase() is 'my' then name = msg.message.user.name
    user = robot.brain.userForName(name)

    messanger = robot.brain.userForId(msg.envelope.user['id'])
    unless user and user['id']
      return msg.reply 'Your user could not be found in my Brain, sorry!'
    unless robot.auth.hasRole(messanger, 'admin')
      return msg.reply 'Access Denied. You need role \'admin\' to perform this action.'
    msg.reply name + '\'s ID is: ' + user['id'] + '.'