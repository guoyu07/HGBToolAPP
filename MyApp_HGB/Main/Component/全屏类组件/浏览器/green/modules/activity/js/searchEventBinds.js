$(document).on("pageInit", "#page-search_tpl", function() {
   
	var temp_userinfo = {};
	//存储一个全局变量
	var vue_modual = {};
               
	var vm = new Vue({
		el: '#page-search_tpl', //@绑定节点
		data: { //@数据	
			hotActivityList: [],
			search: ''

			// hotActivityList:{
			//   list:[],
			//   down_bool:false
			// }

		},
		methods: { //@方法-事件调用(this指向data)

			//点击大家热搜索数据放入文本框里点击搜索跳转页面
			onHotActivity: function(data) {

				vue_modual.search = data.name_;

			},
			//点击搜索按钮跳转页面
			onInput: function() {
				conserve('name', vue_modual.search);
				$.router.load('../../modules/home/home_tpl.html', true);
           }

		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			//初始化
			init();

       }
    });

               
 

	//界面初始化
	function init() {
        
        // paramsVal = getsession('paramsVal');

        // paramsVal = vue_modual.search;

		temp_userinfo = getsession('userInfo');
        
       
		//热活动列表
		hotActivity();
		// //热活动列表
		// hotActivity();        
              
	}
	/**
	 * 热活动加载列表的核心方法  - 热活动列表 js - start 
	 */
	function hotActivity() {

		//var temp_url = "http://localhost:8080/data/json_6.json";
		var temp_url = url_ + "mobile/hotWords/hotWordsList.jhtml";
		var temp_post_csh = {
			limit: 20,
			start: 0
			//,
			//name_: vue_modual.search

		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			if(data.appcode == 1) {

				vue_modual.hotActivityList = data.data;

			}

			//callback();

		}, function(err) {
			$.toast('网络请求失败!');
		});
	}

});

