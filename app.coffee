"use strict"

express       = require "express"
app           = express()
server        = require("http").createServer(app)
io            = require("socket.io").listen(server)
ConnectMincer = require "connect-mincer"
mongoose      = require "mongoose"

env           = process.env.NODE_ENV

app.use express.logger()

mincer = new ConnectMincer(
  root: __dirname
  production: env is "production"
  mountPoint: "/assets"
  manifestFile: __dirname + "/public/assets/manifest.json"
  paths: [
    "assets/stylesheets",
    "assets/javascripts",
    "assets/images",
    "vendor/javascripts"
  ]
)

app.use mincer.assets()
app.use "/assets", mincer.createServer() if env isnt "production"
app.set 'view engine', 'ejs'

# var redis = require('redis');
# var url = require('url');
# var redisURL = url.parse(process.env.REDISCLOUD_URL);
# var client = redis.createClient(redisURL.port, redisURL.hostname, {no_ready_check: true});
# client.auth(redisURL.auth.split(":")[1]);

uristring = process.env.MONGOLAB_URI or process.env.MONGOHQ_URL
mongoose.connect uristring, (err, res) ->
  if err
    console.log "ERROR connecting to: " + uristring + ". " + err
  else
    console.log "Succeeded connected to: " + uristring

io.configure ->
  io.set "transports", ["xhr-polling"]
  io.set "polling duration", 10

io.sockets.on "connection", (socket) ->
  socket.on "message", (msg) ->
    console.log "Message Received: ", msg
    socket.broadcast.emit "message", msg

  socket.on "my other event", (data) ->
    console.log data

app.get "/", (req, res) ->
  res.render "home.ejs"

app.get "/seed", (req, res) ->
  seeder = require "./lib/seeder"
  seeder.init()
  res.send "seeded"

# app.get('/redis', function(request, response) {
#   client.set('foo', 'bar');
#   client.get('foo', function (err, reply) {
#       console.log(reply.toString()); // Will print `bar`
#   });
# });

port = process.env.PORT or 5000
server.listen port, ->
  console.log "Listening on " + port