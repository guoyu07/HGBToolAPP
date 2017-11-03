$(document).on("pageInit", "#page-changePhoneNumbers_tpl", function(e, pageId, $page) {
	var  temp_userinfo ={};
	
	var vm = new Vue({
		el: '#page-changePhoneNumbers_tpl', //@绑定节点
		data: { //@数据	 表单数据
			 
			
			phone_new:'',
			mobile_code:''	
		

		},
		methods: { //@方法-事件调用(this指向data)
           submit:function(){
           	submit();
           }
		},
		created: function() { //@业务逻辑（this指向data）
			
                vue_modual = this;
		        //初始化
		        temp_userinfo = getsession('userInfo');
		       
		}
	});
    function submit(){
		var mobileCode = getsession('mobile_code');
		var phone_new = getsession('phone_new');
		vue_modual.phone_new = phone_new;


		if(vue_modual.mobile_code != mobileCode){
            $.toast('验证码不正确!');
		}else{
			
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
	    }
    }
	$('.phone_cancel').on('click', function(e) {
		$.router.load('./setPhoneNumber_tpl.htm?id=1&name=2', false, { "key" : "value"});
	});
});
