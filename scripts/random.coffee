# Description:
#   Random responses
#

Timekeeper = require '../lib/timekeeper'

module.exports = (robot) ->

  timekeeper = new Timekeeper(robot)

  robot.hear /it .should. work/i, (res) ->
    lastResponseAge = timekeeper.getAge 'it.should.work', new Date
    if lastResponseAge == 0 || lastResponseAge > 3600
      res.send 'ha, if i had a dollar for every time i heard that'

  robot.respond /[mb]ake .* (cake|something)/i, (res) ->
    key = 'make.me.a.cake'
    responses = ['make your own damn cake', 'here ya go :cake:']

    if !timekeeper.get key
      res.reply res.random responses
      timekeeper.set key, true, 60 * 15  # 15 minutes

  robot.hear /(greatest|best) (.*) ever/i, (res) ->
    key = 'greatest.ever'
    thing = res.match[2]

    if !timekeeper.get key
      timekeeper.set key, true, 60 * 15  # 15 minutes
      timekeeper.delay 2, ->
        res.send "the BEST #{thing}"

  robot.hear /worst (.*) ever/i, (res) ->
    key = 'worst.ever'
    thing = res.match[1]

    if !timekeeper.get key
      timekeeper.set key, true, 60 * 15  # 15 minutes
      timekeeper.delay 2, ->
        res.send "so bad, the WORST #{thing}"

  robot.hear /gross/i, (res) ->
    key = 'gross'
    if !timekeeper.get key
      timekeeper.set key, true, 60 * 60 * 24 * 1 # 1 day
      timekeeper.delay 1, ->
        res.send 'you\'re gross'

  robot.hear /\+1/i, (res) ->
    key = 'plus.one'
    if !timekeeper.get key
      timekeeper.set key, true, 60 * 60 * 24 * 1 # 1 day
      timekeeper.delay 1, ->
        res.send '+1'
  
  robot.hear /ninja/i, (res) ->
    key = 'ninja'
    if !timekeeper.get key
      timekeeper.set key, true, 60 * 60 * 24 * 1 # 1 day
      timekeeper.delay 1, ->
        res.send ':ninja:'

  robot.hear /^cheers/i, (res) ->
    key = 'cheers'
    if !timekeeper.get key
      timekeeper.delay 2, ->
        res.send 'cheers! :cocktail:'
        timekeeper.set key, true, 60 * 60 * 1  # 1 hour

  robot.hear /facevase/i, (res) ->
    key = 'facevase'
    if !timekeeper.get key
      timekeeper.delay 2, ->
        res.send 'needs more face on that vase'
        timekeeper.set key, true, 60 * 60 * 24 * 10  # 10 days

  robot.hear /hair\s*cut/i, (res) ->
    key = 'haircut'
    if !timekeeper.get key
      timekeeper.set key, true, 60 * 60 * 24 * 1  # 1 day
      res.send ':haircut: snip snip'

  robot.hear /more jquery/i, (res) ->
    res.reply 'http://i.stack.imgur.com/ssRUr.gif'

  robot.hear /the worst/i, (res) ->
    key = 'the.worst'
    if !timekeeper.get key
      timekeeper.set key, true, 60 * 60 * 24 * 1  # 1 day
      res.send 'so bad'    

  robot.hear /halloween costume/i, (res) ->
    key = 'halloween.costume'

    if !timekeeper.get key
      res.send res.random [
        'take some pics for me!', 
        'just because i\'m not there anymore, doesn\'t mean you can start slacking on your costumes'
      ]
      timekeeper.set key, true, 60 * 60 * 24 * 10  # 10 days

  robot.hear /made in the future/i, (res) ->
    key = 'made.in.the.future'

    if !timekeeper.get key
      res.send 'the future :shapeways: '
      timekeeper.set key, true, 60 * 60 * 24 * 10  # 10 days    

  robot.hear /(third|3rd) rail/i, (res) ->
    key = 'third.rail'

    if !timekeeper.get key
      timekeeper.delay 2, ->
        res.send 'don\'t touch it! :zap: '
      timekeeper.set key, true, 60 * 60 * 24 * 10  # 10 days

  robot.hear /she said yes/i, (res) ->
    key = 'she.said.yes'

    if !timekeeper.get key
      timekeeper.delay 2, ->
        res.send 'how exciting! congratulations!!'
      timekeeper.set key, true, 60 * 60 * 24 * 10  # 10 days

  robot.hear /in (\d+) min/i, (res) ->
    minutes = res.match[1]

    timekeeper.delay parseInt(minutes) * 60, ->
      res.reply "it's been #{minutes} minutes: ```#{res.message.text}```"

  robot.hear /shapeways\.xxx/i, (res) ->
    key = 'xxx'
    if !timekeeper.get key
      timekeeper.set key, true, 60 * 60 * 1  # 1 hours
      res.send ':hear_no_evil:'

  robot.hear /(write|unit) test/i, (res) ->
    key = 'tests'
    if !timekeeper.get key
      timekeeper.set key, true, 60 * 60 * 1  # 1 hour
      res.send res.random [':rock:', 'tests :rocket:', 'the more tests, the more good']

  robot.respond /throw shade/i, (res) ->
    key = "throw.shade:#{res.message.user.name}"
    if !timekeeper.get key
      timekeeper.set key, true, 60 * 60 * 24  # 1 day
      res.reply 'oh you want shade? gurl, get ready. you\'re going to need a flashlight'
      
      timekeeper.delay 4, ->
        res.send res.random [
          'i wish i had the self confidence you do to leave the house like that :clap:',
          'you look really good today. from like way, way over there',
          'everyone really admires the fact that you try so hard',
          'those shoes with that face? no :no_good: '
        ]

        timekeeper.delay 3, ->
          res.send res.random [
            'well at least you have... a personality',
            'well at least a _couple_ of people like you',
            'i don\'t start fights, but i\'ll finish this one',
          ]

          timekeeper.delay 3, ->
            res.send res.random [
              'and if you need a hand, the back of mine is available :wave:',
              'you are so bereft of class, you could be a marxist utopia',
            ]

            timekeeper.delay 3, ->
              res.send res.random [
                  'don\'t worry, you can cry. it\'s not like anyone would notice anyway :sob:', 
                  'anyway, i hope your day is as pleasant as you are :lips:'
              ]

              timekeeper.delay 3, ->

                res.send res.random [
                  'bye, bitch. bye. http://ak-hdl.buzzfed.com/static/2013-11/enhanced/webdr02/4/10/anigif_enhanced-buzz-10236-1383578922-23.gif',
                  'http://ak-hdl.buzzfed.com/static/2013-11/enhanced/webdr07/3/19/anigif_enhanced-buzz-3701-1383525573-5.gif',
                  'http://media.giphy.com/media/hooItdIE2Uc3S/giphy.gif'
                ]
                res.send ':nail_care:'
    else
      res.send 'ugh, you got yours. let me do someone who actually matters'
      res.send res.random [
        'https://33.media.tumblr.com/80d10c0630f3d1f72264eac8a7ee032f/tumblr_moz43ehro41rzowylo1_400.gif',
        'http://ak-hdl.buzzfed.com/static/2013-11/enhanced/webdr03/3/14/anigif_enhanced-buzz-12260-1383505674-15.gif',
        'http://media.giphy.com/media/QfpB5vvAGxWnK/giphy.gif',
        'http://media.giphy.com/media/3o85xqgW1m9Fi8T6aQ/giphy.gif'

      ]

  robot.hear /meatball sub/, (res) ->
    key = 'meatball.sub'
    if !timekeeper.get key
        timekeeper.delay 2, ->
            res.send 'It doesn\'t make any sense. You have all of these starches that go 
with meatballs: polenta, pasta, potatoes. They\'re classic. The whole point is that 
these are meant to sop up the sauce. Why bring bread into it? Now you just have
soggy bread. I don\'t get it. I just don\'t. '