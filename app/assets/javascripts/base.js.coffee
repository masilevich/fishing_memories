# Initializers
$ ->
  # jQuery datepickers (also evaluates dynamically added HTML)
  $(document).on 'focus', '.datepicker:not(.hasDatepicker)', ->
    defaults = dateFormat: 'yy-mm-dd'
    options = $(@).data 'datepicker-options'
    $(@).datepicker $.extend(defaults, options)

  # Clear Filters button
  $('.clear_filters_btn').click ->
    params = window.location.search.split('&')
    regex = /^(q\[|q%5B|q%5b|page|commit)/
    window.location.search = (param for param in params when not param.match(regex)).join('&')
