$ ->
  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      console.log 'answers!!'
      console.log gon.question_id
      @perform 'follow', question_id: gon.question_id
    ,

    received: (data) ->
      console.log data
      $('.answers').append data
  })