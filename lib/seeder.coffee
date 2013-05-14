Card = require "../models/card"

class Seeder
  @cards: [
    { name: "Forest", types: "Basic Land — Forest", rarity: "Basic Land", number: 273, text: "G", expansion: "Magic 2013" }
    { name: "Deadly Recluse", mana_costs: ["1","G"], types: "Creature — Spider", text: "Reach (This creature can block creatures with flying.) Deathtouch (Any amount of damage this deals to a creature is enough to destroy it.)", flavor: "Even dragons fear its silken strands.", power: 1, toughness: 2, expansion: "Magic 2013", rarity: "Common", number: 165 }
  ]

  @init: ->
    Card.findOneAndUpdate({ name: card.name }, card, { upsert: true }).exec() for card in @cards

module.exports = Seeder