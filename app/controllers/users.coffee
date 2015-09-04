'use strict'

UserModel = require('../models/user').UserModel

exports.UsersController = class UsersController
	constructor: (dataManager) ->
		@user = new UserModel dataManager

	authenticate: (authenticationData, callback) =>
		console.log "inside the user controller about to authenticate users"
		@user.authenticate authenticationData, (authenticationError, authenticationResult) =>
			callback authenticationError, authenticationResult