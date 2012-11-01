jQuery ->

  $('#box_list').masonry
    itemSelector: '.box_teaser'


  $('#new_box').live 'submit', (e) ->
    e.preventDefault()
    self = @
    $.ajax
      url: $(self).attr('action')
      data: $(self).serializeArray()
      cache: false
      dataType: 'json'
      type: 'POST'
      success: (data, textStatus, jqXHR) ->
        window.location = data.edit_url
      error: (jqXHR, textStatus, errorThrown) ->
        globalError(jqXHR, $(self))

  $('#header .new_box').live 'click', (e) ->
    e.preventDefault()
    $('#header #new_box').toggle(200)

  $('.box_form .item_form .add_item').live 'click', (e) ->
    e.preventDefault()
    self = $(@).parent('.item_form:first')
    $.ajax
      url: '/items'
      data: $(self).serializeArray()
      cache: false
      dataType: 'json'
      type: 'POST'
      success: (data, textStatus, jqXHR) ->
        $(self).find('select option[value=""]').attr('selected', true)
        $(self).find(':checked').removeAttr('checked')
        console.log data
      error: (jqXHR, textStatus, errorThrown) ->
        globalError(jqXHR, $(self))