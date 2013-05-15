module.exports = (app) ->
  app.get "/seed", (req, res, next) ->
    seeder = require "./lib/seeder"
    seeder.init()
    res.send "seeded"