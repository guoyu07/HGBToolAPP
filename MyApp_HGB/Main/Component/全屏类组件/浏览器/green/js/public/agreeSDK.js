/**
 * agreesdk create at 2016/10/7.
 */
var AgreeSDK = {};
AgreeSDK.QRCode = {};
AgreeSDK.Geolocation = {};
AgreeSDK.Media = {};
AgreeSDK.Device = {};
AgreeSDK.Connection = {};
AgreeSDK.FileSystem = {};
AgreeSDK.Contact = {};
AgreeSDK.Notification = {};
AgreeSDK.Anyoffice = {};
AgreeSDK.Bioassay = {};
AgreeSDK.OCRScan = {};
AgreeSDK.Share = {};
AgreeSDK.Keyboard = {};
AgreeSDK.VideoTalk = {};
AgreeSDK.BankCard = {};
AgreeSDK.WebView = {};
AgreeSDK.App = {};
AgreeSDK.Statistics = {};
AgreeSDK.CodeScanPlugin = {};
AgreeSDK.MakeImgPlugin = {};
AgreeSDK.PwdLockPlugin = {};
AgreeSDK.KeybordPlugin = {};
AgreeSDK.EncryptPlugin = {};
AgreeSDK.LocationPlugin = {};
AgreeSDK.NetWorkPlugin = {};
AgreeSDK.FingerprintPlugin = {};
AgreeSDK.FilePlugin = {};
AgreeSDK.RSTFileDecrypt = {};
AgreeSDK.SIGN = {};
AgreeSDK.isPC = {};
AgreeSDK.incrementalUpdating= {};
//PC 调试专用，模拟插件在电脑无法调用，默认给定在真机的正常值
//AgreeSDK.getTestDefaults = {};

function GetQueryString(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
		var r = window.location.search.substr(1).match(reg);
		if(r != null)
			return unescape(r[2]);
		return null;
}

/*
 * @brief  签名
 * @return 返回签名
 */
AgreeSDK.SIGN.sign = function(data_json,successCallback, failureCallback) {
	var isPC = AgreeSDK.isPC();
    if(!isPC){
		cordova.exec(successCallback, failureCallback, 'AutographPlugin', 'autograph', [data_json]);
	}else{
		successCallback("模拟的返回签名后的字符串");
	}
}


/*
 * @brief  二维码扫描
 * @return 返回二维码内置的字符串
 */
AgreeSDK.QRCode.scan = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'ScanPlugin', 'scanCode', []);
}
/*
 * @brief  获取当前地理位置信息(普通定位)
 * @return  返回JSONObject：checkAddr:'地址',lon:'经度',lat:'纬度'
 */
AgreeSDK.Geolocation.getLocationInfo = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'LocationPlugin', 'LocationInfo', []);
}
/*
 * @brief  打开地图，手动定位地理位置信息
 * @return 返回JSONObject checkAddr:'地址',lon:'经度',lat:'纬度'
 */
AgreeSDK.Geolocation.openMap = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'LocationPlugin', 'openMap', []);
}
/*
 * @brief  调用照相机功能组件
 * @return  返回图片地址
 */
AgreeSDK.Media.camera = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'MediaPlugin', 'camer', []);
}
/*
 * @brief  调用本地图库功能组件
 * @return  返回图片地址
 */
AgreeSDK.Media.picture = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'MediaPlugin', 'picture', []);
}
/* @brief  图片加水印功能
 ** @param：
 imagePath    图片路径
 img_text     水印内容
 textsize     水印文字大小(单位:px)
 location     控制水印位置：(1-左上角，2-左下角，3-右上角－4右下角)
 * */
AgreeSDK.Media.watermark = function(imagePath, img_text, textsize, location, successCallback, failureCallback) {
	var watermark = {
		imagePath: imagePath,
		text: img_text,
		textsize: textsize,
		location: location
	};
	cordova.exec(successCallback, failureCallback, 'MediaPlugin', 'watermark', [watermark]);
}
/* @brief  调用录音功能
 * */
AgreeSDK.Media.audio = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'MediaPlugin', 'audio', []);
}
/* @brief  创建txt文件
 * */
AgreeSDK.Media.createFile = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'MediaPlugin', 'createFile', []);
}
/*
 * @brief  获取设备屏幕分辨率
 * @param：
 *      infoParam :
 *      1.代表屏幕分辨率
 * @return 返回JSONArray数组（数组第一个值为宽，数组第二个值为高）
 */
