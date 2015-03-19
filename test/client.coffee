'use strict'
#
#
#
#
#
should = require('chai').should()
uuid = require 'uuid'
Client = require '../lib/client'

describe 'Client', ->

  s = null
  before (done)->
    Client.connect()
    s = Client.socket
    s.on 'connect', ->
      done()

  name = uuid.v4()
  date = null
  it 'should create a task', (done)->
    date = new Date()
    date.setSeconds(date.getSeconds() + 5)
    task =
      name: name
      time: date
      opts:
        some: 'data'

    Client.schedule(task).spread (json, res)->
      res.statusCode.should.equal 200
      json.name.should.equal task.name
      done()
    .done()

  it 'should get a task', (done)->
    Client.get(name).spread (task)->
      task.name.should.equal name
      new Date(task.time).getTime().should.equal date.getTime()
      task.opts.some.should.equal 'data'
      done()

  it 'should get a task to execute', (done)->
    @timeout(6000)
    s.on 'task', (task)->
      task.name.should.equal name
      done()
