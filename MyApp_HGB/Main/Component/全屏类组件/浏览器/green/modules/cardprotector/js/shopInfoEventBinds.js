$(document).on("pageInit", "#page-shopInfo_tpl", function() {

    var vm = new Vue({
		el: '#page-shopInfo_tpl', //@绑定节点
		data: { //@数据
			shopName: {},
			phone: '',
			cardNo: '', //卡号
			account: '', //账号
			shopId: GetQueryString('shopId') //商户id
		},
		methods: { //@方法-事件调用
			getShopInfo: function(){
				var _this = this;
				var temp_device = getsession("device_id_");
				var post_adress = url_ + "mobile/merchant/merchantDetail.jhtml";
				var data = {
					id_: _this.shopId
				};

			    AgreeSDK.Connection.getNetWorkRequest(post_adress, data, '', temp_device, function(msg) {
					if(msg.appcode == 1) {
						var data = msg.data;

						_this.shopName = data;
					}
				}, function(err) {
					$.toast('网络请求失败!');
				});
			},
			bindCard: function(){
				var _this = this;
				var temp_device = getsession("device_id_");
				var post_adress = url_ + "mobile/cardPackage/carPackageBinding.jhtml";
				var data = {
					user_id_: this.shopId,
					member_card_no_: this.cardNo,
					member_account_: this.account,
					member_id_: getsession("userInfo").id_,
					reserve_phone_: this.phone
				};

				console.log(data);

				if(this.cardNo!='' && this.account!='' && this.phone!=''){
					AgreeSDK.Connection.getNetWorkRequest(post_adress, data, '', temp_device, function(msg) {
						if(msg.appcode == 1) {
							$.toast(msg.appmsg);
							$.router.load('./cardBall_tpl.html');
						}else{
							$.toast(msg.appmsg);
						}
					}, function(err) {
						$.toast('网络请求失败!');
					});
				}else{
					$.toast('您有未填的信息！');
				}

			    
			}
		},
		created: function() {
			this.getShopInfo();
		}
	});

});