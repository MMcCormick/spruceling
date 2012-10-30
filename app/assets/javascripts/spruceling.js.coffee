jQuery ->

  $('.attachinary-input').attachinary()

  # splash page
  resizeSplash = ->
    $('#splash .main').css('height', $(window).height() - $('.top_strip').height())
  resizeSplash()
  $(window).resize ->
    resizeSplash()
