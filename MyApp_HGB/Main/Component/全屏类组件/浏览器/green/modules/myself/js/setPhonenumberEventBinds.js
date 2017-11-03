$(document).on("pageInit", "#page-setPhonenumber_tpl", function() {
    

    var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
	var vm = new Vue({
		el: '#page-setPhonenumber_tpl', //@绑定节点
		data: { //@数据	

          phone:''
		},
		methods: { //@方法-事件调用(this指向data)

          
		},
		created: function() { //@业务逻辑（this指向data）
		    vue_modual = this;
		    //初始化
			init();
		    
		}
	});


	//界面初始化
	function init(){

		temp_userinfo = getsession('userInfo');
		phone_ = temp_userinfo.phone_;
		vue_modual.phone = phone_;

	}

	$('.div-custom-setphone').on('click', function(e) {
		$.router.load('./changePhoneNumber_tpl.html?phone_='+phone_,false);

	});
})