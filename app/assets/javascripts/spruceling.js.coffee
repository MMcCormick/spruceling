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

  # For IE 7/8
  $('.cover-image').css("background-size", "cover")
  $('.contain-image').css("background-size", "contain")

  $('.complete-purchase .button').on 'click', (e) ->
    $(@).find('.button').val('working...').addClass('disabled')
    $(@).find('.button').text('working...').addClass('disabled')