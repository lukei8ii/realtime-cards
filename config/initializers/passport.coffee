mongoose = require "mongoose"
FacebookStrategy = require("passport-facebook").Strategy
User = mongoose.model "User"

module.exports = (passport) ->
  # serialize sessions
  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findOne
      _id: id
    , (err, user) ->
      done err, user

  # use facebook strategy
  passport.use new FacebookStrategy(
    clientID: process.env.FACEBOOK_APP_ID
    clientSecret: process.env.FACEBOOK_APP_SECRET
    callbackURL: "#{process.env.SITE_URL}auth/facebook/callback"
  , (accessToken, refreshToken, profile, done) ->
    User.findOne
      "facebook.id": profile.id
    , (err, user) ->
      return done(err) if err
      unless user
        user = new User(
          name: profile.displayName
          email: profile.emails[0].value
          username: profile.username
          provider: "facebook"
          facebook: profile._json
        )
        user.save (err) ->
          console.log err  if err
          done err, user
      else
        done err, user
  )