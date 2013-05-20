passportSocketIo = require "passport.socketio"
mongoose = require "mongoose"
User = mongoose.model "User"

module.exports = (io, redisSessionStore) ->
  users = []

  # socket.io
  io.configure ->
    io.set "transports", ["xhr-polling"]
    io.set "polling duration", 10

  io.set "authorization", passportSocketIo.authorize (
    key: process.env.COOKIE
    secret: process.env.SECRET
    store: redisSessionStore
    fail: (data, accept) -> # *optional* callbacks on success or fail
      accept null, false # second param takes boolean on whether or not to allow handshake

    success: (data, accept) ->
      accept null, true
  )

  io.sockets.on "connection", (socket) ->
    current_user = socket.handshake.user
    console.log "user connected: ", current_user.name

    users.push current_user
    console.log "users: ", users

    io.sockets.emit "users", users

    socket.on "disconnect", ->
      index = users.indexOf(current_user)
      users.splice(index, 1)
      console.log "user disconnected: ", current_user.name
      console.log "users: ", users

      io.sockets.emit "users", users

    #filter sockets by user...
    # userGender = socket.handshake.user.gender
    # opposite = (if userGender is "male" then "female" else "male")
    # passportSocketIo.filterSocketsByUser(sio, (user) ->
    #   user.gender is opposite
    # ).forEach (s) ->
    #   s.send "a " + userGender + " has arrived!"

  # io.sockets.on "connection", (socket) ->
  #   socket.on "login", (user_id) ->

  #   socket.on "disconnect", ->
  #     socket.get "nickname", (err, name) ->
  #       client.get "users", (err, users) ->
  #         users = [] unless _.isArray users
  #         users = users.splice(users.indexOf(name), 1)
  #         client.set "users", users
  #         console.log "users decreased to: #{users}"

  #         socket.broadcast.emit "users", users

  #   # socket.on "message", (msg) ->
  #   #   socket.get "nickname", (err, name) ->
  #   #     console.log "Message Received: ", msg
  #   #     socket.broadcast.emit "message", "[#{name || 'Unknown'}] #{msg}"

  #   socket.on "set nickname", (name) ->
  #     socket.set "nickname", name, ->
  #       client.get "users", (err, users) ->
  #         console.log "users = #{users}"
  #         users = [] unless _.isArray users
  #         users = users.push name
  #         client.set "users", users
  #         console.log "users increased to: #{users}"

  #         socket.broadcast.emit "users", users