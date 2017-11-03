$(document).on('pageInit', '#page-recharge_tpl', function() {



	var temp_card_info = {};
	var temp_userinfo = {};

	var vue_modual = {};

	var vm = new Vue({
		el: '#page-recharge_tpl', //@绑定节点
		data: { //@数据	
			cardinfo:{
               
			},
			cashMoney:{

			},
			money:''
			
		},
		methods: { //@方法-事件调用(this指向data)
          submit:function(){
          	submit();
          },
          recharge:function(){

               var moneys = $('.span-custom-rechargeMoney').html();
          	   this.money = moneys;
          }
		},
		created: function() { //@业务逻辑（this指向data）
		    vue_modual = this;
		    //初始化
			init();
		    
		}
	});
	//验证
	function verification(){
       if(!CHECK(vue_modual.money)){
          return true;
       }
       return false
   }


	function init(){

		temp_userinfo = getsession('userInfo');

		temp_card_info = getsession('card_info');


		vue_modual.cardinfo = temp_card_info;
               
               
        var temp_bank_ =  bank_like(vue_modual.cardinfo.bkacctno_);
        
		vue_modual.cardinfo.bkacctno_ =  Transformation(vue_modual.cardinfo.bkacctno_);
        vue_modual.BANKIMG = temp_bank_.BANKIMG;

		cashMoney();
	}


    function cashMoney(){

    	var temp_url = url_ + "mobile/member/memberCashBalance.jhtml";//已改
        var id = temp_userinfo.id_;
		var temp_post_csh = {
			member_id_:id
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {

			
			if(data.appcode == 1){

				vue_modual.cashMoney = data.data;
			}	
			
		}, function(err) {
			$.toast('网络请求失败!');
		});
    }
    
	function submit(){
           if(verification()){
               $.toast('请输入金额！');
               return;
           }
               
        AgreeSDK.KeybordPlugin.onKeyboard('1','1234567891234567',function(msg){
           //返回输入的值 与 本地 密码进行比较
              var temp_settingPayPwd =  getsession('settingPayPwd');
              if(temp_settingPayPwd!=null && temp_settingPayPwd!=''&& temp_settingPayPwd!=undefined){
              
                  if(msg == temp_settingPayPwd){
                      $.showPreloader('正在处理...');
                      var temp_url = url_ + "mobile/trade/cashWithdraw.jhtml";//已改
                      var id = temp_userinfo.id_;
                      var temp_post_csh = {
                          member_id_:id,
                          amount_:vue_modual.money
                      };
                      var temp_token = temp_userinfo.token_;
                      var temp_deviceid = temp_userinfo.device_id_;
                                          
                      AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
                                                   
                         $.hidePreloader();
                         $('.span-custom-txbtn').removeClass('activies');
                        
                            if(data.appcode == 1){
                            
                                //将提现金额带过去
                                var money_recharge = vue_modual.money;
                                conserve('cash_infos',data.data);
                                $.router.load('./forwardResult_tpl.html',true);
                              

                            }else{
                                    conserve('msgs',data.appmsg);
                                    $.router.load('./cashForwardResults_tpl.html',true);
                                   
                            }
                        
                        }, function(err) {
                        
                                $.hidePreloader();
                                $.toast('网络请求失败!');
                                $('.span-custom-txbtn').removeClass('activies');
                        });
                  }
                                          
              }else{
                 $.toast('未知密码');
              }
           /**
           AgreeSDK.EncryptPlugin.TTAlgorithmSM4Decrypt(msg,'1234567891234567',function(msg){
                   
                   var pay_password = conserve('settingPayPwd');
                   if(pay_password == msg ){
                   	
					       $.showPreloader('提现中...');
					       $('.span-custom-txbtn').addClass('activies');

							if(verification()){
								return;
							}
							//var temp_url = "http://localhost:8080/data/json_23.json";
							var temp_url = url_ + "mobile/trade/cashWithdraw.jhtml";//已改
					       var id = temp_userinfo.id_;
							var temp_post_csh = {
								member_id_:id,
								amount_:vue_modual.money
							};
							var temp_token = temp_userinfo.token_;
							var temp_deviceid = temp_userinfo.device_id_;

							AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {

					           $.hidePreloader();
					           $('.span-custom-txbtn').removeClass('activies');

								if(data.appcode = 1){

									//将提现金额带过去
					               var money_recharge = vue_modual.money;
					               $.router.load('./cashForwardResults_tpl.html',true);

					               conserve('cash_infos',data.data);



								}else{

						             conserve('appmsg',data.appmsg);
									 $.router.load('./forwardResult_tpl.html',true);

								}

							}, function(err) {

					           $.hidePreloader();
								$.toast('网络请求失败!');
								$('.span-custom-txbtn').removeClass('activies');
							});
                          $.toast('密码不正确,请重新输入!');
                   }else{
                          $.router.load('./forwardResult_tpl.html',true);
                   }
           },function(error){
                                                        alert(error);
           })

            **/
                                          
        }, function(err) {
          // alert(err);
        });


	}
	

	
	
})
getDeviceName();
