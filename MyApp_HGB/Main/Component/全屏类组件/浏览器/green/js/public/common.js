//var url_ = 'http://192.168.43.173:10010/aos/';
//var url_ = 'http://192.168.89.20:10010/aos/';
var url_ = 'http://www.mylvzuan.com/aos/';
/**
 *  绿色积分发行账户id
 *  固定值
 */
//var ISSUER = 'r3kmLJN5D28dHuH8vZNUZpMC43pEHpaocV';
var ISSUER = 'rnfKMLZSThg6NXHmXD8nL7QZBfup73qAwp';

//分页数总大小
var LIMIT = 10;

var deviceid = '';


/** 
 *  支付socket 推送
 *  固定值
 */
var websocket_url = "ws://120.24.47.57:8181/";



function ALL_San(data) {
    
    if(data != null && data != '') {
        try {
            
            var temp_trad_info = JSON.parse(data);
            
            if(temp_trad_info.type != null && temp_trad_info != '' && temp_trad_info.type!=undefined) {
                jump_trad(temp_trad_info.type, temp_trad_info);
            } else {
                //识别失败
                $.alert(data);
                return
            }
        } catch(error) {
            //识别失败
            $.alert(error);
            return
        }
    } else {
        //识别失败
        $.alert("二维码内容为空！");
        return
    }
    
    //var type = data.type;
    //商户
    
}


function jump_trad(type, data) {
    //type = 1;
    if(type == '1') {
        //addr 由二维码给
        //mid 由二维码给
        var obj = {};
        obj.addr = data.addr;
        obj.mid = data.mid;
        obj.uid = data.uid;
        conserve('temp_payinfo',obj);
        $.router.load('../../modules/transferaccounts/cashTransferShops_tpl.html', true);
    }
    //好友 - 收钱码
    if(type == '2') {
        //从返回值中获取好友的ID
        ferFriendInfo(data.create_user_id, function() {
             $.router.load('../../modules/transferaccounts/cashTransferFriend_tpl.html?integral='+data.integral, true);
        });
        
    }
    //识别 个人二维码
    if(type == '3') {
        
        $.router.load('../../modules/transferaccounts/friendInformation_tpl.html?dataid='+data.create_user_id, true);
    }
}


//查询好友详情
function ferFriendInfo(arg_friends_id_, callback) {
    var temp_userinfo = getsession("userInfo");
    var temp_url = url_ + "mobile/friends/friendsDetail.jhtml";
    
    var temp_post_csh = {
         friends_id_: arg_friends_id_
    };
    
    //temp_post_csh = JSON.stringify(temp_post_csh);
    var temp_token = temp_userinfo.token_;
    var temp_deviceid = temp_userinfo.device_id_;
    
    AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
        //alert("::"+JSON.stringify(data));
       if(data.appcode == 1) {
                                          
          conserve('friend_Infos', data.data);
          callback();
        }
                                          
        }, function(err) {
           $.toast('网络请求失败!');
        });
    
}




// if(userInfo != null && userInfo!= ""){
// 		successcallback(userInfo);
// 	}else{
// 		AgreeSDK.FilePlugin.getDefaults("userInfo", function(data) {
// 			succescallback(JSON.parse(data));
// 		},function(msg){
// 			errorcallback(msg);
// 		});
// 	}

//获取本地文件
function getFile(key,successcallback,errorcallback){
    
    AgreeSDK.FilePlugin.getDefaults(key, function(data) {
                                    //alert("1111:::" + data);
        var temp_json = JSON.parse(data);
        successcallback(temp_json);
    },function(msg){
             errorcallback(msg);
         
    });
}

//保存文件
function saveFile(key,model,successcallback,errorcallback){
  AgreeSDK.FilePlugin.saveDefaults(key, JSON.stringify(model), function(msg) {
     successcallback();
  },function(msg){
      errorcallback(msg);
  });
}

//获取session
function  getsession(keyStr){
	return  JSON.parse(sessionStorage.getItem(keyStr));
}



//存储session
function  conserve(keyStr,arg_data){
	sessionStorage.setItem(keyStr, JSON.stringify(arg_data));
}


//获取设备插件
function getDeviceName(){
	AgreeSDK.Device.getDeviceName(function(msg) {
	   var device_id_ = msg;
	   conserve("device_id_",device_id_);
	}, function(err) {
	  alert("获取设备标识异常");
	});
}

