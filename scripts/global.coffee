# Description:
#   Global Scripts
#

Timekeeper = require '../lib/timekeeper'

module.exports = (robot) ->

  timekeeper = new Timekeeper(robot)

  welcomeReplies = ['(☞ ﾟヮﾟ)☞ hey anytime!', 'no problem (✌ ﾟ∀ﾟ)☞ i got your back', 'you got it dude :thumbsup:']

  robot.hear /((.*) thanks$|^thanks (.*))/i, (res) ->
    if res.match[1] == robot.name || res.match[2] == robot.name || res.match[3] == robot.name
      res.reply res.random welcomeReplies
  
  robot.hear //i, (res) ->
    if res.match[1] == robot.name
      res.reply res.random welcomeReplies

  robot.enter (res) ->
    replies = ['Welcome ' + res.user + '!']
    res.send res.random replies

  robot.respond /[mb]ake .* cake/i, (res) ->
    responses = ['make your own damn cake', 'here ya go :cake:']

    lastResponseAge = timekeeper.getAge 'make.me.a.cake', new Date
    if lastResponseAge == 0 || lastResponseAge > 10
      res.reply res.random responses
  
  robot.respond /meatball sub.*/, (res) ->
    res.send 'It doesn\'t make any sense. You have all of these starches that go great 
with meatballs: polenta, pasta, rice. They\'re classic. The whole point is that 
these are meant to sop up the sauce. Why bring bread into it? Now you just have
soggy bread. I don\'t get it. I just don\'t. '
