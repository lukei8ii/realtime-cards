mongoose = require "mongoose"
Schema = mongoose.Schema

cardSchema = new Schema(
  name: String
  type: String
  cost: String
  rules: String
  text: String
  loyalty: Number
  power: Number
  toughness: Number
  rarity: String
  sets: [
    name: String
    number: Number
  ]
)

cardSchema.statics.findOrCreate = (card, index) ->
  @findOne { name: card.name }, (err, c) =>
    console.log("error finding: ", err) if err

    if c
      console.log "#{index} - updating: #{card.name}"
      c.sets.concat card.sets
      c.save()
    else
      console.log "#{index} - creating: #{card.name}"
      @create card, (err) ->
        console.log("error creating: ", err) if err

module.exports = mongoose.model "Card", cardSchema