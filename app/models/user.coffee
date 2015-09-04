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
				# 
				callback null, {user: username}