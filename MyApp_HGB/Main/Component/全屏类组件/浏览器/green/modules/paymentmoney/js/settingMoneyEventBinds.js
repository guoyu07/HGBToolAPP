$(document).on("pageInit", "#page-settingMoney_tpl", function() {
               
    var vue_modual = {};
    //双向数据绑定对象
    var vm = new Vue({
        el: '#page-settingMoney_tpl', //@绑定节点
        data: { //@数据
           integral:0
        },
        methods: { //@方法-事件调用(this指向data)
                     submit: function() {
                        $.router.load('./collectMoney_tpl.html?integral='+vue_modual.integral,true);
                     }
        },
        created: function() { //@业务逻辑（this指向data）
           vue_modual = this;
           
        }
    });

});
