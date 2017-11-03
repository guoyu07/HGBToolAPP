$(document).on("pageInit", "#page-messagelist_tpl", function() {
	var temp_userinfo = {};
	//存储一个全局变量
	var vue_modual = {};
	// 加载flag
	var loading = false;
	// 最多可加载的条目
	var maxItems = 100;
	// 每次加载添加多少条目
	var itemsPerLoad = 10;

	var vm = new Vue({
		el: '#page-messagelist_tpl', //@绑定节点
		data: { //@数据 
			messagelist: {
				list: [],
				down_bool: false
			}

		},
		methods: { //@方法-事件调用(this指向data)
			onMessage: function(data) {
				messageInfo(data);
			},
			back: function() {
				$.router.load('../home/home_tpl.html', true);
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

		//
		messageLists(0, 10, function() {

		});

	}

	function messageInfo(data) {

		switch(data.type_) { //商户推送的活动
			case '1':
				//跳转界面
				break;
			case '2':
				//跳转界面
				break;
			case '3':
				//跳转界面
				break;
		}
	}
	/**
	 * 列表 js - start 
	 */
	function messageLists(arg_start_, arg_limit_, callback) {

		//var temp_url = "http://localhost:8080/data/json_1.json";
		var temp_url = url_ + "mobile/activity/activityList.jhtml";

		var temp_post_csh = {
			limit: arg_limit_,
			start: arg_start_,
			id: temp_userinfo.id_
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			if(data.appcode == 1) {
				//alert(vue_modual.tenantActivityList.down_bool);
				if(vue_modual.messagelist.list.length > 9 && arg_start_ != 0) {
					for(var i = 0; i < data.data.length; i++) {
						vue_modual.messagelist.list.push(data.data[i]);
					}
				} else {
					vue_modual.messagelist.list = data.data;

					if(data.data.length < 9) {
						vue_modual.messagelist.down_bool = false;
					} else {
						vue_modual.messagelist.down_bool = true;
					}
				}

				vue_modual.messagelist.start = arg_start_;
				vue_modual.messagelist.limit = arg_limit_;

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
		messageLists((vue_modual.messagelist.start + 1), vue_modual.messagelist.limit, function() {
			loading = false;
			lastIndex = $('.selectMerchantlist').length;
			//容器发生改变,如果是js滚动，需要刷新滚动
			$.refreshScroller();
		});

	});
	//下方结束

})