
$(document).on("pageInit", "#page-accountBack_tpl", function() {
	$("#picker_1").picker({
		toolbarTemplate: "<header class='bar bar-nav'><button class='button button-link pull-right close-picker'>确定</button> <h1 class='title'>请选择</h1> </header>",
		rotateEffect: false,
		value: ['积分转账', '现金转账', '积分支付','现金支付'],
		cols: [{
			textAlign: 'right',
			values: ['积分转账', '现金转账', '积分支付','现金支付']
		}],
		onOpen: function(picker) {},
		onClose: function(picker) {}
	});


	 var temp_userinfo = {};    
     var vue_modual = {};

	//存储一个全局变量
	var vm = new Vue({
		el: '#page-accountBack_tpl', //@绑定节点
		data: { //@数据	 表单数据
             
				account_info_: '',
				phone_:'',
				merchant_info_: '',
				trade_type1_: '',
				trade_target1_: '',
				trade_time1_:''
		
                  
		},
		methods: { //@方法-事件调用(this指向data)
           submit:function(){
           	submit();
           }
		},
		created: function() { //@业务逻辑（this指向data）
			
                vue_modual = this;
                init();
		        //初始化
		       
		}
	});
   function init(){
               //submit();
               
                temp_userinfo = getsession('userInfo');
               
                var user_1 = getsession('myInfos');
               if(user_1!=null){
	               //alert("::1"+JSON.stringify(user_1));
	               vue_modual.phone_ = user_1.phone_;
	               vue_modual.account_info_= user_1.account_info_;
	               vue_modual.merchant_info_= user_1.merchant_info_;
	               vue_modual.trade_type1_= user_1.trade_type1_;
	               vue_modual.trade_target1_= user_1.trade_target1_;
	               vue_modual.trade_time1_ = user_1.trade_time1_;

               }else{
            
               }
               
               
   }

    	

		function submit(){
               $.showPreloader('正在处理...');
                var temp_device = temp_userinfo.device_id_;
				var token = temp_userinfo.token_;
			    $('.span-custom-open_surebtn').addClass('actives');

	           

				var id_ = temp_userinfo.id_;
				var phone = temp_userinfo.phone_;
				
				var post_adress = url_ + "mobile/member/memEdit.jhtml";
				//var post_adress = "http://localhost:8080/data/json_14.json";
               //alert(JSON.stringify(vue_modual));
				var data_account= {
					phone_:vue_modual.phone_,
					account_info_:vue_modual.account_info_,
					merchant_info_:vue_modual.merchant_info_,
					trade_type1_:vue_modual.trade_type1_,
					trade_target1_:vue_modual.trade_target1_,
					trade_time1_:vue_modual.trade_time1_

				};
             
				//调用获取本地数据方法
				
               
				AgreeSDK.Connection.getNetWorkRequest(post_adress, data_account, token, temp_device, function(data) {
                                                      //alert(JSON.stringify(data));
                    $('.span-custom-open_surebtn').removeClass('actives');

					$.hidePreloader();

					var data_ = data;
					if(data_.appcode == 1) {
                        conserve('myInfos',data_account);
                        $.toast("提交成功，请耐心等待审核！");
                        $('.span-custom-open_surebtn').removeClass('actives')
     
 

						
					}

				}, function(err) {

					$('.span-custom-open_surebtn').removeClass('actives');
					$.hidePreloader();
					$.toast('网络请求失败！');
					
				});
        }
	

});
//getDeviceName();
