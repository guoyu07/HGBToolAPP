$(document).on('pageInit', '#page-setting_tpl', function() {
              
	var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
	var vm = new Vue({
		el: '#page-setting_tpl', //@绑定节点
		data: { //@数据	
         isChecked:false,
         phone_setting:'',
         touch:'请设置'
		},
		methods: { //@方法-事件调用(this指向data)
             onChecked:function(){
                 setUp();
             },
             onTouch:function(){
                 setTouch();
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
		phone_setting = temp_userinfo.phone_;
		vue_modual.phone_setting = phone_setting;
        phone_new = getsession('phone_new');
		if(phone_new){
			 vue_modual.phone_setting = phone_new;
		}
		//存储小额免密支付是否开通的状态
		var setup = getsession('setUp');
        if(setup!=null && setup!=''){
           vue_modual.isChecked = setup.isChecked;
        }
               
       //存储小额免密支付是否开通的状态
        var setTouch = getsession('setTouch');
        if(setTouch!=null && setTouch!=''){
          vue_modual.touch = '已设置';
        }
	}

   function setUp(){
        
       var obj = {};
       obj.isChecked = vue_modual.isChecked;
       
       saveFile('setUp',obj,function(){
                conserve('setUp',obj);
                $.toast('设置免密支付成功...');
        },function(error){
                $.toast('插件调用失败！');
        })
   }
               
   //设置手势密码
   function setTouch(){
      getFile('setTouch',function(data){
          if(data==null || data == '' || data== undefined){
              showTouch();
           }else{
              conserve('setTouch',data);
              checkTouch();
           }
    },function(error){
        if(error == '获取失败'){
            showTouch();
        }else{
            $.toast('插件调用失败！');
        }
    });
               
   function showTouch(){
         AgreeSDK.PwdLockPlugin.SetPwdLock(function(msg){
           saveFile('setTouch',msg,function(){
               conserve('setTouch',msg);
               vue_modual.touch = '已设置';
               $.toast('设置手势密码成功...');
            },function(error){
                $.toast('插件调用失败！');
            });
         }, function(error) {
     
         });
   }
               
   function checkTouch(){
       var temp_touch = getsession("setTouch");
       AgreeSDK.PwdLockPlugin.DecryptLock(temp_touch,function(msg){
           showTouch();
       }, function(error) {
           $.toast('手势密码错误！');
       })
   }
   /**
   var obj = {};
   obj.isChecked = vue_modual.isChecked;
   
   saveFile('setTouch',obj,function(){
            conserve('setTouch',obj);
            $.toast('设置手势密码成功...');
            },function(error){
            $.toast('插件调用失败！');
    });
    **/
   }






	$('#logouts').on('click', function(e) {
		
		   location.href = '../../index_tpl.html';
       //也可以使用ide页面的跳转
	});

	$('#phonenumber_page').on('click', function(e) {
		$.router.load('./setPhonenumber_tpl.html',true);
	});
	$('#passwordSetting').on('click', function(e) {
		$.router.load('./passwordSetting_tpl.html',true);
	});
	$('#pay_password').on('click', function(e) {
		$.router.load('./payPassword_tpl.html',true);
	});
//    $('#gestureverification').on('click', function(e) {
//        
//        AgreeSDK.PwdLockPlugin.SetPwdLock(function(msg){
//
//        }, function() {
//            
//        })
//    //解锁九宫格密码
//    
//    // AgreeSDK.PwdLockPlugin.DecryptLock('',function(msg){
//
//    // }, function() {
//        
//    // })
//        //$.router.load('../loginoneof/gestureVerification_tpl.html',true);
//    });
	$('#accountback').on('click', function(e) {
		$.router.load('./accountBack_tpl.html',true);
	});

	
 //    if(!$("#consent").attr("checked")){
	// 	$.toast('请选择是否本人已阅读条款并同意', 2000);
	// 	return;
	// }
});
