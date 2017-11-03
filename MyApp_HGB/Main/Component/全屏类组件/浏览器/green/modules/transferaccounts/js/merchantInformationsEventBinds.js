$(document).on("pageInit", "#page-merchantInformations_tpl", function() {
   
	var type = GetQueryString("type");
    
	var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
    //
    var temp_tenant = {};

	var vm = new Vue({
		el: '#page-merchantInformations_tpl', //@绑定节点
		data: { //@数据	
          tenant_Info:{
              // isShow:false,
              // isHide:true
          },
          account_:'',
          cardid_:'',
          phone_:''
		},
		methods: { //@方法-事件调用(this指向data)
            //点击查看该商户活动跳转    
           find:function(){
           	  $.router.load('../../modules/cardprotector/cardBall_tpl.html',true);
           },
            //绑定跳转    
           bound:function(){
           	  bingTenant();
           }
		},
		created: function() { //@业务逻辑（this指向data）
		    vue_modual = this;
		    //初始化
			init();
		    
		}
	});


	//界面初始化
	function init(){

		temp_userinfo = getsession('userInfo');

	    temp_tenant = getsession('temp_tenant_info_2');
	    
	    if(temp_tenant){

			//vue_modual.tenant_Info.name_ = temp_tenant.name_;
			//vue_modual.tenant_Info.image_ = temp_tenant.image_;
            vue_modual.tenant_Info = temp_tenant;
	    }
	    
	}
  //短信验证
  $(".yzms").on('click', function() {

    $.sendVerifyCode($(this), 60, '重新发送');
    //调用手机验证码接口

    var post_adress = url_ + "mobile/member/phoneCode.jhtml";

    var data = {
      phone_: vue_modual.phone_
    };

    var deviceid = temp_userinfo.device_id_;
    var token = temp_userinfo.token_;
    AgreeSDK.Connection.getNetWorkRequest(post_adress, data, token, deviceid, function(msg) {

      if(msg.appcode == 1) {
          

      }

    }, function(err) {

      $.toast('网络请求失败');

      $('.span-custom-bdbtn').removeClass('actives');
    });

  })

	/**
	 * 绑定商户 - 商户详情列表 js - start 
	 */
	function bingTenant() {
       
        if(Verification()){
           $.toast('请填写内容！');
           return;
        }
        $.showPreloader('正在处理...');
		//var temp_url = "http://localhost:8080/data/json_12.json";
		var temp_url = url_ + "mobile/cardPackage/carPackageBinding.jhtml";
        var id = temp_tenant.id_;
		var temp_post_csh = {
			user_id_:id,
			member_card_no_:vue_modual.cardid_,
			member_account_:vue_modual.account_,
			member_id_:temp_userinfo.id_,
			reserve_phone_:vue_modual.phone_

		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
			$.hidePreloader();
			if(data.appcode == 1){
				
                
				if(data.data == 0 ){
					$.toast('您已绑定该商户！');
				}
                loadCardList();

				//调绑定接口，如果绑了，就是查看该商户按钮，否则是绑定按钮
			}
			
		}, function(err) {
            $.hidePreloader();
			$.toast('网络请求失败!');
		});
	}
               
               function loadCardList(){
               
               var post_adress = url_ + "mobile/cardPackage/carPackageList.jhtml";
               var data = {
               page:1,
               start: 0,
               limit: 100,
               id_: temp_userinfo.id_
               };
               var temp_token = temp_userinfo.token_;
               var temp_deviceid = temp_userinfo.device_id_;
               AgreeSDK.Connection.getNetWorkRequest(post_adress, data, temp_token, temp_deviceid, function(msg) {
                                                     if(msg.appcode == 1) {
                                                     
                                                     //记录当前已绑定的卡包列表
                                                     conserve('usercardList',msg.data);
                                                     
                                                     saveFile("tenanInfo",msg.data,function(){
                                                        conserve("temp_tenant_info",msg.data);
                                                         //跳转
                                                         Jump();
                                                      },function(error){
                                                         //未获取到数据
                                                         $.toast('插件错误');
                                                      });
                                                     
                                                     }
                                                     }, function(err) {
                                                     $.toast('网络请求失败!');
                                                     });
   }
	/**
	 * 加载列表详情的核心方法  - 商户详情列表 js - end 
	 */
   function Verification(){

       if(vue_modual.code_ ==''){
           $.toast('请填写验证码！');
       }      
       if(vue_modual.tenant_Info.check_type_ == "1"){
               
               if(!CHECK(vue_modual.phone_)){
                   return true;
               }
       }
       if(vue_modual.tenant_Info.check_type_ == "2"){
               if(!CHECK(vue_modual.account_)){
                       return true;
               }
       }
       if(vue_modual.tenant_Info.check_type_ == "3"){
               if(!CHECK(vue_modual.cardid_)){
                   return true;
               }
               if(!CHECK(vue_modual.account_)){
                   return true;
               }
               if(!CHECK(vue_modual.phone_)){
                   return true;
               }
       }
       
           return false;
   }

	function Jump(){
        
		if(type!='' && type!=null && type == '0'){
			 conserve('tenantInformation',temp_tenant);
			 $.router.load('../../modules/integralwallet/addShops_tpl.html?type=1',true);
		}else{
			 conserve('tenantInformation',temp_tenant);
            $.router.load('../../modules/integralwallet/addShops_tpl.html',true);
			//$.router.load('../../modules/exchange/addShop_tpl.html',true);
		}
	}
});
getDeviceName();
