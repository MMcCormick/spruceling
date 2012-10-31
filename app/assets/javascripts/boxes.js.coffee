jQuery ->

  $('#box_list').masonry
    itemSelector: '.box_teaser'


  # NEW BOX FORM
  $('#new_box').livequery ->
    gender = $('#box_gender').val()
    if gender == 'm'
      $('#new_box .boy').toggleClass('grey on')
    else if gender == 'f'
      $('#new_box .girl').toggleClass('grey on')

  $('#new_box .boy, #new_box .girl').click (e) ->
    $('#new_box .boy, #new_box .girl').removeClass('on').addClass('grey')
    $(@).toggleClass('grey on')
    $('#box_gender, #new_box .item_form .item_gender').val($(@).data('value'))

  $('#box_size').on 'change', ->
    $('#new_box .item_form .item_size').val($(@).val())

  $('#new_box .item_form').livequery ->
    $(@).find('.item_gender').val($('#box_gender').val())
    $(@).find('.item_size').val($('#box_size').val())