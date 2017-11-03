$(document).on("pageInit", "#page-activityAll_tpl", function() { 
    $('.buttons-tab  a').on('click',function(){
        var tabIndex = $(this).index();
        localStorage.setItem('tabIndex',tabIndex);
    })
     
    var temp_userinfo={};
	//存储一个全局变量
    var vue_modual = {};
    var paramsVal = $('.activityAllInput input').val();
	// 加载flag
	var loading = false;
	// 最多可加载的条目
	var maxItems = 100;
	// 每次加载添加多少条目
	var itemsPerLoad = 10;
     
   


	var vm = new Vue({
		el: '#page-activityAll_tpl', //@绑定节点
		data: { //@数据	
           tenantActivityList:{
             list:[],
             down_bool:false
           },
           tenantsList: {
           	 list:[],
           	 down_bool:false
           },
           friendsList:{
             list:[],
             down_bool:false
           }



		},
		methods: { //@方法-事件调用(this指向data)
                
           		tabTenants:function(){
					//tab2 - 商户列表
					tenantsList(0,10,function(){

					});
				},
				tabFriends:function(){
					//tab3 - 好友列表
					
					friendsLists(0,10,function(){

					});
				},
				//search:function(){
					//
					
					//searchLists(0,10,function(){

					//});
				//},
				//跳转活动详情页面
				 onClicks:function(dataid){
					$.router.load('../../modules/activity/activityListDetail_tpl.html?dataid='+dataid);
	              	
	             },
	             //跳转商户信息页面
	             onShops:function(dataid){
					$.router.load('../../modules/transferaccounts/merchantInformation_tpl.html?dataid='+dataid);
	             },
	             //跳转好友信息页面
	             onFriends:function(dataid){
					$.router.load('../../modules/transferaccounts/friendInformation_tpl.html?dataid='+dataid);
	             },
	              //点击搜索按钮事件判断当前是哪个tab,输入内容就会搜索其列表
	             onInput:function(){

				   	var tabIndex =  localStorage.getItem('tabIndex');

				   	switch(tabIndex)
					{
					case 0:
					  tenantActivity();
					  break;
					case 1:
					  tenantsList();
					  break;
					 case 2:
					  	friendsLists();
					  	break;	  
					}
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

		
		//tab1  -商户活动列表
		tenantActivity(0,10,function(){

		});
	


	}
	/**
	 * 商户活动加载列表的核心方法  - 商户活动列表 js - start 
	 */
	function tenantActivity(arg_start_,arg_limit_,callback) {

		//var temp_url = "http://localhost:8080/data/json_1.json";
		var temp_url = url_ + "mobile/activity/activityList.jhtml";

		var temp_post_csh = {
			limit:arg_limit_,
			start:arg_start_,
			name_:paramsVal
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;
        $.showPreloader();
		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {

			$.hidePreloader();

			if(data.appcode == 1){
				//alert(vue_modual.tenantActivityList.down_bool);
				if(vue_modual.tenantActivityList.list.length > 9 && arg_start_!=0){
					for(var i = 0 ; i < data.data.length ; i ++){
						vue_modual.tenantActivityList.list.push(data.data[i]);
					}
				}else{
					vue_modual.tenantActivityList.list = data.data;

					if(data.data.length < 9){
						vue_modual.tenantActivityList.down_bool = false;
					}else{
						vue_modual.tenantActivityList.down_bool = true;
					}
				}

				vue_modual.tenantActivityList.start = arg_start_;
				vue_modual.tenantActivityList.limit = arg_limit_;

				callback();

              
				
			}
			
		}, function(err) {
			$.hidePreloader();
			$.toast('网络请求失败!');
		});
	}

	//下方加载
	$(document).on('infinite', '', function() {	
		// 如果正在加载，则退出
		if(loading) return;

		// 设置flag
		loading = true;

		//追加
		tenantActivity((vue_modual.tenantActivityList.start+1),vue_modual.tenantActivityList.limit,function(){
			loading = false;
			lastIndex = $('.list-container #div_activity_list').length;
			//容器发生改变,如果是js滚动，需要刷新滚动
			$.refreshScroller();
		});
		
		
	 });
	//下方结束

	//上方加载
	// 添加'refresh'监听器
	$(document).on('refresh', '.pull-to-refresh-content', function(e) {

		// - 商户活动列表
		// tenantActivity(0,10,function(){
		// 	// 加载完毕需要重置
		// 	$.pullToRefreshDone('.pull-to-refresh-content');
		// 	//容器发生改变,如果是js滚动，需要刷新滚动
		// 	$.refreshScroller();
		// });
		
	});
	/**
	 *  商户活动列表 js - end 
	 */



	 /**
	 * 商户加载列表的核心方法  - 商户列表 js - start 
	 */
	function tenantsList(arg_start_,arg_limit_,callback) {

		//var temp_url = "http://localhost:8080/data/json_2.json";
		var temp_url = url_ + "mobile/merchant/merchantList.jhtml";

		var temp_post_csh = {
			limit:arg_limit_,
			start:arg_start_,
			name_:paramsVal
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;
        $.showPreloader();
		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {

			$.hidePreloader();
			if(data.appcode == 1){
				//alert(vue_modual.tenantsList.list.length);
				if(vue_modual.tenantsList.list.length > 9 && arg_start_!=0){
					for(var i = 0 ; i < data.data.length ; i ++){
						vue_modual.tenantsList.list.push(data.data[i]);
					}
				}else{
					vue_modual.tenantsList.list = data.data;

					if(data.data.length <= 9){
						vue_modual.tenantsList.down_bool = true;
					}else{
						vue_modual.tenantsList.down_bool = false;
					}
				}
				// if(data.appcode == -1){
				//    $('.allList.specialt').html('没有相关信息！');
			 //    }	

				vue_modual.tenantsList.start = arg_start_;
				vue_modual.tenantsList.limit = arg_limit_;

				callback();

              
				
			}
			
		}, function(err) {
			$.hidePreloader();
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
     /**
	 * 好友加载列表的核心方法  -  好友列表 js - start 
	 */
	function friendsLists(arg_start_,arg_limit_,callback) {

		//var temp_url = "http://localhost:8080/data/json_3.json";
		var id_ = temp_userinfo.id_;
		var temp_url = url_ + "mobile/friends/friendsList.jhtml";

		var temp_post_csh = {
			limit:arg_limit_,
			start:arg_start_,
			account_id_:id_
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

        $.showPreloader();
		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
            
            $.hidePreloader();
			if(data.appcode == 1){
				//alert(vue_modual.friendsList.list.length);
				if(vue_modual.friendsList.list.length > 9 && arg_start_!=0){
					for(var i = 0 ; i < data.data.length ; i ++){
						vue_modual.friendsList.list.push(data.data[i]);
					}
				}else{
					vue_modual.friendsList.list= data.data;

					if(data.data.length <=9){
						vue_modual.friendsList.down_bool = false;
					}else{
						vue_modual.friendsList.down_bool = true;
					}
					
				}

				vue_modual.friendsList.start = arg_start_;
				vue_modual.friendsList.limit = arg_limit_;

				callback();

              
				
			}	
			
		}, function(err) {
			$.hidePreloader();
			$.toast('网络请求失败!');
		});
	}

	//下方加载
	$(document).on('infinite', '', function() {		
		// 如果正在加载，则退出
		if(loading) return;

		// 设置flag
		loading = true;

		//追加
		friendsLists((vue_modual.friendsList.start+1),vue_modual.friendsList.limit,function(){
			loading = false;
			lastIndex = $('.list-container #div_activity_list').length;
			//容器发生改变,如果是js滚动，需要刷新滚动
			$.refreshScroller();
		});
		
		
	});
	//下方结束

	//上方加载
	// 添加'refresh'监听器
	$(document).on('refresh', '.pull-to-refresh-content', function(e) {

		// -  好友列表
		// friendsLists(0,10,function(){
		// 	// 加载完毕需要重置
		// 	$.pullToRefreshDone('.pull-to-refresh-content');
		// 	//容器发生改变,如果是js滚动，需要刷新滚动
		// 	$.refreshScroller();
		// });
		
	});
	/**
	 *   好友列表 js - end 
	 */

   
   
});
getDeviceName();
