'use strict'

# this class represents a users controller. It handles all calls
# related to users

UserModel = require('../models/user').UserModel

exports.UsersController = class UsersController
	constructor: (dataManager) ->
		@user = new UserModel dataManager

	# authenticate a user given her username and password
	authenticate: (authenticationData, callback) =>
		console.log "inside the user controller about to authenticate users"
		@user.authenticate authenticationData, (authenticationError, authenticationResult) =>
			callback authenticationError, authenticationResult