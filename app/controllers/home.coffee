#
# GET home page.
#
exports.index = (req, res) ->
  res.render "home/whatever",
    title: "Realtime Cards"
    user: req.user