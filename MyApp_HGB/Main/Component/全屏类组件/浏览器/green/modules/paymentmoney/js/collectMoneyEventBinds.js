$(document).on("pageInit", "#page-collectMoney_tpl", function() {
    var arg_integral = GetQueryString("integral");
               
    var vue_modual = {};

	var userinfo = {};

	//此处的变量需要替换成正式的环境地址
	//var temp_url = "http://localhost:8080/data/json_4.json";

	//双向数据绑定对象
	var vm = new Vue({
		el: '#page-collectMoney_tpl', //@绑定节点
		data: { //@数据
			obj:{
				display_code:"",
				code_path:"",
				qcode_path:""
			},
            isShow:false
		},
		methods: { //@方法-事件调用(this指向data)

		
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			
			//初始化
			init();
		}
	});

	//界面初始化方法
	function init(){

		userinfo = getsession("userInfo");
		//tree_no = 
		//type_   = 
		init_code_qcode();
		
	}

	//生成二维码
	function init_code_qcode(){
               var temp_integral = 0;
               if(arg_integral!=null){
                 temp_integral = arg_integral;
               }
               //生成二维码
               var codes  = {
                    integral:temp_integral,
                    create_user_id:userinfo.id_,
                    type:"2"
               }
               AgreeSDK.MakeImgPlugin.MakeQrCode(JSON.stringify(codes),function(data){
                    vue_modual.obj.code_path = data;
               },function(error){
                 
               });
        
       /**
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
				arg_modual.obj.type = data.data.type_;
			
				//生成二维码
				var codes  = {
                    integral:0
					auth_code:arg_modual.obj.auth_code,
					type:arg_modual.obj.type
				}
				AgreeSDK.MakeImgPlugin.MakeQrCode(JSON.stringify(codes),function(data){
					arg_modual.obj.code_path = data;
				},function(error){

				});

				
			}
			
			
		},function(error){

		});
        **/
	}

	$('.span-custom-collect_je').on('click', function(e) {
		$.router.load('./settingMoney_tpl.html',true);
	});
	$('.span-custom-record').on('click', function(e) {
		$.router.load('./collectionRecords_tpl.html',true);
	});

});
