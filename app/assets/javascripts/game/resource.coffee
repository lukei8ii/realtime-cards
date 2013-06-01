class RTC.Game.Resource
  @WALLPAPER: "https://s3.amazonaws.com/realtime-cards/mtg_wallpaper.jpg"

  @init: (callback) ->
    resources = []

    resources.push { src: @WALLPAPER }

    RTC.chat.iosocket.on "card_assets", (cards) =>
      $.each cards, (index, card) =>
        resources.push { src: card.image_url }

      callback resources if typeof callback is "function"

    RTC.chat.iosocket.emit "card_assets"