'use strict'
#
#
#
#
Socket = require '../lib/socket'
Q = require 'q'
uuid = require 'uuid'

describe 'Socket', ->

  it 'should connect', (done)->
    s = new Socket()
    s.connect(port: 8124)
    s.on 'connect', ->
      done()

  describe 'methods', ->

    s = null
    beforeEach (done)->
      s = new Socket()
      s.connect(port: 8124)
      s.on 'connect', ->
        done()

    it 'should compress data', ->
      data = hello: 'world'
      s.compress(data).should.equal '{"hello":"world"}'

    it 'should build a "create" packet', ->
      res = s.packet('create', name: 'ok')
      res.id.should.be.ok
      res.attributes.name.should.equal 'ok'
      res.command.should.equal 'create'

    it 'should build a "get" packet', ->
      res = s.packet('get', 'ok')
      res.id.should.be.ok
      res.name.should.equal 'ok'
      res.command.should.equal 'get'

    it 'should build a "delete" packet', ->
      res = s.packet('delete', 'ok')
      res.id.should.be.ok
      res.name.should.equal 'ok'
      res.command.should.equal 'delete'

    it 'should return a promise on write', ->
      p = s.send('get', 'ok')
      Q.isPromise(p).should.be.true

    it 'should resolve the promise', (done)->
      p = s.send('get', 'ok').then ->
        done()

    name = uuid.v4()
    date = null
    it 'should create a task', (done)->
      date = new Date()
      date.setMinutes(date.getMinutes() + 1)
      task =
        name: name
        time: date
        opts:
          some: 'data'
      s.send('create', task).then (data)->
        data.code.should.equal 200
        done()

    it 'should get a task', (done)->
      s.send('get', name).then (data)->
        task = data.task
        task.name.should.equal name
        new Date(task.time).getTime().should.equal date.getTime()
        task.opts.some.should.equal 'data'
        done()

    afterEach (done)->
      s.end()
      s.on 'close', -> done()
