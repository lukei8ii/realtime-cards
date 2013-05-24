module.exports = (nap) ->
  nap
    gzip: true
    assets:
      js:
        all: ["/app/assets/javascripts/*.coffee", "components/jquery-ui/ui/*.js", "components/bootstrap/docs/assets/js/*.js", "vendor/js/**/*.js" ]
      css:
        all: ["/app/assets/stylesheets/**/*.less", "components/jquery-ui-bootstrap/*.css", "components/bootstrap/stuff/*.css", "vendor/css/*.css"]