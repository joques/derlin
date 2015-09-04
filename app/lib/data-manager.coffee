'use strict'

async = require 'async'
Couchbase = require 'couchbase'

exports.DataManager = class DataManager

	_getAllEvents = (callback) ->
		console.log "Second step of fetching all events"
		_getDataBucket.call @, (bucketError, dataBucket) =>
			if bucketError?
				callback bucketError, null
			else
				console.log "got the bucket. Will pull them all"
				ViewQuery = Couchbase.ViewQuery
				allEvtsQuery = ViewQuery.from('dev_events', 'events')
				dataBucket.query allEvtsQuery, (multiEventError, multiEvents) =>
					if multiEventError?
						callback multiEventError, null
					else
						events = (curEvent.value for curEvent in multiEvents)
						callback null, events

	_getDataBucket = (callback) ->
		@dataBucket ?= new Couchbase.Cluster('couchbase://localhost').openBucket('default')
		callback null, @dataBucket

	_insertSingleData = (data, callback) ->
		_getDataBucket.call @, (bucketError, dataBucket) =>
			if bucketError?
				callback bucketError, null
			else
				dataBucket.insert data._id, data, (singleLoadError, singleLoadResult) =>
					callback singleLoadError, singleLoadResult

	constructor: ->
		@dataBucket = null
		# constructor for data manager

	insertBulkData: (shouldInsert, callback) =>
		if not shouldInsert
			callback null, null
		else
			event1 =
				_id: 'event0'
				type: 'events'
				school: 'SCI'
				title: 'Welcome to all new students'
				startTime: '2015-09-02 7:30'
				endTime: '2015-09-02 9:30'
				venue: 'ITH432'
				organizer: 'Lameck Amugongo'
			event2 =
				_id: 'event1'
				type: 'events'
				school: 'SCI'
				title: 'Information Session about New Technologies'
				startTime: '2015-09-02 9:30'
				endTime: '2015-09-02 11:30'
				venue: 'ITH2245'
				organizer: 'Heinrich Aluvilu'
			event3 =
				_id: 'event2'
				type: 'events'
				school: 'SCI'
				title: 'Quizz in Computing Technologies'
				startTime: '2015-09-02 11:30'
				endTime: '2015-09-02 12:30'
				venue: 'ITH4439'
				organizer: 'Damien Fouchet'
			sampleEvents = [event1, event2, event3]
			async.each sampleEvents, @insertSingleData, (insertError) =>
				if insertError?
					console.log insertError
					callback insertError, null
				else
					callback null, "Bulk data successgully loaded."

	insertSingleData: (dataItem, callback) =>
		_insertSingleData.call @, dataItem, (loadError, loadResult) =>
			callback loadError

	getAllEvents: (callback) =>
		console.log "first step in fetch all events from the db..."
		_getAllEvents.call @, (allEventsError, allEvents) =>
			callback allEventsError, allEvents