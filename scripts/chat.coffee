# Description:
#   Example scripts for you to examine and try out.
#
Timekeeper = require '../lib/timekeeper'

isPrivateChat = (res) ->
  return res.message.user.name == res.message.room

module.exports = (robot) ->

  timekeeper = new Timekeeper(robot)

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