'use strict'

# This is the main class of the Orientation week application
# 
# @author José G. Quenum

# define an execution environmnent
myEnv = process.env.NODE_ENV || 'development'


# loading needed packages
bodyParser     = require 'body-parser'
compress       = require 'compression'
express        = require 'express'
fs             = require 'fs'
http2          = require 'http2'
methodOverride = require 'method-override'
morgan         = require 'morgan'

# loading the single instance of the data manager
DataManager = require('../app/lib/data-manager').DataManager

oneDay = 86400000

# create the express application
app = express()

# set up view template
app.set 'views', __dirname + '/../app/views'
app.engine('html', require('ejs').renderFile)

# more configuration
app.use(compress())
app.use(bodyParser.urlencoded({extended: false}))
app.use(bodyParser.json())
app.use(methodOverride())

# define folder for static files and how long they may be cached
app.use(express.static(__dirname + '/../app', {maxAge: oneDay}))

# instantiate he data manager
dataManager = new DataManager()

# this method call is a temporary fix to insert a bulk of data
# into the database before 
dataManager.insertBulkData false, (loadError, loadResult) =>
	if loadError?
		console.log "oops! there was an error loading the initial event data..."
	else
		# define the routes
		require('../app/routes/view-routes')(app)
		require('../app/routes/api-routes')(app, dataManager)

		# define key, certificate and security parameters for http2
		serverOptions =
			key: fs.readFileSync __dirname + '/ssl/orient.key'
			cert: fs.readFileSync __dirname + '/ssl/orient.crt'
			requestCert: true
			passphrase: 'when is your orientation week'

		# create the http2 server and connect it to the
		# express server
		server = http2.createServer serverOptions, app
		portNumber = 5491

		# start the server
		server.listen portNumber, () ->
			console.log "Orientation week application now running -- server listening on port %d in mode %s", portNumber, app.settings.env