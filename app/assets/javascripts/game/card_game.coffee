$ ->
  $("body").on "cocos2d", ->
    RTC.RealtimeCards = cc.Layer.extend(init: ->
      @_super()
      size = cc.Director.getInstance().getWinSize()

      lazyLayer = cc.Layer.create()
      @addChild lazyLayer

      @sprite = cc.Sprite.create "https://s3.amazonaws.com/realtime-cards/37.jpg"
      @sprite.setPosition(cc.p(size.width / 2, size.height / 2))
      # @sprite.setScale 0.5

      lazyLayer.addChild @sprite, 0

      true
    )

    RTC.RealtimeCardsScene = cc.Scene.extend(onEnter: ->
      @_super()
      layer = new RTC.RealtimeCards()
      layer.init()
      @addChild layer
    )