_ = require "underscore"
Feed = require "../models/feed"

module.exports.publish = (req, res)->
  feed = new Feed req.body
  feed.save (err)->
    if not err
      res.json feed
    else 
      res.send 500

module.exports.query = (req, res)->
  constrains = req.query || {}

  query = Feed.find()
  
  query = query.where("until").gt(constrains.date) if constrains.date
  query = query.where("from").equals(constrains.from) if constrains.from
  query = query.where("to").equals(constrains.to) if constrains.to
  
  query.sort 'until'
  .exec (err, feeds)->
    if not err
      res.json feeds
    else 
      res.send 500

module.exports.update = (req, res)->
  patch = req.body

  patch = _.pick patch, "from", "to", "until", "description"

  Feed.findById req.params.id, (err, feed)->
    _.extend feed, patch
    feed.save (err, feed)->
      if not err
        res.json feed
      else 
        res.send 400
  