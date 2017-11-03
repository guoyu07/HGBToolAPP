$(document).on("pageInit", "#page-recordshops_tpl", function() {
	
		var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
	var vm = new Vue({
		el: '#page-recordshops_tpl', //@绑定节点
		data: { //@数据	
         recordInfo:{
           
            list:[]

          }



		},
		methods: { //@方法-事件调用(this指向data)
            onLoad:function(dataid){
            	//跳转交易详情分为好友和商户详情页面
				$.router.load('./shopDetails_tpl.html?dataid='+dataid,true);
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
	
		record_list(0,10,function(){

		});
	


	}
	

	 function record_list(arg_start_,arg_limit_,callback) {

		//var temp_url = "http://localhost:8080/data/json_13.json";
		var temp_url = url_ + "mobile/member/memberTradeRecord.jhtml";
		
		var temp_post_csh = {
			order_no_:id,
			limit:arg_limit_,
			start:arg_start_,
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
			
			if(data.appcode == 1){	
                if(vue_modual.recordInfo.list.length > 9 && arg_start_!=0){
					for(var i = 0 ; i < data.data.length ; i ++){
						vue_modual.recordInfo.list.push(data.data[i]);
					}
				}else{
					vue_modual.recordInfo.list = data.data;

					if(data.data.length < 9){
						vue_modual.recordInfo.down_bool = false;
					}else{
						vue_modual.recordInfo.down_bool = true;
					}
				}

				vue_modual.recordInfo.start = arg_start_;
				vue_modual.recordInfo.limit = arg_limit_;

				callback();
				
			}	
			
		}, function(err) {
			$.toast('网络请求失败!');
		});
	}
	

});
getDeviceName();


