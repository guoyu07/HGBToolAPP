$(document).on("pageInit", "#page-payPassword_tpl", function(e, pageId, $page) {

	var temp_userinfo = {};
	//存储一个全局变量
	var vue_modual = {};
	var vm = new Vue({
		el: '#page-payPassword_tpl', //@绑定节点
		data: { //@数据	 表单数据

			old_pay_password_: '',
			pay_password_: '',
            sure_password_:''

		},
		methods: { //@方法-事件调用(this指向data)
			submit: function() {
				submit();
			},
			 mima1: function() {

				mima1();
			},
			mima2: function() {

				mima2();
			},
			mima3: function() {

				mima3();
			}
		},
		created: function() { //@业务逻辑（this指向data）

			vue_modual = this;
			//初始化
			settingPayPwd = getsession('settingPayPwd');

		}
	});
    //弹出密码键盘
	function mima1() {
		AgreeSDK.KeybordPlugin.onKeyboard('1', '1234567891234567', function(msg) {
			vue_modual.old_pay_password_ = msg;
		}, function() {

		});
	}

	function mima2() {
		AgreeSDK.KeybordPlugin.onKeyboard('1', '1234567891234567', function(msg) {
			vue_modual.pay_password_ = msg;
		}, function() {

		});
	}

	function mima3() {
		AgreeSDK.KeybordPlugin.onKeyboard('1', '1234567891234567', function(msg) {
			vue_modual.sure_password_ = msg;
		}, function() {

		});
	}


	function submit() {

		
		if(settingPayPwd != vue_modual.old_pay_password_) {
			$.toast('旧支付密码有误，请重新输入！');
               return;
		}
		if(vue_modual.pay_password_ != vue_modual.sure_password_) {
			$.toast('支付密码不一致，请重新输入！');
               return;
		}else{
               $.showPreloader('正在处理...');
               
               $('.span-custom-open_surebtn').addClass('actives');
               
               
               
               //存储到文件 sdk
               saveFile("settingPayPwd", vue_modual.pay_password_, function() {
                   $.hidePreloader();
                conserve('settingPayPwd', vue_modual.pay_password_);
                $.toast('支付密码保存成功！');
                $.router.load('../../modules/home/home_tpl.html', true);
                }, function(error) {
                $.toast(error);
                $.hidePreloader();
                });
               
               
              
            
		}
		
	}

});
