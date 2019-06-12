$ ->
  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id
    ,

    received: (data) ->
      console.log(data);
      $('.answers').append(JST['templates/answers/answer'] (data));
  })