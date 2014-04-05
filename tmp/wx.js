var wechat = require('wechat'),
    user = require('../ctrler/user'),
    message = require('../ctrler/message');

var config = require('../config');

console.log(config);

/*
ss 文字路由
 * 只接受文字信息
 */
var resTpl = [
  config.event.done,
  '—— 来自活动『' + config.event.title + '』'
].join('\n');

var greeting = {
  first: "欢迎来到帮带网.",
  hi: "欢迎回来.",
  parden: "不好意思，我是机器人，请按照我的指令发送好吗？"
}

var qanda = [{
  question: "求帮带打a，有空箱打b.",
  alias: "need",
  validate: function(content){
    return /^[ab]{1}$/.test(content);
  },
  answer: {
    type: "choice",
    options: {
      a: {
        value: "求帮带",
        next: 1 
      },
      b: {
        value: "有空箱",
        next: 1
      }  
    }
  } 
}, {
  question: "请输入出发地，目的地（请用空格隔开）",
  alias: "fromTo",
  answer: {
    next: 2
  } 
}];

var storage = function(){
  var map = {};

  return {
    hasQuery: function(uid){
      return !!map[uid];
    },

    upsertQuery: function(uid, query){
      map[uid] = query || {step: 0};
      setTimeout(function(){
        delete map[uid];
      }, 120000);
    },

    getQuery: function(uid){
      return map[uid];
    }
  }
}();

module.exports = wechat(config.token, function(req, res, next) {
  var msg = req.weixin;
  if(msg.MsgType === "event" && msg.Event === "subscribe"){
    storage.upsertQuery(msg.FromUserName);
    res.reply(greeting.first + qanda[0].question);
    return
  }

  if(msg.MsgType === "text"){
    var uid = msg.FromUserName;
    if(storage.hasQuery(uid)){
      var query = storage.getQuery(uid);
      var content = msg.Content.trim().toLowerCase();

      if(query.step < qanda.length) {
        var qa = qanda[query.step];

        if(qa.validate && typeof qa.validate === "function" && !qa.validate(content)) {
          res.reply(greeting.parden + qa.question);
          return;
        } else {
          if(qa.answer.type === "choice") {
            var option = qa.answer.options[content];
            query[qa.alias] = option.value;
            query.step = option.next;
          } else {
            query[qa.alias] = content;
            query.step = qa.answer.next;
          }
          storage.upsertQuery(uid, query);
          if(query.step < qanda.length) {
            res.reply(qanda[query.step].question);
          } else {
            console.info("uid: ", uid, "query:", query);
            res.reply("谢谢查询");
          }
          return;
        }
      } else {
        console.info("uid: ", uid, "query:", query);
        res.reply("已经收到了您的查询，谢谢查询");
        return;
      }
    } else {
      storage.upsertQuery(uid);
      res.reply(greeting.hi + qanda[0].question);
      return;
    }
  }

  res.reply('hehe');
});