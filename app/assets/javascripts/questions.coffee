# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  $('.question').find('.vote-for').click (e) ->
    e.preventDefault()
    questionId = $('.question').data('id')
    $.post('/questions/' + questionId + '/vote_for')
    .then (data) ->
      $('.question').find('.rating').text(data.rating)
    $('.question').find('.vote-for').hide()
    $('.question').find('.vote-against').hide()

  $('.vote-against').click (e) ->
    e.preventDefault()
    questionId = $('.question').data('id')
    $.post('/questions/' + questionId + '/vote_against')
    .then (data) ->
      $('.question').find('.rating').text(data.rating)
    $('.question').find('.vote-for').hide()
    $('.question').find('.vote-against').hide()

  $('.reset-vote').click (e) ->
    e.preventDefault()
    questionId = $('.question').data('id')
    $.post('/questions/' + questionId + '/reset_vote')
    .then (data) ->
      $('.question').find('.rating').text(data.rating)
    $('.question').find('.vote-for').show()
    $('.question').find('.vote-against').show()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow',

    received: (data) ->
      $('.questions').append data
  })
