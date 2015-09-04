'use strict'

exports.EventModel = class EventModel
	constructor: (@dataManager) ->
		# 

	listEvents: (callback) =>
		console.log "in the event model will call data manager"
		@dataManager.getAllEvents (eventListError, eventList) =>
			callback eventListError, eventList