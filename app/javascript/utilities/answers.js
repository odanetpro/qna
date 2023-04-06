$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    var answerId = $(this).data('answerId')

    e.preventDefault()
    
    $(this).addClass('hidden')
    $('.answer-' + answerId).children('.delete-answer-link').addClass('hidden')
    $('.answer-' + answerId).children('.best-answer-link').addClass('hidden')
    $('form#edit-answer-' + answerId).removeClass('hidden')

    $('form#edit-answer-' + answerId + ' #answer_files').prop('disabled', false)
    $('form#edit-answer-' + answerId + ' #answer_files').val('')
  })

  $('.answers').on('ajax:success', function(e) {
    const answerId = e.detail[0]['id']
    $('.answer-' + answerId + ' .rating-value').html(e.detail[0]['rating'])
  })
})
