mongoose = require "mongoose"

cardSchema = new mongoose.Schema(
  name:
    type: String
    trim: true
)

class Card extends mongoose.model "Cards", cardSchema

module.exports = Card