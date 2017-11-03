$(document).on("pageInit", "#page-bindCard_tpl", function() {
              
	//存储一个全局变量
	var vue_modual = {};

	var temp_userinfo = {};
    var cardInfo = {};

	//存储一个全局变量
	var vm = new Vue({
		el: '#page-bindCard_tpl', //@绑定节点
		data: { //@数据	 表单数据

          codeNumber:''
 
		},
		methods: { //@方法-事件调用(this指向data)
            sure:function(){

            	pre_contract();
            }
		},
		created: function() { //@业务逻辑（this指向data）
	        
		     vue_modual = this;

		     init();
		}
    });
    function init(){

       temp_userinfo = getsession('userInfo');
       cardInfo = getsession('bing_card_info');

    	
    }


      function pre_contract(){

        if(valid()){
            return;
        };
        $.showPreloader('正在处理...');
    	//var temp_url = "http://localhost:8080/data/json_2.json";
		var temp_url = url_ + "mobile/trade/bindBankQy.jhtml"; //已改
        //var sgnno_ = cardInfo.sgnno_;
		var temp_post_csh = {
			id_:cardInfo.id_,
			pre_auth_msg_:vue_modual.codeNumber
		};
        //alert(JSON.stringify(temp_post_csh));
        //return
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
            
            $.hidePreloader();
			if(data.appcode == 1){			
                //判断返回信息跳转银行卡添加成功失败页面
                conserve('card_result',data.data);
                $.router.load('./cashBoundCardSuccess_tpl.html',true);
            }else{
            	$.toast(data.appmsg);
            }
            

		}, function(err) {
            $.hidePreloader();
			$.toast('网络请求失败!');
		});
    }
    
    function valid(){
        if(!vue_modual.codeNumber){
            $.toast('请输入验证码！');
            return true;
        }
        return false;
    }

});
getDeviceName();
