exports = mongoose = require 'mongoose'
exports = Schema = mongoose.Schema
exports = ObjectId = Schema.ObjectId

mongo = GLOBAL.db || 'mongodb://localhost/match'

mongoose.connect mongo

