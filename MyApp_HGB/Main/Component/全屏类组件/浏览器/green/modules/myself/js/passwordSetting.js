$(document).on("pageInit", "#page-passwordSetting", function(e, pageId, $page) {
	$('#a-custom-forget_cancel').on('click', function(e) {
		$.router.back();
	});
	var temp_userinfo = {};
	$("#form_forget").mvalidate({
		onKeyup: false, //支持键盘验证事件
		firstInvalidFocus: true,
		valid: function(event, options) {
			//点击提交按钮时,表单通过验证触发函数
			event.preventDefault();
			var surePassword = $('.surePassword').val();
			var forget_password = $(".registePassword").val();
			var input_verifyCode = $('#input_verifyCode').val();
			phone = $('.registePhone').val(phone);
			if(surePassword != forget_password) {
				$.toast('密码不一致！请重新输入');
			}
			if(!input_verifyCode) {
				$.toast('请输入验证码!');
			}

			var post_adress = url_ + "mobile/member/memFindPsw.jhtml";
			var data = {
				phone_: phone,
				password_: forget_password
			};
			data = JSON.stringify(data);
			$.showPreloader();
			//调用获取本地数据方法
			temp_userinfo = getsession('userInfo');
			var temp_device = temp_userinfo.device_id_;
			var phone = temp_userinfo.phone_;
			var token = temp_userinfotoken_;
			AgreeSDK.Connection.getNetWorkRequest(post_adress, data, token, temp_device, function(msg) {
				alert(msg);
				var data_forgetlist = JSON.parse(msg);
				alert(data_forgetlist);
				if(data_forgetlist.appcode == 1) {
					setTimeout(function() {
						$.hidePreloader();
						$.router.load('../../index_tpl.html', true);
					}, 500)
				}

			}, function(err) {
				$.toast('网络请求失败！');
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
	})
	//短信验证
	$("#a_getCode").on('click', function() {
		$.sendVerifyCode($(this), 60, '重新发送');
	});

});
getDeviceName();