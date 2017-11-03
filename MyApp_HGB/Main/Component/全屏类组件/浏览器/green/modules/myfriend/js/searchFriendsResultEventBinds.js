$(document).on("pageInit", "#page-searchFriendsResult_tpl", function () {

	var vue_modual = {};
	var temp_userinfo = {};

	var vm = new Vue({
		el: '#page-searchFriendsResult_tpl', //@绑定节点
		data: { //@数据
			searchResult:{

			},
			val_input:'',
			valInput:'',
			isShow:false
		},
		methods: { //@方法-事件
           search:function(){
               search();
           },
           list:function(dataid){

		       //跳转好友资料页面
			   $.router.load('../../modules/transferaccounts/friendInformation_tpl.html?dataid=' + dataid +'&type=0',true);

		   },
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			init();
		}
	});

   

	function init() {
              
		var temp_user = getsession("temp_userInfo");


	}  
    function search(){
               
        $.showPreloader('搜索中...');
              
       
		var post_adress = url_ + "mobile/member/memList.jhtml";
		

		var data = {

			nick_name_:vue_modual.val_input,
            phone_:vue_modual.val_input,
			start:0,
			limit:1000

			
		};
		
       var temp_token = temp_userinfo.token_;
       var temp_deviceid = temp_userinfo.device_id_;
               
		AgreeSDK.Connection.getNetWorkRequest(post_adress, data, temp_token, temp_deviceid, function(msg) {
            $.hidePreloader();
			if(msg.appcode == 1) {
               
				vue_modual.searchResult = msg.data;
                vue_modual.isShow = false;

            }else if(msg.appcode ==106 ){

                vue_modual.isShow = true;

            }
				
		}, function(err) {
            $.hidePreloader();
			$.toast('网请求失败！');
		});
           


    }



})
