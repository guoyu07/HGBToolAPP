$(document).on("pageInit", "#page-merchantName", function() {
	//	$('.merchantInput').on('focus', function(e) {
	//
	//	});
	$('#div_activity_list').on('click', function(e) {
		$.router.load('./activityListDetail_tpl.html?id=1&name=2', false, { "key": "value" });
	});
});
getDeviceName();