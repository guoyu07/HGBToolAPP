$(document).on("pageInit", "#page-selectMerchant_tpl", function() {
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
		el: '#page-selectMerchant_tpl', //@绑定节点
		data: { //@数据 
			tenantInfo: {
				list: [],
				down_bool: false,
				isShow: false
			}

		},
		methods: { //@方法-事件调用(this指向data)
			onSelect: function() {

				tenants(0, 10, function() {
					list();
				});
			},
			//点击列表跳转页面
			loads: function(dataid) {

				loadDetail(dataid);

			}

		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;

			init();
		}
	});

	function init() {
		temp_userinfo = getsession('userInfo');
	}

	//查询已绑定卡包
	function list() {
		//var temp_url = "http://localhost:8080/data/json_12.json";
		var temp_url = url_ + "mobile/cardPackage/carPackageList.jhtml";
		var temp_post_csh = {
			start: 0,
			limit: 1000,
			id_: temp_userinfo.id_
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			if(data.appcode == 1) {
				isbing(data.data);
			}

		}, function(err) {
			$.toast('网络请求失败!');
		});
	}

	//将搜索出来的商户列表，标注已绑定了的商户
	function isbing(data) {

		for(var i = 0; i < vue_modual.tenantInfo.list.length; i++) {
			vue_modual.tenantInfo.list[i]["bind"] = '';
		}

		//alert(JSON.stringify(vue_modual.tenantInfo));

		for(var i = 0; i < vue_modual.tenantInfo.list.length; i++) {
			for(var j = 0; j < data.length; j++) {
				if(vue_modual.tenantInfo.list[i].id_ == data[j].id_) {
					vue_modual.tenantInfo.list[i].bind = '';
				}
			}
		}

	}

	// -商户列表

	/**
	 * 加载列表详情的核心方法  - 商户列表 js - start 
	 */

	function tenants(arg_start_, arg_limit_, callback) {

		//var temp_url = "http://localhost:8080/data/json_2.json";
		var temp_url = url_ + "mobile/merchant/merchantList.jhtml";
		var paramsVal = $('#result_input').val();

		var temp_post_csh = {
			limit: arg_limit_,
			start: arg_start_,
			name_: paramsVal
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			if(data.appcode == 1) {

				//vue_modual.tenantInfo = false;

				if(vue_modual.tenantInfo.list.length > 9 && arg_start_ != 0) {
					for(var i = 0; i < data.data.length; i++) {
						vue_modual.tenantInfo.list.push(data.data[i]);
					}
				} else {

					vue_modual.tenantInfo.list = data.data;

					if(data.data.length < 9) {
						vue_modual.tenantInfo.down_bool = false;
					} else {
						vue_modual.tenantInfo.down_bool = true;
					}
				}

				vue_modual.tenantInfo.start = arg_start_;
				vue_modual.tenantInfo.limit = arg_limit_;

				callback();

			} else {
				//vue_modual.tenantInfo = true;
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
		tenants((vue_modual.tenantInfo.start + 1), vue_modual.tenantInfo.limit, function() {
			loading = false;
			lastIndex = $(' .div-custom-merchant').length;
			//容器发生改变,如果是js滚动，需要刷新滚动
			$.refreshScroller();
		});

	});
	//下方结束
	/**
	 * 加载列表的核心方法  -商户列表 js - end 
	 */

	/**
	  跳转积分兑换商户列表详情  - start
	**/
	function loadDetail(data) {

		bingtenant(data);

	}

	//选择商户并且绑定商户
	function bingtenant(data) {

		conserve('temp_tenant_info', data);

		$.router.load('../../modules/transferaccounts/merchantInformations_tpl.html', true);

	}

	/**
	  跳转积分兑换商户列表详情  - end
	**/

});
getDeviceName();