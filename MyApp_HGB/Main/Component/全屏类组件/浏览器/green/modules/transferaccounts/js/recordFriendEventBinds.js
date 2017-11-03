$(document).on("pageInit", "#page-recordFriend_tpl", function() {
	//上拉
	// 加载flag
	var loading = false;
	// 最多可加载的条目
	var maxItems = 100;
	// 每次加载添加多少条目
	var itemsPerLoad = 10;

	//存储一个全局变量
	var vue_modual = {};

	var temp_userinfo ={};

	//此处的变量需要替换成正式的环境地址
	
	var USERID = '';

	//列表
	var vm = new Vue({
		el: '#page-recordFriend_tpl', //@绑定节点
		data: { //@数据
			list: [
				
			],
			chainsql_balance_:0,
			name_:'',
            image_:''
		},
		methods: { //@方法-事件调用(this指向data)
                     oninfo:function(obj){
                         conserve('order_item',obj);
                         $.router.load('./records_tpl.html',true);
                     }
			//    var this_ = this;
			// var mouth = this_.list[i].mouth;
			//    // this_.list = datalist;
			//    console.log(mouth)
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			
			//初始化
			init();
		}
	})

	//转换对象帮助 util 
	function Transformation(data){

		var LIST_ITEMS = {};

		for(var i = 0; i < data.data.length ; i++) {
			var temp_data = data.data[i];
			var temp_time = temp_data.create_time_;
			//根据年份
			var y = temp_time.split('-')[0];
			//根据月份进行拆分
			var m = temp_time.split('-')[1];

			if(LIST_ITEMS[y] == undefined){
				LIST_ITEMS[y] = {};

				if(LIST_ITEMS[y][m] == undefined){ 
					LIST_ITEMS[y][m] = {};
					LIST_ITEMS[y][m]["key"] = m;
					LIST_ITEMS[y][m]["list"] = new Array();
					LIST_ITEMS[y][m]["list"].push(temp_data);
				}

			}else{
				
				if(LIST_ITEMS[y][m] == undefined){ 
					LIST_ITEMS[y][m] = {};
					LIST_ITEMS[y][m]["key"] = m;
					LIST_ITEMS[y][m]["list"] = new Array();
					LIST_ITEMS[y][m]["list"].push(temp_data);
				}else{
					LIST_ITEMS[y][m]["list"].push(temp_data);
				}
				
			}
		}

		return LIST_ITEMS;
	}

	//初始化
	function init(){
		
		temp_userinfo = getsession('userInfo');

		//用户名称
		vue_modual.name_ = temp_userinfo.name_;
               //用户名称
        vue_modual.image_ = temp_userinfo.image_;
		//绿色积分
		agreeinit();

		USERID = temp_userinfo.id_

		list(0,10,function(){

		});
	}

	function agreeinit(){

		var temp_url = url_ + "mobile/member/memberPointBalanceForChainsal.jhtml";

		var temp_post_csh = {
			phone_:temp_userinfo.phone_
			
		};
		var temp_token = temp_userinfo.token_;
	    var temp_deviceid = temp_userinfo.device_id_;

	    AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
	    	//alert(JSON.stringify(data));
	    	if(data.appcode == 1){
	    		vue_modual.chainsql_balance_ = data.data.chainsql_balance_;
	    	}else{
				vue_modual.chainsql_balance_ = 0;
	    	}
	    },function(error){

		});
	}



	function list(arg_start_,arg_limit_,callback){

		//var temp_url = "http://localhost:8080/data/json_2.json";
		var temp_url = url_ + "mobile/member/memberOrder.jhtml";

		var temp_post_csh = {
			start:arg_start_,
			limit:arg_limit_,
			account_id_:temp_userinfo.id_
		};
		var temp_token = temp_userinfo.token_;
	    var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url,temp_post_csh,temp_token,temp_deviceid,function(data){
			// 生成新条目的HTML
			//alert(JSON.stringify(data));
			//alert(arg_start_ + "--" + arg_limit_);
			var html = '';
			if(data.appcode == 1){


				if(vue_modual.list.length > 9 && arg_start_!=0){
					for(var i = 0 ; i < data.data.length ; i ++){
						vue_modual.list.push(data.data[i]);
					}
				}else{
					vue_modual.list = data.data;

					if(data.data.length < 9){
						vue_modual.down_bool = false;
					}else{
						vue_modual.down_bool = true;
					}
				}

				vue_modual.start = arg_start_;
				vue_modual.limit = arg_limit_;
				
				//将返回的对象进行转换
				var LIST_ITEMS = Transformation(data);

				var temp_data_items;
				for(var key in LIST_ITEMS){
					temp_data_items = LIST_ITEMS[key];
					break;
				}

				//order_type_
				//0 积分
				//1 现金
				//2 混合

				//pay_id_  付款人
				//get_id_  收款人 

				//数据类型转换
				for(var key in temp_data_items){
					for(var i = 0 ; i < temp_data_items[key].list.length ; i ++){
						var temp_ = temp_data_items[key].list[i];
						if(temp_.order_type_ == 0){
							temp_.order_type_name = "积分";
						}
						if(temp_.order_type_ == 1){
							temp_.order_type_name = "现金";
						}
						if(temp_.order_type_ == 2){
							temp_.order_type_name = "混合";
						}

						if(temp_.pay_id_ == USERID){
							temp_.pay_type_ = "-";
						}

						if(temp_.get_id_ == USERID){
							temp_.pay_type_ = "+";
						}
					}
				}


				//console.log("::"+JSON.stringify(temp_data_items));
				vue_modual.list = temp_data_items;
                callback();

			}
			
		},function(error){

		});
	}



	function addItems(number, lastIndex) {
		//console.log(i);

	}
	//预先加载20条
	//addItems(itemsPerLoad, 0);

	// 上次加载的序号

	var lastIndex = 10;

	// 注册'infinite'事件处理函数
	$(document).on('infinite', '.infinite-scroll-bottom', function() {
		
		// 如果正在加载，则退出
		if(loading) return;

		// 设置flag
		loading = true;

		//重新加载
		list((vue_modual.start+1),(vue_modual.limit),function(){
			loading = false;

			lastIndex = $('.list-container .div-custom-mouthboxs').length;
			//容器发生改变,如果是js滚动，需要刷新滚动
			$.refreshScroller();
		});
		/**
		// 模拟1s的加载过程
		setTimeout(function() {
			// 重置加载flag
			loading = false;

			if(lastIndex >= maxItems) {
				// 加载完毕，则注销无限加载事件，以防不必要的加载
				$.detachInfiniteScroll($('.infinite-scroll'));
				// 删除加载提示符
				$('.infinite-scroll-preloader').remove();
				return;
			}

			// 添加新条目
			addItems(itemsPerLoad, lastIndex);
			// 更新最后加载的序号
			lastIndex = $('.list-container .div-custom-mouthboxs').length;
			//容器发生改变,如果是js滚动，需要刷新滚动
			$.refreshScroller();
		}, 1000);
		**/
	});
	//上拉结束
	//下拉刷新
	// 添加'refresh'监听器
	$(document).on('refresh', '.pull-to-refresh-content', function(e) {

		//重新加载
		init(vue_modual,function(){

			// 加载完毕需要重置
			$.pullToRefreshDone('.pull-to-refresh-content');
			//容器发生改变,如果是js滚动，需要刷新滚动
			//$.refreshScroller();
		});
		/**
		// 模拟2s的加载过程
		setTimeout(function() {
			var cardNumber = $(e.target).find('.div-custom-mouthboxs').length + 1;
			var cardHTML = '<div data-type="div" class="div-custom-obox">' +
				'<span data-type="span" class="span-custom-mouth">123月</span>' +
				'<div data-type="div" class="div-custom-mouthboxs">' +
				'<div data-type="div" class="div-custom-transationbox" >' +
				' <div class="div-custom-transboxs" data-type="div" >' +
				'    <div class="div-custom-transtop" data-type="div">' + cardNumber + '<span data-type="span" class="span-custom-toptext">+15</span></div>' +
				'  <div class="clear"></div>' +
				'  <div class="div-custom-transbottom" data-type="span">7月20日 20:00<span data-type="span" class="span-custom-bottomtext">备注类型</span>' +
				'</div>	' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>';

			$(e.target).find('.list-container').prepend(cardHTML);
			// 加载完毕需要重置
			$.pullToRefreshDone('.pull-to-refresh-content');
		}, 2000);
		**/
	});
	$('.div-custom-mouthboxs .div-custom-transationbox').on('click', function() {
		//点击某一个跳转到  - 交易列表
		var id = $(this).attr("id");
       
		$.router.load('./records.html?id='+id);
	})

	$("#info_img").click(function() {
		//
		window.localStorage.removeItem("a");
		AgreeSDK.Media.picture(function(msg) {
			window.localStorage.setItem("a", msg);
			$("#info_img").attr("src", msg);
		}, function(err) {
			alert(err);
		})
	});
	
});
getDeviceName();
