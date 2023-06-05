$(document).on('turbolinks:load', function() {
  $('.question-controls').on('click', '.edit-question-link', function(e) {
    e.preventDefault()

    $(this).addClass('visually-hidden')
    $('.delete-question-link').addClass('visually-hidden')
    $('.unsubscribe-question-link').addClass('visually-hidden')
    $('form#edit-question').removeClass('hidden')

    $('form#edit-question #question_files').prop('disabled', false)
    $('form#edit-question #question_files').val('')
  })

  $('.question').on('click', '.question-add-comment', function(e) {
    var questionId = $(this).attr('id')
    e.preventDefault()

    $(this).addClass('hidden')
    $(`form#question-${questionId}-new-comment`).removeClass('hidden')
  })

  $('.question').on('ajax:success', function(e) {
    $('.question .rating-value').html(e.detail[0]['rating'])
  })
})
