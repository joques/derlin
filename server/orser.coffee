'use strict'

# This is the main class of the Orientation week application
# 
# @author José G. Quenum

myEnv = process.env.NODE_ENV || 'development'

bodyParser     = require 'body-parser'
compress       = require 'compression'
express        = require 'express'
fs             = require 'fs'
http2          = require 'http2'
methodOverride = require 'method-override'
morgan         = require 'morgan'

console.log __dirname

DataManager = require('../app/lib/data-manager').DataManager

oneDay = 86400000

# instantiating app
app = express()

# set up view template
app.set 'views', __dirname + '/../app/views'
app.engine('html', require('ejs').renderFile)

app.use(compress())
app.use(bodyParser.urlencoded({extended: true}))
app.use(methodOverride())

app.use(express.static(__dirname + '/../app'))

dataManager = new DataManager()

dataManager.insertBulkData false, (loadError, loadResult) =>
	if loadError?
		console.log "oops! there was an error loading the initial event data..."
	else
		# define the routes
		require('../app/routes/view-routes')(app)
		require('../app/routes/api-routes')(app, dataManager)

		serverOptions =
			key: fs.readFileSync __dirname + '/ssl/orient.key'
			cert: fs.readFileSync __dirname + '/ssl/orient.crt'
			requestCert: true
			passphrase: 'when is your orientation week'

		server = http2.createServer serverOptions, app
		portNumber = 5491

		server.listen portNumber, () ->
			console.log "Orientation week application now running -- server listening on port %d in mode %s", portNumber, app.settings.env