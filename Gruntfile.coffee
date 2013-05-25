module.exports = (grunt) ->

  grunt.initConfig(
    mince:
      js:
        src: "application.js"
        include: ["app/assets/javascripts", "vendor/js", "components/jquery-ui/ui", "components/bootstrap/js"],
        dest: "public/assets/application.js"
      css:
        src: "application.css"
        include: ["app/assets/stylesheets", "components/bootstrap/stuff", "vendor/css", "components/jquery-ui-bootstrap"],
        dest: "public/assets/application.css"
    uglify:
      options:
        mangle: false
      my_target:
        files:
          'public/assets/application.js': ["public/assets/application.js"]
    cssmin:
      combine:
        files:
          'public/assets/application.css': ["public/assets/application.css"]
  )

  grunt.loadNpmTasks "grunt-mincer"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-cssmin"

  grunt.registerTask "heroku", ["mince", "uglify", "cssmin"]
  # grunt.registerTask "heroku", ["mince"]