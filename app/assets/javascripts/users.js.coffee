jQuery ->

  $('#toggle_withdraw').click (e) ->
    e.preventDefault()
    $('#withdraw').toggleClass('hide')
