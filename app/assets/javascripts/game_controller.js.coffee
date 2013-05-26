# class RTC.GameController
#   constructor: ->
#     canvas = $("#board")[0]
#     ctx = canvas.getContext("2d")

#     card1Ready = false
#     card1Image = new Image(223, 310)
#     card1Image.onload = ->
#       card1Ready = true

#     card1Image.src = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=249695&type=card"

#     card2Ready = false
#     card2Image = new Image(223, 310)
#     card2Image.onload = ->
#       card2Ready = true

#     card2Image.src = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=265722&type=card"

#     card3Ready = false
#     card3Image = new Image(223, 310)
#     card3Image.onload = ->
#       card3Ready = true

#     card3Image.src = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=278076&type=card"

#     # Update game objects
#     update = (modifier) ->

#     # Draw everything
#     render = ->
#       ctx.drawImage card1Image, 0, 0  if card1Ready
#       ctx.drawImage card2Image, 40, 0  if card2Ready
#       ctx.drawImage card3Image, 80, 0  if card3Ready

#       # Score
#       # ctx.fillStyle = "rgb(250, 250, 250)"
#       # ctx.font = "24px Helvetica"
#       # ctx.textAlign = "left"
#       # ctx.textBaseline = "top"
#       # ctx.fillText "Goblins caught: " + monstersCaught, 32, 32

#     # The main game loop
#     main = ->
#       now = Date.now()
#       delta = now - then_
#       update delta / 1000
#       render()
#       then_ = now

#     # Let's play this game!
#     # reset()
#     then_ = Date.now()
#     setInterval main, 1 # Execute as fast as possible