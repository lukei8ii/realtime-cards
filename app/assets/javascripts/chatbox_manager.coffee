class RTC.ChatboxManager

  constructor: (@current_user_id, options) ->
    @config =
      width: 300 #px
      gap: 20
      maxBoxes: 5

    $.extend @config, options

    # list of all opened boxes
    @box_list = []
    # list of boxes shown on the page
    @show_list = []
    # list of user ids
    @user_list = []

    $("#clients").on "click", "a[rel='user']", (event) =>
      event.preventDefault()
      user_id = $(event.target).data("user_id")
      box_id = @getBoxId(user_id)
      user = @getUserById user_id
      @addBox box_id, user, true

    @initializeSocketIo()

  getBoxId: (user_id) ->
    "box_#{user_id}"

  getUserById: (user_id) ->
    $.grep(@user_list, (u) ->
      u._id is user_id
    )[0]

  initializeSocketIo: ->
    @iosocket = io.connect()

    @iosocket.on "error", (reason) ->
      console.error "Unable to connect Socket.IO", reason

    @iosocket.on "connect", ->
      console.log "Connected to Socket.IO"

    @iosocket.on "users", (users) =>
      @user_list = users
      @current_user ||= @getUserById @current_user_id

      $("#clients").empty()

      $.each users, (index, user) ->
        # content = if user._id isnt user_id
        content = "<a href='#' rel='user' data-user_id='#{user._id}'>#{user.name}</a>"
        # else user.name

        $("#clients").append $("<li>#{content}</li>")

    @iosocket.on "private", (data) =>
      box_id = @getBoxId data.from
      user = @getUserById data.from
      @addBox box_id, user, false, data.message

  delBox: (id) ->
    # TODO

  getNextOffset: ->
    (@config.width + @config.gap) * @show_list.length

  boxClosedCallback: (id) =>
    # close button in the titlebar is clicked
    idx = @show_list.indexOf(id)

    if idx isnt -1
      @show_list.splice idx, 1
      diff = @config.width + @config.gap
      i = idx

      while i < @show_list.length
        offset = $("#" + @show_list[i]).chatbox("option", "offset")
        $("#" + @show_list[i]).chatbox "option", "offset", offset - diff
        i++
    else
      alert "should not happen: " + id

  addBox: (box_id, user, focus = false, message = null) ->
    idx1 = @show_list.indexOf box_id
    idx2 = @box_list.indexOf box_id

    unless idx1 is -1
    # found one in show box, do nothing
    else unless idx2 is -1
      # exists, but hidden
      # show it and put it back to @show_list
      box = $("##{box_id}")
      box.chatbox "option", "offset", @getNextOffset()
      manager = box.chatbox("option", "boxManager")
      manager.toggleBox()
      @show_list.push box_id
    else
      el = document.createElement("div")
      el.setAttribute "id", box_id

      $(el).chatbox
        id: box_id
        user: user
        title: user.name
        hidden: false
        width: @config.width
        offset: @getNextOffset()
        messageSent: @messageSentCallback
        boxClosed: @boxClosedCallback

      @box_list.push box_id
      @show_list.push box_id

    @messageReceived box_id, user, message if message
    $(el).chatbox("option", "boxManager").elem.uiChatboxInputBox.focus() if focus

  messageSentCallback: (box_id, user, message) =>
    @iosocket.emit "private", { to: user._id, message: message }
    $("##{box_id}").chatbox("option", "boxManager").addMsg @current_user.name, message

  messageReceived: (box_id, user, message) ->
    $("##{box_id}").chatbox("option", "boxManager").addMsg user.name, message