Controller = require "../controllers/controller"
UserController = require "../controllers/userController"

module.exports = (app)->
  app.get "/", Controller.index

  app.get "/auth/register", UserController.register