$(document).on("pageInit", "#page-passwordSetting_tpl", function(e, pageId, $page) {
	$('#a-custom-forget_cancel').on('click', function(e) {
		$.router.back();
	});
	var temp_userinfo = {};
	//存储一个全局变量
	var vue_modual = {};
	var vm = new Vue({
		el: '#page-passwordSetting_tpl', //@绑定节点
		data: { //@数据	 表单数据

			old_lgoin_pwd_: '',
			password_: '',
                     sure_password:''

		},
		methods: { //@方法-事件调用(this指向data)
			submit: function() {
				submit();
			}
		},
		created: function() { //@业务逻辑（this指向data）

			vue_modual = this;
			//初始化
			temp_userinfo = getsession('userInfo');
            
		}
	});

	function submit() {

         //alert(temp_userinfo.password_);
         //alert(md5(vue_modual.old_lgoin_pwd_).toUpperCase() + "==" + temp_userinfo.password_);
		if(temp_userinfo.password_ != md5(vue_modual.old_lgoin_pwd_).toUpperCase()) {
			$.toast('旧登陆密码有误，请重新输入！');
			
               return;
		}
		if(vue_modual.password_ != vue_modual.sure_password) {
			$.toast('登陆密码不一致，请重新输入！');
			
               return;
		}
		var temp_device = temp_userinfo.device_id_;
		var token = temp_userinfo.token_;
		$('.span-custom-open_surebtn').addClass('actives');

		var post_adress = url_ + "mobile/member/memEdit.jhtml";
		//var post_adress = "http://localhost:8080/data/json_14.json";
		var data = {
            id_:temp_userinfo.id_,
			old_lgoin_pwd_: vue_modual.old_lgoin_pwd_,
			password_: vue_modual.password_

		};
               //alert(JSON.stringify(data));
	    $.showPreloader("正在处理...");

		//调用获取本地数据方法

		AgreeSDK.Connection.getNetWorkRequest(post_adress, data, token, temp_device, function(data) {
                                              alert(JSON.stringify(data));
			$('.span-custom-open_surebtn').removeClass('actives');

			$.hidePreloader();

			var data_ = data;
			if(data_.appcode == 1) {

				$('.span-custom-open_surebtn').removeClass('actives')
				$.toast('登录密码修改成功,请重新登陆！');
				$.router.load('../../index_tpl.html');

                                              }else{
                                              $.toast(data_.appmsg);
                                              
                                              }

		}, function(err) {

			$('.span-custom-open_surebtn').removeClass('actives');
			$.hidePreloader();
			$.toast('网络请求失败！');

		});
	}

});
getDeviceName();
