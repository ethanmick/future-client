'use strict'
#
#
#
#
#
Q = require 'q'
uuid = require('uuid').v4
EventEmitter = require('events').EventEmitter
Socket = require './socket'
jsonstream = require 'json-stream'
DEFAULT_PORT = 8124

class Client extends EventEmitter

  constructor: (opts)->
    opts.port ?= DEFAULT_PORT
    @socket = new Socket()
    @socket.connect(opts)

    @socket.on 'task', (task)=>
      @emit 'task', task

  schedule: (task)->
    @socket.write('create', task)

  get: (name)->
    @socket.write(@compress(task))

  delete: (name)->
    @socket.write(@compress(task))

module.exports = Client
