module.exports = (grunt) ->

  grunt.initConfig(
    mince:
      js:
        src: "application.js"
        include: ["app/assets/javascripts", "vendor/js", "vendor/jquery-ui/ui", "vendor/bootstrap/js"],
        dest: "public/assets/application.js"
      cocos2d:
        src: "cocos2d.js"
        include: ["vendor/cocos2d-html5-master"],
        dest: "public/cocos2d.js"
      css:
        src: "application.css"
        include: ["app/assets/stylesheets", "vendor/bootstrap/main", "vendor/css", "vendor/jquery-ui-bootstrap"],
        dest: "public/assets/application.css"
    copy:
      main:
        files: [
          expand: true
          src: ["app/assets/images/*"]
          dest: "public/assets/"
          flatten: true
          filter: "isFile"
        ,
          expand: true
          src: ["vendor/bootstrap/img/*"]
          dest: "public/assets/"
          flatten: true
          filter: "isFile"
        ,
          expand: true
          src: ["vendor/jquery-ui-bootstrap/*.png"]
          dest: "public/assets/"
          flatten: true
          filter: "isFile"
        ]
    uglify:
      options:
        mangle: false
      my_target:
        files:
          'public/assets/application.js': ["public/assets/application.js"]
          'public/cocos2d.js': ["public/cocos2d.js"]
    cssmin:
      combine:
        files:
          'public/assets/application.css': ["public/assets/application.css"]
  )

  grunt.loadNpmTasks "grunt-mincer"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-copy"

  grunt.registerTask "heroku", ["mince", "copy", "uglify", "cssmin"]
  grunt.registerTask "dev", ["mince", "copy"]