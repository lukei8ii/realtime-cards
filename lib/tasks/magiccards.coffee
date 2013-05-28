system = require("system")

if system.args.length is 1
  console.log "Usage: magiccards.coffee <some set>"
  phantom.exit()

set = system.args[1]
set_for_url = encodeURIComponent set

process = ->
  page = require("webpage").create()

  page.open "http://gatherer.wizards.com/Pages/Search/Default.aspx?output=spoiler&method=text&sort=cn+&action=advanced&set=+%5b%22#{set_for_url}%22%5d", ->
    page.includeJs "http://code.jquery.com/jquery-1.10.0.min.js", ->
      data = page.evaluate((set) ->
        cards = []
        search_summary = $("#ctl00_ctl00_ctl00_MainContent_SubContent_SubContentHeader_searchTermDisplay").text()
        count = parseInt search_summary.match(/\((.+?)\)/)[1]
        i = 0

        names = $(".nameLink")
        costs = $(".textspoiler td:contains('Cost')").next()
        types = $(".textspoiler td:contains('Type')").next()
        optionals = $(".textspoiler td:contains('Type')").parent().next()

        # loyalty
        # power
        # toughness
        rules = $(".textspoiler td:contains('Rules')").next()
        texts = $(".textspoiler td:contains('Text')").next()
        sets_rarities = $(".textspoiler td:contains('Set/Rarity')").next()

        # initialize card objects
        while i < count
          c = cards[i] = {}
          c.name = names[i].text
          c.number = i + 1
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
                c.loyalty = optional_value.match(/\((.*?)\)/)[1]
              when "Pow/Tgh:"
                power_toughness = optional_value.match(/\((.*?)\)/)[1].split("/")
                c.power = power_toughness[0]
                c.toughness = power_toughness[1]

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

          # remove any rarity item in each for set
          c.sets = ((sets_match = sr.match(/(.+?) (Common|Uncommon|Rare|Mythic Rare)/); sets_match[1] if sets_match) for sr in sets_rarity)

          i++

        cards
      , set)

      console.log JSON.stringify(data)
      page.close()
      phantom.exit()


# getCardData = (number, callback) ->
#   page = require("webpage").create()

#   page.open "http://magiccards.info/m13/en/#{number}.html", ->
#     page.includeJs "http://code.jquery.com/jquery-1.10.0.min.js", ->
#       data = page.evaluate ->

#         name: document.title
#         cost:
#           type: String
#         type:
#           type: String
#         rules:
#           type: String
#         text:
#           type: String
#         power:
#           type: Number
#         toughness:
#           type: Number
#         sets: [
#           type: String
#         ]
#         rarity:
#           type: String
#         number:
#           type: Number


#       console.log JSON.stringify(data)
#       page.close()
#       callback(number + 1)

# process = (number) ->
#   if (number <= count)
#     getCardData number, process
#   else
#     phantom.exit()

# getCount(process)
process()