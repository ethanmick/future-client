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



module.exports = Task
