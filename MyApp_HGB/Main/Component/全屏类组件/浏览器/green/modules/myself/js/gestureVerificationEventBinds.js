$(document).on('pageInit', '#page-gestureVerification_tpl', function() {
	console.log('1111');
	$("#demoform").mvalidate({
		onKeyup: true, //支持键盘验证事件
		firstInvalidFocus: true,
		valid: function(event, options) {
			//点击提交按钮时,表单通过验证触发函数
			event.preventDefault();
			$.router.load('transferAccount1_tpl.html', true, {
				username: $('#txt_username').val(),
				pws: $('#txt_password').val()
			});
		},
		invalid: function(event, status, options) {
			//点击提交按钮时,表单未通过验证触发函数
		},
		eachField: function(event, status, options) {
			//点击提交按钮时,表单每个输入域触发这个函数 this 执向当前表单输入域，是jquery对象
		},
		eachValidField: function(val) {},
		eachInvalidField: function(event, status, options) {}
	});
});