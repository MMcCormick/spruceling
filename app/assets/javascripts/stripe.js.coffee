jQuery ->

  stripeResponseHandler = (status, response) ->
    if (response.error)
      # show the errors on the form
      $(".payment-errors").text(response.error.message)
      $(".submit-button").removeAttr("disabled")
    else
      form$ = $("#payment-form")
      # token contains id, last4, and card type
      token = response['id']
      # insert the token into the form so it gets submitted to the server
      form$.find('.stripe-token').val(token)
      # and submit
      form$.get(0).submit()

  $("#payment-form").submit (event) ->
    # disable the submit button to prevent repeated clicks
    $('.submit-button').attr("disabled", "disabled")

    Stripe.createToken({
      number: $('.card-number').val(),
      cvc: $('.card-cvc').val(),
      exp_month: $('.card-expiry-month').val(),
      exp_year: $('.card-expiry-year').val()
    }, stripeResponseHandler)

    # prevent the form from submitting with the default action
    return false