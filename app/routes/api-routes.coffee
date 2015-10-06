'use strict'

# API routes

EventsController = require('../controllers/events').EventsController
UsersController = require('../controllers/users').UsersController

module.exports = (app, dataManager) ->
	# Fetch all daily events in a bulk
	app.route('/api/events').get (request, response) ->
		console.log "getting all events..."
		new EventsController(dataManager).listEvents (eventListError, eventList) =>
			if eventListError?
				response.json 500, {error: eventListError.message}
			else
				response.json eventList

	# Authenticate a user attempting to log into the system
	app.route('/api/authenticate').post (request, response) ->
		console.log "authenticating a user..."
		console.log request.body
		new UsersController(dataManager).authenticate request.body, (authenticationError, authenticationResult) =>
			if authenticationError?
				response.status(500).json({error: authenticationError.message})
			else
				response.status(200).json(authenticationResult)