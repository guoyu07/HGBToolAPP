$(document).on('pageInit', '#page-friendInformation_tpl', function() {

	// $('.span-custom-payment').on('click', function(e) {
	// 	$.router.load('./cashTransferFriend_tpl.html?id=1&name=2', false, {
	// 		"key": "value"
	// 	});
	// });
	

	var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
	var vm = new Vue({
		el: '#page-friendInformation_tpl', //@绑定节点
		data: { //@数据	
         friendInfo:{
              
              
              //默认隐藏积分转增
          },
          isShow:false,
          isDonation:false
		},
		methods: { //@方法-事件调用(this指向data)
           add:function(){
           	  add();
           	  
           },
           deletes:function(){
           	  deletes();
           },
           donation:function(){
             conserve('friend_Infos', vue_modual.friendInfo);
           	 $.router.load('./cashTransferFriend_tpl.html',true);
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
        
        memIsNoFriends(function(data){
           // -好友详情列表
           friendDetail();
        });
		
	}
   //是否好友
   function memIsNoFriends(callback){
       
        var temp_url = url_ + "mobile/member/memIsNoFriends.jhtml";
        var id = $.router.query('dataid');
               
        var temp_post_csh = {
               fri_id_:id,
               member_id_:temp_userinfo.id_
        };
        var temp_token = temp_userinfo.token_;
        var temp_deviceid = temp_userinfo.device_id_;
               
       AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
       
         if(data.appcode == 1){
                                             
             vue_modual.isDonation = data.data.flag;
             vue_modual.isShow = data.data.flag;
             callback();
         }
                                             
      }, function(err) {
          $.toast('网络请求失败!');
      });
   }
	/**
	 * 加载列表详情的核心方法  - 好友详情列表 js - start 
	 */
	function friendDetail() {
        $.showPreloader('正在查询...');       
		//var temp_url = "http://localhost:8080/data/json_13.json";
		var temp_url = url_ + "mobile/friends/friendsDetail.jhtml";
        var id = $.router.query('dataid');
		var temp_post_csh = {
			friends_id_:id
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
			
			$.hidePreloader();
			if(data.appcode == 1){	

				vue_modual.friendInfo = data.data;

				//调绑定接口，如果绑了，就是查看该商户按钮，否则是绑定按钮
			}	
			
		}, function(err) {
			$.hidePreloader();
			$.toast('网络请求失败!');
		});
	}
	/**
	 * 加载列表详情的核心方法  - 好友详情列表 js - end 
	 */


	 function add() {
        $.showPreloader('提交中...');
        $('.span-custom-deletebtn').addClass('.activies');

		//var temp_url = "http://localhost:8080/data/json_13.json";
		var temp_url = url_ + "mobile/friends/friendsAdd.jhtml";
		var id = temp_userinfo.id_;
        var dataid = $.router.query('dataid');
		var temp_post_csh = {
			member_id_:id,
			friends_id_:dataid
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
			$.hidePreloader();
			$('.span-custom-deletebtn').removeClass('.activies');

			if(data.appcode == 1){	
                $.toast('添加好友成功，请等待好友确认!');
				//$.router.load('../../modules/home/home.html',true);
            }else{
                $.toast('您已提交好友申请，请等待好友确认!');
            }
			
		}, function(err) {
            $.hidePreloader();
			$.toast('网络请求失败!');
			$('.span-custom-deletebtn').removeClass('.activies');

		});
	}
	/**
	 * 加载列表详情的核心方法  - 好友详情列表 js - end 
	 */
	 function deletes() {
        $.confirm('确定删除好友关系么？', function() {
                  $.showPreloader('正在处理...');
                  //var temp_url = "http://localhost:8080/data/json_13.json";
                  var temp_url = url_ + "mobile/friends/friendsDel.jhtml";
                  var id = temp_userinfo.id_;
                  var dataid = $.router.query('dataid');
                  var temp_post_csh = {
                  member_id_:id,
                  friends_id_:dataid
                  };
                  var temp_token = temp_userinfo.token_;
                  var temp_deviceid = temp_userinfo.device_id_;
                  
                  AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
                    $.hidePreloader();
                    if(data.appcode == 1){
                    $.router.load('../../modules/home/home_tpl.html',true);
                    }
                    
                    }, function(err) {
                    $.hidePreloader();
                    $.toast('网络请求失败!');
                    });
         },function(){
         
         });
        
	}

});
getDeviceName();
