$(document).on("pageInit", "#page-uploadAvatar_tpl", function(e, pageId, $page) {

	
     //判断获取本地文件插件
     var imgUrl ='2.png';
     var vue_modual = {};
     AgreeSDK.FilePlugin.getFile (imgUrl,'1',function (msg){
     	//alert(msg);
         if(msg){
         	
            //存在头像则
           $('#user-camera img').attr('src',"data:image/png;base64,"+msg);

    
         }
     },function(error){
          
     })
		
	$('.cancel').on('click', function(e) {
		$.router.load('./myselfInfo_tpl.html?id=1&name=2', false, {
			"key" : "value"});
	});


    //调取相册插件
	$('#button_selectPhotos').on('click', function(e) {
		AgreeSDK.Media.picture(function(msg) {
		if (msg) {
			// -上传头像
		    UploadAvatar(msg);
		} else {}
			
			
		}, function(err) {
		   //alert(err);
		});
	});
	//调取拍照插件
	$('#button_take_picture').on('click', function(e) {
		AgreeSDK.Media.camera(function(msg) {
		if (msg) {
			// -上传头像
		    UploadAvatar(msg);
		} else {}

		}, function(err) {
		   //alert(err);
		});
	});
	
    //调用上传头像接口
    var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
	var vm = new Vue({
		el: '#page-uploadAvatar_tpl', //@绑定节点
		data: { //@数据	
          avatar:{
             
          }
		},
		methods: { //@方法-事件调用(this指向data)

          
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
		

	}
		/**
	 * 上传头像 js - start 
	 */
	function UploadAvatar(msg) {
	
		
		var temp_url = url_ + "mobile/member/memPhoto.jhtml";
		var temp_post_csh = {
			//image_:avatarImg
			image_:msg
		};
		//alert(msg);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
			//alert(JSON.stringify(data));
			
			if(data.appcode == 1){	

				//头像文件保存插件
			
				var imgUrl =msg;

				AgreeSDK.FilePlugin.saveFile(imgUrl,'2.png',function(msg){
			
				 $('#user-camera img').attr('src',msg);

				},function(error){
                   // alert(error);
				})
			}	
			
		}, function(err) {
			$.toast('网络请求失败!');
		});
	}
	/**
	 * 上传头像 js - end 
	 */
	


	
});
getDeviceName();
