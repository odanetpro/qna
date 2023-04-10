import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const questionsList = $('.questions-list')
  if(!questionsList.length){
    return
  }

  //remove all opened chanels
  for (const subscription of consumer.subscriptions.subscriptions) {
    consumer.subscriptions.remove(subscription)
  }

  consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
    received(data) {
      $('.questions-list').append(data)
    }
  })
})
