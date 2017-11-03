$(document).on('pageInit', '#page-cashBoundCardSuccess_tpl', function() {
	//获取成功的数据赋值
	var temp_userinfo = {};

	var vue_modual = {};

	var temp_card_bank_info = {};

	var vm = new Vue({
		el: '#page-cashBoundCardSuccess_tpl', //@绑定节点
		data: { //@数据  
			bank_cardno_: '',
			create_time_: ''
		},
		methods: { //@方法-事件调用(this指向data)

			jump: function() {
				$.router.load('./cashAlreadyBound_tpl.html', true);
			}
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			//初始化
			init();

		}
	});

	function init() {

		temp_card_bank_info = getsession('card_result');

		vue_modual.bank_cardno_ = temp_card_bank_info.bank_cardno_;
		vue_modual.create_time_ = temp_card_bank_info.create_time_;
	}

});