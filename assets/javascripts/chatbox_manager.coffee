class RTC.ChatboxManager

  constructor: (options) ->
    @config =
      width: 200 #px
      gap: 20
      maxBoxes: 5
      messageSent: (dest, msg) ->
        # override this
        $("#" + dest).chatbox("option", "boxManager").addMsg dest, msg

    $.extend @config, options

    # list of all opened boxes
    @boxList = []

    # list of boxes shown on the page
    @showList = []

    # list of first names, for in-page demo
    @nameList = []

  delBox: (id) ->
    # TODO

  getNextOffset: ->
    (@config.width + @config.gap) * @showList.length

  boxClosedCallback: (id) ->
    # close button in the titlebar is clicked
    idx = @showList.indexOf(id)

    if idx isnt -1
      @showList.splice idx, 1
      diff = @config.width + @config.gap
      i = idx

      while i < @showList.length
        offset = $("#" + @showList[i]).chatbox("option", "offset")
        $("#" + @showList[i]).chatbox "option", "offset", offset - diff
        i++
    else
      alert "should not happen: " + id

  # caller should guarantee the uniqueness of id
  addBox: (id, user, name) ->
    idx1 = @showList.indexOf(id)
    idx2 = @boxList.indexOf(id)

    unless idx1 is -1
    # found one in show box, do nothing
    else unless idx2 is -1
      # exists, but hidden
      # show it and put it back to @showList
      $("#" + id).chatbox "option", "offset", @getNextOffset()
      manager = $("#" + id).chatbox("option", "boxManager")
      manager.toggleBox()
      @showList.push id
    else
      el = document.createElement("div")
      el.setAttribute "id", id

      $(el).chatbox
        id: id
        user: user
        title: user.first_name + " " + user.last_name
        hidden: false
        width: @config.width
        offset: @getNextOffset()
        messageSent: @messageSentCallback
        boxClosed: @boxClosedCallback

      @boxList.push id
      @showList.push id
      @nameList.push user.first_name

  messageSentCallback: (id, user, msg) ->
    idx = @boxList.indexOf(id)
    @config.messageSent @nameList[idx], msg

  # not used in demo
  dispatch: (id, user, msg) ->
    $("#" + id).chatbox("option", "boxManager").addMsg user.first_name, msg