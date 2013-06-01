passportSocketIo = require "passport.socketio"
mongoose = require "mongoose"
User = mongoose.model "User"
Card = mongoose.model "Card"
_ = require "underscore"

module.exports = (io, redisSessionStore) ->
  users = []

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
    users.push current_user unless _.findWhere(users, { id: current_user.id })
    console.log "user count: ", users.length
    io.sockets.emit "users", users

    socket.on "disconnect", ->
      index = users.indexOf(current_user)
      users.splice(index, 1)
      console.log "user disconnected: ", current_user.name
      console.log "user count: ", users.length
      io.sockets.emit "users", users

    socket.on "private", (data) ->
      passportSocketIo.filterSocketsByUser(io, (user) ->
        console.log "user._id: #{user._id}, data.to: #{data.to}"
        user.id is data.to
      ).forEach (s) ->
        console.log "emitting private"
        s.emit "private", { from: current_user._id, message: data.message }

    socket.on "cards", ->
      Card.find().limit(7).exec (err, cards) ->
        socket.emit "cards", cards

    socket.on "card_assets", ->
      Card.find().limit(7).exec (err, cards) ->
        socket.emit "card_assets", cards