//验证
function CHECK(arg_val){
    var temp_val = $.trim(arg_val);
    if(temp_val != undefined  &&  temp_val!=null && temp_val != ''){
        return true;
    }else{
        return false;
    }
}


/**
 * 统一支付
 * lastLedgerIndexPay_ 区块链交易高度
 * tx_blob_ 签名数据
 * service_key_ 商户唯一标识key
 * temp_trade_no_ 临时交易号
 * p_amount_ 积分金额
 * r_amount_ 现金金额
 * order_total_ 订单总金额
 * r_type_ 现金支付类型 
 *
 */
function SDKPay(arg_data,successcallback,errorcallback){
	//调用区块链高度
	SDKsequence_Ledger(arg_data,function(SDKsequence_data){
        //alert("gd:"+JSON.stringify(SDKsequence_data));
		//当积分为0 不需要签名
		if(arg_data.pay.p_amount_ != 0){
			//调用签名
			SDKSign(SDKsequence_data,function(SDKSign_data){
				//发起支付
				pay(SDKSign_data,function(data){
					successcallback(data);
				},function(error){
					errorcallback(error);
				});

			},function(error){
				errorcallback(error);
			});
		}else{
         
            //alert("12:"+JSON.stringify(SDKsequence_data));
            pay(SDKsequence_data,function(data){
                successcallback(data);
            },function(error){
                errorcallback(error);
            });
           
		}
	},function(error){
		errorcallback(error);
	})
}

//积分转账,总入口
function SDKPay_Point(arg_data,successcallback,errorcallback){
	
	//调用区块链高度
	SDKsequence_Ledger(arg_data,function(SDKsequence_data){
		//alert('qk:'+SDKsequence_data);
		//当积分为0 不需要签名
		if(arg_data.pay.p_amount_ != 0){
			//调用签名
			SDKSign(SDKsequence_data,function(SDKSign_data){
				//alert('sign:'+SDKSign_data);
				//发起支付
				pay_point(SDKSign_data,function(data){
					successcallback(data);
				},function(error){
					errorcallback(error);
				});

			},function(error){
				errorcallback(error);
			});
		}
	},function(error){
		errorcallback(error);
	})
}

/**
 * 调用区块链高度
 * phone
 * token
 * deviceid
 */
function SDKsequence_Ledger(arg_data,successcallback,errorcallback){
    //alert("SDKsequence_Ledger:"+JSON.stringify(arg_data));
	var temp_url = url_ + "mobile/member/memberChainsqlHeight.jhtml";
	//var temp_url = "http://localhost:8080/data/json_5.json";
	var temp_post_csh = {
		phone_:arg_data.userinfo.phone_
	};
	var temp_token = arg_data.userinfo.token;
	var temp_deviceid = arg_data.userinfo.deviceid;
    //alert("3222:"+JSON.stringify(temp_post_csh));
	AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
		//alert("123:"+JSON.stringify(data));
		//接口调用成功
		if(data.appcode == 1){
			arg_data.ledger = {};
			arg_data.ledger["sequence_"] = data.data.sequence_;
			arg_data.ledger["lastLedgerIndex_"] = parseInt(data.data.lastLedgerIndex_) + 5;
            //arg_data.ledger["lastLedgerIndex_"] = 5;
			successcallback(arg_data);

		}else{
			errorcallback(data);
		}
	},function(error){
		errorcallback(error);
	});
}

/**
 * 调用签名
 * 
 */
function SDKSign(arg_data,successcallback,errorcallback){

	arg_data.signinfo = {};
	//转账源账户id
	arg_data.signinfo.Account = arg_data.userinfo.block_chain_addr_;
	arg_data.signinfo.Amount = {
		currency:"GRD",
		issuer:ISSUER,
		value:arg_data.pay.p_amount_
	};
	//转账目标账户id
	arg_data.signinfo.Destination = arg_data.pay.destination;
	arg_data.signinfo.Fee = "10";
	arg_data.signinfo.LastLedgerSequence = parseInt(arg_data.ledger.lastLedgerIndex_);
	arg_data.signinfo.Sequence = parseInt(arg_data.ledger.sequence_);
	arg_data.signinfo.TransactionType = "Payment";
	//alert("sign:"+JSON.stringify(arg_data.signinfo));
	//签名对象
    var txjson = {
        tx_json:arg_data.signinfo
    }
    var tx_json_str =JSON.stringify(txjson);
    //tx_json_str = tx_json_str.substr(1,tx_json_str.length-2);
	var sign_info = {
		json:arg_data.signinfo,
		key:getsession("private_key")
	}
    //alert("sign:"+JSON.stringify(sign_info));
	//签名SDK
	AgreeSDK.SIGN.sign(sign_info,function(data){
		arg_data.signinfo.sign = data;
		successcallback(arg_data);
	},function(error){
		errorcallback(error);
	});
}

