'use strict'

bcrypt = require 'bcrypt'

exports.PasswordHandler = class PasswordHandler
	constructor: ->
		# 

	verifyPassword: (clearText, hashedPassword, callback) =>
		bcrypt.compare clearText, hashedPassword, (compareError, compareResult) =>
			callback compareError, compareResult