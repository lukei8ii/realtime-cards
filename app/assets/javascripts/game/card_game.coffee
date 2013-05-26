$ ->
  $("body").on "cocos2d", ->
    RTC.RealtimeCards = cc.Layer.extend(init: ->
      @_super()
      s = cc.Director.getInstance().getWinSize()
      layer1 = cc.LayerColor.create(new cc.Color4B(255, 255, 0, 255), 760, 540)
      layer1.setAnchorPoint new cc.Point(0.5, 0.5)
      helloLabel = cc.LabelTTF.create("Hello world", "Arial", 20)
      helloLabel.setPosition new cc.Point(s.width / 2, s.height / 2)
      helloLabel.setColor new cc.Color3B(255, 0, 0)
      rotationAmount = 0
      scale = 1
      helloLabel.schedule ->
        @setRotation rotationAmount++
        rotationAmount = 0  if rotationAmount > 360
        @setScale scale
        scale += 0.05
        scale = 1 if scale > 10

      layer1.addChild helloLabel
      @addChild layer1
      true
    )

    RTC.RealtimeCardsScene = cc.Scene.extend(onEnter: ->
      @_super()
      layer = new RTC.RealtimeCards()
      layer.init()
      @addChild layer
    )