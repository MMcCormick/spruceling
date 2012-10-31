jQuery ->

  $('.attachinary-input').attachinary()

  # splash page
  resizeSplash = ->
    $('#splash .main').css('height', $(window).height() - $('.top_strip').outerHeight() - $('#footer').outerHeight())
  resizeSplash()
  $(window).resize ->
    resizeSplash()
