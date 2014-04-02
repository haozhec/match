Controller = require "../controllers/controller"

module.exports = (app)->
  app.get "/", Controller.index
