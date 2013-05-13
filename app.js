var express = require('express');
var app = express();
app.use(express.logger());

var redis = require('redis');
var url = require('url');
var redisURL = url.parse(process.env.REDISCLOUD_URL);
var client = redis.createClient(redisURL.port, redisURL.hostname, {no_ready_check: true});
client.auth(redisURL.auth.split(":")[1]);

app.get('/', function(request, response) {
  response.send('Hello World!');
});

app.get('/redis', function(request, response) {
  client.set('foo', 'bar');
  client.get('foo', function (err, reply) {
      console.log(reply.toString()); // Will print `bar`
  });
});

var port = process.env.PORT || 5000;
app.listen(port, function() {
  console.log("Listening on " + port);
});