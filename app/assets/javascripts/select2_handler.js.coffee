initSelect2 = ->
  $('.select2').each (i, e) =>
    select = $(e)
    options =
      placeholder: select.data('placeholder')
      allowClear: true
      containerCss: {"display":"block"}
    select.select2(options)

$(document).ready(initSelect2);
$(document).on('page:load', initSelect2);