AgreeSDK.Device.getScreenResolution = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DevicePlugin', 'getResolution', []);
}
/*
 * @brief  获取设备信息IMEI（设备唯一标识）
 * @return 返回字符串
 */
AgreeSDK.Device.getIMEI = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DevicePlugin', 'getIdentification', []);
}
/*
 * @brief  获取设备厂商
 * @return 返回字符串
 */
AgreeSDK.Device.getDeviceFirm = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DevicePlugin', 'getEquipment', []);
}
/*
 * @brief  获取设备名称
 * @return 返回字符串
 */
AgreeSDK.Device.getDeviceName = function(successCallback, failureCallback) {
	 var isPC = AgreeSDK.isPC();
     if(!isPC){
		cordova.exec(successCallback, failureCallback, 'DevicePlugin', 'getDeviceName', []);
	 }else{
	 	return successCallback('');
	 }
	
}
/*
 * @brief  获取APP名称
 * @return 返回字符串
 */
AgreeSDK.Device.getAPPName = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DevicePlugin', 'getAPPName', []);
}
/*
 * @brief  获取手机号
 * @return 返回字符串
 */
AgreeSDK.Device.getPhoneNum = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DevicePlugin', 'getPhoneNumber', []);
}
/*
 * @brief  打电话组件
 * @param
 phoneNum  要拨打的号码
 * @return 返回成功标识
 */
AgreeSDK.Device.callPhone = function(phoneNum, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'CallPhonePlugin', 'getCallPhone', [phoneNum]);
}
/*
 * @brief  获取设备系统版本号
 * @return 返回字符串
 */
AgreeSDK.Device.getSysVersion = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DevicePlugin', 'getSystemNumber', []);
}
/*
 * @brief  网络请求
 * @param    post请求：
 post_adress	地址
 post_csh	上送参数
 * @return  JSON字符串
 */
