'use strict'
#
#
#
#
#

net = require 'net'
DEFAULT_PORT = 8124

class Client

  constructor: (opts)->
    opts.port ?= DEFAULT_PORT
    @socket = net.createConnection(opts)

module.exports = Client
