//var isEmpty = function() {
//	var username = $("#login_name").val();
//	var psd = $("#login_password").val();
//	if (username && psd) {
//		$("#btn_login").removeClass('unaction');
//	} else {
//		$("#btn_login").addClass('unaction');
//	}
//};
$(document).on("pageInit", "#page-collectionRecords_tpl", function() {
	//	$("input").on('input propertychange change', function() {
	//		isEmpty();
	//	});
	//
	//	$("#form_1").mvalidate({
	//		onKeyup : true, //支持键盘验证事件
	//		firstInvalidFocus : true,
	//		valid : function(event, options) {
	//			//点击提交按钮时,表单通过验证触发函数
	//			$.alert("验证通过！接下来可以做你想做的事情啦！");
	//			event.preventDefault();
	//		},
	//		invalid : function(event, status, options) {
	//			//点击提交按钮时,表单未通过验证触发函数
	//		},
	//		eachField : function(event, status, options) {
	//			//点击提交按钮时,表单每个输入域触发这个函数 this 执向当前表单输入域，是jquery对象
	//		},
	//		eachValidField : function(val) {
	//		},
	//		eachInvalidField : function(event, status, options) {
	//		}
	//	});

});