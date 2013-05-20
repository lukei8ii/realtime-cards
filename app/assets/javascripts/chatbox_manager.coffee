class RTC.ChatboxManager

  constructor: (options) ->
    @config =
      width: 300 #px
      gap: 20
      maxBoxes: 5
      messageSent: (dest, msg) ->
        # override this
        $("#" + dest).chatbox("option", "boxManager").addMsg dest, msg

    $.extend @config, options

    # list of all opened boxes
    @box_list = []

    # list of boxes shown on the page
    @show_list = []

    # list of user ids
    @user_list = []

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

  # caller should guarantee the uniqueness of id
  addBox: (id, user) ->
    idx1 = @show_list.indexOf(id)
    idx2 = @box_list.indexOf(id)

    unless idx1 is -1
    # found one in show box, do nothing
    else unless idx2 is -1
      # exists, but hidden
      # show it and put it back to @show_list
      $("#" + id).chatbox "option", "offset", @getNextOffset()
      manager = $("#" + id).chatbox("option", "boxManager")
      manager.toggleBox()
      @show_list.push id
    else
      el = document.createElement("div")
      el.setAttribute "id", id

      $(el).chatbox
        id: id
        user: user
        title: user.name
        hidden: false
        width: @config.width
        offset: @getNextOffset()
        messageSent: @messageSentCallback
        boxClosed: @boxClosedCallback

      @box_list.push id
      @show_list.push id
      @user_list.push user._id

  messageSentCallback: (id, user, msg) =>
    idx = @box_list.indexOf(id)
    @config.messageSent @user_list[idx], msg

  # not used in demo
  dispatch: (id, user, msg) ->
    $("#" + id).chatbox("option", "boxManager").addMsg user.first_name, msg