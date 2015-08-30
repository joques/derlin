# This is the main class of the Orientation week application
# 
# @author José G. Quenum

myEnv = process.env.NODE_ENV || 'development'

bodyParser = require 'body-parser'
compress = require 'compression'
express = require 'express'
http2 = require 'http2'
methodOverride = require 'method-override'
morgan = require 'morgan'

oneDay = 86400000

# instantiating app
app = express()

# set up view template
app.set 'views', __dirname + '../app/views'
app.engine('html', require('ejs').renderFile)

app.use(compress())
app.use(bodyParser.urlencoded({extended: true}))
app.use(methodOverride())

app.use(express.static(__dirname + '/../app'))

serverOptions =
	key: fs.readFileSync 'ssl/or.key'
	cert: fs.readFileSync 'ssl/or.crt'
	requestCert: true
	passphrase: 'when is your orientation week'

server = http2.createServer serverOptions, app
portNumber = 5491

server.listen portNumber, () ->
	console.log "Orientation week application now running -- server listening on port %d in mode %s".underline.green, portNumber, app.settings.env
