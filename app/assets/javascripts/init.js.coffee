RTC = {}
RTC.Game = {}

$ ->
  RTC.chat = new RTC.ChatboxManager $("#current_user").data("id")
  RTC.Game.Resource.init (resources) ->
    RTC.g_ressources = resources
    RTC.Cocos2d.init()

  $("body").on "cocos2d", ->
    RTC.Game.CardGame.init()
    RTC.Main.init()