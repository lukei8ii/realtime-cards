#
# *  Generic require login routing middleware
#
exports.requires_login = (req, res, next) ->
  return res.redirect("/facebook") unless req.isAuthenticated()
  next()