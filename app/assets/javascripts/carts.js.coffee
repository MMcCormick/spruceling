jQuery ->

  $('.step .toggle').click (e) ->
    $(@).parent().find('.show,.edit').toggle()
    if $.trim($(@).text()) == 'Edit'
      $(@).text('Cancel')
    else
      $(@).text('Edit')

  $('.login-container .options #new_account').click (e) ->
    $('.login-container .login #password, .login-container .login .facebook_login').hide()

  $('.login-container .options #have_account').click (e) ->
    $('.login-container .login #password, .login-container .login .facebook_login').removeClass('hide').show()

  $('.login-container .login #email').keyup (e) ->
    $('.login-container .register #email').val($(@).val())

  $('.login-container .login form').submit (e) ->
    if $('.login-container .login #new_account').is(':checked')
      e.preventDefault()
      $('.login-container .login').hide()
      $('.login-container .register').removeClass('hide').show()
      $('.header').text('Now fill in your name & password.')
      $('.subheader').text('You\'ll only have to do this once.')
      false