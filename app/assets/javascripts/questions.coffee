$ ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'Connected, denio!'
      @perform 'follow'
    ,

    received: (data) ->
      $('.question_list').append data
  })