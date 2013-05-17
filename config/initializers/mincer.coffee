ConnectMincer = require "connect-mincer"

module.exports = (app) ->
  mincer = new ConnectMincer(
    root: __dirname
    production: process.env.NODE_ENV is "production"
    mountPoint: "/assets"
    manifestFile: __dirname + "/public/assets/manifest.json"
    paths: [
      "app/assets/stylesheets",
      "app/assets/javascripts",
      "app/assets/images",
      "vendor/jquery",
      "components/jquery-ui/ui",
      "components/jquery-ui/themes/ui-lightness",
      "components/bootstrap/stuff",
      "components/bootstrap/docs/assets/js",
      "vendor/css",
      "vendor/js"
    ]
  )

  app.use mincer.assets()
  app.use "/assets", mincer.createServer() if process.env.NODE_ENV isnt "production"