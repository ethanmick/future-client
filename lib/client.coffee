'use strict'
#
#
#
#
#
Q = require 'q'
uuid = require('uuid').v4
request = require 'request'
SocketIO = require 'socket.io-client'
DEFAULT_PORT = 8124

class Client

  connect: (opts)->
    return if @socket
    @opts = opts or {}
    @opts.port ?= DEFAULT_PORT
    @opts.baseURL ?= "http://localhost:#{@opts.port}"
    @socket = SocketIO("http://localhost:#{@opts.port}")

  _send: (opts)->
    deferred = Q.defer()
    request opts, (err, res, body)->
      return deferred.reject(err) if err
      deferred.resolve([body, res])
    deferred.promise

  schedule: (task)->
    @_send({
      method: 'POST'
      url: "#{@opts.baseURL}/v1/task"
      json: yes
      body: task
    })

  get: (name)->
    @_send({
      url: "#{@opts.baseURL}/v1/task/#{name}"
      json: yes
    })

  delete: (name)->
    @_send({
      method: 'DELETE'
      url: "#{@opts.baseURL}/v1/task/#{name}"
      json: yes
    })

module.exports = new Client()
