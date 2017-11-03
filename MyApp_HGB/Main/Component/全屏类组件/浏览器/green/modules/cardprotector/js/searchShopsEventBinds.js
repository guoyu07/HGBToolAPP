$(document).on("pageInit", "#page-searchShops_tpl", function() {
    //全局user对象变量
    var temp_userinfo = {};
    //var name = getsession('name');
    //存储一个全局变量 - 页面对象
    var vue_modual = {};
    //城市code
    var city_code_ = '';
	var vm = new Vue({
		el: '#page-searchShops_tpl', //@绑定节点
		data: { //@数据
			isShow: false,
			tenantInfo: {
				list: {}
			},
			create_time_: '',
			shopName: ''
		},
		methods: { //@方法-事件调用(this指向data)
			getShopList: function(){
                 search();
			},
			jumpShopInfo: function(mondule){
            
                if(mondule.bind == true){
                     return;
                }
                conserve('temp_tenant_info_2',mondule);
				$.router.load('../../modules/transferaccounts/merchantInformations_tpl.html',true);
			},
            bindCard:function(mondule){
                 conserve('temp_tenant_info_2',mondule);
                 $.router.load('../../modules/transferaccounts/merchantInformations_tpl.html',true);
            }
		},
		created: function() { //@业务逻辑（this指向data）
			//this.getShopList();
            vue_modual = this;
            init();
		}
	});
     
               function init(){
                   temp_userinfo = getsession("userInfo");
                   var city = getsession("city");
                   if(city!=null && city!=''){
                       city_code_ = city.code;
                   }
               
               }
               //搜索
               function search(){
                       $.showPreloader('正在查询...');
                       var shopName = vue_modual.shopName;
                       var post_adress = url_ + "mobile/merchant/merchantList.jhtml";
                       var data = {
                            start: 0,
                            limit: LIMIT,
                            page: 1,
                            name_: shopName,
                            city_:city_code_
                       };
                       var temp_token = temp_userinfo.token_;
                       var temp_deviceid = temp_userinfo.device_id_;
                       
                       AgreeSDK.Connection.getNetWorkRequest(post_adress, data, temp_token , temp_deviceid, function(msg) {
                                                             $.hidePreloader();
                                                             //alert("::"+JSON.stringify(msg));
                                                             if(msg.appcode == 1) {
                                                                 vue_modual.isShow = false;
                                                                 vue_modual.tenantInfo.list = msg.data;
                                                                 setup_btn();
                                                             }else if(msg.appcode == 106){
                                                                 vue_modual.isShow = true;
                                                             }
                                                            
                                                             }, function(err) {
                                                                 $.hidePreloader();
                                                                 $.toast('网络请求失败!');
                                                             });
               
               
               }
               
               //是否绑定商户
               function setup_btn(){
               
                   var usercardList = getsession("usercardList");
                   if(usercardList){
                           for(var i = 0 ; i < vue_modual.tenantInfo.list.length ; i++){
                                   var temp_1 = vue_modual.tenantInfo.list[i];
                           for(var j = 0 ; j < usercardList.length ; j++){
                                   var temp_2 = usercardList[j];
               
                                   if(temp_1.id_ == temp_2.id_){
                                       vue_modual.tenantInfo.list[i]["bind"] = true;
                                       break;
                                   }else{
                                       vue_modual.tenantInfo.list[i]["bind"] = false;
                                   }
                           }
                       }
                   }
               
               }
});
