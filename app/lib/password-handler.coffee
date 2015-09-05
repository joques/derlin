'use strict'

bcrypt = require 'bcrypt'

exports.PasswordHandler = class PasswordHandler
	constructor: ->
		# 

	encryptPassword: (clearText, callback) =>
		bcrypt.genSalt 9, (saltError, salt) =>
			if saltError?

				callback new Error("Error generating salt"), null
			else
				bcrypt.hash clearText, salt, (hashError, hashedPassword) =>
					if hashError?
						callback new Error("Error generating hash"), null
					else
						callback null, hashedPassword

	verifyPassword: (clearText, hashedPassword, callback) =>
		bcrypt.compare clearText, hashedPassword, (compareError, compareResult) =>
			callback compareError, compareResult