'use strict'

exports.PasswordHandler = class PasswordHandler
	constructor: ->
		# 

	verifyPassword: (clearText, hashedPassword, callback) =>
		bcrypt.compare clearText, hashedPassword, (compareError, compareResult) =>
			callback compareError, compareResult