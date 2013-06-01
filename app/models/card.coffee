mongoose = require "mongoose"
Schema = mongoose.Schema
_ = require "underscore"

CARD_SETS =
  "Magic 2013": "m13"

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

cardSchema.set('toJSON', { virtuals: true })

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

# cardSchema.methods.image_url = (set_name) ->
#   set = (if set_name then _.findWhere(@sets, { name: set_name }) else @sets[0])
#   set_id = constants.CARD_SETS[set.name]
#   "https://s3.amazonaws.com/realtime-cards/#{set_id}/#{set.number}.jpg"

cardSchema.virtual("image_url").get ->
  set = @sets[0]
  set_id = CARD_SETS[set.name]
  "https://s3.amazonaws.com/realtime-cards/#{set_id}/#{set.number}.jpg"

module.exports = Card = mongoose.model "Card", cardSchema

Card.CARD_SETS = CARD_SETS