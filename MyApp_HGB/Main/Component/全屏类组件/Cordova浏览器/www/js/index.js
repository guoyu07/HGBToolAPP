/**
 * Created by dongfenghua on 2016/11/7.
 */
$(function () {
    //加载JS-SDK插件封装文件
    $.getScript('js/plugin.js');

    //二维码扫描按钮
    $('#btn_QRCode').click(function () {
                           
        Plugin.getQRCodeScan(function (msg) {
            alert(msg);
        }, function (err) {
            alert(err);
        })
                           });
  //友盟分享组件
  $('#btn_Share').click(function () {
                        
                         Plugin.getShare(function (msg) {
                                              alert(msg);
                                              }, function (err) {
                                              alert(err);
                                              })
                         })
 
})
