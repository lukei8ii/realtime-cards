mongoose = require "mongoose"
User = mongoose.model "User"

exports.signin = (req, res) ->

exports.authCallback = (req, res, next) ->
  res.redirect "/"

exports.logout = (req, res) ->
  req.logout()
  res.redirect "/"

exports.profile = (req, res) ->
  res.render "users/profile"