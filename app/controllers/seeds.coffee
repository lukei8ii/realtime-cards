exports.seed = (req, res) ->
  seeder = require "../lib/seeder"
  seeder.init()
  res.send "seeded"