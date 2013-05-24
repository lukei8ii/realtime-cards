#
# *  http://stackoverflow.com/questions/14464873/expressjs-session-expiring-despite-activity
#
exports.extend_session = (req, res, next) ->
  return next()  if "HEAD" is req.method or "OPTIONS" is req.method

  # break session hash / force express to spit out a new cookie once per second at most
  req.session._garbage = Date()
  req.session.touch()
  next()