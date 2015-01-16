select2Gem = ->
  $('.select2').each (i, e) =>
    select = $(e)
    options =
      placeholder: select.data('placeholder')
      width: '100%'
    select.select2(options)

$(document).ready(select2Gem);
$(document).on('page:load', select2Gem);