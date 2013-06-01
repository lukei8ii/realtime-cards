class RTC.Main
  @init: ->
    $(window).resize =>
      @resizeCanvas()

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
        cc.LoaderScene.preload RTC.g_ressources, (->
          director.replaceScene new @startScene()
        ), this

        RTC.Main.resizeCanvas()

        true
    )

    RTC.myApp = new cocos2dApp RTC.Game.RealtimeCardsScene

  @resizeCanvas: ->
    bounds = $(window)
    container = $("#Cocos2dGameContainer")
    canvas = $("canvas")
    menu = 41 # menu bar
    width = bounds.width()
    height = bounds.height() - menu

    if width < cc.originalCanvasSize.width
        cc.canvas.width = cc.originalCanvasSize.width
    else
        cc.canvas.width = width

    if height < cc.originalCanvasSize.height
        cc.canvas.height = cc.originalCanvasSize.height
    else
        cc.canvas.height = height

    originalRatio = cc.originalCanvasSize.width / cc.originalCanvasSize.height
    newRatio = cc.canvas.width / cc.canvas.height

    if newRatio > originalRatio
      cc.canvas.width = cc.canvas.height * originalRatio
    else
      cc.canvas.height = cc.canvas.width / originalRatio

    xScale = cc.canvas.width / cc.originalCanvasSize.width

    cc.canvas.width = cc.originalCanvasSize.width * xScale
    cc.canvas.height = cc.originalCanvasSize.height * xScale

    container.width(cc.canvas.width)
    container.height(cc.canvas.height)

    canvas.width(cc.canvas.width)
    canvas.height(cc.canvas.height)

    container.prev().css("margin-bottom", canvas.width * -1)

    cc.renderContext.translate(0, cc.canvas.height)
    cc.renderContext.scale(xScale, xScale)
    cc.Director.getInstance().setContentScaleFactor(xScale)