$(document).on('pageInit', '#page-index_tpl', function() {


  AgreeSDK.incrementalUpdating.init(function(msg){
        AgreeSDK.incrementalUpdating.increUpdate('08251c2eb08e4144acafadf23cb67368','123','','0',function(msg){
                                                
        //         AgreeSDK.incrementalUpdating.increUpdate(appid,'123','','0',function(msg){
                
        // },function(error){

        // })
        },function(error){
                                               
        })
  },function(error){
     
  }) 
	var vue_modual = {};
	var temp_device = '';

	var vm = new Vue({
		el: '#page-index_tpl', //@绑定节点
		data: { //@数据
			userpwd:'',
			username:'',

		},
		methods: { //@方法-事件
			submit:function(){
				submit1();
			}
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
      setTimeout(function(){
        init();
      },500);
			
		}
                     
	});
    


	function init(){
         $.showPreloader();
//        vue_modual.userpwd = '12345';
//        vue_modual.username = '13552144749';
//        vue_modual.userpwd = '12345';
//        vue_modual.username = '13688888888';
//          vue_modual.userpwd = '111111';
//          vue_modual.username = '18611816078';
		//var temp_userinfo = getsession("userInfo");
              
        getFile('userInfo',function(data){
                
                if(data != null && data != ''){
                    vue_modual.username = data.phone_;
                }else{
                   $.hidePreloader();
                }
                //校验token是否过期
                check_token();
       },function(error){
                
           setTimeout(function(){
                $.hidePreloader();
           },2000);
          
       });
       
	}
  
   function check_token(){
       
       getFile('userInfo',function(data){
           if(data != null && data != ''){
                conserve("userInfo",data);
               //赋值
               vue_modual.username = data.phone_;
                //var temp_url = "http://localhost:8080/data/json_2.json";
                var temp_url = url_ + "mobile/member/memberDetails.jhtml";

                var temp_post_csh = {
                    id_:data.id_,
                    phone_:data.phone_
                };
                var temp_token = data.token_;
                var temp_deviceid = data.device_id_;

                AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
                //alert(JSON.stringify(data));
                if(data.appcode == 1){
                    //弹出手势密码
                     touchcheck();
                  }else if(data.appcode == 201){
                    $.hidePreloader();
                    $.toast('TOKEN过期，请重新登录');
                  }

                },function(error){
                      $.hidePreloader();
                     $.toast('网络请求失败!');
                });
           }
       },function(error){
            
       });
   }
               
   var INDEX = 0;
   
   function touchcheck(){
               
       getFile('setTouch',function(data){
               $.hidePreloader();
               AgreeSDK.PwdLockPlugin.DecryptLock(data,function(msg){
                                                  
                    init_load(getsession('userInfo'));
                                                  
                  }, function(error) {
                  INDEX ++ ;
                  if(INDEX < 3){
                  $.confirm("密码错误，您还有" +(3 - INDEX) +"次机会重试",function(){
                            touchcheck();
                            },function(){
                            
                            });
                  }else{
                  $.toast('验证次数超过3次，请登录！');
                  }
               });
               
               
               },function(error){
               $.hidePreloader();
               if(error == '获取失败'){
                   //统一load系统初始变量
                   init_load(getsession('userInfo'));
               }else{
                   $.toast('插件调用失败！');
               }
        });
        
   }
               
    //验证方法
	function valid(){
        
		if(CHECK(vue_modual.username) && CHECK(vue_modual.userpwd)){
	    	return false;
	    }else{
	    	
	    	$.toast('请输入账户或密码！');
	    	$('#btn_login').removeClass('actives');
	    	
	    	return true;
	    }
	    return false;
	}

    var btn_bool = false;
               
	function submit1(){
        
        if(btn_bool){
           return;
        }
        btn_bool = true;

		if(valid()){
            btn_bool = false;
			return;
		}
        $('#btn_login').addClass('actives');
		$.showPreloader('登陆中...');

		var post_adress = url_ + "mobile/member/memLogin.jhtml";
		var data = {
			phone_: vue_modual.username,
			password_: vue_modual.userpwd
		};

	    AgreeSDK.Connection.getNetWorkRequest(post_adress, data, '', temp_device, function(msg) {
            
            $.hidePreloader();

            var data_login = msg;

			if(data_login.appcode == 1) {

				var userInfo = data_login.data;
				
				//存储到Storage
				conserve("userInfo",userInfo);
                //统一load系统初始变量
                init_load(userInfo);
                
                                              
                  
			} else if(data_login.appcode == 103) {
				
				$.confirm('该账户不存在，是否需要注册？', function() {
					conserve("temp_userInfo",data);
					$.router.load('modules/loginoneof/register_tpl.html');
				},function(){

				});
				
				
				
			} else if (data_login.appcode == 104){

                $.toast("账号或密码错误！");
				

			}else if(data_login.appcode == -1){
				$.toast('失败');
			}
            $('#btn_login').removeClass('actives');
            btn_bool = false;
			}, function(err) {
				$.toast('网络请求失败!');
                setTimeout(function(){
                   $('#btn_login').removeClass('actives');
                   $.hidePreloader();
                   btn_bool = false;
                },2000);
			});
	}
               
    
   function init_load(userInfo){
            var data_1 = {
            id_:userInfo.id_,
            phone_:userInfo.phone_,
            nick_name_:userInfo.nick_name_,
            like_:userInfo.like_,
            real_name_:userInfo.real_name_,
            image_:userInfo.image_,
            sex_:userInfo.sex_,
            area_:userInfo.area_,
            constellatory_:userInfo.constellatory_,
            age_:userInfo.age_,
            weight_:userInfo.weight_,
            occupation_:userInfo.occupation_,
            income_:userInfo.income_,
            height_:userInfo.height_
            };
            conserve('myInfo',data_1);
            //vue_modual.username = temp_userinfo.phone_

            getFile("private_key",function(data){

	            conserve("private_key",data);
	            //现金账户余额
	            myBalance(userInfo);
	            //获取设置的页面的免密支付
	            getSetup();
            //存储到文件 sdk
	            AgreeSDK.FilePlugin.saveDefaults("userInfo", JSON.stringify(userInfo), function(msg) {

		            //获取存储的商户卡包信息
		            getFile("tenanInfo",function(data){

			            conserve("temp_tenant_info",data);
			            //获取存储的密码
			            getpwd();
		            },function(error){

		            //未获取到数据
		            getpwd();
		            });
	            }, function(msg) {
	               $.toast("插件异常");
	            });

            },function(error){
               $.toast("插件异常,获取私钥失败");
               //
            });
   }
    //获取我的现金账户
    function myBalance(arg_userinfo) {
              
        //var temp_url = "http://localhost:8080/data/json_23.json";
        var temp_url = url_ + "mobile/member/memberCashBalance.jhtml";
        var id_ = arg_userinfo.id_;

        var temp_post_csh = {
        member_id_:id_
        };
              
        //temp_post_csh = JSON.stringify(temp_post_csh);
        var temp_token = arg_userinfo.token_;
        var temp_deviceid = arg_userinfo.device_id_;

        AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
                                              
        if(data.appcode == 1){
        conserve("cash_balance",data.data.balance_);
        }

        }, function(err) {
        $.toast('网络请求失败!');
        });
    }
               
   //查询本地设置
   function getSetup(){
       
       getFile("setUp",function(data){
            conserve("setUp",data);
       },function(error){
       	    if(error == '获取失败'){
              
       	    }else{
               $.tost(error);
       	    }
           
       });
   }
               
   function getpwd(){
              
       getFile("settingPayPwd",function(data){
               conserve("settingPayPwd",data);
               $.router.load('modules/home/home_tpl.html',true);
       },function(error){
               //未获取到数据
               $.router.load('modules/home/home_tpl.html',true);
       });
   }


	$(".footers .password").on('click', function() { //?id=1&name=2',false,{"key": "value"}
		$.router.load('modules/loginoneof/forgetPassword_tpl.html',true);
	});
	$(".footers .zhuce").on('click', function() { //?id=1&name=2',false,{"key": "value"}
		$.router.load('modules/loginoneof/register_tpl.html',true);
	});
})
getDeviceName();
