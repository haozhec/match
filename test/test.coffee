request = require 'superagent'
expect = require 'expect.js'
server = require './server'

describe 'Suite one', ->
  it 'test one', (done)->
    request.get server.host
    .end (res)->
      expect(res).to.exist
      expect(res.status).to.equal 200
      done()