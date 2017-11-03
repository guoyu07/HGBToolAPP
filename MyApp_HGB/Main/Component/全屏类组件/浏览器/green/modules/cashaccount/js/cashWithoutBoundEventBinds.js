
$(document).on('pageInit', '#page-cashWithoutBound_tpl', function() {
	
	var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
	var vm = new Vue({
		el: '#page-cashWithoutBound_tpl', //@绑定节点
		data: { //@数据	

		  //账户余额
          moneyInfo:{
             
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

		
		// 查询账户余额
		myBalance();


	}




    /*
	 *账户余额 js - start 
	 */
     function myBalance() {

		var temp_url = "http://localhost:8080/data/json_23.json";
		//var temp_url = url_ + "mobile/ad/adlist.jhtml";
        var id_ = temp_userinfo.id_;
		var temp_post_csh = {
			member_id_:id_
		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;
        
		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
			if(data.appcode == 1){              
                vue_modual.moneyInfo = data.data;
			}	
			
		}, function(err) {
			$.toast('网络请求失败!');
		});			
	}
	/**
	 *  账户余额 js - end 
	 */
	
	$('.div-custom-cardBox .span-custom-righttext').on('click', function(e) {
		$.router.load('./addBlankCard_tpl.html',true);
	});

});
getDeviceName();
