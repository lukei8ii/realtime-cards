ConnectMincer = require "connect-mincer"

module.exports = (app, root) ->
  mincer = new ConnectMincer(
    root: root
    production: process.env.NODE_ENV is "production"
    mountPoint: "/assets"
    manifestFile: "#{root}/public/assets/manifest.json"
    paths: [
      "vendor/js", "components/jquery-ui/ui", "components/bootstrap/js", "app/assets/javascripts",
      "components/bootstrap/stuff", "vendor/css", "components/jquery-ui-bootstrap", "app/assets/stylesheets"
      # "app/assets/stylesheets",
      # "app/assets/javascripts",
      # "app/assets/images",
      # "vendor/jquery",
      # "components/jquery-ui/ui",
      # # "components/jquery-ui/themes/ui-lightness",
      # "components/jquery-ui-bootstrap",
      # "components/bootstrap/stuff",
      # "components/bootstrap/docs/assets/js",
      # "vendor/css",
      # "vendor/js"
    ]
  )

  app.use mincer.assets()
  app.use "/assets", mincer.createServer() if process.env.NODE_ENV isnt "production"