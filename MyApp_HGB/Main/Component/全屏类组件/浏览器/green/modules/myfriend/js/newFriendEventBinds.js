$(document).on("pageInit", "#page-newFriend_tpl", function() {
	// $('.div-custom-rightcont.special .span-custom-bd_normal').on('click', function(e) {
	// 	$.router.load('./verification_tpl.html?id=1&name=2', false, {
	// 		"key": "value"
	// 	});
	// });
	var temp_userinfo = {};
	//存储一个全局变量
	var vue_modual = {};
	var vm = new Vue({
		el: '#page-newFriend_tpl', //@绑定节点
		data: { //@数据	
			//新的朋友列表
			newFriendList: {
				list:[],
				down_bool: false
			}
		},
		methods: { //@方法-事件调用(this指向data)

			//点击接受按钮 
			rect: function(dataid) {

				agreeFriends(dataid);
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

		temp_userinfo = getsession('userInfo');

		//新的朋友列表
		newFriends(0, 10, function() {

		});

	}
	/**
	 *  新的朋友列表 js - start 
	 */
	function newFriends(arg_start_, arg_limit_, callback) {

		//var temp_url = "http://localhost:8080/data/json_10.json";
		var temp_url = url_ + "mobile/friends/friendsList.jhtml"; //掉的也是好友列表

		var id = temp_userinfo.id_;
		var temp_post_csh = {
            start:0,
            limit:1000,
			account_id_: id,
			status_: 0 //申请中

		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
                                              //alert(JSON.stringify(data));
			if(data.appcode == 1) {

				if(vue_modual.newFriendList.list.length > 9 && arg_start_ != 0) {
					for(var i = 0; i < data.data.length; i++) {
						vue_modual.newFriendList.list.push(data.data[i]);
					}
				} else {
					vue_modual.newFriendList.list = data.data;

					if(data.data.length <= 9) {
						vue_modual.newFriendList.down_bool = true;
					} else {
						vue_modual.newFriendList.down_bool = false;
					}
				}

				vue_modual.newFriendList.start = arg_start_;
				vue_modual.newFriendList.limit = arg_limit_;

				callback();

			}

		}, function(err) {
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
		newFriends((vue_modual.newFriends.start + 1), vue_modual.newFriends.limit, function() {
			loading = false;
			lastIndex = $('.div-custom-collectioncont').length;
			//容器发生改变,如果是js滚动，需要刷新滚动
			$.refreshScroller();
		});

	});
	//下方结束

	//上方加载
	// 添加'refresh'监听器
	$(document).on('refresh', '.pull-to-refresh-content', function(e) {

		//首页 - 商户活动列表
		// activityList(0,10,function(){
		// 	// 加载完毕需要重置
		// 	$.pullToRefreshDone('.pull-to-refresh-content');
		// 	//容器发生改变,如果是js滚动，需要刷新滚动
		// 	$.refreshScroller();
		// });

	});

	/**
	 *  新的朋友列表 js - end 
	 */

	/**
	 *  接受朋友添加 js - end 
	 */

	function agreeFriends(dataid) {
         
        $.router.load('./verification_tpl.html?dataid=' + dataid, true);
        /**
		//var temp_url = "http://localhost:8080/data/json_22.json";
		var temp_url = url_ + "mobile/friends/friendsAgreeApply.jhtml"; //掉的同意好友添加列表

		var id = temp_userinfo.id_;
		var temp_post_csh = {

			friends_id_: id, //会员id
			member_id_: dataid //好友id

		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			if(data.appcode == 1) {

				$.router.load('./verification_tpl.html?dataid=' + dataid, true);
			}

		}, function(err) {
			$.toast('网络请求失败!');
		});
         **/
	}

});
getDeviceName();
