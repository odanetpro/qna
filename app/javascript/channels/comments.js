import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const questionId = $('.question').attr('id')
  if(!questionId){
    return
  }

  //remove all opened chanels
  for (const subscription of consumer.subscriptions.subscriptions) {
    const channelName = JSON.parse(subscription.identifier).channel

    //except AnswersChannel
    if (channelName == 'AnswersChannel') {
      continue
    }

    consumer.subscriptions.remove(subscription)
  }

  consumer.subscriptions.create({ channel: "CommentsChannel", question_id: questionId }, {
    received(data) {
      const comment = JSON.parse(data).comment

      if(comment.author_id != gon.user_id){
        $(`.${comment.commentable_type.toLowerCase()}-${comment.commentable_id}-comments`).append(`<div class="comment-body py-1 border-bottom" id="comment-${comment.id}">${simpleFormat(comment.body)}</div>`)
      }
    }
  })
})
