mongoose = require 'mongoose'

feedShema = new mongoose.Schema
  created: 
    type: Date
    default: Date.now
  name: 
    type: String
    required: true
  until:
    type: Date
    default: Date.now() + 7*24*3600*1000
    required: true
    index: true
  from:
    type: String
    required: true
  to:
    type: String
    required: true
  goods:
    type: String
    required: true
  payment:
    type: Number
    default: 0
    required: true
  currency:
    type: String
    default: "eur"
    enum: ["eur"]
    required: true
  email: 
    type: String
    required: true
  description: 
    type: String
    trim: true
    validate: [
      (v)->
        v.trim().length < 100
      , "it's too long"]
feedShema.index from: 1, to: 1

module.exports = mongoose.model 'Feed', feedShema


