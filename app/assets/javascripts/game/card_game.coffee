class RTC.Game.CardGame
  @init: ->
    RTC.Game.RealtimeCards = cc.Layer.extend(init: ->
      @_super()
      size = cc.Director.getInstance().getWinSize()

      RTC.chat.iosocket.on "cards", (cards) =>
        $.each cards, (index, card) =>
          lazyLayer = cc.Layer.create()
          @addChild lazyLayer

          @sprite = cc.Sprite.create card.image_url
          @sprite.setPosition(cc.p(size.width / 2 + index * 40, size.height / 2))
          @sprite.setScale 0.5

          lazyLayer.addChild @sprite, 0

      RTC.chat.iosocket.emit "cards"

      true
    )

    RTC.Game.RealtimeCardsScene = cc.Scene.extend(onEnter: ->
      @_super()
      layer = new RTC.Game.RealtimeCards()
      layer.init()
      @addChild layer
    )