require('better-require')()
mongoose = require "mongoose"

process.env.NODE_ENV = 'test'
app = require process.env.PWD + '/app'

module.exports.host = 'localhost:' + GLOBAL.port

process.on "exit", ->
  mongoose.connection.db.dropDatabase()