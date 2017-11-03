$(document).on("pageInit", "#page-payPasswordSetting_tpl", function() {

	var vue_modual = {};
	var vm = new Vue({
		el: '#page-payPasswordSetting_tpl', //@绑定节点
		data: { //@数据
			first_pass: '',
			last_pass: ''
		},
		methods: { //@方法-事件
			submit: function() {
				submit();
			},
			mima1: function() {

				mima1();
			},
			mima2: function() {

				mima2();
			}
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;

		}
	});

	//弹出密码键盘
	function mima1() {
		AgreeSDK.KeybordPlugin.onKeyboard('1', '1234567891234567', function(msg) {
			vue_modual.first_pass = msg;
		}, function() {

		});
	}

	function mima2() {
		AgreeSDK.KeybordPlugin.onKeyboard('1', '1234567891234567', function(msg) {
			vue_modual.last_pass = msg;
		}, function() {

		});
	}

	function submit() {
		$.showPreloader('正在处理...');
		var once_password = vue_modual.first_pass;
		var nomal_password = vue_modual.last_pass;

		if(nomal_password !== once_password) {
			$.hidePreloader();
			$.toast('密码不一致！请重新输入');
			$('#pay_password_setting').removeClass('actives');
		} else {

			//存储到文件 sdk
			saveFile("settingPayPwd", once_password, function() {
				$.hidePreloader();
				conserve('settingPayPwd', once_password);
				$.toast('支付密码保存成功！');
				$.router.load('../../modules/home/home_tpl.html', true);
			}, function() {
				$.hidePreloader();
			});

		}
	}

});