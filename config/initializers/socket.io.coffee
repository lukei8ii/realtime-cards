mongoose = require "mongoose"
User = mongoose.model "User"

module.exports = (io) ->
  # socket.io
  io.configure ->
    io.set "transports", ["xhr-polling"]
    io.set "polling duration", 10

  io.sockets.on "connection", (socket) ->
    socket.on "disconnect", ->
      socket.get "nickname", (err, name) ->
        client.get "users", (err, users) ->
          users = [] unless _.isArray users
          users = users.splice(users.indexOf(name), 1)
          client.set "users", users
          console.log "users decreased to: #{users}"

          socket.broadcast.emit "users", users

    socket.on "message", (msg) ->
      socket.get "nickname", (err, name) ->
        console.log "Message Received: ", msg
        socket.broadcast.emit "message", "[#{name || 'Unknown'}] #{msg}"

    socket.on "set nickname", (name) ->
      socket.set "nickname", name, ->
        client.get "users", (err, users) ->
          console.log "users = #{users}"
          users = [] unless _.isArray users
          users = users.push name
          client.set "users", users
          console.log "users increased to: #{users}"

          socket.broadcast.emit "users", users