$(document).on('pageInit', '#page-cashForwardResults_tpl', function() {

	

	var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
    //现金提现返回的数据
    var appmsg = {};

	var vm = new Vue({
		el: '#page-cashForwardResults_tpl', //@绑定节点
		data: { //@数据	
            desc_:''
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

	  
		var appmsg = getsession('msgs');
		vue_modual.desc_ = appmsg;

	}

});
