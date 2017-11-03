$(document).on("pageInit", "#page-verification_tpl", function() {
	//点击保存按钮判断跳转newFriend_tpl.html朋友页面/friendInformation_tpl好友资料页面    如果在好友资料页面可再次修改备注点击备注页面的保存按钮跳转。。。。
	var vue_modual = {};
	var temp_userinfo = {};

	var vm = new Vue({
		el: '#page-verification_tpl', //@绑定节点
		data: { //@数据

		},
		methods: { //@方法-事件
			saveuser: function() {
				save();
			}
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			init();
		}
	});

	function init() {

		temp_userinfo = getsession("userInfo");

	}

	function save() {

		$.showPreloader('正在处理...');
		var post_adress = url_ + "mobile/friends/friendsAgreeApply.jhtml";
		var dataid = $.router.query('dataid'); //获取跳转路径参数dataid
		var id = temp_userinfo.id_;
		var data = {
			member_id_: dataid,
			friends_id_: id
		};

		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(post_adress, data, temp_token, temp_deviceid, function(msg) {

			$.hidePreloader();

			if(msg.appcode == 1) {
				$.toast('好友添加成功!');
				$.router.load('../../modules/home/home_tpl.html', true);

			}
		}, function(err) {
			$.toast('网请求失败！');
		});

	}

})