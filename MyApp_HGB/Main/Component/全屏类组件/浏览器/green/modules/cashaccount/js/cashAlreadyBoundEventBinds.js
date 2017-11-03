$(document).on("pageInit", "#page-cashAlreadyBound_tpl", function() {
	

	var  temp_userinfo ={};
	//存储一个全局变量
    var vue_modual = {};
	var vm = new Vue({
		el: '#page-cashAlreadyBound_tpl', //@绑定节点
		data: { //@数据	

		  //账户余额
          moneyInfo:{
             
          },
		 //查询会员银行卡接口
		  blankCard:{
	           list:[]
		  },
		  isShow:false,
		  isHide:false,
		  BANKNAME:'',
		  BANKIMG:''




		},
		methods: { //@方法-事件调用(this指向data)

          addCardBank:function(){
          	$.router.load('./addBlankCard_tpl.html?type=3&type_=3',true); 
          },
          replace:function(){
          	//点击更换银行卡跳转
          	$.router.load('./addBlankCard_tpl.html?type=2&type_=1',true);
          },
          withdrawals:function(){
          	withdrawals();
          },
          recharge:function(){
          	recharge();
          },
          //点击银行卡列表
          onRoad:function(){
          	//点击未激活银行卡跳转页面
             //alert(vue_modual.qianyue_status_)
             if(vue_modual.qianyue_status_ == '未签约' ){
                 $.router.load('./addBlankCard_tpl.html?type_=2',true);
             }
          }
		},
		created: function() { //@业务逻辑（this指向data）
		    vue_modual = this;
		    //初始化
			init();
		    
		}
	});
    

	//提现
	function withdrawals(){
		if(vue_modual.qianyue_status_ == '未签约'){
			$.toast('该卡未签约，请激活！');
			return;
		}
		$.router.load('./recharge_tpl.html',true);
	}

	//充值
	function recharge(){
		if(vue_modual.qianyue_status_ == '未签约' ){
			$.toast('该卡未签约，请激活！');
			return;
		}
		$.router.load('./enchashment_tpl.html',true);
	}


	//界面初始化
	function init(){
        $.showPreloader();
		temp_userinfo = getsession('userInfo');
		

		// 查询账户余额
       myBalance(function(){
             //查询会员银行卡
             findCardBanks(function(){
                     $.hidePreloader();
              });
      });

		
       /**
	  if(GetQueryString('type') == "0") {
			 vue_modual.isShow = false;

	  }else if(GetQueryString('type') == "1"){

	         vue_modual.isShow = true;
	  }

**/
	

	}
	/**
	 * 查询会员银行卡js - start 
	 */
	function findCardBanks(callback) {

		//var temp_url = "http://localhost:8080/data/json_23.json";
		var temp_url = url_ + "mobile/member/memberBank.jhtml";//已改
        var id = temp_userinfo.id_;
		var temp_post_csh = {
			member_id_:id
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
         
          
			if(data.appcode == 1){
				  
                 
				  if(data.data == undefined){
				  	vue_modual.blankCard.list = new Array();
				  	vue_modual.isShow = true;
				  	vue_modual.moneyInfo = {};
				  	vue_modual.moneyInfo.balance_ = 0.00;
				  }else{

				  	vue_modual.blankCard.list = new Array();
				  	vue_modual.blankCard.list.push(data.data);
				  	for(var i = 0 ; i < vue_modual.blankCard.list.length ; i ++){
//alert("ssss:"+JSON.stringify(vue_modual.blankCard.list[i]));
				  		conserve('card_info',vue_modual.blankCard.list[i]);
                        var temp_bank_ =  bank_like(vue_modual.blankCard.list[i].bkacctno_);//根据银行卡号识别
				  		vue_modual.blankCard.list[i].bkacctno_ = Transformation(vue_modual.blankCard.list[i].bkacctno_);
				  		
				  		
				  		//vue_modual.BANKNAME = temp_bank_.BANKNAME;//根据银行卡号识别出银行
				  		vue_modual.BANKIMG = temp_bank_.BANKIMG;//根据银行卡号识别出logo
                                              
				  	}
				    vue_modual.isShow = false;
				  }
				  //未签约状态的时候
				  if(data.data.status_ == '1'){
                      vue_modual.qianyue_status_ = '已签约';
				  }else if(data.data.status_ == '2' || data.data.status_ == '0'){
				  	  vue_modual.qianyue_status_ = '未签约';
                  }else{
                       vue_modual.qianyue_status_ = '';
                  }
				  
				  
			}else{
				vue_modual.isShow = true;
			}	
                                              callback();
			
		}, function(err) {
                                              
			$.toast('网络请求失败!');
                                              callback();
		});
	}

	

	/**
	 *  查询会员银行卡js js - end 
	 */
	/**




	 *账户余额 js - start 
	 */
     function myBalance(callback) {

		//var temp_url = "http://localhost:8080/data/json_23.json";
		var temp_url = url_ + "mobile/member/memberCashBalance.jhtml";
        var id_ = temp_userinfo.id_;
       
		var temp_post_csh = {
			member_id_:id_
		};

		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;
       
		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
                                              //alert(JSON.stringify(data));
			if(data.appcode == 1){              
                if(!data.data){
					data["data"]={};
					data.data["balance_"]=0;
                }
                vue_modual.moneyInfo = data.data;
			}
                                              callback();
			
		}, function(err) {
			$.toast('网络请求失败!');
                                              callback();
		});			
	}
	/**
	 *  账户余额 js - end 
	 */
});
getDeviceName();
