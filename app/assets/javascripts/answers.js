$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-'+ answerId).removeClass('hidden');
  });

  $('form.new-answer').on('ajax:success', function(e) {
    var answer = e.detail[0];
    $('.answers').append(JST['templates/answers/answer'] (answer));
  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];
      $.each(errors, function(index, value) {
        $('.answer-errors').html('');
        $('.answer-errors').append('<p>' + value + '</p>');
      });
    });
  
  $('div.voting-answer a').on('ajax:success', function(e) {
    var voting = e.detail[0];
    var answerId = $(this).data('answerId');
    $('p.rating-answer-' + answerId).html('rating: ' + voting.rating);
  });
});