
$(document).on("pageInit", "#page-modifyPassword", function(e, pageId, $page) {
	$("input").on('input propertychange change', function() {
		isEmpty();
	});
	//短信验证
	$(".obtain").on('click', function() {
		$.sendVerifyCode($(this), 60, '重新发送');
	});
});
