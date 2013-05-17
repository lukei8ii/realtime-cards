###
Module dependencies.
###
flash = require "connect-flash"
express = require("express")

module.exports = (app, passport) ->
  app.set "port", process.env.PORT or 3000
  app.set "showStackError", true

  # should be placed before express.static
  app.use express.compress(
    filter: (req, res) ->
      /json|text|javascript|css/.test res.getHeader("Content-Type")

    level: 9
  )
  app.use express.favicon()

  # don't use logger for test env
  app.use express.logger("dev") if process.env.NODE_ENV isnt "test"

  # set views path, template engine and default layout
  app.set "views", config.root + "/app/views"
  app.set "view engine", "ejs"

  app.configure ->
    # cookieParser should be above session
    app.use express.cookieParser()

    # bodyParser should be above methodOverride
    app.use express.bodyParser()
    app.use express.methodOverride()

    # express/mongo session storage
    app.use express.session(
      secret: "noobjs"
      store: new mongoStore(
        url: config.db
        collection: "sessions"
      )
    )

    # connect flash for flash messages
    app.use flash()

    # use passport session
    app.use passport.initialize()
    app.use passport.session()

    # routes should be at the last
    app.use app.router

    # assume "not found" in the error msgs
    # is a 404. this is somewhat silly, but
    # valid, you can do whatever you like, set
    # properties, use instanceof etc.
    app.use (err, req, res, next) ->
      # treat as 404
      return next()  if ~err.message.indexOf("not found")

      # log it
      console.error err.stack

    # development only
    app.use express.errorHandler() if "development" is app.get("env")