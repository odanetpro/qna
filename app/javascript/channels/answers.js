import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const questionId = $('.question').attr('id')
  if(!questionId){
    return
  }

  //remove all opened chanels
  for (const subscription of consumer.subscriptions.subscriptions) {
    const channelName = JSON.parse(subscription.identifier).channel

    //except CommentsChannel
    if (channelName == 'CommentsChannel') {
      continue
    }

    consumer.subscriptions.remove(subscription)
  }

  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: questionId }, {
    received(data) {
      const parsedData = JSON.parse(data)

      if(parsedData.answer.author_id != gon.user_id){
        $('.answers').append(generateAnswerHTML(parsedData))
      }
    }
  })
})

function generateAnswerHTML(data) {
  const [answer, files, links, vote] = [data.answer, data.answer_files, data.answer_links, data.answer_vote]
  const [question, answer_controls] = [data.question, data.answer_controls]

  let HTML = `<li class="answer-${answer.id}">` +
              answerBody(answer) +
              answerFiles(answer, files) +
              answerLinks(answer, links) +
              answerRating(answer, vote) +
              answerControl(question, answer_controls) +
              `</li>`
  return HTML
}

function answerBody(answer) {
  return `<div id="answer-body-${answer.id}">${answer.body}</div>`
}

function answerFiles(answer, files) {
  let result = `<div id="answer-attachments-${answer.id}">`
  for (const file of files) {
    result += `<p id="file-${file.id}">`
    result += `<a href="${file.url}">${file.name}</a>`
    result += `</p>`
  }
  result += '</div>'

  return result
}

function answerLinks(answer, links) {
  let result = `<div id="answer-links-${answer.id}"><ul>`
  for (const link of links) {
    result += `<li id="link-${link.id}">`

    if(link.gist_id){
      result += `<a href="${link.url}" class="gist-link" data-gist-id="${link.gist_id}">${link.name}</a>`
    } else {
      result += `<a href="${link.url}">${link.name}</a>`
    }

    result += `</li>`
  }
  result += '</ul></div>'

  return result
}

function answerRating(answer, vote) {
  let result = `<div id="answer-rating-${answer.id}"><p>` +
               `Rating:` +
               `<div class="rating-value">${vote.rating}</div>`

  if(gon.user_id){
    result += `<a data-type="json" class="vote-up" data-remote="true" rel="nofollow" data-method="post" href="${vote.up_path}">+</a>`
    result += ` | `
    result += `<a data-type="json" class="vote-down" data-remote="true" rel="nofollow" data-method="post" href="${vote.down_path}">–</a>`
  }

  result += '</p></div>'

  return result
}

function answerControl(question, answer_controls) {
  if(question.author_id != gon.user_id){
    return
  }

  return `<a class="best-answer-link" data-remote="true" rel="nofollow" data-method="post" href="${answer_controls.mark_best_path}">Best</a>`
}
