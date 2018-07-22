# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.add-comment-link').click (e) ->
    e.preventDefault();
    $(this).next('form.add-comment').toggle();

  $('form.add-comment').submit (e) ->
    e.preventDefault()
    commentsList = $(this).parentsUntil('ul').find('.comments-list').first()
    bodyText = $(this).find('#comment_body').first()

    $.ajax({
      url: $(this).attr( "action" ),
      type: 'post',
      dataType: 'json',
      contentType: 'application/json; charset=UTF-8',
      data: JSON.stringify(body: bodyText.val())
      })
      .then (data) ->
        commentsList.append('<li>' + data.body)
        bodyText.val('')

    $(this).hide()

    return false

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      questionId = $('.question').data('id')
      if questionId
        @perform 'follow', id: questionId
    ,

    received: (data) ->
      current_user_id = gon.current_user_id
      if current_user_id != data.comment.user_id
        if data['commentable_type'] == 'question'
          $('.question').find('.comments-list').append(JST["templates/comment"](data))
        else if data['commentable_type'] == 'answer'
          $('#answer-id-' + data['commentable_id']).find('.comments-list').append(JST["templates/comment"](data))
  })
