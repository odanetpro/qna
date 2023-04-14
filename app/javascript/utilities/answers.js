$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    var answerId = $(this).data('answerId')

    e.preventDefault()
    
    $(this).addClass('hidden')
    $('.answer-' + answerId).find('.delete-answer-link').addClass('hidden')
    $('.answer-' + answerId).find('.best-answer-link').addClass('hidden')
    $('form#edit-answer-' + answerId).removeClass('hidden')

    $('form#edit-answer-' + answerId + ' #answer_files').prop('disabled', false)
    $('form#edit-answer-' + answerId + ' #answer_files').val('')
  })

  $('.answers').on('click', '.answer-add-comment', function(e) {
    var answerId = $(this).attr('id')
    e.preventDefault()

    $(this).addClass('hidden')
    $(`form#answer-${answerId}-new-comment`).removeClass('hidden')
  })

  $('.answers').on('ajax:success', function(e) {
    const answerId = e.detail[0]['id']
    $('.answer-' + answerId + ' .rating-value').html(e.detail[0]['rating'])
  })
})
