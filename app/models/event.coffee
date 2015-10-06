'use strict'

# This class represents an event model. It accesses and manipulates event
# objects in the database through the data manager

exports.EventModel = class EventModel
	constructor: (@dataManager) ->

	# this method lists all events of the day
	listEvents: (callback) =>
		console.log "in the event model will call data manager"
		@dataManager.getAllEvents (eventListError, eventList) =>
			callback eventListError, eventList