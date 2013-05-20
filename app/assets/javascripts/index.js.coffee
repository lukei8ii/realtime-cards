$ ->
  user_id = $("#current_user").data("id")
  # return unless user_id

  iosocket = io.connect()

  iosocket.on "error", (reason) ->
    console.error "Unable to connect Socket.IO", reason

  iosocket.on "connect", ->
    console.log "Connected to Socket.IO"

  iosocket.on "users", (users) ->
    $("#clients").empty()

    $.each users, (index, user) ->
      content = (if user._id isnt user_id then "<a href='#' data-id='#{user._id}'>#{user.name}</a>" else user.name)
      $("#clients").append $("<li>#{content}</li>")

#     iosocket.on "message", (message) ->
#       test = 1
#       # $("#incomingChatMessages").append $("<li></li>").text(message)

#     iosocket.on "disconnect", ->
#       test = 1
#       # $("#incomingChatMessages").append "<li>Disconnected</li>"

#   $("#outgoingChatMessage").keypress (event) ->
#     if event.which is 13
#       event.preventDefault()
#       message = $("#outgoingChatMessage").val()
#       iosocket.send message
#       $("#incomingChatMessages").append $("<li></li>").text("[#{nickname}] #{message}")
#       $("#outgoingChatMessage").val ""

#   counter = 0
#   idList = new Array()

#   broadcastMessageCallback = (from, msg) ->
#     i = 0

#     while i < idList.length
#       manager.addBox idList[i]
#       $("#" + idList[i]).chatbox("option", "boxManager").addMsg from, msg
#       i++

#   # chatboxManager is excerpt from the original project
#   # the code is not very clean, I just want to reuse it to manage multiple chatboxes
#   manager = new RTC.ChatboxManager messageSent: broadcastMessageCallback

#   $("#link_add").click (event, ui) ->
#     counter++
#     id = "box" + counter
#     idList.push id
#     manager.addBox id,
#       dest: "dest" + counter # not used in demo
#       title: "box" + counter
#       first_name: "First" + counter
#       last_name: "Last" + counter


#     #you can add your own options too
#     event.preventDefault()

#   nickname = prompt "Please enter your nickname"
#   iosocket.emit "set nickname", nickname