'use strict'
#
#
#
#
#
should = require('chai').should()
Client = require '../lib/client'

describe 'Client', ->

  it 'should exist', ->
    should.exist Client
