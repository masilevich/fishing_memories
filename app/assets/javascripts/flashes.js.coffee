fade_flash = ->
  $("#flash_notice").delay(5000).fadeOut "slow"
  $("#flash_alert").delay(5000).fadeOut "slow"
  $("#flash_error").delay(5000).fadeOut "slow"
  return

fade_flash()
show_ajax_message = (msg, type) ->
  $("div.flashes").html "<div class=\"flash flash_" + type + "\">" + decode_utf8(msg) + "</div>"
  fade_flash()
  return

$(document).ajaxComplete (event, request, settings) ->
  msg = request.getResponseHeader("X-Message")
  type = request.getResponseHeader("X-Message-Type")
  show_ajax_message msg, type #use whatever popup, notification or whatever plugin you want
  return

decode_utf8 = (s) ->
  decodeURIComponent escape(s)