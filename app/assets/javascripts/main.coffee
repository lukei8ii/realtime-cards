$ ->
  $("body").on "cocos2d", ->
    cocos2dApp = cc.Application.extend(
      config: document["ccConfig"]
      ctor: (scene) ->
        @_super()
        @startScene = scene
        cc.COCOS2D_DEBUG = @config["COCOS2D_DEBUG"]
        cc.initDebugSetting()
        cc.setup @config["tag"]
        cc.AppController.shareAppController().didFinishLaunchingWithOptions()

      applicationDidFinishLaunching: ->
        if cc.RenderDoesnotSupport()

          #show Information to user
          alert "Browser doesn't support WebGL"
          return false

        # initialize director
        director = cc.Director.getInstance()

        # enable High Resource Mode(2x, such as iphone4) and maintains low resource on other devices.
        #director.enableRetinaDisplay(true);

        # turn on display FPS
        director.setDisplayStats @config["showFPS"]

        # set FPS. the default value is 1.0/60 if you don't call this
        director.setAnimationInterval 1.0 / @config["frameRate"]

        #load resources
        cc.LoaderScene.preload g_ressources, (->
          director.replaceScene new @startScene()
        ), this
        true
    )

    myApp = new cocos2dApp(RTC.RealtimeCardsScene)