# Description:
#   Global Scripts
#

Timekeeper = require '../lib/timekeeper'

module.exports = (robot) ->

  timekeeper = new Timekeeper(robot)

  robot.enter (res) ->
    un = res.message.user.name
    if res.message.room == 'general'
      res.send 'hey ' + un + ', welcome to shapeways!'
    else
      replies = ['welcome ' + un + '!']
      res.send res.random replies

  robot.leave (res) ->
    if Math.random() > 0.9
      res.send 'later ' + res.message.user.name

  robot.hear /h[e|a]lp$/i, (res) ->
    key = 'hear.help'

    if parseInt(timekeeper.get key) + 1 >= 2
      res.reply 'if you want help, jump in a private chat with me'
    else
      timekeeper.increment key, 10

  robot.hear /((.*) thanks$|^thanks (.*))/i, (res) ->
    welcomeReplies = ['(☞ ﾟヮﾟ)☞ hey anytime!', 'no problem (✌ ﾟ∀ﾟ)☞ i got your back', 'you got it dude :thumbsup:']
    if res.match[1] == robot.name || res.match[2] == robot.name || res.match[3] == robot.name
      res.reply res.random welcomeReplies

  robot.hear /high[\s-]five/i, (res) ->
    res.reply ':hand:'

  robot.hear /happy birthday/i, (res) ->
    lastResponseAge = timekeeper.getAge 'happy.birthday', new Date
    if lastResponseAge == 0 || lastResponseAge > 1000
      res.send res.random [
        'happy birthday :birthday:', 'woo happy birthday! :party: :cake:', 'happy birthday!!',
        'happy birthday to you!']

  robot.hear /(hi|hello|hey|yo) (.*)/i, (res) ->
    if res.match[2] == robot.name
      res.send res.random ['hey', 'sup', 'yo', 'hello']
  
  robot.hear /github\.com\/justiniso\/(.*)/i, (res) ->
    if res.match[1] == 'justinbot'
      res.send 'OH CRAP! you found me. don\'t look inside, that\'s like looking at me naked!'
    else
      res.send 'hey that\'s a good one!'

  robot.hear /is live!/i, (res) ->
    lastResponseAge = timekeeper.getAge 'is.live', new Date
    if lastResponseAge == 0 || lastResponseAge > 10
      res.send res.random [
        'woohooo :party:', 'congratulations!', 'awesome work!', 'amazing!', 
        'beautiful!'
      ]

  robot.hear /not feeling .*(well|good|great)/i, (res) ->
    key = 'not.feeling.well'
    if !timekeeper.get key
      timekeeper.delay 1, ->
        res.reply 'aww, sorry to hear that. feel better please!'
        timekeeper.set key, true, 60 * 60 * 24  # 1 day

  robot.hear /^standup/, (res) ->
    lastResponseAge = timekeeper.convertSecondsToDays timekeeper.getAge 'standup', new Date
    if lastResponseAge == 0 || lastResponseAge > 1
      res.send 'here\'s your daily standup thought:'
      res.send res.random [
        """A man is smoking a cigarette and blowing smoke rings into the air.  His girlfriend becomes irritated with the smoke and says, “Can’t you see the warning on the cigarette pack?  Smoking is hazardous to your health!” To which the man replies, “Oh it's fine, it's just a warning not an error.” """
        ,"""Q: Why do programmers always mix up Halloween and Christmas?

A: Because Oct 31 == Dec 25!"""
        ,"""I eat URLs for breakfast.

Q: How many?
A: 200 OK"""
        ,"""`Highlander getSingletonInstance() // there can only be one.`"""
        ,"""`["hip","hip"]`"""
        ,"""http://www.codinghorror.com/blog/images/the-only-valid-measurement-of-code-quality-wtfs-per-minute.png"""
        ,"""https://twitter.com/ivanamcconnell/status/465068755736088576"""
        ,"""Why do java programmers have to wear glasses?

Because they don't see sharp."""
        ,"""Q: Why did the database administrator divorce his wife?

A: She had one-to-many relationships"""
        ,"""To understand what recursion is, you must first understand recursion."""
        ,"""Q: Why did the concurrent chicken cross the road?

A: the side other To to get"""
        ,"""It's been said that if you play a windows CD backwards, you'll hear satanic chanting...worse still if you play it forwards, it installs windows."""
        ,"""A SQL query goes into a bar, walks up to two tables and asks, "Can I join you?" """
        ,"""When your hammer is C++, everything begins to look like a thumb."""
        ,"""If you put a million monkeys at a million keyboards, one of them will eventually write a Java program. The rest of them will write Perl programs."""
        ,"""Q: "Whats the object-oriented way to become wealthy?"

A: Inheritance"""
        ,"""A Cobol programmer made so much money doing Y2K remediation that he was able to have himself cryogenically frozen when he died. One day in the future, he was unexpectedly resurrected.

When he asked why he was unfrozen, he was told:

"It's the year 9999 - and you know Cobol" """
        ,"""The C language combines all the power of assembly language with all the ease-of-use of assembly language."""
        ,"""Two bytes meet. The first byte asks, “Are you ill?”

The second byte replies, “No, just feeling a bit off.”"""
        ,"""Why should you be careful with PHP's garbage collector?

Because there might be nothing left!"""
        ,"""JQuery is like violence. If it doesn't solve your problem, you're not using enough of it"""
        ,"""Q. Why was the statement scared while the comment was not?

A. Statements are executed."""
        ,"""Any program can always be reduced in length by at least one line and always contains at least one bug. Taking this to its logical conclusion we can deduce that any program can be reduced to a single line of code that doesn't work."""
        ,"""Q: Why does the C programmer not get the punchline to the joke about pointers?
A: They don't understand dereference."""
        ,""" "Can I tell you a TCP Joke?"
"Yes, Please tell me a TCP Joke."
"Ok, I'll tell you a TCP Joke." """
        ,"""Only god and I knew what I was trying to do with this code. Should have added comments. Now only god knows."""
        ,"""https://twitter.com/imaginarythomas/status/619133572830486528"""
        ,"""How many developers does it take to change a light bulb?

Startup – 0, it's not MVP
Enterprise – 0, there's no budget in Q4"""
        ,"""Breaking News: Developer accused of unreadable code refuses to comment"""
        ,"""VPNs are pieces of SSH IT"""
        ,"""Q: What do you call a VC who writes code?
A: A Rich Text Editor"""
        ,"""Getting the NSA a present this year? Don't spoil the surprise by buying it online."""
        ,"""Programming is 1% inspiration, 99% trying to get your environment working."""
        ,"""OkCupid has suspended Martin Odersky. The creator of Scala uploaded a 37,000 word answer to profile question 'What is your type?'"""
        ,"""Q: Why is Java slow?
A: Because Time is a Long"""
        ,"""Measure your legacy codebase in apologies per second while onboarding"""
      ]



