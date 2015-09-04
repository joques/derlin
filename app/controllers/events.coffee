EventModel = require('../models/event').EventModel

exports.EventsController = class EventsController
	constructor: (dataManager) ->
		@event = new  EventModel dataManager

	listEvents: (callback) =>
		console.log "inside the event controller about to fetch data..."
		@event.listEvents (eventListError, eventList) =>
			callback eventListError, eventList