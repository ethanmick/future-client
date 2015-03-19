'use strict'

should = require('chai').should()
Task = require '../lib/task'
Client = require '../lib/client'

describe 'Task', ->

  it 'should exist', ->
    should.exist Task

  it 'should be createable', ->
    t = new Task({
      name: 'a name'
      time: new Date()
      opts:
        something: 'ok'
    })
    t.name.should.equal 'a name'
    t.time.should.be.ok
    t.opts.should.deep.equal something: 'ok'

  it 'should schedule', ->
    Client.connect()
    t = new Task(name: 'name', time: new Date())
    t.schedule()
