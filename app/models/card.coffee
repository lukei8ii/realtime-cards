mongoose = require "mongoose"

cardSchema = new mongoose.Schema(
  name:
    type: String
  cost:
    type: String
  type:
    type: String
  rules:
    type: String
  text:
    type: String
  power:
    type: Number
  toughness:
    type: Number
  sets: [
    type: String
  ]
  rarity:
    type: String
  number:
    type: Number
)

Card = mongoose.model "Cards", cardSchema

module.exports = Card