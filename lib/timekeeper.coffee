
dateAdd = (date, delta) ->
    return new Date date.getTime() + delta*1000


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
    
    # If the key is within the original expiration specified, increment
    # the counter. Otherwise, expire the key and reset to 0 with new 
    # expiration. The expiration is rolling; i.e. every time the counter
    # is incremented, the expiration is reset to the new expiration time
    #
    # key -- key to access
    # expiration -- seconds from now until key expires
    #
    # Format of the stored value should be: {count: 1, expires: Date}
    increment: (key, expiration) ->
        date = new Date
        stored = @robot.brain.get key

        if stored && date < stored.expires  # not expired yet
            count = stored.count + 1
        else
            count = 1
        @robot.brain.set key, {value: count, expires: dateAdd date, expiration}

    push: (key, item, expiration) ->
        date = new Date
        stored = @robot.brain.get key

        if stored && date < stored.expires  # not expired yet
            items = stored.value
            items.push item
        else
            items = [item]
        @robot.brain.set key, {value: items, expires: dateAdd date, expiration}

    get: (key) ->
        date = new Date
        stored = @robot.brain.get key
        
        if stored && date < stored.expires
            return stored.value
        else 
            return null

    set: (key, value, expiration) ->
        date = new Date
        @robot.brain.set key, {value: value, expires: dateAdd date, expiration}

    expire: (key) ->
        @robot.brain.remove key

    delay: (seconds, callback) ->
        setTimeout callback, seconds * 1000

    convertSecondsToMinutes: (seconds) ->
        return seconds / 60

    convertSecondsToHours: (seconds) ->
        return seconds / 3600

    convertSecondsToDays: (seconds) ->
        return seconds / 86400

module.exports = Timekeeper