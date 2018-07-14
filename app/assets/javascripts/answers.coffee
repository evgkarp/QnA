# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show();

  $('.answers').find('.vote-for').click (e) ->
    e.preventDefault()
    questionId = $('.question').data('id')
    answerId = $(this).closest('li').data('id')
    $.post('/questions/' + questionId + '/answers/' + answerId + '/vote_for')
    .then (data) ->
      $('#answer-id-' + answerId).find('.rating').text(data.rating)
    $('#answer-id-' + answerId).find('.vote-for').hide()
    $('#answer-id-' + answerId).find('.vote-against').hide()

  $('.answers').find('.vote-against').click (e) ->
    e.preventDefault()
    questionId = $('.question').data('id')
    answerId = $(this).closest('li').data('id')
    $.post('/questions/' + questionId + '/answers/' + answerId + '/vote_against')
    .then (data) ->
      $('#answer-id-' + answerId).find('.rating').text(data.rating)
    $('#answer-id-' + answerId).find('.vote-for').hide()
    $('#answer-id-' + answerId).find('.vote-against').hide()

  $('.answers').find('.reset-vote').click (e) ->
    e.preventDefault()
    questionId = $('.question').data('id')
    answerId = $(this).closest('li').data('id')
    $.post('/questions/' + questionId + '/answers/' + answerId + '/reset_vote')
    .then (data) ->
      $('#answer-id-' + answerId).find('.rating').text(data.rating)
    $('#answer-id-' + answerId).find('.vote-for').show()
    $('#answer-id-' + answerId).find('.vote-against').show()

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      questionId = $('.question').data('id')
      if questionId
        @perform 'follow', id: questionId
    ,

    received: (data) ->
      current_user_id = gon.current_user_id
      if current_user_id != data.data.user_id
        $('ul.answers').append(JST["templates/answer"](data))
  })
