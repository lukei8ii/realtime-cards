class RTC.CardGame
  @init: ->
    RTC.RealtimeCards = cc.Layer.extend(init: ->
      @_super()
      size = cc.Director.getInstance().getWinSize()

      lazylayer = cc.Layer.create()
      @addChild lazylayer

      @sprite = cc.Sprite.create RTC.Resource.WALLPAPER
      content_size = @sprite.getContentSize()
      scaleX = size.width / content_size.width
      @sprite.setScale scaleX
      @sprite.setAnchorPoint(cc.p(0.5, 0.5))
      @sprite.setPosition(cc.p(size.width / 2, size.height / 2))

      lazylayer.addChild @sprite, 0

      RTC.chat.iosocket.on "cards", (cards) =>
        $.each cards, (index, card) =>
          @sprite = cc.Sprite.create card.image_url
          @sprite.setPosition(cc.p(size.width / 2 + index * 40, size.height / 2))
          @sprite.setScale 0.5

          lazylayer.addChild @sprite, 0

      RTC.chat.iosocket.emit "cards"

      true
    )

    RTC.RealtimeCardsScene = cc.Scene.extend(onEnter: ->
      @_super()
      layer = new RTC.RealtimeCards()
      layer.init()
      @addChild layer
    )