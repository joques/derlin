'use strict'

# This class represents a user model. It manipulates the user data
# representation through the data manager

PasswordHandler = require('../lib/password-handler').PasswordHandler

exports.UserModel = class UserModel
	constructor: (@dataManager) ->

	# authenticate a user given her username and password
	authenticate: (authenticationData, callback) =>
		console.log "in the user model will call data manager"
		# find the user from the database using the username submitted in the form
		@dataManager.findUser authenticationData.username, (findError, findResult) =>
			if findError?
				# the user does not exist or an error occurred while fetching the 
				# data from the database
				callback findError, null
			else
				# will now verify the password
				userPassword = findResult.password
				new PasswordHandler().verifyPassword authenticationData.password, userPassword, (verificationError, verificationRes) =>
					if verificationError?
						# the verification failed
						callback verificationError, null
					else
						if verificationRes
							# the verification was successful. 
							# Session data will be sent to the user
							callback null, {user: username}
						else
							# the verification failed. The password did not match
							authenticationError = new Error("Authentication failed for user #{authenticationData.username}")
							callback authenticationError, null