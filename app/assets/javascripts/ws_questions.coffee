$ ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      console.log(data)
      $('.question_list').append(data)
  })