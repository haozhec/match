request = require 'superagent'
expect = require 'expect.js'
server = require './server'

describe 'Test auth and user modules', ->
  it 'should register an user', (done)->
    request.get server.host + "/auth/register"
    .end (res)->
      expect(res).to.exist
      expect(res.status).to.equal 200
      done()