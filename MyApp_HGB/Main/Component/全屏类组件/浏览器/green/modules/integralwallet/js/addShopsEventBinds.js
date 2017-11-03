$(document).on("pageInit", "#page-addShops_tpl", function() {
    var type = GetQueryString("type");
	var temp_userinfo = {};
	//存储一个全局变量
	var vue_modual = {};
	var vm = new Vue({
		el: '#page-addShops_tpl', //@绑定节点
		data: { //@数据	
			//商户详情
			tenantInfo: {},
			//原积分余额对象
			originals: {
				original_balance: ''
			},
			rule:{

			},
			chainsqlBalance_:0,
			numbers_display:0,
			show_exchange:false,
			numbers:0,
			isShow:true,
            type:0
		},
		methods: { //@方法-事件调用(this指向data)
			//点击商户列表跳转我的卡包页面
			loads: function() {
				$.router.load('./myCardBall_tpl.html');
			},
			//点击兑换按钮
			sure: function() {

				exchange();
			},
			on_blur:function(){
				Calculation();
			},
			none:function(){
				$.toast('你在该商户下的积分为0，无法进行绿色积分兑换！');
			},
			add:function(){
				
				addMenant();
			},
			allExchange:function(){
                if(parseInt(vue_modual.originals.original_balance_) >= parseInt(vue_modual.rule.upperlimit_)){
                    vue_modual.numbers = vue_modual.rule.upperlimit_;
                 }else{
                     vue_modual.numbers = vue_modual.originals.original_balance_;
                 }

				 Calculation();
			},
			choice:function(){
				$.router.load('./myCardBall_tpl.html?type=1',true);
			},
			add:function(){
				
				addMenant();
			},
            on_input:function(){
             if(parseInt(vue_modual.numbers) >= parseInt(vue_modual.rule.upperlimit_)){
                     vue_modual.numbers = vue_modual.rule.upperlimit_;
             }
             Calculation();
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
       $.showPreloader('正在加载...');
       temp_userinfo = getsession('userInfo');
               if(type!=null && type!='' && type!= undefined){
               vue_modual.type = type;
               }
       //查询是否绑定过商户
       var items = getsession('temp_tenant_info');
               
               if(items!=null && items!='' && items.length > 0 ){
               vue_modual.tenantInfo =items[0];
                   if(vue_modual.tenantInfo){
                   //我的绿色积分
                   mygreen(function(){
                           //查某商户兑换规则
                           getTenant_rule(function(){
                                          //原来积分接口
                                          original(function(){
                                                   vue_modual.isShow = true;
                                                    $.hidePreloader();
                                                   });
                                          });
                           });
               
               
               
                   }else{
                       vue_modual.isShow = false;
                       mygreen(function(){
                        $.hidePreloader();
                       });
                   }
               }else{
               
                 vue_modual.isShow = false;
                 mygreen(function(){
                        $.hidePreloader();
                 });
               }
 
	}

    function addMenant(){
          
          $.router.load('../cardprotector/searchShops_tpl.html', true);
		//$.router.load('./selectMerchants_tpl.html', true);
	}

	function exchange(){
		
		if(vue_modual.numbers!='' && vue_modual.numbers > 0 ){

			$.showPreloader('兑换中...');
				
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
               //alert(JSON.stringify(temp_post_csh));
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
		
			
			$.hidePreloader();

			if(data.appcode == 1) {
               
			   $.toast('兑换成功！');
			   init();
			}else{
				$.toast('兑换失败！');	
				
			}

		}, function(err) {
            $.hidePreloader();
			$.toast('网络请求失败!');
		});
	}

    //计算
    function Calculation(){
               
    	if(vue_modual.tenantInfo !='' && vue_modual.rule != ''){
    		if(vue_modual.numbers!=''){
				var ratio = changeTwoDecimal(vue_modual.rule.green_points_ / vue_modual.rule.original_points_);
				vue_modual.numbers_display = changeTwoDecimal(vue_modual.numbers * ratio);
               }else{
               
                   var ratio = changeTwoDecimal(vue_modual.rule.green_points_ / vue_modual.rule.original_points_);
                   vue_modual.numbers_display = changeTwoDecimal(vue_modual.numbers * ratio);
                   //vue_modual.numbers = 0;
               }
    	}
	}

	function mygreen(callback){

		var temp_url = url_ + "mobile/member/memberPointBalanceForChainsal.jhtml";
	    var temp_post_csh = {

	         phone_:temp_userinfo.phone_
	    };
	    var temp_token = temp_userinfo.token_;
	    var temp_deviceid = temp_userinfo.device_id_;

	    AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
	      
	      if(data.appcode == 1){      
	          vue_modual.chainsqlBalance_ = data.data.chainsql_balance_;

	      }
	      if(vue_modual.chainsqlBalance_ == 0){

                    vue_modual.show_exchange = false;  

		   }else{

					vue_modual.show_exchange = true;
                
		  }
                                              callback();
	    }, function(err) {
	      $.toast('网络请求失败!');
                                              callback();
	    });
	}


	//查询某个商户的兑换规则
	function getTenant_rule(callback){

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
                                              callback();
		}, function(err) {
			$.toast('网络请求失败!');
                                              callback();
		});

	}


	/**
	 *      查询原积分余额接口  start
	 */
	function original(callback) {
      
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
                                              callback();
		}, function(err) {
			$.toast('网络请求失败!');
                                              callback();
		});
	}

	/**
	 *   查询原积分余额接口 - end 
	 */
   
       $('.cnt-minus').on('click', function() {
          var cnt = $('.cnt-num input').val();
          if(!cnt) return;
          cnt < 1 ? $('.cnt-num input').val(0) : $('.cnt-num input').val(--cnt);
          vue_modual.numbers = $('.cnt-num input').val();
          Calculation();
      });
       
       $('.cnt-add').on('click', function() {
            var cnt = $('.cnt-num input').val();
                        
            if(parseInt(cnt) >= parseInt(vue_modual.rule.upperlimit_)){
               return
            }
            if(!cnt) return;
            $('.cnt-num input').val(++cnt);
            vue_modual.numbers = $('.cnt-num input').val();
            Calculation();
        });

});
getDeviceName();