AgreeSDK.Connection.getNetWorkRequest = function(post_adress, post_csh, token, deviceid,successCallback, failureCallback) {
    //alert(post_adress);
	var Post_obj = {
		post_adress: post_adress,
		post_parameter:JSON.stringify(post_csh),
		token:token,
		deviceid:deviceid

	};
	var isPC = AgreeSDK.isPC();
    if(!isPC){
　　　　　　　 //执行移动端要执行的代码
//       $.ajax({
//                type: "post",
//                url: post_adress,
//                async: false,
//                data: JSON.stringify(post_csh),
//                contentType: "application/json; charset=utf-8",
//                dataType: "json",
//                success: function(data) {
//                    successCallback(data);
//                    console.log(data);
//
//
//                },
//                error: function(data) {
//                    failureCallback(data);
//                    console.log('error');
//                }
//            });
        //if(post_adress.indexOf("memLogin")!=-1 || post_adress.indexOf("friendsList")!=-1){
            cordova.exec(successCallback, failureCallback, 'NetworkPlugin', 'getNetwork_green', [Post_obj]);
        //}
        
        console.log("移动端接口调用");
    }else{
    	$.ajax({
				type: "post",
				url: post_adress,
				async: false,
				data: JSON.stringify(post_csh),
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(data) {

					successCallback(data);
					console.log(data);
					

				},
				error: function(data) {
					failureCallback(data);
					console.log('error');
				}
			});
    }
	
}
//二维码扫描
AgreeSDK.CodeScanPlugin.scanCode = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'CodeScanPlugin', 'scanCode', []);
}
//解密
AgreeSDK.RSTFileDecrypt = function(getString,successCallback, failureCallback) {
	var Post_obj = {
		 getString:getString

	};
	cordova.exec(successCallback, failureCallback, 'NetworkPlugin', 'RSTFileDecrypt', [Post_obj]);
}
//国家解密
AgreeSDK.EncryptPlugin.TTAlgorithmSM4Decrypt = function(string,key,successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'EncryptPlugin', 'TTAlgorithmSM4Decrypt ', [string,key]);
}
//加密
AgreeSDK.RSTFileEncrypt = function(getString,successCallback, failureCallback) {
	var Post_obj = {
		 getString:getString

	};
	cordova.exec(successCallback, failureCallback, 'NetworkPlugin', 'RSTFileEncrypt', [Post_obj]);
}
//二维码生成请求
AgreeSDK.MakeImgPlugin.MakeQrCode  = function(key,successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'MakeImgPlugin', 'MakeQrCode', [key]);
}
//条形码生成请求
AgreeSDK.MakeImgPlugin.MakeBarCode  = function(key,successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'MakeImgPlugin', 'MakeBarCode', [key]);
}
//设置九宫格密码
AgreeSDK.PwdLockPlugin.SetPwdLock  = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'PwdLockPlugin', 'SetPwdLock', []);
}
//解锁九宫格密码
AgreeSDK.PwdLockPlugin.DecryptLock  = function(key,successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'PwdLockPlugin', 'DecryptLock', [key]);
}
//自定义键盘
AgreeSDK.KeybordPlugin.onKeyboard  = function(status,key,successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'KeybordPlugin', 'onKeyboard', [status,key]);
}
//地理位置    直接定位
AgreeSDK.LocationPlugin.LocationInfo  = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'LocationPlugin', 'LocationInfo', []);
}
//地理位置    地图定位
AgreeSDK.LocationPlugin.openMap  = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'LocationPlugin', 'openMap', []);
}
//地理位置    经纬度转换
AgreeSDK.LocationPlugin.translocation  = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'LocationPlugin', 'translocation', [{'lat':'23','lng':'123'}]);
}
//文件保存
AgreeSDK.FilePlugin.saveFile  = function(docPath,docName,successCallback, failureCallback) {
 cordova.exec(successCallback, failureCallback, 'FilePlugin', 'saveFile', [docPath,docName]);
}
//文件获取
AgreeSDK.FilePlugin.getFile  = function(docName,getType,successCallback, failureCallback) {
    cordova.exec(successCallback, failureCallback, 'FilePlugin', 'getFile', [docName,getType]);
}
//偏好文件获取
AgreeSDK.FilePlugin.getDefaults  = function(key,successCallback, failureCallback) {
    // var isPC = AgreeSDK.isPC();
    // if(!isPC){
		cordova.exec(successCallback, failureCallback, 'FilePlugin', 'getDefaults', [key]);
	// }else{
	// 	//return successCallback(AgreeSDK.getTestDefaults("FilePlugin.getDefaults"));
	// 	return successCallback('');
	// }

}
//偏好文件保存
AgreeSDK.FilePlugin.saveDefaults   = function(key,string,successCallback, failureCallback) {
    // var isPC = AgreeSDK.isPC();
    // if(!isPC){
		cordova.exec(successCallback, failureCallback, 'FilePlugin', 'saveDefaults', [key,string]);
	// }else{
	// 	// return successCallback(AgreeSDK.getTestDefaults("FilePlugin.saveDefaults"));
	// 	return successCallback('');
	// }

}
//指纹解锁
AgreeSDK.FingerprintPlugin.fingerprinUnlock   = function(successCallback, failureCallback) {
    cordova.exec(successCallback, failureCallback, 'FingerprintPlugin', 'fingerprinUnlock', []);
}
//获取指纹解锁权限
AgreeSDK.FingerprintPlugin.getJurisdiction   = function(successCallback, failureCallback) {
    cordova.exec(successCallback, failureCallback, 'FingerprintPlugin', 'getJurisdiction', []);
}
 //文件上传
AgreeSDK.NetWorkPlugin.postNetWork = function(successCallback, failureCallback) {
    cordova.exec(successCallback, failureCallback, 'NetWorkPlugin', 'postNetWork', []);
}
 //post请求
AgreeSDK.NetWorkPlugin.postNetWork = function(successCallback, failureCallback) {
    //cordova.exec(successCallback, failureCallback, 'NetWorkPlugin', ' postNetWork', ['url','{'name':'huang'}']);
}
 //get请求
AgreeSDK.NetWorkPlugin.postNetWork = function(successCallback, failureCallback) {
    cordova.exec(successCallback, failureCallback, 'NetWorkPlugin', 'postNetWork', ['url']);
}
/*
 * @brief  获取当前网络状态
 * @return ：
 * 		-1：没有网络
 1：wifi网络
 2：手机网络
 0：未知状态
 */
AgreeSDK.Connection.getNetWorkState = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'NetworkPlugin', 'getNetInfo', []);
}
/*
 * @brief  文件系统（文件上传）
 * @param：
 tabfile		文件目录
 tabname		文件名字
 tabtype 	文件类型
 postadress	上送地址（不支持base64只支持数据流）
 * @return 返回url字符串
 */
