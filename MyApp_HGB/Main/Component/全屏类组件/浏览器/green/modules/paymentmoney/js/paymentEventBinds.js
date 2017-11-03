$(document).on("pageInit", "#page-payment_tpl", function() {
	
	var vue_modual = {};

	var userinfo = {};

	//此处的变量需要替换成正式的环境地址
	//var temp_url = "http://localhost:8080/data/json_4.json";

	//双向数据绑定对象
	var vm = new Vue({
		el: '#page-payment_tpl', //@绑定节点
		data: { //@数据
			obj:{
				type:"积分付款",
				auth_code:"",
				display_code:"",
				code_path:"",
				qcode_path:""
			}
		},
		methods: { //@方法-事件调用(this指向data)

		
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			
			//初始化
			init(vue_modual,function(){

			});
		}
	});

	//界面初始化方法
	function init(arg_modual,callback){

		userinfo = getsession("userInfo");
		//tree_no = 
		//type_   = 
		//建立临时链接，等待执行支付
		
		paywebsocket(function(data_ws){
		 	//正式调用二维码sdk
		 	init_code_qcode(arg_modual);

		},function(error){

		});
		
	}

	//生成二维码
	function init_code_qcode(arg_modual){

		var temp_url = url_ + "mobile/scancode/tempTradeno.jhtml";
		var temp_post_csh = {
			member_phone_:userinfo.phone_
		};
		var temp_token = userinfo.token;
		var temp_deviceid = userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
			
			//生成临时交易号
			if(data.appcode == 1){
				arg_modual.obj.auth_code = data.data.trade_no_;
                $('#auth_code').html(arg_modual.obj.auth_code);
				arg_modual.obj.type = data.data.type_;
				//转换成隐藏   8888 **** 点击查看
				code_transformation(arg_modual);
				//生成二维码
                var codes  = arg_modual.obj.auth_code;
					//create_user_id:userinfo.id_,
					
					//type:arg_modual.obj.type
				
				AgreeSDK.MakeImgPlugin.MakeQrCode(codes,function(data){
					arg_modual.obj.code_path = data;
				},function(error){

				});

				//生成条形码
				AgreeSDK.MakeImgPlugin.MakeBarCode(codes,function(data){
					arg_modual.obj.qcode_path = data;
				},function(){

				});
			}
			
			
		},function(error){

		});
	}

	//链接socket方法
	function paywebsocket(successcallback,errorcallback){
		var ws = null;
	    var url = null;
	    url = websocket_url + "websoketServer/pointServer/0/10/1"
	    ws =  new WebSocket(url);
	    ws.onopen = function () {
	        console.log('Info: connection opened.');
	        successcallback(ws);
	    };
	    ws.onmessage = function (event) {
	    	console.log(event.data);
	    	//处理链接事件
	    	var json = JSON.parse(event.data);
	    	console.log(json);
	    	if(json.data!=null){
	    		if(json.scmd == 'connect'){
	    			//{"data":{"username":"1","type":"1","userno":"11"},"scmd":"connect"}
	    			//
	    			var relation_json = {
										    "scmd": "relation",
										    "data": {
										        "userid": "11",
										        "kfid": "10" 
										    }
										};
	    		
	    			ws.send(JSON.stringify(relation_json));
	    		}else if(json.scmd == 'close'){
	    			//调转到订单界面
	    			ws = null;
	    			//存储交易返回的临时对象
	    			
	    			conserve('payInfo',json);
	    			$.router.load('../transferaccounts/cashTransferShops_tpl.html',true);
	    		}
	    	}
	    	
	    };
	    ws.onclose = function (event) {
	    	console.log('Info: connection closed.');
	    	errorcallback();
	    };
	}

	//将code 值进行后四位隐藏
	function code_transformation(arg_modual){
		var temp_code = arg_modual.obj.auth_code;
		temp_code = temp_code.substring(0,3) + " **** 查看数字";
		arg_modual.obj.display_code = temp_code;
	}


	$('.open-code').on('click', function() {
		$.popup('.popup-about-code');
	});

	//条形码二维码生成插件
	//cordova.exec(function(msg) { alert(msg); }, function(msg) { alert(msg); }, 'MakeImgPlugin', ' MakeQrCode ', ['信息']);
	$('.open-about').on('click', function() {
		$.popup('.popup-about');
	});

	$('.list-block li').on('click', function() {

		$('.list-block li').find('.item-inner').removeClass('bckimg');
		$('.list-block li').find('.item-title').removeClass('selected');
		$(this).find('.item-inner').addClass('bckimg');
		$(this).find('.item-title').addClass('selected');
	});

	//弹出选择支付方式，选择后更新变量,并关闭弹出框
	$('.ul_li_a li').on('click', function() {
		var liclass = $(this).attr('class');
		
		if(liclass == 'one'){
			vue_modual.obj.type = "积分付款";
			$.closeModal('.popup-about');
		}
		if(liclass == 'two'){
			vue_modual.obj.type = "现金账户";
			$.closeModal('.popup-about');
		}
		if(liclass == 'three'){
			vue_modual.obj.type = "银行卡";
			$.closeModal('.popup-about');
		}
	});
	

	//个人二维码收款
	$('.div-custom-personalPayment .span-custom-paymentbtn').on('click', function() {
		//测试变量，正式请注释
		// var json = {
		// 	type:'1',
		// 	service_key_:'chainsql',
		// 	order_total_:'10',
		// 	merchant_addr_:'rrrrr',
		// 	temp_trade_no_:'68510',
		// };
		//conserve('payInfo',json);
		//$.router.load('../transferaccounts/cashTransferShops_tpl.html',true);
		$.router.load('./collectMoney_tpl.html',true);
	})

});
