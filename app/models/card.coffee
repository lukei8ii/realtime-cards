mongoose = require "mongoose"

cardSchema = new mongoose.Schema(
  name:
    type: String
    trim: true
  mana_costs: [
    type: String
  ]
  types:
    type: String
    trim: true
  text:
    type: String
    trim: true
  flavor:
    type: String
    trim: true
  power:
    type: Number
  toughness:
    type: Number
  expansion:
    type: String
    trim: true
  rarity:
    type: String
    trim: true
  number:
    type: Number
)

Card = mongoose.model "Cards", cardSchema

module.exports = Card