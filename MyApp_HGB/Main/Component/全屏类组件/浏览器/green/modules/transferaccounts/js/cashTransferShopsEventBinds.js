$(document).on("pageInit", "#page-cashTransferShops_tpl", function() {
    //var addr = GetQueryString("addr");
    //var mid = GetQueryString("mid");
    //var uid = GetQueryString("uid");
              
	var vue_modual = {};
    var temp_payInfo = getsession('payInfo');
    
	//双向数据绑定对象
	var vm = new Vue({
		el: '#page-cashTransferShops_tpl', //@绑定节点
		data: { //@数据
			obj:{
				amount:0
			},
             isShow:false
		},
		methods: { //@方法-事件调用(this指向data)

			//点击支付按钮
			onPay:function(){
				pay_sumbmit();
			},
            pull_goback:function(){
                $.router.load('../../modules/home/home_tpl.html',true);
            },
			//输入
			onAmountFocus:function(){
				if(this.obj.amount == 0){
					this.obj.amount = '';
				}
			}
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			
			//初始化
			init();

		}
	});
               
               
    function init(){
       
       var userinfo = getsession('userInfo');
       

       if(temp_payInfo==null || temp_payInfo=='' || temp_payInfo==undefined || temp_payInfo.temp == "temp"){
           var temp_payinfo_1 = getsession('temp_payinfo');
           var addr ='';
           var mid ='';
           var uid = '';
           if(temp_payinfo_1!=null){
               addr = temp_payinfo_1.addr;
               mid = temp_payinfo_1.mid;
               uid = temp_payinfo_1.uid;
           }
           //创建临时交易号
           if(mid!=null){
               
               var temp_url = url_ + "mobile/scancode/tempTradeno.jhtml";
               var temp_post_csh = {
                   member_phone_:userinfo.phone_
               };
               var temp_token = userinfo.token;
               var temp_deviceid = userinfo.device_id_;
               
               AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
                                                     
                 //生成临时交易号
                 if(data.appcode == 1){
                     temp_payInfo = {};
                     //商户唯一标示
                     temp_payInfo.service_key_ = mid;
                     //
                     //payInfo.order_total_ = "";
                     //区块链地址
                     temp_payInfo.merchant_addr_ = addr;
                     //临时交易号
                     temp_payInfo.temp_trade_no_ = data.data.trade_no_;
                     //
                     temp_payInfo.uid = uid;
                     temp_payInfo.temp = "temp";
                     //显示按钮
                     vue_modual.isShow = true;
                     
                     }else{
                        $.toast(data.appmsg);
                     }
                 },function(error){
                     $.toast('网络请求失败!');
               });
               
              
               }else{
               
               }
       }
    }

	function pay_sumbmit(){
		
		if(vue_modual.obj.amount == ''){
			$.alert('请输入金额');
			return;
		}
		if(vue_modual.obj.amount < 0){
			$.alert('不能输入负数');
			return;
		}
		var temp_amount = changeTwoDecimal(vue_modual.obj.amount);
		if(temp_amount == 0){	
			$.alert('请输入大于0的金额');
			return;
		}
               
        
        pay();
        
        
	}
               
    function pay(){
               
        temp_payInfo.order_total_  = changeTwoDecimal(vue_modual.obj.amount);
        //payInfo 下包含
        //
        //
        if(temp_payInfo!=null && ""!=temp_payInfo){
               //将录入的值存储到该变量下
               temp_payInfo.amount = vue_modual.obj.amount;
               //存储
               conserve('payInfo',temp_payInfo);
               $.router.load('./shopsUser_tpl.html',true);
        }
    }

});

