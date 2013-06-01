class RTC.CardGame
  @init: ->
    RTC.RealtimeCards = cc.Layer.extend(init: ->
      @_super()
      size = cc.Director.getInstance().getWinSize()
      scale = 1 / 3

      lazylayer = cc.Layer.create()
      @addChild lazylayer

      @sprite = cc.Sprite.create RTC.Resource.WALLPAPER
      content_size = @sprite.getContentSize()
      scaleX = size.width / content_size.width
      @sprite.setScale scaleX
      @sprite.setAnchorPoint(cc.p(0.5, 0.5))
      @sprite.setPosition(cc.p(size.width / 2, size.height / 2))

      lazylayer.addChild @sprite, 0

      laylayer = cc.Layer.create()
      @addChild lazylayer

      RTC.chat.iosocket.on "cards", (cards) =>
        sprite = cc.Sprite.create cards[0].image_url
        total_width = (cards.length - 1) * 40 + sprite.getContentSize().width * scale
        y = sprite.getContentSize().height / 2 * scale + 10

        $.each cards, (index, card) =>
          @sprite = cc.Sprite.create card.image_url
          @sprite.setAnchorPoint(cc.p(1, 0.5))
          x = size.width / 2 + total_width / 2 - index * 40
          @sprite.setPosition(cc.p(x, y))
          @sprite.setScale (scale)

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