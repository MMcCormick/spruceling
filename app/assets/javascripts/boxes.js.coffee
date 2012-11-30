jQuery ->

  $('#new_box').on 'submit', (e) ->
    e.preventDefault()
    self = @
    button = $(self).find('.button')
    return if button.hasClass('disabled')
    button.addClass('disabled')
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
      complete: (jqXHR, textStatus) ->
        button.text('Start Building It!').removeClass('disabled')

  $('#header .new_box').on 'click', (e) ->
    unless ($(e.target).hasClass('new_box'))
      return

    if $(@).hasClass('no-address')
      location.href = '/boxes/new'
    else
      e.preventDefault()
      $('#header #new_box').toggle()

  # handle adding a new item to a box
  $('body').on 'click', '#new_item .add_item', (e) ->
    e.preventDefault()
    self = $('#new_item')
    button = $(self).find('.button')
    return if button.hasClass('disabled')
    button.addClass('disabled').text('loading...')
    $.ajax
      url: '/items'
      data: self.find('input,select').serializeArray()
      cache: false
      dataType: 'json'
      type: 'POST'
      success: (data, textStatus, jqXHR) ->
        self.find('select option[value=""]').attr('selected', true)
        self.find('#item_brand').val('')
        self.find(':checked').removeAttr('checked')
        self.find('.alert-error').remove()
        $('.item-list').append(data.form_teaser)
        $('.price .low').text("$#{data.recommended_price.recommended_low}")
        $('.price .high').text("$#{data.recommended_price.recommended_high}")
      error: (jqXHR, textStatus, errorThrown) ->
        globalError(jqXHR, self)
      complete: ->
        button.text('Add Item').removeClass('disabled')

  # brand search when adding new box items
  $('#item_brand').livequery ->
    $(@).soulmate
      url:            '/sm/search'
      types:          ['brand']
      minQueryLength: 2
      maxResults:     5
      renderCallback: (term, data, type) ->
        term
      selectCallback: (term, data, type) ->
        $('#soulmate').hide()
        $('#item_brand').val(term).blur()

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
        if progress >= 80
          data.context.find('.bar').parents('.upload:first').addClass('done')
    done: (e,data) ->
      $('.photo-list .upload.done').remove()
      for image in data.result
        $('.photo-list').append(image.html)

  # box show page image slider
  $('#photo-list').orbit
    advanceSpeed: 20000

  $('.box_form').livequery ->
    $('#new_item').appendTo($('.item_form'))
    $('#new_item').replaceWith("<div id='new_item'>#{$('#new_item').html()}</div>")