$(document).on('pageInit', '#page-addBlankCard_tpl', function() {
  var type = GetQueryString('type_');
	//存储一个全局变量
	var vue_modual = {};
	var temp_userinfo = {};
    temp_userinfo = getsession('userInfo');

   
	//存储一个全局变量
	var vm = new Vue({
		el: '#page-addBlankCard_tpl', //@绑定节点
		data: { //@数据	 表单数据

          myInfo:{

            bank_cardno_:'',
            id_no_:'',
            name_:'',
            checked:true,//checkbox初始化,
            phone_:''
            
          },
          name:'',
          isShow:false,
          isDis:3


		},
		methods: { //@方法-事件调用(this指向data)
          
          	submit:function(){
          		submit();
          	},
            checkcard:function(){
               likeCard();
            },
             submit1:function(){
               submit1();
             }
		},
		created: function() { //@业务逻辑（this指向data）
                     
		     vue_modual = this;
         init();

                     // vue_modual.myInfo.bank_cardno_ = '6217771000012098';
                     // vue_modual.myInfo.id_no_ = '321322199010010116';
                     // vue_modual.myInfo.name_ = '林光亮';
                     // vue_modual.myInfo.checked = true;
                     // vue_modual.myInfo.phone_ = '15852911343';
		}
    });
    function init(){
               
      //获取银行卡信息
       var card_info =  getsession('card_info');
       var temp_bank_ = {};
       if(card_info!=null){
          //alert(card_info.bkacctno_);
          temp_bank_ =  bank_like(card_info.bkacctno_);
       }
      

      if(card_info!=null){
         
         vue_modual.isShow = true;
         vue_modual.myInfo.id_ =card_info.id_;
         vue_modual.myInfo.bank_cardno_ = card_info.bkacctno_;
         vue_modual.myInfo.send_card_bank_ = temp_bank_.BANKNAME;
         vue_modual.myInfo.id_no_ = card_info.idno_;
         vue_modual.myInfo.name_ = card_info.cstmrnm_;
         vue_modual.myInfo.checked = true;
         vue_modual.myInfo.phone_ = card_info.user_phone_no_ ;
           
      }
               
      

      if (type == '1') {
       //点击更换银行卡跳过来的
         vue_modual.isDis = 1;
         vue_modual.isShow = true;
         vue_modual.myInfo.id_ =card_info.id_;
         vue_modual.myInfo.bank_cardno_ = card_info.bkacctno_;
         vue_modual.myInfo.send_card_bank_ = temp_bank_.BANKNAME;
         vue_modual.myInfo.id_no_ = card_info.idno_;
         vue_modual.myInfo.name_ = card_info.cstmrnm_;
         vue_modual.myInfo.checked = true;
         vue_modual.myInfo.phone_ = card_info.user_phone_no_ ;
               
      }else if(type == '2'){
               
       //点击未激活银行卡跳过来的
         vue_modual.isDis = 2;
         vue_modual.isShow = false;
         vue_modual.myInfo.id_ =card_info.id_;
         vue_modual.myInfo.bank_cardno_ = card_info.bkacctno_;
         vue_modual.myInfo.send_card_bank_ = temp_bank_.BANKNAME;
         vue_modual.myInfo.id_no_ = card_info.idno_;
         vue_modual.myInfo.name_ = card_info.cstmrnm_;
         vue_modual.myInfo.checked = true;
         vue_modual.myInfo.phone_ = card_info.user_phone_no_;
               
       }else{
        //添加银行卡
         //$.showPreloader();
         vue_modual.isDis = 3;
         vue_modual.isShow = true;
               
       }

       
    }

  
               
    //识别银行卡
    function likeCard(){
       //此方法定义在common.js中
       if(vue_modual.myInfo.bank_cardno_.length >= 3){
           var bankinfo = bank_like(vue_modual.myInfo.bank_cardno_);
               vue_modual.myInfo.send_card_bank_ = bankinfo.BANKNAME;
       }
    }



   //激活
   function submit1(){
       $.showPreloader('正在处理...');
       var post_adress = url_+'mobile/trade/bindBankQy.jhtml';
       var data = {
            id_:vue_modual.myInfo.id_
       }
        //alert(JSON.stringify(data));
       var temp_device = temp_userinfo.device_id_;
       var token = temp_userinfo.token_;
       AgreeSDK.Connection.getNetWorkRequest(post_adress, data,token,temp_device,function(data) {
              $.hidePreloader();
             if(data.appcode == 1){
                  //跳转
                  conserve('bing_card_info',data.data);
                 
                  $.router.load('./bindCard_tpl.html',true);
             }else{
                 $.toast('预签约失败：'+data.appmsg);
             }
       }, function(err) {
         $.hidePreloader();
         $.toast('网络请求失败！');
     });
               
   }
               
               
   

   
   //提交绑定银行卡
   function submit(){
	
      	if(valid()){
      		return;
      	}
           
      	var id_ = temp_userinfo.id_;
      	var phone_ = temp_userinfo.phone_;
        //var info = vue_modual.myInfo;//获取上边vue里的data
                     
        if(vue_modual.myInfo.checked == false){
              $.toast('请同意条款！',200);
        }
          
      	var post_adress = url_+'mobile/trade/bindBankKhYqy.jhtml'; //已改
      	//var post_adress = "http://localhost:8080/data/json_25.json";
        var bankinfo = bank_like(vue_modual.myInfo.bank_cardno_);
      	var data = {

      		member_id_:id_,
      		user_name_:vue_modual.myInfo.name_,
      		id_type_:'00',
      		id_no_:vue_modual.myInfo.id_no_,
      		mobile_phone_:vue_modual.myInfo.phone_,
      		bank_cardno_:vue_modual.myInfo.bank_cardno_,
      		send_card_bank_:bankinfo.BANKNAME

      	 };


      	
          $.showPreloader('正在处理...');
          //调用获取本地数据方法
           var temp_device = temp_userinfo.device_id_;
           var token = temp_userinfo.token_;
      	 AgreeSDK.Connection.getNetWorkRequest(post_adress, data,token,temp_device,function(data) {		
          	
               $.hidePreloader();
               
               if(data.appcode == 1) {
                  if(data.data.status_ == '0' || data.data.status_ == '2'){//
                    //alert(JSON.stringify(data.data));
                    conserve("bing_card_info",data.data);
                    conserve("card_info",data.data);
                    type = 2;

                    init();
                   setTimeout(function(){
                              likeCard();
                   },500);
                    
                    }else{

                        $.router.load('./cashAlreadyBound_tpl.html',true);
                    }

               }else{
                  
               	$.toast(data.appmsg);
               }

      	}, function(err) {
      		$.hidePreloader();
      		$.toast('网络请求失败！');
      	});
			
    }
//
//   if(GetQueryString('type') == "2") {
//
//         vue_modual.isShow = false;
//         var name = getsession('getName');
//         vue_modual.name = name;
//    }
//
//
//    //判断从绑定失败页面跳过来
//    if(GetQueryString('type') == "fail"){
//           
//        vue_modual.isShow =true;
//    }

    


    function valid(){

    	var info = vue_modual.myInfo;//获取上边vue里的data
    
    	if($.trim(info.id_no_) == ''){
    		$.toast('请输入身份证！',200);
    		return true;
    	}else if(info.id_no_.length != 18 ){
			$.toast('请输入正确的身份证！',200);
			return true;
    	}else if($.trim(info.bank_cardno_)== ''){
    		$.toast('请输入银行卡号！',200);
			return true;
    	}else if(info.bank_cardno_.length != 16 && info.bank_cardno_.length !=19 ){
    		$.toast('请输入正确的银行卡号！',200);
			return true;
    	}
    	return false;
    }


});
getDeviceName();
