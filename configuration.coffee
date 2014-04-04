# Configuration
assets = require 'connect-assets'
express = require 'express'
#RedisStore = require('connect-redis') express

exports.configure = (app, express) ->
    
  app.configure ->
    app.use assets()
    app.use express.json()
    app.use express.urlencoded()
    app.use express.cookieParser()
    app.use express.methodOverride()
    app.use express.static __dirname + '/assets'
    app.set 'views', __dirname + '/app/views'
    app.set 'view engine', 'jade'
    app.locals.pretty = true
    #app.use express.session secret: "G/ahL)n?GxHyi!pY", store: new RedisStore
    
  app.configure 'development', ->
    app.use express.errorHandler dumpExceptions: true, showStack: true
    app.use express.logger "dev"
    GLOBAL.port = 5800
    GLOBAL.host = "frontend.dandzire.com:4000"

  app.configure 'test', ->
    app.use express.errorHandler dumpExceptions: true, showStack: true
    GLOBAL.db = 'mongodb://localhost/match-test' 
    GLOBAL.port = 5801
    GLOBAL.host = "frontend.dandzire.com:4000"

  app.configure 'production', ->
    app.use express.errorHandler()
    GLOBAL.port = 5802
    GLOBAL.host = "frontend.dandzire.com"
  