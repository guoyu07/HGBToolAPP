$(document).on("pageInit", "#page-mobileContact_tpl", function() {


var temp_userinfo = {};
//存储一个全局变量
var vue_modual = {};
var vm = new Vue({
	el: '#page-mobileContact_tpl', //@绑定节点
	data: { //@数据	
         friend:[],
         isshow:false
	},
	methods: { //@方法-事件调用(this指向data)

	},
	created: function() { //@业务逻辑（this指向data）
		vue_modual = this;
		//初始化
		init();

	}
});

//界面初始化
function init() {

	temp_userinfo = getsession('userInfo');

   
	AgreeSDK.Contact.getMailList(function(msg) {
         
	     vue_modual.friend= msg;
         if(!msg){
         	vue_modual.isshow = true;
         }
	  
	}, function(err) {
	   alert(err);
	});


	

}
})
	/**
	 *  通讯录列表 js - start 
	 */
// 	function friend() {

// 		//var temp_url = "http://localhost:8080/data/json_5.json";
// 		var temp_url = url_ + "mobile/member/memList.jhtml";

// 		var temp_post_csh = {
//             phone_:vue_modual.input_val,
//             nick_name_:vue_modual.input_val

// 		};
// 		var temp_token = temp_userinfo.token_;
// 		var temp_deviceid = temp_userinfo.device_id_;

// 		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

// 			if(data.appcode == 1) {

// 				vue_modual.friend = data.data;

// 			}

// 			setTimeout(function() {

// 				list();

// 			}, 100);

// 		}, function(err) {
// 			$.toast('网络请求失败!');
// 		});
// 	}

// 	/**
// 	 *  城市列表 js - end 
// 	 */
		
//   function list(){
// 	//通讯录
// 	var indexList = $('.letters-nav');
// 	var LetterBox = $('.letter');

// 		initials();

// 	$(".letters-nav ul li").click(function() {
// 		var _this = $(this);
// 		var LetterHtml = _this.html();
// 		LetterBox.html(LetterHtml).show();

// 		setTimeout(function() {
// 			LetterBox.hide();
// 		}, 1000);
// 		var _index = _this.index();
// 		if(_index == 0) {
// 			$('.content').scrollTop(0);
// 		} else if(_index == indexList.find('ul').children().length - 1) {
// 			if($('#default').length > 0) {
// 				var DefaultTop = $('#default').position().top;
// 				$('.content').scrollTop(DefaultTop);
// 			}
// 		} else {
// 			var letter = _this.text();
// 			if($('#' + letter).length > 0) {
// 				var LetterTop = $('#' + letter).position().top;
// 				var aScrollTop = $('.content').scrollTop();
// 				$('.content').scrollTop(LetterTop + aScrollTop);
// 			}
// 		}
// 	})
//    }
// });

// //添加首字母标签分组重排
// function initials() {
// 	var SortList = $(".sort_list");
// 	var SortBox = $(".sort_list").parent();
// 	SortBox.append(SortList.sort(asc_sort)); //按首字母排序
// 	function asc_sort(a, b) {
// 		return $.getInitialsArrByStr($(b).find('.item-title').text().charAt(0))[0].toUpperCase() < $.getInitialsArrByStr($(a).find('.item-title').text().charAt(0))[0].toUpperCase() ? 1 : -1;
// 	}

// 	var initials = [];
// 	var num = 0;
// 	SortList.each(function(i) {
// 		var initial = $.getInitialsArrByStr($(this).find('.item-title').text().charAt(0))[0].toUpperCase();
// 		if(initial >= 'A' && initial <= 'Z') {
// 			if(initials.indexOf(initial) === -1)
// 				initials.push(initial);
// 		} else {
// 			num++;
// 		}

// 	});

// 	$.each(initials, function(index, value) { //添加首字母标签
// 		SortBox.append('<li class="list-group-title" id="' + value + '">' + value + '</li>');
// 	});
// 	if(num != 0) {
// 		SortBox.append('<li class="list-group-title" id="default"  style="line-height: 30px;">*</li>');
// 	}

// 	for(var i = 0; i < SortList.length; i++) { //插入到对应的首字母后面
// 		var letter = $.getInitialsArrByStr(SortList.eq(i).find('.item-title').text().charAt(0))[0].toUpperCase();
// 		switch(letter) {
// 			case "A":
// 				$('#A').after(SortList.eq(i));
// 				break;
// 			case "B":
// 				$('#B').after(SortList.eq(i));
// 				break;
// 			case "C":
// 				$('#C').after(SortList.eq(i));
// 				break;
// 			case "D":
// 				$('#D').after(SortList.eq(i));
// 				break;
// 			case "E":
// 				$('#E').after(SortList.eq(i));
// 				break;
// 			case "F":
// 				$('#F').after(SortList.eq(i));
// 				break;
// 			case "G":
// 				$('#G').after(SortList.eq(i));
// 				break;
// 			case "H":
// 				$('#H').after(SortList.eq(i));
// 				break;
// 			case "I":
// 				$('#I').after(SortList.eq(i));
// 				break;
// 			case "J":
// 				$('#J').after(SortList.eq(i));
// 				break;
// 			case "K":
// 				$('#K').after(SortList.eq(i));
// 				break;
// 			case "L":
// 				$('#L').after(SortList.eq(i));
// 				break;
// 			case "M":
// 				$('#M').after(SortList.eq(i));
// 				break;
// 			case "N":
// 				$('#N').after(SortList.eq(i));
// 				break;
// 			case "O":
// 				$('#O').after(SortList.eq(i));
// 				break;
// 			case "P":
// 				$('#P').after(SortList.eq(i));
// 				break;
// 			case "Q":
// 				$('#Q').after(SortList.eq(i));
// 				break;
// 			case "R":
// 				$('#R').after(SortList.eq(i));
// 				break;
// 			case "S":
// 				$('#S').after(SortList.eq(i));
// 				break;
// 			case "T":
// 				$('#T').after(SortList.eq(i));
// 				break;
// 			case "U":
// 				$('#U').after(SortList.eq(i));
// 				break;
// 			case "V":
// 				$('#V').after(SortList.eq(i));
// 				break;
// 			case "W":
// 				$('#W').after(SortList.eq(i));
// 				break;
// 			case "X":
// 				$('#X').after(SortList.eq(i));
// 				break;
// 			case "Y":
// 				$('#Y').after(SortList.eq(i));
// 				break;
// 			case "Z":
// 				$('#Z').after(SortList.eq(i));
// 				break;
// 			default:
// 				$('#default').after(SortList.eq(i));
// 				break;
// 		}
// 	};
// }
// getDeviceName();
