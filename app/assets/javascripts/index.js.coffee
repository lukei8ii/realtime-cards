$ ->
  user_list = []
  user_id = $("#current_user").data("id")
  # return unless user_id

  iosocket = io.connect()

  iosocket.on "error", (reason) ->
    console.error "Unable to connect Socket.IO", reason

  iosocket.on "connect", ->
    console.log "Connected to Socket.IO"

  iosocket.on "users", (users) ->
    user_list = users
    $("#clients").empty()

    $.each users, (index, user) ->
      # content = if user._id isnt user_id
      content = "<a href='#' rel='user' data-user_id='#{user._id}'>#{user.name}</a>"
      # else user.name

      $("#clients").append $("<li>#{content}</li>")

  iosocket.on "private message", (message) ->
    # See if you already have a chat window open with this user
    # If not, open one
    # Add message to chat window


  counter = 0
  id_list = []

  messageSentCallback = (dest, msg) ->
    alert "send to user: #{dest}, msg: #{msg}"
    # i = 0

    # while i < id_list.length
    #   manager.addBox idList[i]
    #   $("#" + idList[i]).chatbox("option", "boxManager").addMsg from, msg
    #   i++


  manager = new RTC.ChatboxManager messageSent: messageSentCallback

  $("#clients").on "click", "a[rel='user']", (event) ->
    event.preventDefault()
    user_id = $(this).data("user_id")
    user = $.grep(user_list, (u) ->
      u._id is user_id
    )[0]

    counter++
    id = "box" + counter
    id_list.push id

    manager.addBox id, user

   $("#outgoingChatMessage").keypress (event) ->
     if event.which is 13
       event.preventDefault()
       message = $("#outgoingChatMessage").val()
       iosocket.send message
       $("#incomingChatMessages").append $("<li></li>").text("[#{nickname}] #{message}")
       $("#outgoingChatMessage").val ""