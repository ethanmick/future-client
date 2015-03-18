// Generated by CoffeeScript 1.9.1
(function() {
  'use strict';
  var NetSocket, Q, Socket, jsonstream, util, uuid;

  Q = require('q');

  jsonstream = require('json-stream');

  uuid = require('uuid').v4;

  NetSocket = require('net').Socket;

  util = require('util');

  Socket = function() {
    NetSocket.call(this);
    this.actions = {};
    this.setEncoding('utf8');
    this.stream = jsonstream();
    this.stream.on('data', (function(_this) {
      return function(data) {
        console.log('WTF WE GOT DATA', data);
        return _this.response(data);
      };
    })(this));
    this.pipe(this.stream);
    return this;
  };

  util.inherits(Socket, NetSocket);

  Socket.prototype.response = function(json) {
    var deferred, id, res;
    console.log('WTF IS THIS JSON', json);
    id = json.id;
    deferred = this.actions[id];
    delete json.id;
    if (deferred) {
      return deferred.resolve(json);
    }
    console.log('wat', this.listeners('task'));
    console.log('errors', this.listeners('error'));
    console.log('errors', this.listeners('data'));
    res = this.emit('task', json.execute);
    return console.log(res);
  };

  Socket.prototype.send = function(name, opts) {
    var deferred, pkt;
    pkt = this.packet(name, opts);
    deferred = Q.defer();
    this.actions[pkt.id] = deferred;
    this.write(this.compress(pkt));
    return deferred.promise;
  };

  Socket.prototype.compress = function(obj) {
    return JSON.stringify(obj);
  };

  Socket.prototype.packet = function(name, obj) {
    var id, pkt;
    id = uuid();
    pkt = {
      command: name,
      id: id
    };
    switch (name) {
      case 'create':
        pkt.attributes = obj;
        break;
      case 'get':
        pkt.name = obj;
        break;
      case 'delete':
        pkt.name = obj;
        break;
      default:
        console.log('UNKNOWN COMMAND');
    }
    return pkt;
  };

  module.exports = Socket;

}).call(this);
