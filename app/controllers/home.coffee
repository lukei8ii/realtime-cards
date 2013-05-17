#
# GET home page.
#
exports.index = (req, res) ->
  res.render "index",
    title: "Realtime Cards"
    user: req.user