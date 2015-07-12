# Description:
#   Example scripts for you to examine and try out.
#
Timekeeper = require '../lib/timekeeper'

isPrivateChat = (res) ->
  return res.message.user.name == res.message.room.toLowerCase()

module.exports = (robot) ->

  timekeeper = new Timekeeper(robot)

  robot.respond /say in (.*): (.*)/i, (res) ->
    room = res.match[1]
    message = res.match[2]

    robot.send {room: room}, message

  robot.respond /compliment (.*)/i, (res) ->
    user = res.match[1]
    if user == 'me'
      user = res.message.user.name

    messages = [
      "#{user}, you look nice today", "you're awesome, #{user}!", "#{user} you are fantastic",
      "#{user} thanks for being pretty great all-around"]

    timekeeper.delay 1, ->
      if isPrivateChat res
        robot.send {room: user}, res.random messages
      else
        res.send res.random messages

  robot.respond /leave message to (.*): ((.*\s*)+)/i, (res) ->
    un = res.match[1]
    message = res.match[2]

    userMessage = robot.brain.set "message:#{un}", message
    res.send 'done'

  robot.respond /read message/i, (res) ->
    key = "message:#{res.message.user.name}"
    message = robot.brain.get key

    if message
      res.send "i was told to relay this message to you: ```#{message}```"
      robot.brain.remove key
    else
      res.send 'no messages (http://www.sadtrombone.com/assets/sound/trombone.ogg)'

  robot.hear /send message to (.*): (.*)/i, (res) ->
    user = res.match[1]
    message = res.match[2]

    KEY = """secretmessage-from:#{res.message.user.name}to:#{user}"""
    
    timekeeper.delay 30, ->
      if !timekeeper.get KEY
        try
          robot.send {room: user}, """someone sent you an anonymous message: ```#{message}```"""
          res.send 'okay, message delivered :)'
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
      res.send 'try typing `help` to see some of what i can do'

  robot.respond /help/i, (res) ->

    unreadMessage = robot.brain.get "message:#{res.message.user.name}"
    if unreadMessage
      hasUnreadMessage = '(psss! you have 1 message!)'
    else
      hasUnreadMessage = '(you don\'t have any right now)'

    if isPrivateChat res
      res.send """i won\'t tell you everything, but here are some cool things i can do:

      - collecting people for lunch trains. type `train` in the lunch chat
      - response times -- `justin response time of <website>` (thanks ellington!)
      - send anonymous messages -- `send message to <user>: you have a drinking problem` (please use constructively)
      - send anonymous compliments -- `compliment <user>`
      - read an unread message you have -- `read message` #{hasUnreadMessage}
      - throw shade

the rest is left for you to discover!
      """

      if /qualitybros/i.test(res.message.room.toLowerCase())
        res.send 'and just for you, qualitybros: a special little command: `justin say in <room>: <message>`. please troll wes with it ;)'
    else
      res.reply 'oh come on, I\'m not going to make it that easy ;). feel free to hop in a private chat with me though (*hint hint)'

  robot.respond /why.* you leave/i, (res) ->
    if isPrivateChat res
      res.reply 'now that is the right question'