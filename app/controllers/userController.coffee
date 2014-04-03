User = require "../models/user"

module.exports.register = (req, res)->
  kitty = new User name: 'Zildjian'
  kitty.save (err)->
    res.json kitty
  