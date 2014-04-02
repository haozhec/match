express = require 'express'
_ = require "underscore"

process.on 'uncaughtException', (err) ->
  console.error err 

app = module.exports = express()

require("./configuration").configure app, express

#require "./settings/db"

require('./app/routes') app

app.listen 3500, ->
  console.log "Express server listening on port %d in %s mode", 3500, app.settings.env