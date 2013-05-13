express = require("express")
app = express()
server = require("http").createServer(app)
io = require("socket.io").listen(server)
app.use express.logger()
port = process.env.PORT or 5000

# var redis = require('redis');
# var url = require('url');
# var redisURL = url.parse(process.env.REDISCLOUD_URL);
# var client = redis.createClient(redisURL.port, redisURL.hostname, {no_ready_check: true});
# client.auth(redisURL.auth.split(":")[1]);
mongoose = require("mongoose")
uristring = process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or "mongodb://localhost/HelloMongoose"
mongoose.connect uristring, (err, res) ->
  if err
    console.log "ERROR connecting to: " + uristring + ". " + err
  else
    console.log "Succeeded connected to: " + uristring

io.configure ->
  io.set "transports", ["xhr-polling"]
  io.set "polling duration", 10

app.get '/', (req, res) ->
  res.sendfile __dirname + '/index.html'

io.sockets.on "connection", (socket) ->
  socket.emit "news",
    hello: "world"

  socket.on "my other event", (data) ->
    console.log data

# app.get('/redis', function(request, response) {
#   client.set('foo', 'bar');
#   client.get('foo', function (err, reply) {
#       console.log(reply.toString()); // Will print `bar`
#   });
# });

server.listen port, ->
  console.log "Listening on " + port