$(document).on("pageInit", "#page-forgetPassword_tpl", function(e, pageId, $page) {
               
               var vue_modual = {};
               var temp_userinfo = {};
               
               var vm = new Vue({
                                el: '#page-forgetPassword_tpl', //@绑定节点
                                data: { //@数据
                                phone:'',
                                veritrycode:''
                                },
                                methods: { //@方法-事件
                                submit:function(){
                                submit();
                                }
                                },
                                created: function() { //@业务逻辑（this指向data）
                                vue_modual = this;
                                init();
                                }
                                });
               
               function init() {
               
               var temp_user = getsession("temp_userInfo");
               
               
               }
               
               //短信验证
               $(".obtain").on('click', function() {
                               
                               $.sendVerifyCode($(this), 60, '重新发送');
                               //调用手机验证码接口
                               
                               var post_adress = url_ + "mobile/member/phoneCode.jhtml";
                               
                               var data = {
                               
                               phone_: vue_modual.phone
                               };
                               
                               var token_ = temp_userinfo.token_;
                               var deviceid = temp_userinfo.device_id_;
                               
                               
                               
                               AgreeSDK.Connection.getNetWorkRequest(post_adress, data,token_,deviceid, function(msg) {
                                                                     
                                                                     $.hidePreloader();
                                                                     
                                                                     if(msg.appcode == 1){
                                                                     
                                                                     conserve('mobile_code', msg.data.mobile_code);
                                                                     conserve('phone', vue_modual.phone);
                                                                     
                                                                     }
                                                                     }, function(err) {
                                                                     $('#btn_login').removeClass('actives');
                                                                     $.toast('网络请求失败');
                                                                     });
                               
                               
                               })
               
               function submit(){
               
                   $.showPreloader('正在处理...');
               
                   if(vue_modual.phone != '' && vue_modual.veritrycode!=''){
               
                       var mobile_code = getsession("mobile_code");
               
                       $('#btn_login').addClass('actives');
               
               
                      // if(vue_modual.veritrycode == mobile_code){
               
                       $.router.load('./forgetPasswords_tpl.html?phone='+vue_modual.phone, true);
               
                      // }else{
               
                       //$.toast('验证码不正确！');
                      // $('#btn_login').removeClass('actives');
               
                     //  }
                   }else{
               
                   $.toast('请输入完整！');
               
               }
               
               
               
               
               }
               
               
               
               
               
               });

