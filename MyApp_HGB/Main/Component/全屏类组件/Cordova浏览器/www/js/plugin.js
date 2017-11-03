/**
 * Created by dongfenghua on 2016/11/7.
 */
var Plugin = {
    /*网络请求组件*/
    getQRCodeScan: function QRCodeScan(successCallback, failureCallback) {
        cordova.exec(successCallback, failureCallback, 'back', 'getBack', []);
    },
getShare: function Share(successCallback, failureCallback) {
    cordova.exec(successCallback, failureCallback, 'callPhone', 'getCallPhone', ["18811025031"]);
}
    
   
}
