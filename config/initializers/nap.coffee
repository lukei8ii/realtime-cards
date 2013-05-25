module.exports = (nap) ->
  nap
    gzip: true
    assets:
      # js:
      #   all: ["vendor/js/jquery.js", "components/jquery-ui/jquery-ui.js", "components/jquery.ui.widget.js", "components/bootstrap/js/*.js", "vendor/js/jquery.ui.chatbox.js", "app/assets/javascripts/*.coffee"]
      js:
        all: ["vendor/js/jquery.js"]

      # css:
      #   all: ["components/bootstrap/stuff/bootstrap.less", "vendor/css/jquery-ui.css", "components/jquery-ui-bootstrap/jquery.ui.theme.css", "vendor/css/jquery.ui.chatbox.css", "app/assets/stylesheets/*.less"]
      css:
        all: ["components/bootstrap/less/bootstrap.less"]