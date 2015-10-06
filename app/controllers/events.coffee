'use strict'

# this class represents an events controller. It handles all calls 
# related to events

moment = require 'moment'

EventModel = require('../models/event').EventModel

exports.EventsController = class EventsController
	constructor: (dataManager) ->
		@event = new  EventModel dataManager

	listAllEvents: (callback) =>
		console.log "events controller :: listing all events of the orientation programme"
		@event.listEvents (eventListError, eventList) =>
			callback eventListError, eventList

	# list all the events of the current day
	listEvents: (callback) =>
		console.log "inside the event controller about to fetch data..."
		@event.listEvents (eventListError, eventList) =>
			if eventListError?
				callback eventListError, null
			else
				eventsOfTheDay = []
				now = moment()
				for curEVent in eventList
					do (curEVent) =>
						curStartTime = curEVent.startTime
						curStartMmt = moment(curStartTime)
						if curStartMmt.isSame now, 'day'
							# this event was scheduled for today
							# insert begin and end as time
							if curStartMmt.isBefore now
								curEVent['completed'] = true
							else
								curEVent['completed'] = false
				callback null, eventsOfTheDay