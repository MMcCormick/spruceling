jQuery ->
  $('.photo').on 'click', '.remove', (e) ->
    e.preventDefault()
    self = $(@)
    $.ajax
      url: self.attr('href')
      type: 'delete'
      success: (data, textStatus, jqXHR) ->
        self.parents('.photo:first').remove()