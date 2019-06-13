$ ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id
    ,

    received: (data) ->
      if gon.user_id != data.comment.user_id
        if data.comment.commentable_type == 'Question'
          $('.comment-question-'+ data.comment.commentable_id).prepend(JST['templates/comments/comment'] (data))
          $('.form-comment-question-'+ data.comment.commentable_id).addClass('hidden')
        if data.comment.commentable_type == 'Answer' 
          $('.comment-answer-'+ data.comment.commentable_id).prepend(JST['templates/comments/comment'] (data))
          $('.form-comment-answer-'+ data.comment.commentable_id).addClass('hidden')
  });