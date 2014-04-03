request = require 'superagent'
expect = require 'expect.js'
  
describe 'Suite one', ->
  it 'test one', (done)->
    request.get 'localhost:3500'
    .end (res)->
      expect(res).to.exist
      expect(res.status).to.equal(200)
      done()