$ ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id
    ,

    received: (data) ->
      if gon.user_id != data.comment.user_id
        console.log(data)
        $('.comment-' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id).prepend(JST['templates/comments/comment'] (data))
        $('.form-comment-'+ data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id).addClass('hidden')
  });