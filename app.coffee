express = require "express"
http = require "http"
app = express()
server = http.createServer(app)
io = require("socket.io").listen(server)
passport = require "passport"
fs = require "fs"
mongoose = require "mongoose"
auth = require "./config/middlewares/authorization"
session_extender = require "./config/middlewares/session_extender"
redisSessionStore = require("./config/initializers/redis")(express)
app_helper = require("./app/helpers/application_helper")()

# bootstrap models
models_path = __dirname + "/app/models"
fs.readdirSync(models_path).forEach (file) ->
  require models_path + "/" + file

# bootstrap mincer config
require('./config/initializers/mincer')(app, __dirname) if process.env.NODE_ENV isnt "production"

# bootstrap express config
require('./config/initializers/express')(app, __dirname, redisSessionStore, passport, session_extender, app_helper)

# bootstrap passport config
require("./config/initializers/passport")(passport)

# bootstrap socket.io config
require('./config/initializers/socket.io')(io, redisSessionStore)

# bootstrap db connection
mongoose.connect process.env.MONGOLAB_URI

# bootstrap routes
require("./config/routes")(app, passport, auth)

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")