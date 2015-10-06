'use strict'

# This utility class handles user passwords. It helps create encrypted
# user passwords to be stored in the database and verify them during
# authentication

bcrypt = require 'bcrypt'

exports.PasswordHandler = class PasswordHandler
	constructor: ->

	# generate hashed version of a password from a clear text.
	encryptPassword: (clearText, callback) =>
		# first generate a salt value to be used in the hash
		bcrypt.genSalt 9, (saltError, salt) =>
			if saltError?
				formattedSaltError = new Error("Error generating salt for password hash")
				callback formattedSaltError, null
			else
				# once the salt has been created use it to generate a hashed version
				# of the initial password
				bcrypt.hash clearText, salt, (hashError, hashedPassword) =>
					if hashError?
						formattedHashError = new Error("Error generating password hash")
						callback formattedHashError, null
					else
						callback null, hashedPassword

	# verify if a password corresponds to the hashed version
	verifyPassword: (clearText, hashedPassword, callback) =>
		bcrypt.compare clearText, hashedPassword, (compareError, compareResult) =>
			callback compareError, compareResult