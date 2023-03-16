$(document).on('turbolinks:load', function() {
  $('.question-controls').on('click', '.edit-question-link', function(e) {
    e.preventDefault()

    $(this).addClass('hidden')
    $('.delete-question-link').addClass('hidden')
    $('form#edit-question').removeClass('hidden')
  })
})
