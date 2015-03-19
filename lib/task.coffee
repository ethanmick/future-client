#
# Ethan Mick
# 2015
#
uuid = require 'uuid'
Client = require './client'

class Task

  constructor: (opts)->
    throw Error('"time" is required!') unless opts.time
    @name = opts.name or uuid.v4()
    @time = opts.time
    @opts = opts.opts or null

  toObject: ->
    {
      name: @name
      time: @time
      opts: @opts
    }

  schedule: ->
    Client.schedule(@toObject())

  @inMilliseconds: (ms, opts = {}, autoSchedule = no)->
    date = new Date()
    date.setMilliseconds(date.getMilliseconds() + ms)
    t = new this({
      name: opts.name
      time: date
      opts: opts.opts
    })
    return t.schedule() if autoSchedule
    t

  @inSeconds: (seconds, opts, autoSchedule)->
    @inMilliseconds(seconds * 1000, opts, autoSchedule)


module.exports = Task
