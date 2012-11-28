jQuery ->

  stripeResponseHandler = (status, response) ->
    if (response.error)
      # show the errors on the form
      $(".payment-errors").text(response.error.message)
      $(".action.button").removeAttr("disabled").text('Update Payment Information')
    else
      $(".action.button").text('Success! Reloading...')
      form$ = $("#payment-form")
      # token contains id, last4, and card type
      token = response['id']
      # insert the token into the form so it gets submitted to the server
      form$.find('.stripe-token').val(token)
      # and submit
      form$.get(0).submit()

  $("#payment-form").submit (event) ->
    # disable the submit button to prevent repeated clicks
    $('.action.button').attr("disabled", "disabled").text('working...')

    Stripe.createToken({
      number: $('.card-number').val(),
      cvc: $('.card-cvc').val(),
      exp_month: $('.card-expiry-month').val(),
      exp_year: $('.card-expiry-year').val(),
      name: $('.card_name').val(),
      address_line1: $('.address_line1').val(),
      address_line2: $('.address_line2').val(),
      address_city: $('.address_city').val(),
      address_state: $('.address_state').val(),
      address_zip: $('.address_zip').val()
    }, stripeResponseHandler)

    # prevent the form from submitting with the default action
    return false