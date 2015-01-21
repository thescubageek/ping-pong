# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('button[type=submit]').on 'click', ((e) ->
    if $(this).hasClass('disabled')
      return false
    else
      $(this).addClass('disabled')
  )
