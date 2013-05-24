module.exports = (grunt) ->
  grunt.registerTask "heroku", "Precompile assets for Heroku", ->
    process.env.NODE_ENV = "production"
    nap = require "nap"
    require('./config/initializers/nap')(nap)
    nap.package()