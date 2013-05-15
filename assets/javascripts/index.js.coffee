$ ->
  nickname = "Unknown"
  iosocket = io.connect()
  iosocket.on "connect", ->
    $("#incomingChatMessages").append $("<li>Connected</li>")

    iosocket.on "message", (message) ->
      $("#incomingChatMessages").append $("<li></li>").text(message)

    iosocket.on "disconnect", ->
      $("#incomingChatMessages").append "<li>Disconnected</li>"

  $("#outgoingChatMessage").keypress (event) ->
    if event.which is 13
      event.preventDefault()
      message = $("#outgoingChatMessage").val()
      iosocket.send message
      $("#incomingChatMessages").append $("<li></li>").text("[#{nickname}] #{message}")
      $("#outgoingChatMessage").val ""

  $("#setNickname").click (event) ->
    nickname = prompt "Please enter your nickname"
    iosocket.emit "set nickname", nickname