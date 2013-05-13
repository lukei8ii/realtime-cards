Card = require "../models/card"

class Seeder
  @init: ->
    forest = new Card({ name: "Forest" })
    forest.save (err) ->
      console.log "Error on save!" if err

module.exports = Seeder