module.exports = ->
  initialize: ->
    (req, res, next) ->
      # variables
      res.locals.title = "Realtime Cards"
      res.locals.req = req
      res.locals.current_user = req.user

      # methods
      res.locals.login_link = login_link

      if typeof req.flash isnt "undefined"
        res.locals.info = req.flash "info"
        res.locals.errors = req.flash "errors"
        res.locals.success = req.flash "success"
        res.locals.warning = req.flash "warning"
      next()

login_link = (current_user) ->
  if current_user
    "<p id='current_user' data-id='#{current_user._id}'>Hi there, #{current_user.name}.</p>"
  else
    "<a href='/auth/facebook'>Login with Facebook</a>"