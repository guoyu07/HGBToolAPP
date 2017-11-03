$(document).on('pageInit', '#page-stranger_tpl', function() {

	$('.span-custom-payment').on('click', function(e) {
		$.router.load('./cashTransferFriend_tpl.html', true);
	});
	$('#goback').on('click', function(e) {
		$.router.load('../../modules/home/home_tpl.html', true);
	});

	var temp_userinfo = {};
	//存储一个全局变量
	var vue_modual = {};
	var vm = new Vue({
		el: '#page-stranger_tpl', //@绑定节点
		data: { //@数据	
			stranger: {
				// isShow:false,
				// isHide:true
			}

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
	function init() {

		temp_userinfo = getsession('userInfo');

		stranger();

	}
	/**
	 * 加载列表详情的核心方法  - 好友详情列表 js - start 
	 */
	function stranger() {

		//var temp_url = "http://localhost:8080/data/json_13.json";
		// var temp_url = url_ + "mobile/friends/friendsDetail.jhtml";
		//       var id = $.router.query('dataid');
		// var temp_post_csh = {
		// 	friends_id_:id
		// };
		// var temp_token = temp_userinfo.token_;
		// var temp_deviceid = temp_userinfo.device_id_;

		// AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {

		// 	if(data.appcode == 1){			
		// 		vue_modual.friendInfo = data.data;

		// 		//调绑定接口，如果绑了，就是查看该商户按钮，否则是绑定按钮
		// 	}	

		// }, function(err) {
		// 	$.toast('网络请求失败!');
		// });
	}
	/**
	 * 加载列表详情的核心方法  - 好友详情列表 js - end 
	 */

});
getDeviceName();