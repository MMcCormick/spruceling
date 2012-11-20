jQuery ->

  window.globalSuccess = (data) ->
    if data.flash
      createGrowl false, data.flash, 'Success', 'green'

    if data.redirect
      window.location = data.redirect

  window.globalError = (jqXHR, target=null) ->
    data = $.parseJSON(jqXHR.responseText)

    switch jqXHR.status
      when 422
        if target && data && data.errors
          target.find('.alert-error').remove()
          errors_container = $('<div/>').addClass('alert alert-error')
          for key,errors of data.errors
            if errors instanceof Array
              for error in errors
                errors_container.append("<div>#{error}</div>")
            else
              errors_container.append("<div>#{errors}</div>")
          target.find('.errors').show().prepend(errors_container)