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
        description: "这是一些私人物品"
      .set 'Accept', 'application/json'
      .end (res)-> 
        cb null, res
        
    generateFeeds: (count, cb)->
      async.map _.range(count)
        , @generateFeed
        , cb


  it 'should publish a feed', (done)->
    helper.generateFeed 0, (err, res)->
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
    helper.generateFeeds 10, (err, results)->
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

  it 'should be able to edit a feed', (done)->
    fiveDaysLater = Date.now() + 5*24*3600*1000

    async.waterfall [
      (cb) ->
        helper.generateFeed 0, cb
      (res, cb) ->
        feed = res.body
        cb null, feed._id

      # to update
      (id, cb) ->
        request.patch server.host + "/feed/" + id 
        .send 
          until: fiveDaysLater
          to: "东京"
          name: "马甲"
          description: _.range(10).join("")
        .set 'Accept', 'application/json'
        .end (res)->
          cb null, res
      (res, cb) ->
        feed = res.body
        expect(feed.to).to.equal "东京"
        expect(new Date(feed.until).getTime()).to.equal fiveDaysLater
        expect(feed.name).to.match /^用户名\d+$/
        cb null, feed._id

      # to send a invalid description
      (id, cb) ->
        request.patch server.host + "/feed/" + id 
        .send 
          description: _.range(100).join("")
        .set 'Accept', 'application/json'
        .end (res)->
          cb null, res
      ], (err, res)->
        expect(res.status).to.equal 400
        done()  
    

    

  