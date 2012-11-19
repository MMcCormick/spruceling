jQuery ->

  $('.toggle_edit_payment').click (e) ->
    e.preventDefault()
    $('#card_form_wrapper').toggleClass('hide')
    $('#card_info_wrapper').toggleClass('hide')

  $('.toggle_edit_address').click (e) ->
    e.preventDefault()
    $('#address_form_wrapper').toggleClass('hide')
    $('#address_info_wrapper').toggleClass('hide')