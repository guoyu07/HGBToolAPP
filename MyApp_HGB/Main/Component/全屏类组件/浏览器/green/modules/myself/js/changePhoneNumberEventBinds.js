$(document).on("pageInit", "#page-changePhoneNumber_tpl", function(e, pageId, $page) {

	var  temp_userinfo ={};
	
	var vm = new Vue({
		el: '#page-changePhoneNumber_tpl', //@绑定节点
		data: { //@数据	 表单数据
			 
			phone_:'',
			phone_new:''	
		

		},
		methods: { //@方法-事件调用(this指向data)
           submit:function(){
           	submit();
           }
		},
		created: function() { //@业务逻辑（this指向data）
			
            vue_modual = this;
	        //初始化
		       
		       
		}
	});
	//短信验证
	temp_userinfo = getsession('userInfo');
	var phone_ = temp_userinfo.phone_;
	vue_modual.phone_ = phone_;
    function submit(){
		
		


		$.sendVerifyCode($(this), 60, '重新发送');
		//调用手机验证码接口
		    	
		var post_adress = url_ + "mobile/member/phoneCode.jhtml";

		var data = {
			phone_: vue_modual.phone_new
		};
		
        var deviceid = temp_userinfo.device_id_;
        var token = temp_userinfo.token_;

        if(vue_modual.phone_new != ''){
			conserve('phone_new', phone_new);
		}else{
		 	$.toast('请先填写手机号');
		}

		AgreeSDK.Connection.getNetWorkRequest(post_adress, data,token,deviceid,function(msg) {
      
					if(msg.appcode == 1){

                       conserve('mobile_code', msg.data.mobile_code);

					}

                   
					
		 }, function(err) {

			$.toast('网络请求失败');
			
			$('#btn_login').removeClass('actives');
	     });


		if(phone_new != ''){

			conserve('phoneNumber', phone);
			conserve('phone_new', phone_new);//保存新的手机号
            

			var temp_device = getsession("device_id_");
			var post_adress = url_ + "mobile/member/memEdit.jhtml";
			var data = {
				phone_: phone_
			};

		    AgreeSDK.Connection.getNetWorkRequest(post_adress, data, '', temp_device, function(msg) {

				if(msg.appcode == 1) {
					
					$.router.load('./changePhoneNumbers_tpl.html?id=1&name=2', false, { "key" : "value"});
				}

			}, function(err) {
				$.toast('网络请求失败!');
			});
		}else{
			$.toast('请先填写手机号');
		}
    }
	$('.cancel_phonenumber').on('click', function(e) {
		$.router.load('./setPhoneNumber_tpl.htm?id=1&name=2', false, { "key" : "value"});
	});

});
