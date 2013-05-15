module.exports = (app) ->
  app.get "/", (req, res, next) ->
    res.render "index"

# app.get "/redis", (request, response) ->
#   client.set "foo", "bar"
#   client.get "foo", (err, reply) ->
#     console.log reply.toString() # Will print `bar`