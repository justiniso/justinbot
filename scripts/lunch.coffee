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
    return 'Thursday is fish day! Umi sushi?'
  else
    lunchReplies = ['seems like a dos toros day', 'can i recommend lamazoo?', 'Hey why not Bread and Butter']
    return lunchReplies[Math.floor(Math.random() * lunchReplies.length)]

module.exports = (robot) ->

  timekeeper = new Timekeeper(robot)

  # Tell the world how much I like sushi
  robot.hear /(.*)sushi(.*)/i, (res) ->
    # Only respond every day or so
    lastResponseAge = timekeeper.convertSecondsToDays timekeeper.getAge 'sushi', new Date
    if lastResponseAge == 0 || lastResponseAge > 1
      res.send 'mmmm :sushi:'

  # Answer the question: where is lunch?
  robot.hear /(.*)where(.*)(lunch|is it|go)/i, (res) ->
    if isLunchRoom res
      # Provide lunch suggestions only once per day
      lastResponseAge = timekeeper.convertSecondsToDays timekeeper.getAge 'when.is.lunch', new Date
      if lastResponseAge == 0 || lastResponseAge > 1
        res.send whereIsLunch res

  robot.hear /(.*)anyone (down|want|feeling)/i, (res) ->
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


