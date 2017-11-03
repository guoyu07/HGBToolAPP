$(document).on("pageInit", "#page-pushMessage_tpl", function() {
	$("#form_1").mvalidate({
		onKeyup : true, //支持键盘验证事件
		firstInvalidFocus : true,
		valid : function(event, options) {
			//点击提交按钮时,表单通过验证触发函数
		
			event.preventDefault();
		},
		invalid : function(event, status, options) {
			//点击提交按钮时,表单未通过验证触发函数
		},
		eachField : function(event, status, options) {
			//点击提交按钮时,表单每个输入域触发这个函数 this 执向当前表单输入域，是jquery对象
		},
		eachValidField : function(val) {
		},
		eachInvalidField : function(event, status, options) {
		}
	});

	$('#cardF').on('click', function() {
		//照相调用
		AgreeSDK.Media.camera(function(msg) {
			$('#cardF').attr('src', msg);
		}, function(err) {
			alert(err);
		})
	});
	$('#cardB').on('click', function() {
		//照相调用
		AgreeSDK.Media.camera(function(msg) {
			$('#cardB').attr('src', msg);
		}, function(err) {
			alert(err);
		})
	});
});
