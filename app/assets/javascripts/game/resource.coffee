class RTC.Game.Resource
  @init: (callback) ->
    resources = []

    RTC.chat.iosocket.on "card_assets", (cards) =>
      $.each cards, (index, card) =>
        resources.push { src: card.image_url }

      callback resources if typeof callback is "function"

    RTC.chat.iosocket.emit "card_assets"