AgreeSDK.FileSystem.upload = function(tabfile, tabname, tabtype, postadress, successCallback, failureCallback) {
	var uploadObject = {
		tabfile: tabfile,
		tabname: tabname,
		tabtype: tabtype,
		postadress: postadress
	};
	cordova.exec(successCallback, failureCallback, 'FilesPlugin', 'filesUpload', [uploadObject]);
}
/*
 * @brief  文件系统（文件下载）
 * @param：
 downloadfile	下载存储目录
 downloadname	下载存储名字
 downloadadress	下载地址
 * @return 返回成功或失败
 */
AgreeSDK.FileSystem.download = function(downloadfile, downloadname, downloadadress, successCallback, failureCallback) {
	var downloadObject = {
		downloadfile: downloadfile,
		downloadname: downloadname,
		downloadadress: downloadadress
	};
	cordova.exec(successCallback, failureCallback, 'FilesPlugin', 'filesDownload', [downloadObject]);
}
/*
 * @brief  文件系统（文件删除）
 * @param  filesDelete	删除目录或文件
 * @return 返回成功或失败
 */
AgreeSDK.FileSystem.delete = function(filesDelete, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'FilesPlugin', 'filesDelete', [filesDelete]);
}
/*
 * @brief  文件系统（获取存储空间）
 * @return 字符串（容量）
 */
AgreeSDK.FileSystem.storage = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'FilesPlugin', 'filesStorage', []);
}

/*
 * @brief   文件解压
 * @param   isDefault	 是否使用默认路径( 0:为不使用，1：为使用，默认值为1，非必填)
 *          fileUrl      解压源文件的路径（isDefault为0时，需填写完整路径；否则只填写压缩文件的名称）
 *          outputUrl    解压后的存放位置（不传将采用默认路径，非必填）
 * @return  成功返回“解压成功”；失败返回错误原因的字符串
 */
AgreeSDK.FileSystem.decompression = function(isDefault, fileUrl, outputUrl, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'FilesPlugin', 'filesDecompression', [isDefault, fileUrl, outputUrl]);
}

/*
 * @brief  通讯录
 * @return 返回数组：
 name	 姓名
 number	 电话号码
 */
AgreeSDK.Contact.getMailList = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'MailListPlugin', 'getMailList', []);
}
/*
 *  以下为js中可监听到的事件
 *  jpush.openNotification      点击推送消息启动或唤醒app
 *  jpush.setTagsWithAlias      设置标签、别名完成
 *  jpush.receiveMessage        收到自定义消息
 *  jpush.receiveNotification   前台收到推送
 *  jpush.backgroundNotification 后台收到推送
 */
AgreeSDK.Notification.init = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'JPushPlugin', 'init', []);
}

var getMessage = function(JPushName, JPushContent) {
	alert("JPushName" + JPushName);
	alert("JPushContent" + JPushContent);
}

/*************** anyoffice ****************/
/*
 * @brief  init（环境初始化）
 * @param：
 workPath	工作目录
 username	用户名
 * @return 	Android：首次返回0成功，之后返回-10004成功
 * 			IOS：返回1成功
 */
AgreeSDK.Anyoffice.getInit = function(workPath, username, successCallback, failureCallback) {
	var getInitObject = {
		workPath: workPath,
		username: username
	};
	cordova.exec(successCallback, failureCallback, 'AnyOfficeSDKCordova', 'init', [getInitObject]);
}
/*
 * @brief  authenticate(网关认证)
 * @param：
 username					用户名
 password					密码
 internetGatewayAddress		网关
 authenticateUseSSO			是否单点登录
 authenticateInBackground	是否后台登陆
 * @return 返回0成功
 */
AgreeSDK.Anyoffice.getAuthenticate = function(username, password, internetGatewayAddress, authenticateUseSSO, authenticateInBackground, successCallback, failureCallback) {
	var getAuthenticateObject = {
		username: username,
		password: password,
		internetGatewayAddress: internetGatewayAddress,
		authenticateUseSSO: authenticateUseSSO,
		authenticateInBackground: authenticateInBackground
	};
	cordova.exec(successCallback, failureCallback, 'AnyOfficeSDKCordova', 'authenticate', [getAuthenticateObject]);
}
/*
 * @brief  getUserInfo(获取用户在线信息)
 * @param
 * @return 返回object
 */
AgreeSDK.Anyoffice.getUserInfo = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'AnyOfficeSDKCordova', 'getUserInfo', []);
}
/*
 * @brief  getTunnelStatu(获取网络状态)
 * @param
 * @return 返回0表示未连接；1表示已连接
 */
