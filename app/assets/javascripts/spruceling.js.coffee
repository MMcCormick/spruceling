jQuery ->

  # Attachinary
  $('.attachinary-input').livequery ->
    $(@).attachinary()

  # splash page
  resizeSplash = ->
    $('#splash .main').css('height', $(window).height() - $('.top_strip').outerHeight(true) - $('#footer').outerHeight(true))

  $(window).resize ->
    resizeSplash()

  setTimeout ->
    resizeSplash()
  , 300
