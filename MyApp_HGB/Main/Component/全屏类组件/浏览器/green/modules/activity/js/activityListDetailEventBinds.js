$(document).on("pageInit", "#page-activityListDetail_tpl", function() {
	var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
	var vm = new Vue({
		el: '#page-activityListDetail_tpl', //@绑定节点
		data: { //@数据	
          activityDetailInfo:{
             
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

		
		// -商户活动详情列表
		activityDetail();
	


	}
	/**
	 * 加载列表详情的核心方法  - 活动列表详情 js - start 
	 */
	function activityDetail() {

		//var temp_url = "http://localhost:8080/data/json_7.json";
		var temp_url = url_ + "mobile/activity/detailActivity.jhtml";
        var id = $.router.query('dataid');//获取跳转路径参数dataid
		var temp_post_csh = {
			id_:id
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
			
			if(data.appcode == 1){			
				vue_modual.activityDetailInfo = data.data;
			}	
			
		}, function(err) {
			$.toast('网络请求失败!');
		});
	}
	/**
	 * 加载列表详情的核心方法  - 活动列表详情 js - end 
	 */


	 //调用分享插件
	$('#shareBtn').on('click', function() {
		var url = "https://pano.autohome.com.cn/car/aa/web/?src=share";
		var title = "标题";
		var description = "描述";
		AgreeSDK.Share.getShare(url, title, description, function(msg) {
			alert(msg);
		}, function(err) {
			alert(err);
		});
	})

});
getDeviceName();