AgreeSDK.Anyoffice.getTunnelStatus = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'AnyOfficeSDKCordova', 'getTunnelStatus', []);
}
/*
 * @brief  getTunnelIPAddress(获取IP地址)
 * @param
 * @return 返回IP地址
 */
AgreeSDK.Anyoffice.getTunnelIPAddress = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'AnyOfficeSDKCordova', 'getTunnelIPAddress', []);
}
/*
 * @brief  subscribeTunnelStatusEvent(订阅隧道状态事件)
 * @param
 * @return 返回无
 */
AgreeSDK.Anyoffice.getSubscribe = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'AnyOfficeSDKCordova', 'subscribeTunnelStatusEvent', []);
}
/*
 * @brief  unsubscribeTunnelStatusEvent(取消隧道状态事件)
 * @param
 * @return 返回无
 */
AgreeSDK.Anyoffice.getUnSubscribe = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'AnyOfficeSDKCordova', 'unsubscribeTunnelStatusEvent', []);
}
/*
 * @brief  MDMCheck(MDM检查)
 * @param
 * @return 返回object
 {"OtherCheckOK":true,
 "RootCheck":true,
 "AppCheckOK":true,
 "MDMEnabled":true,
 "Success":true,
 "bindResult":true,
 "PwdCheckOK":true}
 */
AgreeSDK.Anyoffice.getMdm = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'AnyOfficeSDKCordova', 'MDMCheck', []);
}
/*
 * @brief  doHttpClient(http请求)
 * @param：
 address	地址
 csh		参数
 * @return 返回json字符串
 */
AgreeSDK.Anyoffice.getHttp = function(address, csh, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'AnyOfficeSDKCordova', 'doHttpClient', [address, csh]);
}
/*
 * @brief  getPlay(在线播放视频)
 * @param：
 videoPath	视频文内网地址
 * @return 返回
 */
AgreeSDK.Anyoffice.getPlay = function(videoPath, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'VideoPlayerCordova', 'play', [videoPath]);
}
/*
 * @brief  close(关闭播放)
 * @param
 * @return 返回
 */
AgreeSDK.Anyoffice.getClose = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'VideoPlayerCordova', 'close', []);
}
/*
 * @brief  fileEncrypt(文件加密)
 * @param：
 srcFileName	加密文件全路径
 dstFileName	加密后文件存放全路径
 * @return 返回OK
 */
AgreeSDK.Anyoffice.getFileEncrypt = function(srcFileName, dstFileName, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'FileEncryptionCordova', 'fileEncrypt', [srcFileName, dstFileName]);
}
/*
 * @brief  fileDecrypt(文件解密)
 * @param：
 srcFileName	解密文件全路径
 dstFileName	解密后文件存放全路径
 * @return 返回OK
 */
AgreeSDK.Anyoffice.getFileDecrypt = function(srcFileName, dstFileName, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'FileEncryptionCordova', 'fileDecrypt', [srcFileName, dstFileName]);
}
/*
 * @brief  fileEncryptDownload(文件下载加密)
 * @param：
 source		远程文件下载链接
 target		文件下载后存放位置
 objectId	下载的识别码
 headers		下载的头文件信息
 * @return 返回参数obj：
 loaded：已经下载的字节数
 lengthComputable：是否获取总长度
 total：总长度
 */
AgreeSDK.Anyoffice.getFileEncryptDownload = function(source, target, objectId, headers, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'FileEncryptionCordova', 'fileEncryptDownload', [source, target, objectId, headers]);
}
/*
 * @brief  abortDownload(终止文件下载)
 * @param：
 objectId	下载识别码
 * @return 返回无
 */
AgreeSDK.Anyoffice.getAbortDownload = function(objectId, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'FileEncryptionCordova', 'abortDownload', [objectId]);
}
/*
 * @brief  listFile(文件列表查询)
 * @param：
 dirName		文件目录
 * @return 返回对象file的数组：
 name：文件名
 fullpath：文件完整路径
 isDirectory：是否为文件夹
 parentPath：所在文件夹路径
 isEntryptdFile：是否是加密文件
 */
AgreeSDK.Anyoffice.getListFile = function(dirName, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'FileEncryptionCordova', 'listFile', [dirName]);
}
/*
 * @brief  readFile(打开文档)
 * @param：
 filePath	需打开文件的全路径
 openMode	打开方式：
 r：只读；
 rw：读写。默认读写
 * @return 返回读取内容
 */
