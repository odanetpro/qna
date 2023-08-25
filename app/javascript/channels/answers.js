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

  let HTML = `<li class="answer-${answer.id} border-top pt-3">` +
               `<div class="parent">` +
                 `<div class="child pe-4 pb-3 text-center">` +
                    answerRating(answer, vote) +
                 `</div>` +
                 `<div class="child-max">` +
                    answerBody(answer) +
                    answerFiles(answer, files) +
                    answerLinks(answer, links) +
                    answerControl(question, answer_controls) +
                  `</div>` +
                `</div>` +
              `</div></li>`
  return HTML
}

function answerRating(answer, vote) {
  let result = `<div id="answer-rating-${answer.id}" class="text-center">`
  
  if(gon.user_id){
    result += `<a data-type="json" class="vote-up text-black-50" data-remote="true" rel="nofollow" data-method="post" href="${vote.up_path}">
                 <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-caret-up-fill" viewBox="0 0 16 16">
                   <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z"></path>
                 </svg>
              </a>`
  }

  result += `<div class="rating-value text-muted fs-3 mt-1">${vote.rating}</div>`

  if(gon.user_id){
    result += `<a data-type="json" class="vote-down text-black-50" data-remote="true" rel="nofollow" data-method="post" href="${vote.down_path}">
                 <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-caret-down-fill" viewBox="0 0 16 16">
                   <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"></path>
                 </svg>
              </a>`
  }
  result += '</div>'

  return result
}

function answerBody(answer) {
  return `<div id="answer-body-${answer.id}" class="py-3 fs-5">${simpleFormat(answer.body)}</div>`
}

function answerFiles(answer, files) {
  let result = `<div id="answer-attachments-${answer.id}" class="mt-3">`
  for (const file of files) {
    result += `<p id="file-${file.id}">`
    result += `<a href="${file.url}">${file.name}</a>`
    result += `</p>`
  }
  result += '</div>'

  return result
}

function answerLinks(answer, links) {
  let result = `<div id="answer-links-${answer.id}" class="mt-3"><ul class="list-unstyled">`
  for (const link of links) {
    result += `<li id="link-${link.id}"><div class="d-inline">`

    if(link.gist_id){
      result += `<a href="${link.url}" class="gist-link" data-gist-id="${link.gist_id}">${link.name}</a>`
    } else {
      result += `<a href="${link.url}">${link.name}</a>`
    }

    result += `</div></li>`
  }
  result += '</ul></div>'

  return result
}

function answerControl(question, answer_controls) {
  if(question.author_id != gon.user_id){
    return ``
  }

  return `<div class="mt-3"><a class="best-answer-link" data-remote="true" rel="nofollow" data-method="post" href="${answer_controls.mark_best_path}">Best</a></div>`
}
