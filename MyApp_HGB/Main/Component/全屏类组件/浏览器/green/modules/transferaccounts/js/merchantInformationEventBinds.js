$(document).on("pageInit", "#page-merchantInformation_tpl", function() {
	var temp_userinfo = {};
	//存储一个全局变量
	var vue_modual = {};
	var vm = new Vue({
		el: '#page-merchantInformation_tpl', //@绑定节点
		data: { //@数据	
			shopsDetailInfo: {
				// isShow:false,
				// isHide:true
			}

		},
		methods: { //@方法-事件调用(this指向data)
			//点击查看该商户活动跳转    
			find: function() {
				$.router.load('../../modules/cardprotector/cardBall_tpl.html', true);
			},
			//绑定跳转    
			bound: function() {
				$.router.load('../../modules/cardprotector/cardBall_tpl.html', true);
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

		// -商户详情列表
		shopsDetail();

	}
	/**
	 * 加载列表详情的核心方法  - 商户详情列表 js - start 
	 */
	function shopsDetail() {
        $.showPreloader('正在查询...');
		//var temp_url = "http://localhost:8080/data/json_12.json";
		var temp_url = url_ + "mobile/merchant/merchantDetail.jhtml";
		var id = $.router.query('dataid');
		var temp_post_csh = {
			id_: id
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
            $.hidePreloader();
			if(data.appcode == 1) {
				vue_modual.shopsDetailInfo = data.data;

				//调绑定接口，如果绑了，就是查看该商户按钮，否则是绑定按钮
			}

		}, function(err) {
			$.hidePreloader();
			$.toast('网络请求失败!');
		});
	}
	/**
	 * 加载列表详情的核心方法  - 商户详情列表 js - end 
	 */
});
getDeviceName();