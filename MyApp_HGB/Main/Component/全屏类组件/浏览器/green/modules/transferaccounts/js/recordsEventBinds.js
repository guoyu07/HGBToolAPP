$(document).on("pageInit", "#page-records_tpl", function() {
	//var order_no_ = GetQueryString("id");

	//存储一个全局变量
	var vue_modual = {};

	var temp_userinfo = {};

	//列表
	var vm = new Vue({
		el: '#page-records_tpl', //@绑定节点
		data: { //@数据
			list: [

			],
			recordList:{

			}
		},
		methods: { //@方法-事件调用(this指向data)

//            on:function(){
//                $.router.load('./shopDetails_tpl.html', true);
//            }
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;

			//初始化
			init();
		}
	});

	//转换对象帮助 util 
	function Transformation(data) {

		var LIST_ITEMS = {};

		LIST_ITEMS.list = new Array();
		for(var i = 0; i < data.data.length; i++) {
			var temp_data = data.data[i];
			LIST_ITEMS.list.puth(temp_data);
		}

		return LIST_ITEMS;
	}

	//初始化
	function init() {

		 temp_userinfo = getsession('userInfo');
         var temp_order_item = getsession('order_item');
         vue_modual.recordList = temp_order_item;
               
         vue_modual.id_ = temp_userinfo.id_;
		 list();
		 //recordList();
	}


	function list(){

         $.showPreloader();
		//var temp_url = "http://localhost:8080/data/json_2.json";
		var temp_url = url_ + "mobile/member/memberTradeRecord.jhtml";

		var temp_post_csh = {
			start:0,
			limit:200,
			order_no_:vue_modual.recordList.order_no_
		};
		var temp_token = temp_userinfo.token_;
	    var temp_deviceid = temp_userinfo.device_id_;
        
		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
                                              //alert("::"+JSON.stringify(data));
            $.hidePreloader();
			if(data.appcode == 1){
                vue_modual.list = data.data;
                
			}

		},function(error){
			$.hidePreloader();
            $.toast('网络请求失败');
		});
	}

	function recordList(){
		var temp_url = url_ + "mobile/member/memberOrder.jhtml";

		var temp_post_csh = {
			start:0,
			limit:200,
			account_id_:temp_userinfo
		};
		var temp_token = temp_userinfo.token_;
	    var temp_deviceid = temp_userinfo.device_id_;

        $.showPreloader();
        
		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
                                              //alert("::1"+JSON.stringify(data));
            $.hidePreloader();
			if(data.appcode == 1){
                vue_modual.list = data.data;
                
			}

		},function(error){
			$.hidePreloader();
            $.toast('网络请求失败');
		});
	}
	
	

	
});

