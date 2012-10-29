jQuery ->

  $('.toggle_edit_payment').click (e) ->
    console.log('foo')
    e.preventDefault()
    $('#card_form_wrapper').toggleClass('hide')
    $('#card_info_wrapper').toggleClass('hide')