//支付方法体
function pay(arg_data,successcallback,errorcallback){
    //alert("pay::"+JSON.stringify(arg_data));
	//console.log("::"+JSON.stringify(arg_data));
	var temp_url = url_ + "mobile/scancode/memPayment.jhtml";
    
	var temp_post_csh = {
		lastLedgerIndexPay_:arg_data.ledger.lastLedgerIndex_ +"",
		service_key_:arg_data.pay.service_key_+"",
		p_amount_:arg_data.pay.p_amount_ + "",
		r_amount_:arg_data.pay.r_amount_ + "" ,
		r_type_:arg_data.pay.r_type_,
        key:getsession("private_key")
	};
    
    if(arg_data.order_total_!= undefined ){
        temp_post_csh["order_total_"] = arg_data.order_total_ + ""
    }
    //alert("pay:"+JSON.stringify(temp_post_csh));
	//当只用积分时才需要签名
	if(arg_data.signinfo !=null && arg_data.signinfo != ''){
		temp_post_csh["tx_blob_"] = arg_data.signinfo.sign + "";
	}
   
	if(arg_data.pay.temp_trade_no_ != undefined && arg_data.pay.temp_trade_no_!=null && ""!=arg_data.pay.temp_trade_no_){
		temp_post_csh["temp_trade_no_"] = arg_data.pay.temp_trade_no_ + "";
	}else{
		temp_post_csh["temp_trade_no_"] = "";
	}
    
	var temp_token = arg_data.userinfo.token_;
	var temp_deviceid = arg_data.userinfo.device_id_;
    //alert(JSON.stringify(temp_post_csh));

	AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
                                          
		//接口调用成功
		successcallback(data);
		
	},function(error){
                                          
		errorcallback(error);
	});

}


//积分转账方法体
function pay_point(arg_data,successcallback,errorcallback){

	//console.log("::"+JSON.stringify(arg_data));
	
	var temp_url = url_ + "mobile/trade/pointTrans.jhtml";
	//alert(JSON.stringify(arg_data));
	var temp_post_csh = {
		lastLedgerIndexPay_:arg_data.ledger.lastLedgerIndex_ +"",
		pay_phone_:arg_data.pay_point.pay_phone_,
		get_phone_:arg_data.pay_point.get_phone_,
		tx_blob_:arg_data.signinfo.sign,
		amount_:arg_data.pay.p_amount_

	};
	//alert(JSON.stringify(temp_post_csh));
	var temp_token = arg_data.userinfo.token_;
	var temp_deviceid = arg_data.userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
		//alert(JSON.stringify(data));
		//接口调用成功
		if(data.appcode == 1){
			successcallback();
		}else{
			errorcallback(data);
		}
	},function(error){
		errorcallback(error);
	});

}

/**
 * 四舍五入计算 
 */
function changeTwoDecimal(x){
	var f_x = parseFloat(x);
	if (isNaN(f_x)){
		//alert('function:changeTwoDecimal->parameter error');
		return false;
	}
	f_x = Math.round(f_x *100)/100;
	return f_x;
}

//银行卡号转换
function Transformation(arg_no){
		arg_no = arg_no.replace(/[\s]/g, '').replace(/(\d{4})(?=\d)/g, "$1 ");

		var temp_no = '';
		for(var i = 0 ; i < arg_no.length ; i ++){

			if(i < 14){
				if(arg_no[i] == ' '){
					temp_no = temp_no + ' ';
				}else{
					temp_no = temp_no + '*';
				}
			}else{

				temp_no = temp_no + arg_no[i];
			}
		}

		return temp_no;
	}

