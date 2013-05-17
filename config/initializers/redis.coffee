redis = require "redis"
url = require "url"

module.exports = () ->
  # redisURL = url.parse(process.env.REDISCLOUD_URL)
  # client = redis.createClient(redisURL.port, redisURL.hostname,
  #   no_ready_check: true
  # )
  # client.auth redisURL.auth.split(":")[1]