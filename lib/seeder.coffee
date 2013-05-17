Card = require "../app/models/card"
jf = require "jsonfile"

class Seeder
  @init: ->
    file = "cards.json"
    jf.readFile require('path').resolve(__dirname, file), (err, obj) ->
      Card.findOneAndUpdate({ name: card.name }, card, { upsert: true }).exec() for card in obj

module.exports = Seeder