// var temp_user = {
// 	phone_: '18866666666',
// 	token_: '1',
// 	device_id_: '111',
// 	user_id_: '3',
// 	member_card_key_:'1111',
// 	block_chain_addr_:'rwySGiZWBGAGsdGzCt2sMdn9htE1vDGtP8',
// 	id_:'e8c794dac42346a28686a06ee8ec3192',
// 	real_name_:'111',
// 	image_:'1.jpg',
// 	mobile_code:'1111'

// };

//conserve('userInfo',temp_user);

getDeviceName();

//推送消息
function  pushMessage(id_){

   var temp_userinfo = getsession('userInfo');

   if(temp_userinfo!=''){
   	   var temp_url = "http://localhost:8080/data/json_1.json";
   	   //var temp_url = url_ + "";
	   var temp_post_csh = {
			id:id_
	   };
	   var temp_token = temp_userinfo.token_;
	   var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
			//接口调用成功
			if(data.appcode == 1){
				var messagelist = getsession('AllmessageList');
				if(messagelist == '' || messagelist == null){
					var messageList = new Array();
					messageList.push(data.data[0]);
					conserve('AllmessageList',messageList);
					
				}else{
					messagelist.push(data.data[0]);
					conserve('AllmessageList',messagelist);
				}
				
			}else{
				
			}
		},function(error){
			
		});
   }
   
}
//1.count 数量
//2.list 数量
//3.回调
function page_manage(arg_count,arg_list_length,successcallback,callback){
    if(arg_count > arg_list_length){
        successcallback();
    }else{
        //预留当总数小于列表的数才执行回调
        callback();
    }
}

//1.
function net_result_page(data,arg_modual){
   
    if(data.appcode == 1) {
        
        if( arg_modual.start != 0) {
            for(var i = 0; i < data.data.length; i++) {
                arg_modual.list.push(data.data[i]);
            }
        } else {
            arg_modual.list = data.data;
        }
        if(data.count > arg_modual.list.length){
            //down_bool = true;
            arg_modual.page= arg_modual.page + 1;
            arg_modual.start= arg_modual.start + LIMIT;
            arg_modual.bool = true;
        }else{
           // down_bool = false;
            arg_modual.bool = false;
        }
    }
    
}



//检测银行卡自动识别
function bank_like(arg_no){
    var comm_bank_items = [];
    var bankinfo = {};
    //BANK_ITEMS 定义在bank.js中
    for(var i = 0 ; i < BANK_ITEMS.length; i++){
        if(arg_no.indexOf(BANK_ITEMS[i].CARDBINNO)==0){
            comm_bank_items.push(BANK_ITEMS[i]);
        }
    }
    //排序
    for(var i = 0 ; i < comm_bank_items.length; i ++){
        for(var j = 0 ; j < comm_bank_items.length - i - 1;  j++){
            var temp_1 = parseInt(comm_bank_items[j].size);
            var temp_2 = parseInt(comm_bank_items[j+1].size);
            if (temp_1 < temp_2) {
                var temp = comm_bank_items[j];
                comm_bank_items[j] = comm_bank_items[j+1];
                comm_bank_items[j+1] = temp;
            }
        }
    }
    
    if(comm_bank_items.length > 0){
        bankinfo = comm_bank_items[0];
    }
    return bankinfo;
}




// input_keyword = $('#input_keyword').val();
//获取本地的秘钥，如果没有调查询秘钥接口然后再掉解密钥插件
	 //    AgreeSDK.FilePlugin.getDefaults('keys',function(msg) {
		// 	alert(msg);
		// 	var keys = msg;
		// 	if(!keys){
		// 		var post_adress = url_ + "mobile/member/memberSecret.jhtml";
		// 		//var phones = $("#registe_phone").val();
		// 		var data = {
		// 			phone_: phone
		// 		};
		// 		data = JSON.stringify(data);
		// 		//调用设备名称插件
		// 		device();
		// 		AgreeSDK.Connection.getNetWorkRequest(post_adress, data, token, deviceid, function(msg) {
		// 			alert(msg);
		// 			var dataList = JSON.parse(msg);
		// 			//解密插件调用
		// 			AgreeSDK.RSTFileDecrypt(getString,function(msg) {
		// 			   alert(msg);
		// 			}, function(err) {
		//                alert(error);
		// 			});

		// 		}, function(err) {
	 //               alert('网络请求失败！');
		// 		});
	           
		// 	}
		// },function (msg) {
		// 	alert(error);
		// })
