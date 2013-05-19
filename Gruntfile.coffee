module.exports = (grunt) ->
  grunt.registerTask "heroku", "Precompile assets for Heroku", ->
    Mincer = require "mincer"
    env = new Mincer.Environment "./"

    env.appendPath "app/assets/stylesheets"
    env.appendPath "app/assets/javascripts"
    env.appendPath "app/assets/images"
    env.appendPath "vendor/jquery"
    env.appendPath "components/jquery-ui/ui"
    env.appendPath "components/jquery-ui/themes/ui-lightness"
    env.appendPath "components/bootstrap/stuff"
    env.appendPath "components/bootstrap/docs/assets/js"
    env.appendPath "vendor/css"
    env.appendPath "vendor/js"

    manifest = new Mincer.Manifest env, "./public/assets"

    manifest.compile ["*", "*/**"], (err, data) ->
      console.info "Finished precompile:"
      console.dir data