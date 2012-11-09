jQuery ->

  $('#new_box').on 'submit', (e) ->
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

  $('#header .new_box').on 'click', (e) ->
    e.preventDefault()
    $('#header #new_box').toggle(200)

  # handle adding a new item to a box
  $('.box_form .item_form .add_item').on 'click', (e) ->
    e.preventDefault()
    self = $(@).parent('.item_form:first')
    $.ajax
      url: '/items'
      data: $(self).serializeArray()
      cache: false
      dataType: 'json'
      type: 'POST'
      success: (data, textStatus, jqXHR) ->
        console.log data
        $(self).find('select option[value=""]').attr('selected', true)
        $(self).find('#item_brand').val('')
        $(self).find(':checked').removeAttr('checked')
        $(self).find('.alert-error').remove()
        $('.items').append(data.form_teaser)
        $('.price .low').text("$#{data.recommended_price.recommended_low}")
        $('.price .high').text("$#{data.recommended_price.recommended_high}")
      error: (jqXHR, textStatus, errorThrown) ->
        globalError(jqXHR, $(self))

  # brand search when adding new box items
  $('#item_brand').soulmate
    url:            '/sm/search'
    types:          ['brand']
    minQueryLength: 2
    maxResults:     5
    renderCallback: (term, data, type) ->
      term
    selectCallback: (term, data, type) ->
      $('#soulmate').hide()
      $('#item_brand').val(term).blur()

  # handle deleting an item from a box
  $('.item_form_teaser').on 'click', '.delete', (e) ->
    e.preventDefault()
    self = $(@)
    $.ajax
      url: self.attr('href')
      cache: false
      type: 'delete'
      dataType: 'json'
      success: (data, textStatus, jqXHR) ->
        self.parent('.item_form_teaser:first').remove()
        $('.price .low').text("$#{data.recommended_price.recommended_low}")
        $('.price .high').text("$#{data.recommended_price.recommended_high}")

    false

  # update shipping price
  $('#box_seller_price').on 'keyup', (e) ->
    $(@).val(Math.round($(@).val()))
    $('.shipping_note span').text($('.shipping_note span').data('shipping') + parseInt($(@).val()))

  # box images
  $('#boxes_photo_upload').fileupload
    dataType: "json"
    type: 'POST'
    formData: {'imageable_id': $('#box_id').val(), 'imageable_type': 'Box'}
    add: (e,data) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        $('.photo-list').prepend(data.context)
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10) + 1
        data.context.find('.bar').css('width', progress + '%')
        if progress >= 99
          data.context.find('.bar').parents('.upload:first').addClass('done')
    done: (e,data) ->
      $('.photo-list .upload.done').remove()
      for image in data.result
        $('.photo-list').append(image.html)