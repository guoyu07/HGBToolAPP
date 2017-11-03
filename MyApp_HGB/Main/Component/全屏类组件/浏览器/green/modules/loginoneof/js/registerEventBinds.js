$(document).on("pageInit", "#page-register_tpl", function() {

	var vue_modual = {};
	var temp_userinfo = {};

	var vm = new Vue({
		el: '#page-register_tpl', //@绑定节点
		data: { //@数据
			userpwd: '',
			username: '',
			veritrycode: ''
		},
		methods: { //@方法-事件
			submit: function() {
				submit();
			}
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			init();
		}
	});

	function init() {
		var temp_userinfo = getsession("temp_userInfo");
		// if(temp_user != null && temp_user != '') {
		// 	vue_modual.username = temp_user.phone_;
		// 	vue_modual.userpwd = temp_user.password_;

		// }

	}

	//短信验证
	$(".obtain").on('click', function() {

		$.sendVerifyCode($(this), 60, '重新发送');
		//调用手机验证码接口

		var post_adress = url_ + "mobile/member/phoneCode.jhtml";

		var data = {
			phone_: vue_modual.username
		};

		var deviceid = temp_userinfo.device_id_;
		var token = temp_userinfo.toke_;
		AgreeSDK.Connection.getNetWorkRequest(post_adress, data, token, deviceid, function(msg) {

			if(msg.appcode == 1) {

				conserve('mobile_code', msg.data.mobile_code);

			}

		}, function(err) {

			$.toast('网络请求失败');

			$('#btn_login').removeClass('actives');
		});

	})

	function submit() {

		if(vue_modual.username != '' && vue_modual.userpwd != '' && vue_modual.veritrycode != '') {

			$('#btn_login').removeClass('actives');

			var mobile_code = getsession("mobile_code");

			$('.registerbtn').addClass('actives');

           

			$.showPreloader('注册中...');
            // if(vue_modual.veritrycode != mobile_code){
           
            //    $.toast('验证码不正确！');
               
            //    $('#btn_login').removeClass('actives');
           
            // }
			var post_adress = url_ + "mobile/member/memRegister.jhtml";
			//var post_adress = url_ + "mobile/member/memRegister.jhtml";
			var data = {
				phone_: vue_modual.username,
				password_: vue_modual.userpwd
			};
			//注册登录传空的‘’=token

			var temp_device = getsession('device_id_');

			AgreeSDK.Connection.getNetWorkRequest(post_adress, data, '', temp_device, function(msg) {

				$.hidePreloader();

				var dataList = msg;

				if(dataList.appcode == 1) {

					var userInfo = dataList.data;

					//存储到文件 sdk 
					AgreeSDK.FilePlugin.saveDefaults("userInfo", JSON.stringify(userInfo), function(msg) {
						//存储到Storage
						conserve('userInfo', userInfo);

						AgreeSDK.FilePlugin.saveDefaults("private_key", JSON.stringify(userInfo.private_key_), function(msg) {
							//存储到Storage
							conserve('private_key', userInfo.private_key_);

							$.router.load('../home/home_tpl.html', true);
						}, function(msg) {

						});
						//$.router.load('../home/home_tpl.html', true);
					}, function(msg) {

					});
				} else if(dataList.appcode == -1) {

					$.toast('注册失败！');
					$('.registerbtn').removeClass('actives');
				} else {

					$.toast('账户已存在！');
					$('.registerbtn').removeClass('actives');
				}
			}, function(err) {

				$.hidePreloader();

				$.toast('网络请求失败！');

				$('.registerbtn').removeClass('actives');
			});

		} else {
			$.toast('请输入完整!');
		}
	}

})
getDeviceName();
