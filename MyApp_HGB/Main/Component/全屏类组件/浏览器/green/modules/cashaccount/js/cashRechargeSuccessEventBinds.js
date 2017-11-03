$(document).on("pageInit", "#page-cashRechargeSuccess_tpl", function() {

	var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
    //现金充值返回的数据
    var cashRecharge_info = {};

	var vm = new Vue({
		el: '#page-cashRechargeSuccess_tpl', //@绑定节点
		data: { //@数据	

		},
		methods: { //@方法-事件调用(this指向data)

          complete:function(){
          	$.router.load('./cashAlreadyBound_tpl.html', true);
          }
		},
		created: function() { //@业务逻辑（this指向data）
		    vue_modual = this;
		    //初始化
			init();
		    
		}
	});

	function init(){

		cashRecharge_info = getsession('cashRecharge_info');
		
		vue_modual.amount_ = cashRecharge_info.cash_amont_;
		vue_modual.create_time_= cashRecharge_info.trans_time_;

	}

	
});