AgreeSDK.Anyoffice.getReadFile = function(filePath, openMode, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'FileEncryptionCordova', 'readFile', [filePath, openMode]);
}
/*
 * @brief  getLiveingCheck(云从活体检测)
 * @param：
 faceserver	活体检测服务端
 faceappid	活体检测用户ID
 faceappser	活体检测用户密码
 liveLevel	活体检测级别（1，2，3）
 licence		活体检测key
 liveCount	活体检测次数（默认是3）
 * @return 返回JSONObject：
 * 		isLivePass：活体是否通过
 isVerfyPass：比对是否通过
 faceSessionId：比对日志
 resultType：结果类型  （718就是OK的）
 face_score：比对分数
 */
AgreeSDK.Bioassay.getLiveingCheck = function(faceserver, faceappid, faceappser, liveLevel, licence, liveCount, successCallback, failureCallback) {
	var getLiveingCheckObject = {
		faceserver: faceserver,
		faceappid: faceappid,
		faceappser: faceappser,
		liveLevel: liveLevel,
		licence: licence,
		liveCount: liveCount
	};
	cordova.exec(successCallback, failureCallback, 'LivingCheckPlugin', 'getLiveingCheck', [getLiveingCheckObject]);
}

/*************** OCR扫描 ****************/
/*
 * @brief  ocrscan（OCR扫描）--云脉
 * @param
 username	用户名
 pwd			密码
 photoType	图片选择类型：
 "1":选择照片
 "2":拍照
 ocrType		OCR类型：
 driving.scan(行驶证扫描)  			template.scan(企业三证扫描)
 bankcard.scan(银行卡扫描)  			vatInvoice.scan(增值发票扫描)
 driver.scan(驾照扫描)  			passport.scan(护照扫描)
 trafficpermit.scan(港澳通行证扫描) 	officer.scan(军官证扫描)
 ticket.scan(购车票扫描)  			plate.scan(车牌扫描)
 idcard.scan(身份证扫描) 			booklet.scan(户口本扫描)
 * @return 返回json字符串
 */
AgreeSDK.OCRScan.getOcrScan = function(username, pwd, ocrType, photoType, successCallback, failureCallback) {
	var getOcrScanObject = {
		username: username,
		pwd: pwd,
		ocrType: ocrType,
		photoType: photoType
	};
	cordova.exec(successCallback, failureCallback, 'OcrScanPlugin', 'ocrscan', [getOcrScanObject]);
}
/*
 * @brief  docandnamecardscan(文档和名片扫描)
 * @param type object
 username	用户名
 pwd			密码
 photoType	图片类型：
 "1":选择照片
 "2":拍照
 ocrType		OCR类型：
 doc.scan(文档识别) 	namecard.scan(名片识别)
 ocrLang		中英文：
 "1":英文
 "2":中文
 keyLang		简繁体（当中英文选择2时）：
 "0":默认
 "1":简体中文
 "2":繁体中文
 * @return 返回json字符串
 */
AgreeSDK.OCRScan.getDocAndNameCardScan = function(username, pwd, ocrType, photoType, ocrLang, keyLang, successCallback, failureCallback) {
	var getDocAndNameCardScanObject = {
		username: username,
		pwd: pwd,
		ocrType: ocrType,
		photoType: photoType,
		ocrLang: ocrLang,
		keyLang: keyLang
	};
	cordova.exec(successCallback, failureCallback, 'OcrScanPlugin', 'docandnamecardscan', [getDocAndNameCardScanObject]);
}
/*************** 云脉Ocr扫描-本地视频-行驶证驾驶证 ****************/
/*
 * @brief  ：
 XZOCRScanCode（行驶证扫描识别）
 JZOCRScanCode （驾驶证扫描识别）
 XZOCRPhotoScanCode（行驶证拍照识别）
 JZOCRPhotoScanCode（驾驶证拍照识别）
 * @param
 * @return 返回：
 行驶证:
 1. xs_name ：所有人
 2. xs_cardno：车牌号
 3. xs_address : 住址
 4. xs_vehicletype：车辆类型
 5. xs_usecharacte：使用性质
 6. xs_model :品牌型号
 7. xs_vin：车辆识别代号
 8. xs_enginepn：发动机号
 9. xs_registerdate :注册日期
 10.xs_issuedate：发证日期

 驾驶证:
 1. jz_name：姓名
 3. jz_cardno:证号
 4. jz_sex：性别
 5. jz_birthday：出生日期
 6. jz_address：住址
 7. jz_issue_date：初次领证日期
 8. jz_valid_period：有效期
 9. jz_country：国籍
 10.jz_driving_type：准驾车型
 11.jz_register_date：有效起始日期
 */
