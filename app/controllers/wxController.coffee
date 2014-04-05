_ = require "underscore"
Feed = require "../models/feed"

greeting =
  first: "欢迎来到帮带网."
  hi: "欢迎回来."
  parden: "不好意思，我是机器人，请按照我的指令发送好吗？"

qanda = [
  {
    question: "求帮带打a，有空箱打b."
    alias: "need"
    validate: (content) ->
      /^[ab]{1}$/.test content

    answer:
      type: "choice"
      options:
        a:
          value: "求帮带"
          next: 1

        b:
          value: "有空箱"
          next: 1
  }
  {
    question: "请输入出发地，目的地（请用空格隔开）"
    alias: "fromTo"
    answer:
      next: 2
  }
]

storage = do ->
  map = {}
  hasQuery: (uid) ->
    !!map[uid]

  upsertQuery: (uid, query) ->
    map[uid] = query or step: 0
    setTimeout (->
      delete map[uid]

      return
    ), 120000
    return

  getQuery: (uid) ->
    map[uid]

module.exports.delegate = (req, res)->
  wechat "agoodpassword", (req, res, next) ->
  msg = req.weixin
  if msg.MsgType is "event" and msg.Event is "subscribe"
    storage.upsertQuery msg.FromUserName
    res.reply greeting.first + qanda[0].question
    return
  if msg.MsgType is "text"
    uid = msg.FromUserName
    if storage.hasQuery(uid)
      query = storage.getQuery(uid)
      content = msg.Content.trim().toLowerCase()
      if query.step < qanda.length
        qa = qanda[query.step]
        if qa.validate and typeof qa.validate is "function" and not qa.validate(content)
          res.reply greeting.parden + qa.question
          return
        else
          if qa.answer.type is "choice"
            option = qa.answer.options[content]
            query[qa.alias] = option.value
            query.step = option.next
          else
            query[qa.alias] = content
            query.step = qa.answer.next
          storage.upsertQuery uid, query
          if query.step < qanda.length
            res.reply qanda[query.step].question
          else
            console.info "uid: ", uid, "query:", query
            res.reply "谢谢查询"
          return
      else
        console.info "uid: ", uid, "query:", query
        res.reply "已经收到了您的查询，谢谢查询"
        return
    else
      storage.upsertQuery uid
      res.reply greeting.hi + qanda[0].question
      return
  res.reply "hehe"
  
