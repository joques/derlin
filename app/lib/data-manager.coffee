'use strict'

# this singleton class handles all access to the database.
# The database being used in this application is Couchbase
# a NoSQL document store

async = require 'async'
Couchbase = require 'couchbase'

exports.DataManager = class DataManager

	# private function to get a user document from the database
	# here the username is the identifier of the document
	_findUser = (username, callback) ->
		console.log "finding user in db manager... #{username}"
		_getDefaultBucket.call @, (bucketError, dataBucket) =>
			if bucketError?
				callback bucketError, null
			else
				dataBucket.get username, (findError, findResult) =>
					callback findError, findResult

	# private function to retrieve all the events of the day from the database
	_getAllEvents = (callback) ->
		console.log "Second step of fetching all events"
		_getDefaultBucket.call @, (bucketError, dataBucket) =>
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

	# private function to get a data bucket
	_getDataBucket = (bucketName, callback) ->
		theBucket = @dataBucket[bucketName]
		if not theBucket?
			theBucket = new Couchbase.Cluster('couchbase://localhost').openBucket(bucketName)
			@dataBucket[bucketName] = theBucket
		callback null, theBucket

	# private function to get the default data bucket
	_getDefaultBucket = (callback) ->
		_getDataBucket.call @, 'default', (bucketError, bucket) =>
			callback bucketError, bucket

	# private function to insert a bulk of documents into the document store
	_insertDataIterator = (data, callback) ->
		_getDataBucket.call @, (bucketError, dataBucket) =>
			if bucketError?
				callback bucketError, null
			else
				dataBucket.insert data._id, data, (singleLoadError, singleLoadResult) =>
					callback singleLoadError, singleLoadResult

	# private function to insert a bulk of data for testing
	_insertBulkData = (shouldInsert, callback) ->
		if not shouldInsert
			callback null, null
		else
			sampleEvents = [
				event1 =
					_id: 'event0'
					type: 'events'
					school: 'SCI'
					title: 'Welcome to all new students'
					startTime: '2015-09-12 7:30'
					endTime: '2015-09-12 9:30'
					venue: 'ITH432'
					organizer: 'Lameck Amugongo'
				event2 =
					_id: 'event1'
					type: 'events'
					school: 'SCI'
					title: 'Information session about new technologies'
					startTime: '2015-09-12 9:45'
					endTime: '2015-09-12 11:30'
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
			]
			async.each sampleEvents, @_insertDataIterator, (insertError) =>
				if insertError?
					console.log insertError
					callback insertError, null
				else
					callback null, "Bulk data successgully loaded."

	constructor: ->
		@dataBucket = {}

	# insert a collection of test documents into the document store
	# this method is for testing purposes only
	insertBulkData: (shouldInsert, callback) =>
		_insertBulkData.call @, shouldInsert, (insertError, insertResult) =>
			callback insertError, insertResult

	# fetch all the events of the day from the database
	getAllEvents: (callback) =>
		console.log "first step in fetch all events from the db..."
		_getAllEvents.call @, (allEventsError, allEvents) =>
			callback allEventsError, allEvents

	# find a user document identified by the given username
	findUser: (username, callback) =>
		console.log "finding user #{username}..."
		_findUser.call @, username, (findError, findResult) =>
			callback findError, findResult