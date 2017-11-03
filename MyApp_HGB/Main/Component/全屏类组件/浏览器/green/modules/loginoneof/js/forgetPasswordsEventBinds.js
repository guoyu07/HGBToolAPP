$(document).on("pageInit", "#page-forgetPasswords_tpl", function(e, pageId, $page) {
    var phone = GetQueryString("phone");
    var temp_device = '';
	var vue_modual = {};
	var temp_userinfo = {};

	var vm = new Vue({
		el: '#page-forgetPasswords_tpl', //@绑定节点
		data: { //@数据
			phone:'',
			payPassword:'',
			surePassword:''
		},
		methods: { //@方法-事件
           submit:function(){
               submit();
           }
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			init();
		}
	});

	function init() {
        //调用获取本地数据方法
        //temp_userinfo = getsession('userInfo');
        temp_device = getsession("device_id_");
	}
	
		
	
	
    function submit(){
        
    	$('#btn_login').addClass('actives');
        
        if(vue_modual.payPassword != '' && vue_modual.payPassword!=''  && vue_modual.surePassword != '' && vue_modual.surePassword!=''){
	    	$.showPreloader('正在处理...');

      
			var post_adress = url_ + "mobile/member/memFindPsw.jhtml";
			var data = {
				phone_:  phone,
				password_: vue_modual.payPassword
			};

              
			//var token_ = temp_userinfo.token_;
	        //var deviceid = temp_userinfo.device_id_;

			AgreeSDK.Connection.getNetWorkRequest(post_adress, data,'',temp_device, function(msg) {
                                                
 $.hidePreloader();
	            $('#btn_login').removeClass('actives');
	            
				
	            
				var data_forgetlist = msg;

				if(data_forgetlist.appcode == 1) {

				   $.router.load('../../index_tpl.html', true);
					
				}

			}, function(err) {
				 $.hidePreloader();
				$.toast('网络请求失败！');
				$('#btn_login').removeClass('actives');
			});
	    }else{
             
	    	$.toast('请输入密码！');
	    	
	    }



	    
		

	    
		

    }


});
