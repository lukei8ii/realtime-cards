ConnectMincer = require "connect-mincer"

module.exports = (app, root) ->
  mincer = new ConnectMincer(
    root: root
    production: process.env.NODE_ENV is "production"
    mountPoint: "/assets"
    manifestFile: "#{root}/public/assets/manifest.json"
    paths: [
      "vendor/js", "vendor/jquery-ui/ui", "vendor/bootstrap/js", "app/assets/javascripts",
      "vendor/bootstrap/main", "vendor/css", "vendor/jquery-ui-bootstrap", "app/assets/stylesheets"
    ]
  )

  app.use mincer.assets()
  app.use "/assets", mincer.createServer() if process.env.NODE_ENV isnt "production"