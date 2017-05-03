# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('.if-public').css 'display', 'block'
  $('.if-private').css 'display', 'none'

  document.getElementById('idea_private').onchange = ->
    if @checked
      $('.if-public').css 'display', 'none'
      $('.if-private').css 'display', 'block'
    else
      $('.if-public').css 'display', 'block'
      $('.if-private').css 'display', 'none'
    return
