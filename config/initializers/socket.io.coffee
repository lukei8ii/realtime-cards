passportSocketIo = require "passport.socketio"
mongoose = require "mongoose"
User = mongoose.model "User"
_ = require "underscore"

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

    socket.on "private message", (message) ->
      passportSocketIo.filterSocketsByUser(io, (user) ->
        user._id is message.to
      ).forEach (s) ->
        s.emit "private message", message