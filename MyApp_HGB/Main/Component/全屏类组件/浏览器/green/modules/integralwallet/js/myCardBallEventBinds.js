$(document).on("pageInit", "#page-myCardBall_tpl", function() { 
  
    var temp_userinfo={};
	//存储一个全局变量
    var vue_modual = {};
    
	// 加载flag
	var loading = false;
	// 最多可加载的条目
	var maxItems = 100;
	// 每次加载添加多少条目
	var itemsPerLoad = 10;
     
   


	var vm = new Vue({
		el: '#page-myCardBall_tpl', //@绑定节点
		data: { //@数据	
          
           tenantsList: {
           	 list:[]
           	 
           },
          down_bool:false



		},
		methods: { //@方法-事件调用(this指向data)
                
           		tabTenants:function(){
					//商户列表
					
				},
				//跳转积分兑换页面
	             onShops:function(dataid){
					$.router.load('./addShops_tpl.html?dataid='+dataid);
	             }
	              

          
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
   
        tenantsList(0,10,function(){

		});
		
		


	}
	

	 /**
	 * 商户加载列表的核心方法  - 商户列表 js - start 
	 */
	function tenantsList(arg_start_,arg_limit_,callback) {

		//var temp_url = "http://localhost:8080/data/json_2.json";
		var temp_url = url_ + "mobile/merchant/merchantList.jhtml";

		var temp_post_csh = {
			limit:arg_limit_,
			start:arg_start_
			//name_:paramsVal
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {

			
			if(data.appcode == 1){
				//alert(vue_modual.tenantsList.list.length);
				if(vue_modual.tenantsList.list.length > 9 && arg_start_!=0){
					for(var i = 0 ; i < data.data.length ; i ++){
						vue_modual.tenantsList.list.push(data.data[i]);
					}
				}else{
					vue_modual.tenantsList.list = data.data;

					if(data.data.length <= 9){
						vue_modual.down_bool = false;
					}else{
						vue_modual.down_bool = true;
					}
				}

				vue_modual.tenantsList.start = arg_start_;
				vue_modual.tenantsList.limit = arg_limit_;

				callback();

              
				
			}	
			
		}, function(err) {
			$.toast('网络请求失败!');
		});
	}

	// //下方加载
	$(document).on('infinite', '', function() {		
		// 如果正在加载，则退出
		if(loading) return;

		// 设置flag
		loading = true;

		//追加
		tenantsList((vue_modual.tenantsList.start+1),vue_modual.tenantsList.limit,function(){
			loading = false;
			lastIndex = $('.list-container #div_activity_list').length;
			//容器发生改变,如果是js滚动，需要刷新滚动
			$.refreshScroller();
		});
		
		
	});
	// //下方结束

	// //上方加载
	// // 添加'refresh'监听器
	$(document).on('refresh', '.pull-to-refresh-content', function(e) {

		// - 商户列表
		// tenantsList(0,10,function(){
		// 	// 加载完毕需要重置
		// 	$.pullToRefreshDone('.pull-to-refresh-content');
		// 	//容器发生改变,如果是js滚动，需要刷新滚动
		// 	$.refreshScroller();
		// });
		
	});
	/**
	 *  商户列表 js - end 
	 */
    
   
   
});
getDeviceName();
