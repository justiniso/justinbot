
class Timekeeper
    constructor: (robot) ->
        @robot = robot
    
    # Return the date (in seconds) the last time this particular key's
    # age was accessed
    getAge: (key, date) ->
        oldDate = @robot.brain.get(key)
        @robot.brain.set key, date
        
        if oldDate
            return (date - oldDate) / 1000
        else
            return 0

    delay: (callback, seconds) ->
        setTimeout(callback, seconds * 1000)

    convertSecondsToHours: (seconds) ->
        return seconds / 3600

    convertSecondsToDays: (seconds) ->
        return seconds / 86400

module.exports = Timekeeper