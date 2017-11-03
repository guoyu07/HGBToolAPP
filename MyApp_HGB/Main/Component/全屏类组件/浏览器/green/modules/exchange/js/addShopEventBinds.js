$(document).on("pageInit", "#page-addShop_tpl", function() {
  	var dataid = GetQueryString("dataid"); //获取跳转路径参数de方法；
		// dataid = temp_userinfo.dataid;
	var temp_userinfo = {};
	//存储一个全局变量
	var vue_modual = {};
	var vm = new Vue({
		el: '#page-addShop_tpl', //@绑定节点
		data: { //@数据	
			//商户详情
			tenantInfo: {},
			//原积分余额对象
			originals: {
				original_balance: ''
			},
			rule:{

			},
			numbers_display:0,
			show_exchange:false,
			numbers:0,
			isShow:true
		},
		methods: { //@方法-事件调用(this指向data)
			//点击商户列表跳转我的卡包页面
			loads: function() {
				$.router.load('./myCardBall_tpl.html',true);
			},
			//点击兑换按钮
			sure: function() {
 
				exchange();
			},
			on_blur:function(){
				Calculation();
			},
			add:function(){
				
				addMenant();
			},
			allExchange:function(){

				 vue_modual.numbers = vue_modual.originals.original_balance_;

				 Calculation();
			},
			onfocus:function(){
				vue_modual.numbers='';
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
        //查询是否绑定过商户
        var items = getsession('temp_tenant_info');
       if(items!=null && items!='' && items.length > 0){
               vue_modual.tenantInfo =items[0];
               if(vue_modual.tenantInfo){
                   getTenant_rule();
                   // -原积分余额查询
                   original();
                   vue_modual.isShow = true;
                   }else{
                   vue_modual.isShow = false;
               }
       }
        
	}

	function Calculation(){

		if(vue_modual.numbers!='' || vue_modual.numbers == 0){
			var ratio = changeTwoDecimal(vue_modual.rule.green_points_ / vue_modual.rule.original_points_);
			vue_modual.numbers_display = changeTwoDecimal(vue_modual.numbers * ratio);
		}
	}

	function exchange(){
		
		if(vue_modual.numbers!='' && vue_modual.numbers > 0 ){
			$.show
			pointExchange();
		}else{
			$.toast('请输入积分!');
		}
	}

	//积分兑换接口
	function pointExchange(){
        
		var temp_url = url_ + "mobile/trade/pointExchange.jhtml";
		
		var temp_post_csh = {
			merchant_id_:vue_modual.tenantInfo.id_,
			member_id_:temp_userinfo.id_,
			green_point_amount_:vue_modual.numbers_display,
			original_point_amount_:vue_modual.numbers

		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
			
			if(data.appcode == 1) {
               
			   $.toast('兑换成功！');	
			}

		}, function(err) {
			$.toast('网络请求失败!');
		});
	}


	function addMenant(){
		$.router.load('./selectMerchant_tpl.html', true);
	}

	//查询某个商户的兑换规则
	function getTenant_rule(){

		//var temp_url = "http://localhost:8080/data/json_18.json";
		var temp_url = url_ + "mobile/merchant/merchantPointExchangeRule.jhtml";//获取卡包列表接口
		var id = vue_modual.tenantInfo.id_;
		var temp_post_csh = {
			merchant_id_:id
		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
			
			if(data.appcode == 1) {

				vue_modual.rule = data.data;

				vue_modual.show_exchange = true;
                

			}else{

			}

		}, function(err) {
			$.toast('网络请求失败!');
		});

	}

	/**
	 *      //获取卡包列表接口的数据放入商户列表  start
	 */
	function tenantInformation() {

		//var temp_url = "http://localhost:8080/data/json_18.json";
		var temp_url = url_ + "mobile/cardPackage/carPackageList.jhtml";//获取卡包列表接口
		var id = temp_userinfo.id_;
		var temp_post_csh = {
			limit: 1000,
			start: 0,
			id_: id
		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
			
			if(data.appcode == 1) {

				vue_modual.tenantInfo = data.data[0];
				getTenant_rule();
				
			}else{

			}

		}, function(err) {
			$.toast('网络请求失败!');
		});
	}

	/**
	 *   //获取卡包列表接口的数据放入商户列表 - end 
	 */

	/**
	 *      查询原积分余额接口  start
	 */
	function original() {
      
		//var temp_url = "http://localhost:8080/data/json_20.json";
		var temp_url = url_ + "mobile/member/memberPointBalanceForMerchant.jhtml";
		var temp_post_csh = {

			merchant_id_: vue_modual.tenantInfo.id_,
			phone_:temp_userinfo.phone_
		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
 
			
			if(data.appcode == 1) {
				vue_modual.originals = data.data;
				if(vue_modual.originals.original_balance_ == 0){

                    vue_modual.show_exchange = false;  

				}else{

					vue_modual.show_exchange = true;
                
				}

			}

		}, function(err) {
			$.toast('网络请求失败!');
		});
	}

	/**
	 *   查询原积分余额接口 - end 
	 */

	$("#div_custom-resetShop").on("click", function(e) {
		$.router.load('./myCardBall_tpl.html?id=1&name=2', false, {
			"key": "value"
		});
	});
	$('.cnt-minus').on('click', function() {
		var cnt = $('.cnt-num input').val();
		if(!cnt) return;
		cnt < 1 ? $('.cnt-num input').val(0) : $('.cnt-num input').val(--cnt);
   });

	$('.cnt-add').on('click', function() {
		var cnt = $('.cnt-num input').val();
		if(!cnt) return;
		$('.cnt-num input').val(++cnt);
     });
});
getDeviceName();
