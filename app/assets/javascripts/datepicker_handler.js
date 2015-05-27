$(function() {
	$.datepicker.setDefaults($.datepicker.regional["ru"]);
	$( ".datepicker" ).datepicker({
    changeMonth: true,
    changeYear: true
  });
});