'use strict'

PasswordHandler = require('../lib/password-handler').PasswordHandler

exports.UserModel = class UserModel
	constructor: (@dataManager) ->
		# 

	authenticate: (authenticationData, callback) =>
		console.log "in the user model will call data manager"
		@dataManager.findUser authenticationData.username, (findError, findResult) =>
			if findError?
				callback findError, null
			else
				userPassword = findResult.password
				new PasswordHandler().verifyPassword authenticationData.password, userPassword, (verificationError, verificationRes) =>
					if verificationError?
						callback verificationError, null
					else
						if verificationRes
							callback null, {user: username}
						else
							authenticationError = new Error("Authentication failed for user #{authenticationData.username}")
							callback authenticationError, null