RTC = {}

$ ->
  RTC.chat = new RTC.ChatboxManager $("#current_user").data("id")

  $("#friendLink").click (e) ->
    $("#friends").show()

  $("#closeFriends").click (e) ->
    $("#friends").hide()

  RTC.Resource.init (resources) ->
    RTC.g_ressources = resources
    RTC.Cocos2d.init()

  $("body").on "cocos2d", ->
    RTC.CardGame.init()
    RTC.Main.init()