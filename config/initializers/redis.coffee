url = require "url"
redis = require "redis"

module.exports = (express) ->
  redisURL = url.parse(process.env.REDISCLOUD_URL)

  client = redis.createClient(redisURL.port, redisURL.hostname,
    no_ready_check: true
  )
  client.auth redisURL.auth.split(":")[1]

  RedisSessionStore = require("connect-redis")(express)
  new RedisSessionStore(client: client)