AgreeSDK.OCRScan.getXZOCRScanCode = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DriveOCRScanPlugin', 'XZOCRScanCode', []);
}
AgreeSDK.OCRScan.getJZOCRScanCode = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DriveOCRScanPlugin', 'JZOCRScanCode', []);
}
AgreeSDK.OCRScan.getXZOCRPhotoScanCode = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DriveOCRScanPlugin', 'XZOCRPhotoScanCode', []);
}
AgreeSDK.OCRScan.getJZOCRPhotoScanCode = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'DriveOCRScanPlugin', 'JZOCRPhotoScanCode', []);
}
/*
 * @brief  getShare(分享微信、QQ、微博、短信)
 * @param type object
 url			分享的url
 title		分享的标题
 description	分享描述
 * @return 返回：
 "0":分享成功
 "1":分享取消
 "2":分享失败
 */
AgreeSDK.Share.getShare = function(url, title, description, successCallback, failureCallback) {
	var getShareObject = {
		url: url,
		title: title,
		description: description
	};
	cordova.exec(successCallback, failureCallback, 'SharePlugin', 'getShare', [getShareObject]);
}
/*
 * @brief  onKeyboard(模拟键盘)
 * @param
 keyboardIsrandom	键盘是否随机：
 0：不是随机键盘
 1：是随机键盘
 * @return 返回：
 字符串（按键的信息）
 删除：del(单个字母或数字)
 长按删除：dels(所有删除)
 */
AgreeSDK.Keyboard.open = function(keyboardIsrandom, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'KeyboardPlugin', 'onKeyboard', [keyboardIsrandom]);
}
/*
 * @brief  InitEcim（初始化登录方法）
 * @param
 loginName		登录人id（手机号码）
 loginPassWord	登录人密码
 * @return 返回：
 1.：成功编码
 2.：失败编码
 */
AgreeSDK.VideoTalk.init = function(loginName, loginPassWord, successCallback, failureCallback) {
	var getInitEcimObject = {
		loginName: loginName,
		loginPassWord: loginPassWord
	};
	cordova.exec(successCallback, failureCallback, 'EcimVideo', 'initEcim', [getInitEcimObject]);
}
/*
 * @brief  connectEcimVideo（如果是发起方--发起视频）
 * @param
 VoipNo	对方id
 * @return 返回：
 1.：
 2.：
 */
AgreeSDK.VideoTalk.connect = function(VoipNo, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'EcimVideo', 'connectEcimVideo', [VoipNo]);
}

/*----------------------------------iMate银行移动办卡设备------------------------------------------------------------*/
/*
 * @brief  iMateOpen（银行移动办卡设备--开启设备）
 * @param
 * @return 返回：成功与否
 */
AgreeSDK.BankCard.openDevice = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IMatePlugin', 'iMateOpen', []);
}
/*
 * @brief  iMateOff（银行移动办卡设备--关闭设备）
 * @param
 * @return 返回：成功与否
 */
AgreeSDK.BankCard.offDevice = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IMatePlugin', 'iMateOff', []);
}
/*
 * @brief  iMateIdentyScan（银行移动办卡设备--设备身份证扫描）
 * @param
 * @return 返回：
 1，成功与否的状态码
 2，track2 身份文字信息
 3，track3 身份图片信息
 4，成功与否的状态描述
 */
AgreeSDK.BankCard.IDcardScan = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IMatePlugin', 'iMateIdentyScan', []);
}
/*
 * @brief  iMatePayCardScan（银行移动办卡设备--设备刷卡）
 * @param
 * @return 返回：
 1，成功与否的状态码
 2，刷卡成功返回的信息
 3，成功与否的状态描述
 */
AgreeSDK.BankCard.deviceCard = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IMatePlugin', 'iMatePayCardScan', []);
}
/*
 * @brief  iMateFingerScan（银行移动办卡设备--设备指纹）
 * @param
 * @return 返回：
 1，成功与否的状态码
 2，指纹成功返回的信息
 3，成功与否的状态描述
 */
AgreeSDK.BankCard.deviceFinger = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IMatePlugin', 'iMateFingerScan', []);
}

/*
 * @brief  跳转到新的webview容器
 * @param  url	跳转新页面的url
 * @return 返回：0：跳转成功
 */
AgreeSDK.WebView.open = function(targetUrl, successCallback, failureCallback) {
	var obj = {
		"url": targetUrl
	}
	cordova.exec(successCallback, failureCallback, 'WebViewPlugin', 'startWebView', [obj]);
}

