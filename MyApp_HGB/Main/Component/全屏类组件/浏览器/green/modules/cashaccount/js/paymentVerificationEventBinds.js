$(document).on("pageInit", "#page-paymentVerification_tpl", function() {
      $('.div-custom-paymentlist span input').on('focus',function(e){
        var keyboardIsrandom = "1";
		AgreeSDK.Keyboard.open(keyboardIsrandom,function(msg){
		   alert(msg);
		}, function(err) {	
		   alert(err);
		});
      })
});
