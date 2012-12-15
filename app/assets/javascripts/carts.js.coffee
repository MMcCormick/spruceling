jQuery ->

  $('.step .toggle').click (e) ->
    $(@).parent().find('.show,.edit').toggle()
    if $.trim($(@).text()) == 'Edit'
      $(@).text('Cancel')
    else
      $(@).text('Edit')

  $('.login-container .options #new_account').click (e) ->
    $('.login-container .login #password').hide()

  $('.login-container .options #have_account').click (e) ->
    $('.login-container .login #password').removeClass('hide').show()

  $('.login-container .login #email').keypress (e) ->
    $('.login-container .register #email').val($(@).val())

  $('.login-container .login form').submit (e) ->
    if $('.login-container .login #new_account').is(':checked')
      e.preventDefault()
      $('.login-container .login').hide()
      $('.login-container .register').removeClass('hide').show()
      $('.header').text('Now choose a password.')
      $('.subheader').text('You\'ll only have to do this once.')
      false