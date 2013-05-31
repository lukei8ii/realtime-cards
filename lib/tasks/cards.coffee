if process.argv.length < 3
  console.info "You need to pass in the set name."

set = process.argv[2]
set_for_url = encodeURIComponent set
card_count = 1

knox = require "knox"
jf = require "jsonfile"
http = require "http"
mongoose = require "mongoose"
Card = require "../../app/models/card"
ph = require "phantom"

CARD_SETS =
  "Magic 2013": "m13"

getCardData = ->
  # bootstrap db connection
  mongoose.connect process.env.MONGOLAB_URI

  ph.create (ph) ->
    ph.createPage (page) ->
      page.open "http://gatherer.wizards.com/Pages/Search/Default.aspx?output=spoiler&method=text&sort=cn+&action=advanced&set=+%5b%22#{set_for_url}%22%5d", ->
        page.includeJs "http://code.jquery.com/jquery-1.10.0.min.js", ->
          console.log "evaluating page..."
          data = page.evaluate ->
            cards = []
            search_summary = $("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContentHeader_searchTermDisplay").text()
            chosen_set = search_summary.match(/\+"(.*?)"/)[1]
            count = parseInt search_summary.match(/\((.+?)\)/)[1]
            i = 0

            names = $(".nameLink")
            costs = $(".textspoiler td:contains('Cost')").next()
            types = $(".textspoiler td:contains('Type')").next()
            optionals = $(".textspoiler td:contains('Type')").parent().next()
            rules = $(".textspoiler td:contains('Rules')").next()
            texts = $(".textspoiler td:contains('Text')").next()
            sets_rarities = $(".textspoiler td:contains('Set/Rarity')").next()

            # initialize card objects
            while i < count
              c = cards[i] = {}
              c.name = names[i].text
              c.type = types[i].innerHTML.trim()

              cost = costs[i].innerHTML.trim()
              c.cost = cost if cost

              # there is a row that changes between
              # loyalty and power / toughness
              optional_tds = $(optionals[i]).children()
              optional_key = optional_tds.first().text().trim()
              optional_value = optional_tds.last().text().trim()

              # set the appropriate value based on the row name
              if optional_value
                switch optional_key
                  when "Loyalty:"
                    c.loyalty = parseInt optional_value.match(/\((.*?)\)/)[1]
                  when "Pow/Tgh:"
                    power_toughness = optional_value.match(/\((.*?)\)/)[1].split("/")
                    c.power = parseInt power_toughness[0]
                    c.toughness = parseInt power_toughness[1]

              rule = rules[i].innerHTML.trim()
              c.rules = rule if rule

              text = texts[i].innerHTML.trim()
              c.text = text if text

              sets_rarity = sets_rarities[i].innerHTML.trim()

              # convert sets_rarities to an array
              if sets_rarity.indexOf(",") is -1
                sets_rarity = [sets_rarity]
              else
                sets_rarity = sets_rarity.split ", "

              # get rarity
              rarity_match = sets_rarity[0].match(/(Common|Uncommon|Rare|Mythic Rare)/)
              c.rarity = rarity_match[0] if rarity_match

              # get the set / number association
              c.sets = []
              c.sets.push
                name: chosen_set
                number: i + 1

              i++

            cards
          , (result) ->
            # ph.exit()
            # store card data in db
            i = 1
            while i <= result.length
              Card.findOrCreate result[i - 1], i
              i++

            getCardCount(ph)

getCardCount = (ph) ->
  ph.createPage (page) ->
    page.open "http://gatherer.wizards.com/Pages/Search/Default.aspx?output=spoiler&method=text&sort=cn+&action=advanced&set=+%5b%22#{set_for_url}%22%5d", ->
      page.includeJs "http://code.jquery.com/jquery-1.10.0.min.js", ->
        data = page.evaluate ->
          search_summary = $("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContentHeader_searchTermDisplay").text()
          count = parseInt search_summary.match(/\((.+?)\)/)[1]
        , (result) ->
          ph.exit()
          console.log "cards to process: ", result

          getImages result

getImages = (count) ->
  aws_config = jf.readFileSync "#{__dirname}/../../aws.json"
  client = knox.createClient aws_config
  set_id = CARD_SETS[set]

  i = 1
  while i <= count
    card_path = "/#{set_id}/#{i}.jpg"
    getImage client, card_path
    i++

getImage = (client, card_path) ->
  image = http.get "http://magiccards.info/scans/en#{card_path}", (res) ->
    headers =
      "Content-Length": res.headers["content-length"]
      "Content-Type": res.headers["content-type"]
      "x-amz-acl": "public-read"

    client.putStream res, card_path, headers, (err, res) ->
      if err
        console.log err
      else
        console.log "#{card_count++} - uploaded: #{card_path}"

# exit = () ->
#   process.exit(code = 0)

getCardData()