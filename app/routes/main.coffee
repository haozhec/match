Controller = require "../controllers/controller"
UserController = require "../controllers/userController"
FeedController = require "../controllers/feedController"
WXController = require "../controllers/wxController"

module.exports = (app)->
  app.get "/", Controller.index

  app.get "/auth/register", UserController.register

  app.post "/feed", FeedController.publish

  app.get "/feed", FeedController.query

  app.patch "/feed/:id", FeedController.update

  app.post "/wx", WXController.delegate