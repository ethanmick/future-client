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
util = require 'util'

Socket = ->
  NetSocket.call(this);
  @actions = {}
  @setEncoding('utf8')
  @stream = jsonstream()
#  stream.on 'data', @response.bind(this)
  @stream.on 'data', (data)=>
    console.log 'WTF WE GOT DATA', data
    @response(data)
  @pipe(@stream)
  return this

util.inherits(Socket, NetSocket);

Socket.prototype.response = (json)->
  console.log 'WTF IS THIS JSON', json
  id = json.id
  deferred = @actions[id]
  delete json.id
  return deferred.resolve(json) if deferred
  console.log 'wat', @listeners('task')
  console.log 'errors', @listeners('error')
  console.log 'errors', @listeners('data')
  res = @emit('task', json.execute)
  console.log res

Socket.prototype.send = (name, opts)->
  pkt = @packet(name, opts)
  deferred = Q.defer()
  @actions[pkt.id] = deferred
  @write(@compress(pkt))
  deferred.promise

Socket.prototype.compress = (obj)->
  JSON.stringify(obj)

Socket.prototype.packet = (name, obj)->
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
