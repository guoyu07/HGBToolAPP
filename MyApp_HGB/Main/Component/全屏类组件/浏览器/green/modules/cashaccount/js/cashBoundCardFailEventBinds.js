$(document).on('pageInit', '#page-cashBoundCardFail_tpl', function() {
   //获取成功的数据赋值
    var  temp_userinfo ={};

    var vue_modual = {};

    var temp_card_bank_info = {};

    var vm = new Vue({
        el: '#page-cashBoundCardFail_tpl', //@绑定节点
        data: { //@数据  
            fail_result_:''
        },
        methods: { //@方法-事件调用(this指向data)

          jump:function(){
            $.router.load('./cashAlreadyBound_tpl.html?type=fail',true);
          }
        },
        created: function() { //@业务逻辑（this指向data）
            vue_modual = this;
            //初始化
            init();
            
        }
    });

    function init(){
         
        //绑定失败原因
        appmsg = getsession('appmsg');
        
        vue_modual.fail_result_ = appmsg;//
    }

});
