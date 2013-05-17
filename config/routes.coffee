module.exports = (app, passport, auth) ->
  # user routes
  users = require "../app/controllers/users"
  app.get "/logout", users.logout
  app.get "/auth/facebook", passport.authenticate("facebook",
    scope: ["email", "user_about_me"]
    failureRedirect: "/"
  ), users.signin
  app.get "/auth/facebook/callback", passport.authenticate("facebook",
    failureRedirect: "/"
  ), users.authCallback

  # home route
  home = require("../app/controllers/home")
  app.get "/", auth.requires_login, home.index

  # seeds routes
  seeds = require "../app/controllers/seeds"
  app.get "/seed", seeds.seed