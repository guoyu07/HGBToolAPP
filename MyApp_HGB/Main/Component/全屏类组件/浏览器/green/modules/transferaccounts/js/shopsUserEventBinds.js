$(document).on("pageInit", "#page-shopsUser_tpl", function() {
  
	var vue_modual = {};

	var temp_userinfo = {};

	var temp_payInfo = {};
               
    var temp_cash = getsession("cash_balance");

	var vm = new Vue({
		el: '#page-shopsUser_tpl', //@绑定节点
		data: { //@数据
			obj:{
				integral:0,            //界面录入的积分数
				integral_display:0,    //界面显示 可用的总积分数 - 由接口返回
				integral_bool:false,   //如果总积分为0那么 将为true 隐藏录入框
				amount_display:0,      //显示的抵用的现金
				amount_bool:true,     //如果 抵用的现金为0那么隐藏
				amount_still_display:0,  //仍需支付的现金 - 计算所得
				amount_still_bool:true, //仍需支付的 显示或隐藏 - 当仍需支付的现金为0那么为true
				rule_:1,			    //积分抵现规则 默认 1 比 1 
				amount:0				//从上个界面缓存中取得
			},
			integral_text_last:'您目前积分为:',
			integral_text_fast:'',
            isShow:false,
            name_:"",
            code_:"",
            image_:"",
            go_cashaccount_page_text:"",
            go_cashaccount_page_msg:""
		},
		methods: { //@法-事件调用(this指向data)

			//输入
			onIntegralFocus:function(){
				if(this.obj.integral == 0){
					this.obj.integral = '';
				}
			},

			onIntegralChange:function(){
				//alert(this.obj.integral+">"+this.obj.integral_display+(this.obj.integral > this.obj.integral_display));
				this.obj.integral = changeTwoDecimal(this.obj.integral);

				if(changeTwoDecimal(this.obj.integral) > changeTwoDecimal(this.obj.integral_display)){
					$.alert('输入的积分数大于最高积分');
					//this.obj.integral = this.obj.integral_display;
					calculation();
					return;
				}

				if(changeTwoDecimal(this.obj.integral) <= changeTwoDecimal(this.obj.integral_display)){
                     //alert(1);
					calculation();
				}
			},

			onContinuePay:function(){
				if(this.obj.integral == ''){
					this.obj.integral = 0;
				}
                //alert(changeTwoDecimal(this.obj.integral) + "==" + changeTwoDecimal(this.obj.integral_display));
				if(changeTwoDecimal(this.obj.integral) > changeTwoDecimal(this.obj.integral_display)){
					$.alert('输入的积分数大于最高积分');
					//this.obj.integral = this.obj.integral_display;
					calculation();
					return;
				}
                //发起支付
				shopspay();

            },
             go_cashaccount_page:function(){
                     
                     $.router.load('../../modules/cashaccount/cashAlreadyBound_tpl.html', true);
             }

		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			
			//初始化
			init();
		}
	});

	/**
	 * 界面初始化
	 */
	function init(){
         $.showPreloader('正在查询...');
         temp_userinfo = getsession('userInfo');
        
		//从上个界面携带过来的 payInfo 对象
		temp_payInfo = getsession('payInfo');
		if(temp_payInfo!=null && ""!=temp_payInfo){
			vue_modual.obj.amount = temp_payInfo.amount;
			vue_modual.obj.amount_still_display  = temp_payInfo.amount;
               //商户详情
               get_teant_info(function(){
                        //获取积分规则
                    get_rule(function(data){
                        //给规则字段赋值
                        //arg_modual.obj.rule = data.data;
                        //获取当前我的积分总数
                        get_myinteral(function(data){
                                  
                                  if(temp_cash==null || temp_cash == '' || temp_cash == undefined){
                                      temp_cash = "暂未绑卡";
                                  }
                                  if(temp_cash == "0" || temp_cash == '0.00' || temp_cash==0){
                                  vue_modual.go_cashaccount_page_text = "您的现金账户余额不足";
                                  vue_modual.go_cashaccount_page_msg = "去充值";
                                  }else if(temp_cash=='暂未绑卡'){
                                      
                                      vue_modual.go_cashaccount_page_text = "您还未开通现金账户";
                                      vue_modual.go_cashaccount_page_msg = "绑定银行卡";
                                      
                                      
                                  }else{
                                  
                                       vue_modual.go_cashaccount_page_text = "";
                                       vue_modual.go_cashaccount_page_msg = "";
                                       vue_modual.isShow = true;
                                       vue_modual.obj.amount_still_bool = true;
                                  }
                                      
                                       $.hidePreloader();
                        });

                    });
              });
		}else{
               $.alert("错误参数");
               $.hidePreloader();
		}
	}

	/**
	 * 控制界面逻辑层
	 * 处理 积分如果大于 0  或 等于 0 需要做的处理
	 */
	function view_modual(data){
		vue_modual.obj.integral_display = data.data.chainsql_balance_;
		var temp_integral = data.data.chainsql_balance_;
		if(temp_integral > 0){
			vue_modual.integral_text_last = "您目前最高可使用";
			vue_modual.integral_text_fast = "积分";
			vue_modual.obj.integral_bool = true;
		}else{
			vue_modual.integral_text_last = "您目前积分为:";
			vue_modual.integral_text_fast = "";
			vue_modual.obj.integral_bool = false;
			vue_modual.obj.amount_bool = false;
			vue_modual.obj.amount_still_bool = false;
		}
	}

	/**
	 * 获取积分规则
	 */
	function get_rule(successcallback){

     var temp_url = url_ + "mobile/merchant/merchantPointExchangeRule.jhtml";//获取卡包列表接口
     var id = temp_payInfo.uid;
     var temp_post_csh = {
           merchant_id_:id
     };
    
    var temp_token = temp_userinfo.token_;
    var temp_deviceid = temp_userinfo.device_id_;

     AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
          
         if(data.appcode == 1) {
           vue_modual.obj.rule = data.data;
         
         }else{
            
         }
         successcallback();
         
     }, function(err) {
         $.toast('网络请求失败!');
         successcallback();
     });

	}
               
               
   function get_teant_info(successcallback){
       var temp_url = url_ + "mobile/merchant/merchantDetail.jhtml";//获取卡包列表接口
       var id = temp_payInfo.uid;
       var temp_post_csh = {
               id_:id
       };
       
       var temp_token = temp_userinfo.token_;
       var temp_deviceid = temp_userinfo.device_id_;
       
       AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
                                             
         if(data.appcode == 1) {
                 vue_modual.name_ = data.data.name_;
                 vue_modual.image_ =data.data.image_;
                 vue_modual.code_ = data.data.code_;

         }else{
              
         }
         successcallback();
     }, function(err) {
       $.toast('网络请求失败!');
       successcallback();
     });

   }

	/**
	 * 获取我当前的积分数
	 */
	function get_myinteral(successcallback){
               
       var temp_url = url_ + "mobile/member/memberPointBalanceForChainsal.jhtml";
       var temp_post_csh = {
       
               phone_:temp_userinfo.phone_
       };
       var temp_token = temp_userinfo.token_;
       var temp_deviceid = temp_userinfo.device_id_;
       
       AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
                                             
         if(data.appcode == 1){
             //逻辑处理
             view_modual(data);
         }
         successcallback();
         }, function(err) {
         $.toast('网络请求失败!');
         successcallback();
     });
        
	}
     
   //计算比率
   function comm_ratio(){
       return changeTwoDecimal(vue_modual.obj.rule.green_points_ / vue_modual.obj.rule.original_points_)
   }
               
    //计算积分算钱
    function comm_int_cash(arg_cash){
          return changeTwoDecimal(arg_cash * comm_ratio());
     }
               
    //计算钱算积分
    function comm_cash_int(arg_cash){
        return changeTwoDecimal(arg_cash / comm_ratio());
    }
   function return_mix_int(arg_int,arg_top_int){
       return (changeTwoDecimal(arg_int)-changeTwoDecimal(arg_top_int))>0?changeTwoDecimal(arg_top_int):changeTwoDecimal(arg_int);
   }

	/**
	 * 计算积分换算方法
	 */
	function calculation(){
       //订单总金额
       var temp_order_amount_ = vue_modual.obj.amount;
               
       var temp_amount_ = comm_int_cash(vue_modual.obj.integral);
        //仍需的钱
        var temp_amount_still_ = changeTwoDecimal(temp_order_amount_ - temp_amount_);
		//
		if(temp_amount_still_ < 0){
               //alert(comm_cash_int(temp_order_amount_));
               //alert(vue_modual.obj.integral_display);
               //alert(return_mix_int(comm_cash_int(temp_order_amount_),vue_modual.obj.integral_display));
            vue_modual.obj.integral = return_mix_int(comm_cash_int(temp_order_amount_),vue_modual.obj.integral_display);
            vue_modual.isShow = false;
            //重新计算
            calculation();
			return;
		}else if(temp_amount_still_ == 0){
			//隐藏仍需提示
			vue_modual.obj.amount_still_bool = false;
			vue_modual.obj.amount_display = temp_amount_;
            vue_modual.obj.amount_still_display =temp_amount_still_;
            vue_modual.isShow = true;
           
		}else {
			vue_modual.obj.amount_still_bool = true;
			vue_modual.obj.amount_display = temp_amount_;
			vue_modual.obj.amount_still_display = temp_amount_still_ ;
           if(temp_cash > 0 && temp_cash>=temp_amount_still_){
               vue_modual.isShow = true;
           }else{
               vue_modual.isShow = false;
           }
		}
		/**
		integral:0,            //界面录入的积分数
		integral_display:0,    //界面显示 可用的总积分数 - 由接口返回
		integral_bool:false,   //如果总积分为0那么 将为true 隐藏录入框
		amount_display:0,      //显示的抵用的现金
		amount_bool:true,     //如果 抵用的现金为0那么隐藏
		amount_still_display:0,  //仍需支付的现金 - 计算所得
		amount_still_bool:true, //仍需支付的 显示或隐藏 - 当仍需支付的现金为0那么为true
		rule_:1,			    //积分抵现规则 默认 1 比 1 
		amount:0				//从上个界面缓存中取得
		**/
       
       
	}


	/**
	 * 发起支付
	 */
	function shopspay(){
        
        var bool = false;
        //设置了免密支付
        var setUp_info  = getsession('setUp');
        if(setUp_info!=null && setUp_info!='' && setUp_info!=undefined){
           bool = setUp_info.isChecked;
        }
               
        //开启了免密码支付
        if(bool){
               pay();
        }else{
        //需要检验支付密码
        AgreeSDK.KeybordPlugin.onKeyboard('1', '1234567891234567', function(msg) {
              var paypwd = getsession("settingPayPwd");
              //比较密码与设置的支付密码
              if(paypwd == msg){
                  pay();
              }else{
                  $.toast("支付密码错误！");
              }
        }, function(error) {
               $.toast("插件错误");
        });
        }
	}
               
   function pay(){
        $.showPreloader('支付中...');
        //支付的对象
        var pay = {
               p_amount_:vue_modual.obj.integral,          //积分金额 界面录入
               r_amount_:vue_modual.obj.amount_still_display,    //现金 最总计算所得
               destination:temp_payInfo.merchant_addr_,         //转账目标账户id - 推送过来的值
               service_key_:temp_payInfo.service_key_,            //
               temp_trade_no_:temp_payInfo.temp_trade_no_,        //临时交易号 -  推送过来的值
               order_total_:temp_payInfo.amount,            //订单总金额 - 推送过来的值
               r_type_:'0'    //类型 界面选择
        };
               
        //alert(JSON.stringify(pay));
        //$.hidePreloader();
        //return;
        if(temp_userinfo!=null){

        //支付需要的大对象
        var pay_json = {
           userinfo : temp_userinfo,
           pay:pay
        };

        SDKPay(pay_json,function(data){
      
               $.hidePreloader();
                if(data.appcode == 1){
                    $.toast('支付成功');
                    $.router.load('../../modules/home/home_tpl.html',true);
                }else if(data.appcode == 123){
                //假定现金不足了
                //跳转到体现界面
                    $.router.load('../cashaccount/recharge_tpl.html',true);
                }else{
                   $.toast(data.appmsg);
                }
        },function(data){
        //支付失败了
               $.alert(data.appmsg);
               $.hidePreloader();
        });

        }else{
        //当用户不存在了
               $.alert("错误参数");
        }
   }
	
});
