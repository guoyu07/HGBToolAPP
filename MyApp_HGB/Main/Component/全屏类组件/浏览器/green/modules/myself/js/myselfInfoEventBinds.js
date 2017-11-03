$(document).on("pageInit", "#page-myselfInfo_tpl", function() {
	var temp_userinfo = {};
     //判断获取本地文件插件
     var imgUrl ='2.png';
     var vue_modual = {};
     var imgs ='';
     AgreeSDK.FilePlugin.getFile (imgUrl,'1',function (msg){
     	
         if(msg){
	         //存在头像则
	         $('#uploadimg span img').attr('src',"data:image/png;base64,"+msg);
	         imgs = msg;
           
         }
     },function(error){
                                 // $.toast(error);
     })


	$('#uploadimg').on('click', function(e) {
		$.router.load('./uploadAvatar_tpl.html?id=1&name=2', false, {
			"key": "value"
		});
	});
	$("#sex").picker({
		cols: [{
			textAlign: 'center',
			values: ['男', '女']
			//如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
		}]
	});

	// $("#img_head").click(function() {
	// 	//相册调用
	// 	AgreeSDK.Media.picture(function(msg) {
	// 		$('#img_head').attr('src', msg);
	// 	}, function(err) {

	// 	})
	// });

	
	

	//存储一个全局变量
	var vm = new Vue({
		el: '#page-myselfInfo_tpl', //@绑定节点
		data: { //@数据	 表单数据
             
				like_: '',
				nick_name_: '',
				sex_: '',
				area_: '',
				age_: '',
				constellatory_: '',
				weight_: '',
				occupation_: '',
				income_: '',
				like_: '',
				height_:'',
				image_:''
		
                  
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
               
               var user_1 = getsession('myInfo');
               if(user_1!=null){
               //alert("::1"+JSON.stringify(user_1));
               vue_modual.like_ = user_1.like_;
               vue_modual.nick_name_= user_1.nick_name_;
               vue_modual.sex_= user_1.sex_;
               vue_modual.area_= user_1.area_;
               vue_modual.age_= user_1.age_;
               vue_modual.constellatory_ = user_1.constellatory_;
               vue_modual.weight_= user_1.weight_;
               vue_modual.occupation_= user_1.occupation_;
               vue_modual.income_= user_1.income_;
               vue_modual.like_= user_1.like_;
               vue_modual.height_= user_1.height_;
               vue_modual.image_= user_1.image_;
               //alert(vue_modual.nick_name_);
               }else{
               //alert(11);
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
				var data_1 = {
					id_:id_,
					phone_:phone,
					// old_lgoin_pwd_:
					// password_:
					// card_no_:vue_modual.
					// member_no_:vue_modual.
					nick_name_:vue_modual.nick_name_,
					like_:vue_modual.like_,
					real_name_:vue_modual.real_name_,
					//device_id_:.,
					//old_pay_password_:vue_modual.,
					//pay_password_:vue_modual.,
					image_:imgs,
					sex_:vue_modual.sex_,
					area_:vue_modual.area_,
					constellatory_:vue_modual.constellatory_,
					age_:vue_modual.age_,
					weight_:vue_modual.weight_,
					occupation_:vue_modual.occupation_,
					income_:vue_modual.income_,
					height_:vue_modual.height_

				};
               //alert("data:"+JSON.stringify(data_1));
				
			    //var myInfo = getsession('myInfo');
                
				//调用获取本地数据方法
				
               
				AgreeSDK.Connection.getNetWorkRequest(post_adress, data_1, token, temp_device, function(data) {
                   
                    $('.span-custom-open_surebtn').removeClass('actives');

					$.hidePreloader();

					var data_ = data;
					if(data_.appcode == 1) {
                        conserve('myInfo',data_1);
                                                      $.toast("保存成功！");
                        $('.span-custom-open_surebtn').removeClass('actives')
     
					    $.router.load('../../modules/home/home_tpl.html',true);

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
//getDeviceName();
