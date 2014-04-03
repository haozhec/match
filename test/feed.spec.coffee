request = require 'superagent'
expect = require 'expect.js'
async = require "async"
_ = require "underscore"
server = require './server'

describe 'Test feed modules', ->
  helper = do ->
    id = 0

    generateFeed: (index, cb)->
      request.post server.host + "/feed"
      .send
        name: '用户名'+ id++
        until: Date.now() + (id+7)*24*3600*1000
        from: ["柏林", "北京"][index % 2]
        to: ["柏林", "北京"][(index+1) % 2]
        goods: "文件"
        payment: 20
        email: "haozhec@gmail.com"
      .set 'Accept', 'application/json'
      .end cb
        
    generateFeeds: (count, cb)->
      async.map _.range(count)
        , @generateFeed
        , (err, results)-> 
          cb results


  it 'should publish a feed', (done)->
    helper.generateFeed 0, (res)->
      expect(res).to.exist
      expect(res.status).to.equal 200
      feed = res.body
      expect(feed._id).to.exist
      expect(feed.created).to.exist
      expect(feed.currency).to.exist
      expect(feed.from).to.equal "柏林"
      expect(feed.to).to.equal "北京"
      expect(feed.goods).to.equal "文件"
      expect(feed.payment).to.equal 20
      done()

  it 'should list feeds by from and to', (done)->
    helper.generateFeeds 10, (results)->
      request.get server.host + "/feed"
      .set 'Accept', 'application/json'
      .end (res)->
        feeds = res.body
        expect(feeds.length).to.equal 11
        done()

  it 'should query feeds by date, from and to', (done)->
    request.get server.host + "/feed"
    .query 
      date: Date.now() + 10*24*3600*1000
      from: "柏林"
      to: "北京"
    .set 'Accept', 'application/json'
    .end (res)->
      feeds = res.body
      expect(feeds.length).to.equal 4
      done()

  