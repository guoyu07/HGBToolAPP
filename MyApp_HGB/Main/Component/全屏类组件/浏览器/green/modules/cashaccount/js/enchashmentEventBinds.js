$(document).on('pageInit', '#page-enchashment_tpl', function() {

	var temp_card_info = {};
	var temp_userinfo = {};

	var vue_modual = {};

	var vm = new Vue({
		el: '#page-enchashment_tpl', //@绑定节点
		data: { //@数据	
			cardinfo: {
				money: '',
				phone: '',
				mobile_code: ''
			},
			card: {
				dayMonery: '0.00',
				SingleMonery: '0.00'
			}
		},
		methods: { //@方法-事件调用(this指向data)
			submit: function() {
				submit();
			},
			details: function() {

				$.router.load('./bankCardLimit_tpl.html', true);
			}
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			//初始化
			init();

		}
	});

	//验证
	function verification() {
		if(!CHECK(vue_modual.phone)) {
			return true;
		}
		if(!CHECK(vue_modual.money)) {
			return true;
		}
		if(!CHECK(vue_modual.mobile_code)) {
			return true;
		}
		return false;
	}

	function init() {

		temp_userinfo = getsession('userInfo');

		temp_card_info = getsession('card_info');
		vue_modual.cardinfo = temp_card_info;
		//获取卡号
		vue_modual.cardinfo.bkacctno_hide = vue_modual.cardinfo.bkacctno_;
        var temp_bank_ =  bank_like(vue_modual.cardinfo.bkacctno_);
		//对卡号进行转换 *** *** 格式
		vue_modual.cardinfo.bkacctno_ = Transformation(vue_modual.cardinfo.bkacctno_);
		//返回单日金额与单笔金额
		vue_modual.card = bank_like(vue_modual.cardinfo.bkacctno_hide);
        vue_modual.BANKIMG = temp_bank_.BANKIMG;
               
               
               
               
               
               
               

	}

	//短信验证
	$(".obtain").on('click', function() {

		$.sendVerifyCode($(this), 60, '重新发送');
		//调用手机验证码接口

		var post_adress = url_ + "mobile/member/phoneCode.jhtml";

		var data = {
			phone_: vue_modual.phone
		};

		var deviceid = temp_userinfo.device_id_;
		var token = temp_userinfo.toke_;
		AgreeSDK.Connection.getNetWorkRequest(post_adress, data, token, deviceid, function(msg) {

			if(msg.data == 1) {

				conserve('mobile_code', msg.data.mobile_code);
				var mobile_code = getsession('mobile_code');

				//              if(vue_modual.mobile_code != mobile_code){
				//
				//			       $.toast('验证码不正确！');
				//			       
				//			       $('.span-custom-bdbtn').removeClass('activies');
				//
				//			    }

			}

		}, function(err) {

			$.toast('网络请求失败');

			$('.span-custom-bdbtn').removeClass('activies');
		});

	})

	function submit() {

		if(verification()) {
			$.toast('请填写完整信息！');
			return;
		}

		$('.span-custom-bdbtn').addClass('activies');

		$.showPreloader('正在处理...');

		var temp_url = url_ + "mobile/trade/cashRecharge.jhtml";

		var id = temp_userinfo.id_;
		var temp_post_csh = {
			member_id_: id,
			amount_: vue_modual.money
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
           
			$.hidePreloader();
			$('.span-custom-bdbtn').removeClass('activies');

			if(data.appcode == 1) {

				$.router.load('./cashRechargeSuccess_tpl.html', true);

				conserve('cashRecharge_info', data.data);

			} else {

				$.router.load('./cashRechargeFail_tpl.html', true);

				conserve('appmsgs', data.appmsg);
			}

		}, function(err) {

			$.hidePreloader();
			$.toast('网络请求失败!');
			$('.span-custom-bdbtn').removeClass('activies');
		});
	}

});
