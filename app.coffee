express = require "express"
http = require "http"
app = express()
auth = require "./config/middlewares/authorization"
server = http.createServer(app)
io = require("socket.io").listen(server)
passport = require "passport"

# bootstrap env config
config_reader = require "yaml-config"
config = config_reader.readConfig "config/application.yaml"
for attr_name of config
  process.env[attr_name] ||= config[attr_name]

# bootstrap mincer config
require('./config/mincer')(app)

# bootstrap passport config
require("./config/passport")(passport)

# bootstrap socket.io config
require('./config/socket.io')(io)

# bootstrap db connection
uristring = process.env.MONGOLAB_URI or process.env.MONGOHQ_URL
mongoose.connect uristring

# bootstrap models
models_path = __dirname + "/app/models"
fs.readdirSync(models_path).forEach (file) ->
  require models_path + "/" + file

# bootstrap express config
require('./config/express')(app, passport)

# bootstrap routes
require("./config/routes")(app, passport, auth)

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")