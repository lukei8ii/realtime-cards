###
Module dependencies.
###
mongoose = require "mongoose"
User = mongoose.model "User"

exports.signin = (req, res) ->

###
Auth callback
###
exports.authCallback = (req, res, next) ->
  res.redirect "/"

###
Logout
###
exports.logout = (req, res) ->
  req.logout()
  res.redirect "/login"