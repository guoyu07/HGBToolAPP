$(document).on("pageInit", "#page-addFriend_tpl", function() {

	$('.div-custom-friendlist').on('click', function(e) {
		$.router.load('./myQrcode_tpl.html', true);
	});
	
	//点击扫一扫调用二维码插件
	$('#saoyisao').on('click', function() {

		AgreeSDK.QRCode.scan(function(msg) {
			//alert(msg);
			//var type = JSON.parse(msg).type;
			ALL_San(msg);

		}, function(err) {
			$.alert(err);
		});
	});
	$('#phone_contact').on('click', function(e) {
		$.router.load('./mobileContact_tpl.html', true);
	});
	//这个需要给文本框加model ,判断是否有值 在跳转
	$('#result_input').on('focus', function(e) {
		$.router.load('./searchFriendsResult_tpl.html', true);
	});

});