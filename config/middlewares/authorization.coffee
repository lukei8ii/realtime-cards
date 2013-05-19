#
# *  Generic require login routing middleware
#
exports.requires_login = (req, res, next) ->
  # return res.redirect("/auth/facebook") unless req.isAuthenticated()
  next()