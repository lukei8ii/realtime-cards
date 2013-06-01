class RTC.Cocos2d
  @init: ->
    d = document
    d.ccConfig =
      COCOS2D_DEBUG: 2 #0 to turn debug off, 1 for basic debug, and 2 for full debug
      box2d: false
      showFPS: false
      frameRate: 60
      renderMode: 1
      tag: "gameCanvas" #the dom element to run cocos2d on

    # load canvas
    unless d.createElement("canvas").getContext
      s = d.createElement("div")
      s.innerHTML = "<h2>Your browser does not support HTML5 canvas!</h2><p>Google Chrome is a browser that combines a minimal design with sophisticated technology to make the web faster, safer, and easier.Click the logo to download.</p><a href=\"http://www.google.com/chrome\" target=\"_blank\"><img src=\"http://www.google.com/intl/zh-CN/chrome/assets/common/images/chrome_logo_2x.png\" border=\"0\"/></a>"
      p = d.getElementById(c.tag).parentNode
      p.style.background = "none"
      p.style.border = "none"
      p.insertBefore s
      d.body.style.background = "#ffffff"

    # load engine file
    s = d.createElement "script"
    s.src = "/game/engine.js"
    d.body.appendChild s