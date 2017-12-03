# Description
#   Assign roles to users and restrict command access in other scripts.
#
# Configuration:
#   HUBOT_AUTH_ADMIN - A comma separate list of user IDs
#   HUBOT_AUTH_ROLES - A list of roles with a comma delimited list of user ids
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
#   * the 'admin' role can only be assigned through the environment variable and
#     it is not persisted
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
    role_list: process.env.HUBOT_AUTH_ROLES

module.exports = (robot) ->
    # admin role is not persistent. List of user IDs who have admin role
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
    fetchAllRoles: () ->
        unless robot.brain.get('roles')
            robot.brain.set('roles', {})
        robot.brain.get('roles')

    isAdmin: (user) ->
        @hasRole(user, 'admin')

    hasRole: (user, roles) ->
      userRoles = @userRoles(user)
      if userRoles?
        roles = [roles] if typeof roles is 'string'
        for role in roles
          return true if role == "admin" and user.id in admins
          return true if role in userRoles
      return false

    usersWithRole: (role) ->
      users = []
      for own key, user of robot.brain.users()
        if @hasRole(user, role)
          users.push(user.name)
      users

    userRoles: (user) ->
      @fetchAllRoles()[user.id] or []

    addRole: (user, newRole) ->
      if newRole == "admin"
        admins.push(user.id)
        return
      userRoles = @userRoles(user)
      userRoles.push newRole unless newRole in userRoles
      allNewRoles = @fetchAllRoles()
      allNewRoles[user.id] = userRoles
      robot.brain.set('roles', allNewRoles)

    revokeRole: (user, newRole) ->
      if role == "admin"
        admins = (u for u in admins when u != user.id)
        return
      userRoles = @userRoles(user)
      userRoles = (role for role in userRoles when role isnt newRole)
      allNewRoles = @fetchAllRoles()
      allNewRoles[user.id] = userRoles
      robot.brain.set('roles', allNewRoles)

    getRoles: () ->
      result = if admins then ["admin"] else []
      for own key,roles of @fetchAllRoles('roles')
        result.push role for role in roles unless role in result
      result

	robot.auth = new Auth

	# TODO: This has been deprecated so it needs to be removed at some point.
	if config.admin_list?
		robot.logger.warning 'The HUBOT_AUTH_ADMIN environment variable has been deprecated in favor of HUBOT_AUTH_ROLES'
		for id in config.admin_list.split ','
		robot.auth.addRole({ id }, 'admin')

	unless config.role_list?
		robot.logger.warning 'The HUBOT_AUTH_ROLES environment variable not set'
	else
		for role in config.role_list.split ' '
		[dummy, roleName, userIds] = role.match /(\w+)=([\w]+(?:,[\w]+)*)/
		for id in userIds.split ','
		robot.auth.addRole({ id }, roleName)


	robot.respond /auth @?(.+) add (["'\w: -_]+) role$/i, (msg) ->
		name = msg.match[1].trim()
		if name.toLowerCase() is 'i' then name = msg.message.user.name

		unless robot.auth.isAdmin msg.message.user
    		msg.reply 'Sorry, only admins can assign roles.'
    	else
    		newRole = msg.match[2].trim().toLowerCase()

			user = robot.brain.userForName(name)
			return msg.reply name + ' does not exist' unless user?

			if robot.auth.hasRole(user, newRole)
				msg.reply name + ' already has the \'' + newRole + '\' role.'
			else if newRole is 'admin'
				msg.reply 'Sorry, the \'admin\' role can only be defined in the HUBOT_AUTH_ADMIN env variable.'
			else
				robot.auth.addRole user, newRole
				msg.reply 'OK, ' + name + ' has the \'' + newRole + '\' role.'


	robot.respond /auth @?(.+) remove (["'\w: -_]+) role$/i, (msg) ->
		name = msg.match[1].trim()
		if name.toLowerCase() is 'i' then name = msg.message.user.name

		unless robot.auth.isAdmin msg.message.user
			msg.reply 'Sorry, only admins can remove roles.'
		else
			newRole = msg.match[2].trim().toLowerCase()
			
			user = robot.brain.userForName(name)
			return msg.reply name + ' does not exist' unless user?

			if newRole is 'admin'
				msg.reply 'Sorry, the \'admin\' role can only be removed from the HUBOT_AUTH_ADMIN env variable.'
			else
				robot.auth.revokeRole user, newRole
				msg.reply 'OK, ' + name + ' doesn\'t have the \'' + newRole + '\' role.'


	robot.respond /auth list @?(.+) roles?$/i, (msg) ->
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
		role = msg.match[1]
		userNames = robot.auth.usersWithRole(role) if role?
		if userNames.length > 0
			msg.reply 'The following people have the \'' + role +  '\' role: ' + userNames.join ', '
		else
			msg.reply 'There are no people that have the \'' + role + '\' role.'


	robot.respond /auth list roles?$/i, (msg) ->
		roles = robot.auth.getRoles()
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