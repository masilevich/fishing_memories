var decode_utf8, fade_flash, show_ajax_message;

fade_flash = function() {
  $("#flash_notice").delay(5000).fadeOut("slow");
  $("#flash_alert").delay(5000).fadeOut("slow");
  $("#flash_error").delay(5000).fadeOut("slow");
};

fade_flash();

show_encoded_ajax_message = function(msg, type) {
  $("div.flashes").html("<div class=\"flash flash_" + type + "\">" + decode_utf8(msg) + "</div>");
  fade_flash();
};

show_ajax_message = function(msg, type) {
  $("div.flashes").html("<div class=\"flash flash_" + type + "\">" + msg + "</div>");
  fade_flash();
};

$(document).ajaxComplete(function(event, request, settings) {
  var msg, type;
  msg = request.getResponseHeader("X-Message");
  type = request.getResponseHeader("X-Message-Type");
  if (type === "blank") {
    return;
  }
  show_encoded_ajax_message(msg, type);
});

decode_utf8 = function(s) {
  return decodeURIComponent(escape(s));
};