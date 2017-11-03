$(document).on("pageInit", "#page-cashTransferFriend_tpl", function() {
    var  arg_integral = GetQueryString("integral");
    var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
    //现金充值返回的数据
    var cashRecharge_info = {};

	var vm = new Vue({
		el: '#page-cashTransferFriend_tpl', //@绑定节点
		data: { //@数据	
            point:0,
            isintegral:false
		},
		methods: { //@方法-事件调用(this指向data)
			onsubmit:function(data){
				submit();
			},
			recordsList:function(){
				$.router.load('./recordShops_tpl.html', true);
			},
			returns:function(){

                 $.router.load('../../modules/home/home_tpl.html',true);
      
			}
		},
		created: function() { //@业务逻辑（this指向data）
		    vue_modual = this;
		    //初始化
			init();
		    
		}
	});

	function init(){
        temp_userinfo = getsession('userInfo');
		var friend_Infos = getsession('friend_Infos');
        //alert(JSON.stringify(friend_Infos));
    	vue_modual.friend_Infos = friend_Infos;
        if(arg_integral!=null){
           //扫一扫 - 用户收积分二维码
           if(arg_integral == 0){
               vue_modual.isintegral = false;
           }else{
               vue_modual.isintegral = true;
               vue_modual.input_point = arg_integral;
           }

        }
    	findMypoint();
		
	}
    function findMypoint(){
        var temp_url = url_ + "mobile/member/memberPointBalanceForChainsal.jhtml";
       
	    var temp_post_csh = {
            phone_:temp_userinfo.phone_
	    };
	    var temp_token = temp_userinfo.token_;
	    var temp_deviceid = temp_userinfo.device_id_;

	    AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
	      
	      if(data.appcode == 1){
             vue_modual.point = data.data.chainsql_balance_;
	      }
	      
	    }, function(err) {
	      $.toast('网络请求失败!');
	    });
    }

    //转账积分
    function submit(){
      
       if(vue_modual.point == '' || vue_modual.point == 0 || (vue_modual.input_point > vue_modual.point) ){
            $.toast("转账积分不允许超过剩余积分!");
            return;
        }
      
       if(vue_modual.input_point== undefined || vue_modual.input_point == 0 || vue_modual.input_point == ''){
            $.toast("请填写合法的积分数量!");
            return;
       }
               
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
                //比较密码与设置的支付
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
               
   //支付入口
   function pay(){
        $.showPreloader('正在处理...');

        var temp_obj = {
               pay:{
                   p_amount_:vue_modual.input_point,
                   destination:vue_modual.friend_Infos.block_chain_addr_
               },
                   pay_point:{
                   pay_phone_:temp_userinfo.phone_,
                   get_phone_:vue_modual.friend_Infos.phone_
               },
               userinfo:temp_userinfo
        };

        SDKPay_Point(temp_obj,function(data){
                     $.hidePreloader();
                     $.toast('支付成功');
                     $.router.load('../../modules/home/home_tpl.html',true);
                     },function(data){
        //$.router.load('./friendDetail_tpl.html?id=1', true);
        //
        //
        //alert("::"+JSON.stringify(data));
                     var errmsg = '';
                     try{
                        if(data.appmsg != undefined){
                            errmsg = data.appmsg;
                        }else{
                            errmsg = data;
                        }
                     }catch(ex){
                         errmsg = data;
                     }

                     $.hidePreloader();
                     $.toast("转账失败-"+errmsg);
        });
   }



    /**
	$('.top_header').on('click', function(e) {
		$.router.load('./friendInformation_tpl.html?id=1&name=2', false, {
			"key": "value"
		});
	});
	//转账记录一个页面  ：商户和朋友
	$('#friend_records').on('click', function(e) {
		$.router.load('./recordShops_tpl.html?id=1&name=2', false, {
			"key": "value"
		});
	});
	//点击确认转账调键盘插件
	$('#cashpay').on('click', function(e) {
		var money_ = $('#money').val();
		var keyboardIsrandom = "1";
		AgreeSDK.Keyboard.open(keyboardIsrandom, function(msg) {
			alert(msg);
		}, function(err) {
			alert(err);
		});
	});
	$('#intergalPay').on('click', function(e) {
		var money_intergral = $('#money_intergral').val();
		var keyboardIsrandom = "1";
		AgreeSDK.Keyboard.open(keyboardIsrandom, function(msg) {
			alert(msg);
		}, function(err) {
			alert(err);
		});
	});
	//点击现金转账确认转账按钮跳转朋友或者商户页面
	$('.span-custom-open_surebtn').on('click', function(e) {
		$.router.load('./friendDetail_tpl.html?id=1&name=2', false, {
			"key": "value"
		});
		//		$.router.load('./shop_details_tpl.html.html?id=1&name=2', false, {
		//			"key" : "value"});
	});
	//点击积分转账确认转账按钮跳转朋友或者商户页面
	//	$('.span-custom-open_surebtns').on('click', function(e) {
	//		$.router.load('./friend_detail_tpl.html?id=1&name=2', false, {
	//			"key" : "value"});
	//		$.router.load('./shop_details_tpl.html.html?id=1&name=2', false, {
	//					"key" : "value"});
	//	});

	**/

});
