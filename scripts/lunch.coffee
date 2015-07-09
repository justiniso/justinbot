# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
Timekeeper = require '../lib/timekeeper'

isLunchRoom = (res) ->
  room = res.message.room.toLowerCase()
  return /lunch/.test(room) || /food/.test(room) || /shell/.test(room)

whereIsLunch = (res) ->
  today = new Date
  if today.getDay() == 4
    return 'thursday is fish day! umi sushi?'
  else
    lunchReplies = [
      'it\'s a dos toros day (just like every day ಠ_ಠ)', 'how does llama zoo sound?', 
      'hey why not bread and butter', 'fancy a walk? xians is good', 'i\'m in the mood for tinas', 
      'indian? how about haandi?', 'haven\'t had ramen in a while', 'pho?', 'num pang, mmmm',
      'no one does mediocre indian better than copper chimney', 'i\'m not inspired today. just do essen',
      'come get lunch with me (the human version)!', 'go to umi: but tell the hostess i said hello!',
      'this is an ali doro day', 'nothing wrong with a little CPK sometimes', 
      'bagels and schmear is close and fast'
    ]
    return lunchReplies[Math.floor(Math.random() * lunchReplies.length)]

module.exports = (robot) ->

  LUNCH_TRAIN_COUNT_KEY = 'lunch.train.count'
  LUNCH_TRAIN_PEOPLE_KEY = 'lunch.train.people'

  timekeeper = new Timekeeper(robot)

  # Tell the world how much I like sushi
  robot.hear /(.*)sushi(.*)/i, (res) ->
    # Only respond every day or so
    lastResponseAge = timekeeper.convertSecondsToDays timekeeper.getAge 'sushi', new Date
    if lastResponseAge == 0 || lastResponseAge > 1
      res.send 'mmmm :sushi:'

  robot.hear /salad/i, (res) ->
    if isLunchRoom res
      # Only respond every day or so
      lastResponseAge = timekeeper.convertSecondsToDays timekeeper.getAge 'salad', new Date
      if lastResponseAge == 0 || lastResponseAge > 1
        res.send 'really? salad? salad does not make a meal, it\'s a snack at best.'

  robot.hear /(.*)in the kitchen.*/i, (res) ->
    if isLunchRoom res
      # Only respond every day or so
      lastResponseAge = timekeeper.convertSecondsToDays timekeeper.getAge 'in.the.kitchen', new Date
      if lastResponseAge == 0 || lastResponseAge > 1
        res.reply 'nice!'

  # Answer the question: where is lunch?
  robot.hear /(.*)(where|what)(.*)(lunch|is it|go)/i, (res) ->
    if isLunchRoom res
      # Provide lunch suggestions only once per day
      lastResponseAge = timekeeper.convertSecondsToDays timekeeper.getAge 'when.is.lunch', new Date
      if lastResponseAge == 0 || lastResponseAge > 1
        res.send whereIsLunch res

  robot.hear /(.*)anyone (down|want|feeling|interested)/i, (res) ->
    if isLunchRoom res
      # Provide lunch suggestions only once per day
      lastResponseAge = timekeeper.convertSecondsToDays timekeeper.getAge 'anyone.want', new Date
      if lastResponseAge == 0 || lastResponseAge > 1
        res.send 'i wish i could go with you, but i\'m basically trapped in the office, just like when i worked here!'

  robot.hear /i brought/i, (res) ->
    if isLunchRoom res
      lastResponseAge = timekeeper.convertSecondsToDays timekeeper.getAge 'i.brought', new Date
      if lastResponseAge == 0 || lastResponseAge > 1
        res.reply 'http://www.theonion.com/article/man-brings-lunch-from-home-to-cut-down-on-small-jo-37912'

  robot.hear /(.*) train/i, (res) ->
    trainMinutes = 5
    if isLunchRoom res
      count = timekeeper.get LUNCH_TRAIN_COUNT_KEY

      if !count
        res.send 'okay, we\'ve got a lunch train started. rolling out in ' + trainMinutes + ' min. who\'s in? say "i"'

        timekeeper.delay 60 * trainMinutes, ->
          people = timekeeper.get LUNCH_TRAIN_PEOPLE_KEY
          if people
            res.send 'time\'s up! lunch train rolling out. let\'s go ' + people + '!!'
          else
            res.send 'time\'s up! lunch train rolling out. no takers i guess :('

      timekeeper.increment LUNCH_TRAIN_COUNT_KEY, 60 * trainMinutes

  robot.hear /^(i|me|i am|i'm in|i'll go|i'll join)$/i, (res) ->
    if isLunchRoom res
      if timekeeper.get LUNCH_TRAIN_COUNT_KEY

        timekeeper.push LUNCH_TRAIN_PEOPLE_KEY, res.message.user.name, 60 * 15
        
        timekeeper.delay 0.4, ->
          stored = timekeeper.get LUNCH_TRAIN_PEOPLE_KEY
          if stored
            if stored.length == 1
              res.send 'nice! who else?'

            else if stored.length == 2
              res.send 'alright, so far we\'ve got ' + stored + ', who else is in? choo choo!'

            else if stored.length % 4 == 0
              res.send 'so that\'s ' + stored + '. anyone else?'
        
