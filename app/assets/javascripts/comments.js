$(document).on('turbolinks:load', function(){
  $('.add-comment-link').on('click', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    var questionId = $(this).data('questionId');

    if (answerId) { $('.form-comment-answer-'+ answerId).removeClass('hidden')};
    if (questionId) { $('.form-comment-question-'+ questionId).removeClass('hidden')};
  });

  $("[class$='-new-comment']").on('ajax:success', function(e) {
    var comment = e.detail[0]['comment'];
    var user = e.detail[0]['user'];

    if (comment.commentable_type == 'Question') {
      $('.comment-question-'+ comment.commentable_id).prepend('<p>'+ user + ' said:<br>' + comment.body +'</p>')
      $('.form-comment-question-'+ comment.commentable_id).addClass('hidden')
    }
    if (comment.commentable_type == 'Answer') {
      $('.comment-answer-'+ comment.commentable_id).prepend('<p>'+ user + ' sayd:<br>' + comment.body +'</p>')
      $('.form-comment-answer-'+ comment.commentable_id).addClass('hidden')
    }
  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];
      $.each(errors, function(index, value) {
        $('.comment-errors').html('');
        $('.comment-errors').append('<p>' + value + '</p>');
      });
    });
});