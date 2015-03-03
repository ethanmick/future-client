'use strict'
#
#
#
#
#
Q = require 'q'
jsonstream = require 'json-stream'
uuid = require('uuid').v4
NetSocket = require('net').Socket

class Socket extends NetSocket

  constructor: ->
    super()
    @actions = {}
    @setEncoding('utf8')
    stream = jsonstream()
    stream.on 'data', @response.bind(this)
    @pipe(stream)

  response: (json)->
    id = json.id
    deferred = @actions[id]
    delete json.id
    return deferred.resolve(json) if deferred
    @emit 'task', json

  send: (name, opts)->
    pkt = @packet(name, opts)
    deferred = Q.defer()
    @actions[pkt.id] = deferred
    @write(@compress(pkt))
    deferred.promise

  compress: (obj)->
    JSON.stringify(obj)

  packet: (name, obj)->
    id = uuid()
    pkt = command: name, id: id
    switch name
      when 'create'
        pkt.attributes = obj
      when 'get'
        pkt.name = obj
      when 'delete'
        pkt.name = obj
      else
        console.log 'UNKNOWN COMMAND'
    pkt

module.exports = Socket
