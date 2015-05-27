# Initializers
$ ->
  # Clear Filters button
  $('.clear_filters_btn').click ->
    params = window.location.search.split('&')
    regex = /^(q\[|q%5B|q%5b|page|commit)/
    window.location.search = (param for param in params when not param.match(regex)).join('&')