/*
 * @brief  关闭webview容器
 * @param  url	跳转新页面的url
 * @return 返回：0：关闭成功
 */
AgreeSDK.WebView.close = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'WebViewPlugin', 'closeWebView', []);
}

/*
 * @brief   跳转应用的某个界面
 * @param 	1.packageName：跳转的应用包名
 2.activityurl: 跳转的应用的url

 * @return 返回：0：跳转成功
 */
AgreeSDK.App.goto = function(packageName, activityurl, successCallback, failureCallback) {
	var obj = {
		"package": packageName,
		"activityurl": activityurl
	};
	cordova.exec(successCallback, failureCallback, 'StartAppPlugin', 'start', [obj]);
}
/*
 * @brief   统计插件初始化插件
 * @param 	
 1. key：统计appid
 2. url: 服务器的url
 3. post：发送统计方式（默认为实时发送，非必填）
 0：下次启动发送，
 1：实时发送
 2：按时间间隔发送
 4.postTime：间隔时间（发送统计方式为按时间间隔才有效，默认为1min，非必填）
 5. isDebug：是否打开调试模式（非必填）
 6. isUpdate：是否自动更新（非必填）
 7. isUpdateOnline： 启动后台进行相关配置，即可获取并应用在线配置(非必填)
 8. tag：用户标签（非必填）
 9. userID:用户ID（非必填）
 10. isUpdateOnlyWIFI：是否wifi情况下更新（默认true， 非必填）
 11.  isSendLocation： 是否发送定位信息（默认false，非必填）
 12. sessionTime：session时间（默认30s，非必填）
 * @return 返回：0：初始化成功
 */
AgreeSDK.Statistics.init = function(key, url, post, postTime, isDebug, isUpdate, isUpdateOnline, tag, userID, isUpdateOnlyWIFI, isSendLocation, sessionTime, successCallback, failureCallback) {
	var initObj = {
		key: key,
		url: url,
		post: post,
		postTime: postTime,
		isDebug: isDebug,
		isUpdate: isUpdate,
		isUpdateOnline: isUpdateOnline,
		tag: tag,
		userID: userID,
		isUpdateOnlyWIFI: isUpdateOnlyWIFI,
		isSendLocation: isSendLocation,
		sessionTime: sessionTime
	};
	cordova.exec(successCallback, failureCallback, 'StatisticsPlugin', 'init', [initObj]);
}
/*
 * @brief   统计插件页面统计插件
 * @param 	
 1.page：页面ID
 * @return 返回：0：统计成功
 */
AgreeSDK.Statistics.getPage = function(page, successCallback, failureCallback) {
	var pageObj = {
		page: page
	}
	cordova.exec(successCallback, failureCallback, 'StatisticsPlugin', 'page', [pageObj]);
}
/*
 * @brief   统计插件点击统计插件
 * @param 	
 1.click：点击ID
 * @return 返回：0：统计成功
 */
AgreeSDK.Statistics.getClick = function(click, successCallback, failureCallback) {
	var clickObj = {
		click: click
	}
	cordova.exec(successCallback, failureCallback, 'StatisticsPlugin', 'click', [clickObj]);
}


AgreeSDK.isPC = function() {
	var sUserAgent = navigator.userAgent.toLowerCase();  
    var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";  
    var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";  
    var bIsMidp = sUserAgent.match(/midp/i) == "midp";  
    var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";  
    var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";  
    var bIsAndroid = sUserAgent.match(/android/i) == "android";  
    var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";  
    var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";  
    //document.writeln("您的浏览设备为：");  
    if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {  
       return  false;
    } else { 
       return true;
    }  
}


AgreeSDK.incrementalUpdating.init = function(successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 'IncreUpdatePlugin', 'init', []);
}
AgreeSDK.incrementalUpdating.increUpdate = function(appid,userid,version,type,successCallback, failureCallback) {
	var obj={
		appid:appid,
		userid:userid,
		version:version,
		type:type
	}
	cordova.exec(successCallback, failureCallback, 'IncreUpdatePlugin', 'increUpdate', [obj]);
}
AgreeSDK.incrementalUpdating.delete = function(appid,userid,version,type,successCallback, failureCallback) {
	var obj={
		appid:appid,
		userid:userid,
		version:version,
		type:type
	}
	cordova.exec(successCallback, failureCallback, 'IncreUpdatePlugin', 'delete', [obj]);

}

        
