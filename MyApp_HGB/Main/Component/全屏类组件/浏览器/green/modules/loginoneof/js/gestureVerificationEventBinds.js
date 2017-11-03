$(document).on('pageInit', '#page-gestureVerification_tpl', function() {

	var vue_modual = {};
	var temp_userinfo = {};

	var vm = new Vue({
		el: '#page-gestureVerification_tpl', //@绑定节点
		data: { //@数据
			
		},
		methods: { //@方法-事件
          
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			init();
		}
	});

	function init() {

		var temp_user = getsession("temp_userInfo");
     

	}
	
	
});