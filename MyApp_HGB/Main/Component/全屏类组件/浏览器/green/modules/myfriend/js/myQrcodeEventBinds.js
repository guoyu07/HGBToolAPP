$(document).on("pageInit", "#page-myQrcode_tpl", function () {




    var  temp_userinfo ={};

    temp_userinfo = getsession('userInfo');
    
    //存储一个全局变量
    var vue_modual = {};
    var vm = new Vue({
        el: '#page-myQrcode_tpl', //@绑定节点
        data: { //@数据   

          Qcode:'',

          information:{

              nick_name_:temp_userinfo.nick_name_,
              real_name_:temp_userinfo.real_name_,
              image_:temp_userinfo.image_
          }

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
    function init(){

        temp_userinfo = getsession('userInfo');

        // -生成二维码
        makeCode();

      
    }
    /**
     * 生成二维码 js - start 
     */
    function makeCode() {

           //type为会员类型
           var data_info = {
               create_user_id: temp_userinfo.id_,
               type:3
           };
           
           AgreeSDK.MakeImgPlugin.MakeQrCode(JSON.stringify(data_info),function(msg) {
                                             
              vue_modual.Qcode = msg;
                                             
           }, function(err) {
                                             //alert(err);
          });
        /**

        //var temp_url = "http://localhost:8080/data/json_19.json";
        var temp_url = url_ + "mobile/scancode/tempTradeno.jhtml";
        var member_phone_ = temp_userinfo.phone_;
        var temp_post_csh = {
            member_phone_:member_phone_
        };
        var temp_token = temp_userinfo.token_;
        var temp_deviceid = temp_userinfo.device_id_;
      

        AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid, function(data) {
            
            if(data.appcode == 1){        

                vue_modual.Qcode = data.data.trade_no_;
                
                
            }   
            
        }, function(err) {
            $.toast('网络请求失败!');
        });
         **/
    }
    /**
     * 生成二维码  -  js - end 
     */

  
	
    $('.open-about').on('click', function () {
        $.popup('.popup-about');
    });
    $(".icon-menu").on("click", function(e){
    	$.closeModal(".popup-about");
    	$.popup('.pop-content');
    });
    
     $.popup('.popup-about');
    
});
getDeviceName();
