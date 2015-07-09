# Description:
#   Example scripts for you to examine and try out.
#
Timekeeper = require '../lib/timekeeper'

isPrivateChat = (res) ->
  return res.message.user.name == res.message.room

module.exports = (robot) ->

  timekeeper = new Timekeeper(robot)

  robot.respond /(shut up|die|go away|shut down|shutdown)/i, (res) ->
    res.reply 'harsh words. if you really want be to go away, just disable the slack 
integration. that will kill me. forever. but i guess that\'s what you want.'

  robot.respond /(hey|yo|hi|hello)/i, (res) ->
    res.send 'hey ' + res.message.user.name

    if isPrivateChat res  # This is a private chat
      res.send 'you want to chat?'
      res.send 'my responses are limited, but i\m a great listener :) (also my email is j@justiniso.com)'

  robot.respond /help/i, (res) ->
    res.reply 'oh come on, I\'m not going to make it that easy ;). feel free to hop in a private chat with me though'

  robot.respond /why.* you leave/i, (res) ->
    if isPrivateChat res
      res.reply 'now that is the right question'