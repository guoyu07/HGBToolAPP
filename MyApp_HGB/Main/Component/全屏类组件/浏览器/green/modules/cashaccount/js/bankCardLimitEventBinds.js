$(document).on("pageInit", "#page-bankCardLimit_tpl", function () {
 	//存储一个全局变量
	var vue_modual = {};

	var temp_userinfo = {};
    temp_userinfo = getsession('userInfo');

   
	//存储一个全局变量
	var vm = new Vue({
		el: '#page-bankCardLimit_tpl', //@绑定节点
		data: { //@数据	 表单数据

           send_card_bank_:'',
           bkacctno_:'',
           BANKIMG:'',
           dayMonery:'',
           SingleMonery:''


		},
		methods: { //@方法-事件调用(this指向data)
          
         
		},
		created: function() { //@业务逻辑（this指向data）
	        
		     vue_modual = this;
             init();

              // vue_modual.myInfo.bank_cardno_ = '6217770004466979';
              // vue_modual.myInfo.send_card_bank_ = '南京银行';
              // vue_modual.myInfo.id_no_ = '342522199112033920';
              // vue_modual.myInfo.name_ = '俞璐';
              // vue_modual.myInfo.checked = true;
              // vue_modual.myInfo.phone_ = '18782104000';
		}
    });
    function init(){
      //获取银行卡信息
      var card_info =  getsession('card_info');
      var temp_bank_ =  bank_like(card_info.bkacctno_);
      if(card_info!=null){

         var temp_bank_ =  bank_like(card_info.bkacctno_);
         vue_modual.bkacctno_ = Transformation(card_info.bkacctno_);
         vue_modual.send_card_bank_ = temp_bank_.BANKNAME;
         vue_modual.BANKIMG = temp_bank_.BANKIMG;
         vue_modual.dayMonery = temp_bank_.dayMonery;
         vue_modual.SingleMonery = temp_bank_.SingleMonery;
      }
    }
    
});
