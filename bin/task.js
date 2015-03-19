// Generated by CoffeeScript 1.9.1
(function() {
  var Client, Task, uuid;

  uuid = require('uuid');

  Client = require('./client');

  Task = (function() {
    function Task(opts) {
      if (!opts.time) {
        throw Error('"time" is required!');
      }
      this.name = opts.name || uuid.v4();
      this.time = opts.time;
      this.opts = opts.opts || null;
    }

    Task.prototype.toObject = function() {
      return {
        name: this.name,
        time: this.time,
        opts: this.opts
      };
    };

    Task.prototype.schedule = function() {
      return Client.schedule(this.toObject());
    };

    return Task;

  })();

  module.exports = Task;

}).call(this);
