express = require 'express'
_ = require "underscore"

process.on 'uncaughtException', (err) ->
  console.error err 

app = module.exports = express()

require("./configuration").configure app, express

require "./settings/db"

require('./app/routes') app

app.listen GLOBAL.port, ->
  console.log "Express server listening on port %d in %s mode", GLOBAL.port, app.settings.env