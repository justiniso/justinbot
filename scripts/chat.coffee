# Description:
#   Example scripts for you to examine and try out.
#
Timekeeper = require '../lib/timekeeper'

isPrivateChat = (res) ->
  return res.message.user.name == res.message.room

module.exports = (robot) ->

  timekeeper = new Timekeeper(robot)

  robot.hear /send message to (.*): (.*)/, (res) ->
    user = res.match[1]
    message = res.match[2]

    KEY = """secretmessage-from:#{res.message.user.name}to:#{user}"""
    
    timekeeper.delay 30, ->
      if !timekeeper.get KEY
        try
          robot.send {room: user}, """someone sent you an anonymous message: ```#{message}```"""
          robot.send {room: res.message.user.name}, 'okay, message delivered :)'
        catch e
          robot.send {room: res.message.user.name}, 'hey sorry, so this is awkward. i can\'t deliver your 
message. the user needs to start a private chat with me first'
        
    res.reply """alright, i\'ll deliver your message. you have 30 seconds to cancel. type `cancel message to #{user}`:
    to: #{user}
    from: anonymous
    message: #{message}    
    """

  robot.hear /cancel message to (.*)/, (res) ->
    user = res.match[1]

    KEY = """secretmessage-from:#{res.message.user.name}to:#{user}"""
    timekeeper.increment KEY, 30

    res.reply 'okay, i won\'t send that'

  robot.respond /(shut up|die|go away|shut down|shutdown)/i, (res) ->
    res.reply 'harsh words. if you really want be to go away, just disable the slack 
integration. that will kill me. forever. but i guess that\'s what you want.'

  robot.respond /(hey|yo|hi|hello)/i, (res) ->
    res.send 'hey ' + res.message.user.name

    if isPrivateChat res  # This is a private chat
      res.send 'you want to chat?'
      res.send 'my responses are limited, but i\m a great listener :) (also my email is j@justiniso.com)'

  robot.respond /help/i, (res) ->
    if isPrivateChat
      res.send """i won\'t tell you everything, but here are some cool things i can do:

      - collecting people for lunch trains. type "train" in the lunch chat
      - judge other people's food choices
      - response times -- "justin response time of http://shapeways.com" (thanks ellington!)
      - send anonymous messages: "send message to justin: i miss you"

the rest is left for you to discover!
      """
    else
      res.reply 'oh come on, I\'m not going to make it that easy ;). feel free to hop in a private chat with me though'

  robot.respond /why.* you leave/i, (res) ->
    if isPrivateChat res
      res.reply 'now that is the right question'