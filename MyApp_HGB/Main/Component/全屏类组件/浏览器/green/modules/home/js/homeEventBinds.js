$(document).on("pageInit", "#page-home_tpl", function(e, pageId, $page) {
	//是否设置过支付密码
	var isSettingPayPwd = true;
	//全局user对象变量
	var temp_userinfo = {};
	//var name = getsession('name');
	//存储一个全局变量 - 页面对象
	var vue_modual = {};

	// 加载flag
	var loading = false;
	// 最多可加载的条目
	var maxItems = 100;
	// 每次加载添加多少条目
	var itemsPerLoad = 10;
	var vm = new Vue({
		el: '#page-home_tpl', //@绑定节点
		data: { //@数据
			//tab2活动列表
			tenant: {
				list: [],
				down_bool: false,
				bool: false,
				start: 0,
				page: 1
			},
			city: '',
			code: '',
			keyVal: '',
			//图片轮播
			homeBannerList: {
				list: []
			},

			//好友列表
			friendsList: {
				list: [],
				isNewFriend: false
			},
			//我的  --详情
			myInfo: {

			},
			//积分余额
			balance: {

			},
			//现金账户余额
			cash: {

			},
			//积分兑换模块
			exchangeData: {

			},
			messagelist: []

		},
		methods: { //@方法-事件调用(this指向data)
			//tab1首页文本框的值进行判断 跳转页面
			onIn: function() {
				//获取页面model值方法  if(this.key_val && this.key_val !== ''){
				$.router.load('../../modules/activity/activityAll_tpl.html', true);

			},
			//进入热活动搜索页面
			onTabTwo: function() {

				$.router.load('../../modules/activity/search_tpl.html', true);

			},

			//点击积分兑换
			onExchange: function() {

				//调获取卡包接口判断跳转已经添加商户页面or未添加商户页面
				exchange();

			},
			//点击我的模块的银行卡
			onBlankCard: function() {

				//调查询会员银行卡接口判断跳转已经添加银行卡页面or未添加银行卡页面
				findBlankCard();

			},
			//进入活动列表详情页面
			onHome: function(dataid) {
				$.router.load('../../modules/activity/activityListDetail_tpl.html?dataid=' + dataid, true);

			},
			//添加好友
			adduser: function() {

			},

			//进入新朋友页面
			onFriends: function() {
				$.router.load('../../modules/myfriend/newFriend_tpl.html', true);
			},
			//点击朋友列表进入好友资料页面
			onFriendInfo: function(dataid) {
				$.router.load('../../modules/transferaccounts/friendInformation_tpl.html?dataid=' + dataid);
			},
			//点击tab2的商户名进入页面
			onUserName: function(dataid) {
				$.router.load('../../modules/activity/merchantName.html?dataid=' + dataid, true);
			},
			//点击好友列表页面的搜索框
			onSearch: function() {
				//得到搜索框的值
				searchFriends(this.value);
			},
			messagemore: function() {

				$.router.load('../../modules/myself/messagelist_tpl.html', true);
			},
			onMessageList: function(data) {
				messageType(data);
			},
			gobalance: function() {
				//点击积分余额

			},
			gocash: function() {
				//点击现金余额
              $.router.load('../../modules/cashaccount/cashAlreadyBound_tpl.html', true);

			},
             onsearch_user_input:function(){
                     searchFriends();
             }
		},
		created: function() { //@业务逻辑（this指向data）()

			vue_modual = this;
			//初始化
			init();
		},
		compiled: function() {
             
//            $("#slider_1").swiper({
//                pagination: '.swiper-pagination', //页码模板样式
//                paginationClickable: true, //页码是否可点击
//                observeParents: true, //启动动态检查器
//                observer: true, //启动动态检查器
//                loop: true, //是否循环播放
//                spaceBetween: 10, //轮播图的间隔
//                autoplay: 500 //自动切换的时间间隔(单位ms)
//
//            });
		}
	});

	//界面初始化
	function init() {
        load_setpassword();
		//插件取本地数据
		// getFile('settingPayPwd', function(data) {
		//     if(data == '') {
		//         isSettingPayPwd = false;
		//     } else {
		//         isSettingPayPwd = true;
		//     }
		// }, function() {

		// });

		temp_userinfo = getsession('userInfo');
		var cityinfo = getsession("city");
		var cityNames = getsession("cityNames");
		if(cityinfo != null && cityinfo != undefined) {
			vue_modual.city = cityinfo.city;
			vue_modual.code = cityinfo.code;
		}

		//依次调用，不然 sdk 会崩溃， ios  ， android 没测
		//首页 - banner
		homeBanner(function() {
			//获取最新消息
			loadmessage();
			//活动列表
			activityList(function() {
				//首页 - 好友列表
				friends(function() {
					//判断是否显示tab3的新的朋友html
					isNewFriends(function() {
						//余额接口
						myBalance(function() {
							//查询现金账户余额
							findCash(function() {
								//tab4  我的详情信息
								myInfos(function() {
									//用户头像
									load_user_pic();
									//alert('完毕');
                                    
                                    
								});
							});
						});
					});
				});
			});
		});
	}
   //获取本地密码
   function load_setpassword(){
         var temp_settingPayPwd = getsession('settingPayPwd');
         //未设置密码
         if(temp_settingPayPwd==null || temp_settingPayPwd =='' || temp_settingPayPwd==undefined){
               
               $('.box_home').show();
         }
         
   }

	function load_user_pic() {

		//判断获取本地文件插件
		var imgUrl = '2.png';

		AgreeSDK.FilePlugin.getFile(imgUrl, '1', function(msg) {
			if(msg) {
				//存在头像则
				//$('#homeImg img').attr('src', msg);
				 //存在头像则
	            $('#homeImg img').attr('src',"data:image/png;base64,"+msg);

			}
		}, function(error) {

		})

	}

	/**
	 *  首页  界面 js - start
	 */

	//付钱
	$('#paymoney').on('click', function() {
		$.router.load('../../modules/paymentmoney/payment_tpl.html', true);
	});

	//积分钱包
	$('#intergralwallet').on('click', function(e) {

		$.router.load('../../modules/integralwallet/addShops_tpl.html?type=1', true);
	});
	//零钱账户
	$('#cash').on('click', function() {
		if(!isSettingPayPwd) {
			$('.box_home').css('display', 'block');
		} else {
			$.router.load('../../modules/cashaccount/cashAlreadyBound_tpl.html', true);
		}

		//现金账户未绑定银行卡跳转页面
		//$.router.load('../../modules/Cashaccount/cash_withoutbound_tpl.html');
	});
	//转账
	$('#transferaccounts').on('click', function() {
		$.router.load('../../modules/cashaccount/friendslist_tpl.html', true);
	});
	//交易记录
	$('#transactionrecord').on('click', function() {
		$.router.load('../../modules/transferaccounts/recordFriend_tpl.html', true);
	});
	//卡包
	$('#cardprotector').on('click', function() {
		//点击卡包：分为未绑定和已经绑定页面
		//$.router.load('../../modules/cardprotector/card_ball_without_tpl.html');
		$.router.load('../../modules/cardprotector/cardBall_tpl.html', true);
	});
	//全部尚未有

	//判断如果从热词搜索页面跳过来则调商户活动列表接口
	if(GetQueryString('params_') == "search") {
		//获取热词搜索页面的文本框的值
		var val = getsession('val');
		//activityList(0, 10, function() {

		//             });
	}

	//最新消息
	function loadmessage() {
		var messageList = getsession('AllmessageList');

		if(messageList != null && messageList != '') {
			vue_modual.messagelist = messageList;
		} else {
			vue_modual.messagelist = new Array();
		}
	}

	//判断点消息列表跳转不同类型的页面
	function messageType(data) {

		switch(data.type_) { //商户推送的活动

			case '1':
				//跳转界面
				break;
			case '2':
				//跳转界面
				break;
			case '3':
				//跳转界面
				break;
		}

	}
	/**
	 * 首页 banner
	 */
	function homeBanner(callback) {

		//var temp_url = "http://localhost:8080/data/json_4.json";
		var temp_url = url_ + "mobile/ad/adList.jhtml";

		var temp_post_csh = {
			limit: 10,
			start: 0
		};

		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
			$.hidePreloader();
			if(data.appcode == 1) {
				//$('.swiper-container').remove();
				vue_modual.homeBannerList.list = data.data;

				$("#slider_1").swiper({
					pagination: '.swiper-pagination', //页码模板样式
					paginationClickable: true, //页码是否可点击
					observeParents: true, //启动动态检查器
					observer: true, //启动动态检查器
					loop: true, //是否循环播放
					spaceBetween: 10, //轮播图的间隔
					autoplay: 500 //自动切换的时间间隔(单位ms)

				});

			}
			callback();
		}, function(err) {

			$.hidePreloader();
			$.toast('网络请求失败!');

			callback();
		});
	}

	/**
	 *  首页  界面 js - end
	 */

	/**
	 * 我的模块的银行卡业务
	 */
	function findBlankCard() {

		//var temp_url = "http://localhost:8080/data/json_24.json";
		var temp_url = url_ + "mobile/member/memberBank.jhtml"; //已改

		var id = temp_userinfo.id_;
		var temp_post_csh = {
			member_id_: id
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			if(data.appcode == 1) {

				$.router.load('../../modules/cashaccount/cashAlreadyBound_tpl.html?type=0', true);

			} else if(data.appcode = 106) {
				$.router.load('../../modules/cashaccount/cashAlreadyBound_tpl.html?type=1', true);
			}

		}, function(err) {
			$.toast('网络请求失败!');
		});
	}

	/**
	 * 我的模块的银行卡业务 js - end
	 */

	/**
	 * 我的----现金账户余额  start
	 */
	function findCash(callback) {

		//var temp_url = "http://localhost:8080/data/json_23.json";
		var temp_url = url_ + "mobile/member/memberCashBalance.jhtml";
		var id = temp_userinfo.id_;
		var temp_post_csh = {

			member_id_: id
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			if(data.appcode == 1) {

				vue_modual.cash = data.data;
			}
			callback();
		}, function(err) {
			$.toast('网络请求失败!');
			callback();
		});
	}

	/**
	 *  我的----现金账户余额   js - end
	 */

	/**
	 * 商户活动加载列表的核心方法  首页 - 商户活动 js - start
	 */
	//vue_modual.tenant.bool = false;
	function activityList(callback) {

		//var temp_url = "http://localhost:8080/data/json_8.json";
		var temp_url = url_ + "mobile/activity/activityList.jhtml";

		var temp_post_csh = {
			limit: LIMIT,
			start: vue_modual.tenant.start,
			page: vue_modual.tenant.page,
			city_: vue_modual.code

		};
		//alert(arg_page_ + "==" + arg_start_);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			net_result_page(data, vue_modual.tenant);

			callback();
		}, function(err) {
			$.toast('网络请求失败!');
			callback();
		});
	}

	//下方加载
	$(document).on('infinite', '', function() {

		//alert(2);
		// 如果正在加载，则退出
		if(loading) return;

		// 设置flag
		loading = true;

		if(vue_modual.tenant.bool) {
			//追加
			activityList((vue_modual.tenant.page), vue_modual.tenant.start, function() {
				loading = false;
				lastIndex = $('.activelist  #div_activity_list').length;
				//容器发生改变,如果是js滚动，需要刷新滚动
				$.refreshScroller();
			});
		} else {
			loading = false;
			lastIndex = $('.activelist  #div_activity_list').length;
			//容器发生改变,如果是js滚动，需要刷新滚动
			$.refreshScroller();
		}

	});
	//下方结束

	//上方加载
	// 添加'refresh'监听器
	$(document).on('refresh', '.pull-to-refresh-content', function(e) {
		//alert(1);
		//首页 - 商户活动列表
		// activityList(0,10,function(){
		//     // 加载完毕需要重置
		//     $.pullToRefreshDone('.pull-to-refresh-content');
		//     //容器发生改变,如果是js滚动，需要刷新滚动
		//     $.refreshScroller();
		// });

	});
	/**
	 *  首页 - 商户活动 js - end
	 */

	/**
	 * 好友列表
	 */
	function friends(callback) {

		//var temp_url = "http://localhost:8080/data/json_9.json";
		var temp_url = url_ + "mobile/friends/friendsList.jhtml";
		var id = temp_userinfo.id_;
		var temp_post_csh = {
			limit: 1000,
			start: 0,
			account_id_: id
		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
//alert(JSON.stringify(data))
			if(data.appcode == 1) {

				vue_modual.friendsList.list = data.data;
                vue_modual.ALLITEMS = data.data;
				//字母排序
				list();
			}
			callback();
		}, function(err) {
			$.toast('网络请求失败!');
			callback();
		});
	}
	//是否有新朋友
	function isNewFriends(callback) {

		//var temp_url = "http://localhost:8080/data/json_9_1.json";
		var temp_url = url_ + "mobile/friends/friendsList.jhtml"; //已改过地址
		var id = temp_userinfo.id_;
		var temp_post_csh = {
			limit: 1000,
			start: 0,
			account_id_: id,
			status_: 0
		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
			if(data.appcode == 1) {
				if(data.data.length > 0) {

					vue_modual.friendsList.isNewFriend = true;

					vue_modual.friendsList.newFriendCount = data.data.length;
				}

			}
			callback();
		}, function(err) {
			$.toast('网络请求失败!');
			callback();
		});
	}

	/**
	 *  好友列表  界面 js - end
	 */

	/**
	 * 我的   信息展示
	 */
	function myInfos(callback) {

		//var temp_url = "http://localhost:8080/data/json_11.json";
		var temp_url = url_ + "mobile/member/memberDetails.jhtml";
		var id = temp_userinfo.id_;

		var temp_post_csh = {
			id_: id
		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;

		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			if(data.appcode == 1) {

				vue_modual.myInfo = data.data;
				// if(){

				// }

			}
			callback();
		}, function(err) {
			$.toast('网络请求失败!');
			callback();
		});
	}

	/**
	 * 我的   信息展示   界面 js - end
	 */

	/**
	 * 我的积分钱包余额   信息展示
	 */
	function myBalance(callback) {

		//var temp_url = "http://localhost:8080/data/json_17.json";
		var temp_url = url_ + "mobile/member/memberPointBalanceForChainsal.jhtml";
		var phone_ = temp_userinfo.phone_;
		var temp_post_csh = {
			phone_: phone_
		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;
		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {

			if(data.appcode == 1) {

				vue_modual.balance = data.data;

			}
			callback();
		}, function(err) {
			$.toast('网络请求失败!');
			callback();
		});
	}

	/**
	 * 我的积分钱包余额   信息展示   界面 js - end
	 */

	/**
	 * 积分兑换
	 */
	function exchange() {
		$.router.load('../../modules/integralwallet/addShops_tpl.html', true);
		/**
		//var temp_url = "http://localhost:8080/data/json_18.json";
		var temp_url = url_ + "mobile/cardPackage/carPackageList.jhtml"; //获取卡包列表接口
		var id = temp_userinfo.id_;
		var temp_post_csh = {
		limit: 1000,
		start: 0,
		id_: id
		};
		//temp_post_csh = JSON.stringify(temp_post_csh);
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;
               
		AgreeSDK.Connection.getNetWorkRequest(temp_url, temp_post_csh, temp_token, temp_deviceid, function(data) {
		                                      if(data.appcode == 1) {
		                                      
		                                      if(data.data.length > 0) {
		                                      $.router.load('../../modules/exchange/addShop_tpl.html', true);
		                                      } else {
		                                      $.router.load('../../modules/exchange/withoutAdd_tpl.html', true);
		                                      }
		                                      
		                                      }
		                                      
		                                      }, function(err) {
		                                      $.toast('网络请求失败!');
		                                      });
		 **/
	}

	/**
	 *    积分兑换   界面 js - end
	 */
	/**
	 搜索好友列表 start
	 **/
	function searchFriends() {
       
		if(vue_modual.value == '') {
            
			vue_modual.friendsList.list = vue_modual.ALLITEMS;
            setTimeout(function() {
               list();
            }, 500);
			return;
		}
        
		var search_list = new Array();
		for(i = 0; i < vue_modual.ALLITEMS.length; i++) {
			//搜索名字和好友手机号
           if(vue_modual.ALLITEMS[i]["friends_name_"]==undefined ){
               vue_modual.ALLITEMS[i]["friends_name_"]  = "";
           }
           if(vue_modual.ALLITEMS[i]["friends_phone_"]==undefined){
              vue_modual.ALLITEMS[i]["friends_phone_"]  = "";
           }
			if(vue_modual.ALLITEMS[i]["friends_name_"].indexOf(vue_modual.value) == 0 || vue_modual.ALLITEMS[i]["friends_phone_"].indexOf(vue_modual.value) == 0) {
				search_list.push(vue_modual.ALLITEMS[i]);
			}
		}
		vue_modual.friendsList.list = search_list;
        
		setTimeout(function() {
                  
            
			list();
		}, 500);
	}
	/**
	 搜索好友列表 end
	 **/
	function list() {
		//通讯录
		var indexList = $('.letters-nav');
		var LetterBox = $('.letter');
		setTimeout(function() {
			initials();
		}, 500);

		$(".letters-nav ul li").click(function() {
			var _this = $(this);
			var LetterHtml = _this.html();
			LetterBox.html(LetterHtml).show();

			setTimeout(function() {
				LetterBox.hide();
			}, 1000);
			var _index = _this.index();
			if(_index == 0) {
				$('.content').scrollTop(0);
			} else if(_index == indexList.find('ul').children().length - 1) {
				if($('#default').length > 0) {
					var DefaultTop = $('#default').position().top;
					$('.content').scrollTop(DefaultTop);
				}
			} else {
				var letter = _this.text();
				if($('#' + letter).length > 0) {
					var LetterTop = $('#' + letter).position().top;
					var aScrollTop = $('.content').scrollTop();
					$('.content').scrollTop(LetterTop + aScrollTop);
				}
			}
		})
	}
	//tab点击效果
	$('.buttons-tab .tab-link.button').on('click', function(e) {
		$("#footer").find(".icon").removeClass("active");
		$(this).find('.icon').addClass('active');
	});
	//获取点击tab的下标然后利用trigger();
	var tabIndex = localStorage.getItem('tabIndex');
	var input_keyword = $('#input_keyword').val();
	if(tabIndex) {
		if(tabIndex >= 3) {
			tabIndex -= 1;
		}
		$($('.buttons-tab .tab-link')[tabIndex]).trigger("click"); //dom转换为jquery
		console.log($($('.buttons-tab .tab-link')[tabIndex]).trigger("click"));
		tabIndex = "";

	}

	//点击遮罩层的文字跳转支付密码设置页面
	$('.box_home').on('click', function() {
		$('.box_home').css('display', 'none');
		$.router.load('../../modules/loginoneof/payPasswordSetting_tpl.html?type=0', true);
	})

	$('.city_btn').on('click', function() {
		$.router.load('../../modules/activity/activityCity_tpl.html?params=1', true);
	})

	$('.list-block.mymessage').on('click', function(e) {
		$.router.load('../../modules/myself/myselfInfo_tpl.html', true);
	});

	$('#myCode').on('click', function(e) {
		$.router.load('../../modules/myfriend/myQrcode_tpl.html', true);
	});
	$('#myMessage').on('click', function(e) {
		$.router.load('../../modules/myself/messagelist_tpl.html', true);
	});
	$('#setting').on('click', function(e) {
		$.router.load('../../modules/myself/setting_tpl.html', true);
	});

	$('#bill').on('click', function(e) {
		$.router.load('../../modules/transferaccounts/recordFriend_tpl.html', true);
	});

	//点击右边加号跳转页面
	$('#getMoney').on('click', function(e) {
		
		$.router.load('../../modules/paymentmoney/collectMoney_tpl.html', true);
	});
	$('#shou_Money').on('click', function(e) {
		
		$.router.load('../../modules/paymentmoney/collectMoney_tpl.html', true);
	});
	$('#shouMoney').on('click', function(e) {
	
		$.router.load('../../modules/paymentmoney/collectMoney_tpl.html', true);
	});
	$('#AddFriends').on('click', function(e) {
		$.router.load('../../modules/myfriend/addFriend_tpl.html', true);
	});
	$('#add_Friends').on('click', function(e) {
		$.router.load('../../modules/myfriend/addFriend_tpl.html', true);
	});
	$('#Add_Friends').on('click', function(e) {
		$.router.load('../../modules/myfriend/addFriend_tpl.html', true);
	});

	//点击每个tab下标存本地以至于二级页面返回来tab有active状态
	$('.buttons-tab .tab-link').on('click', function(e) {
		tabIndex = $(this).index();
		window.localStorage.setItem('tabIndex', tabIndex);
	});

	//头部右边加号逻辑 start

	$('.icon-rs').on('click', function() {
	
		$(".masks").toggle();
		
	});
	$('.icon-right').on('click', function() {
	   
	   $(".mask_box").toggle();

	});
	$('.icon-rights').on('click', function() {
	   
	   $(".maskBox").toggle();

	});
	$('.masks').on('click', function() {
		
		$(this).toggle();
	});
	$('.mask_box').on('click', function() {
		
		$(this).toggle();
	});
	$('.maskBox').on('click', function() {
		
		$(this).toggle();
	});
	//头部右边加号逻辑 end

	//点击扫一扫调用二维码插件
	$('#div_QRCode').on('click', function() {

		AgreeSDK.QRCode.scan(function(msg) {
			//alert(msg);
			//var type = JSON.parse(msg).type;
			$(".mask").hide();
			ALL_San(msg);

		}, function(err) {
			$.alert(err);
		});
	});
   $('#div_QRCode_1').on('click', function() {
                       
   AgreeSDK.QRCode.scan(function(msg) {
                        //alert(msg);
                        //var type = JSON.parse(msg).type;
                        $(".mask").hide();
                        ALL_San(msg);
                        
                        }, function(err) {
                        $.alert(err);
                        });
   });
   
    $('#saoyi_sao').on('click', function() {
                       
           AgreeSDK.QRCode.scan(function(msg) {
                        //alert(msg);
                        //var type = JSON.parse(msg).type;
                        $(".mask").hide();
                        ALL_San(msg);
                        
                        }, function(err) {
                        $.alert(err);
                        });
   });
   $('#sao_yisao').on('click', function() {
                       
           AgreeSDK.QRCode.scan(function(msg) {
                        //alert(msg);
                        //var type = JSON.parse(msg).type;
                        $(".mask").hide();
                        ALL_San(msg);
                        
                        }, function(err) {
                        $.alert(err);
                        });
   });
               
	//点击扫一扫调用二维码插件
	$('#saoyisao').on('click', function() {

		AgreeSDK.QRCode.scan(function(msg) {
			//alert(msg);
			//var type = JSON.parse(msg).type;
			ALL_San(msg);

		}, function(err) {
			$.alert(err);
		});
	});
    /**
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
    **/
    /**
	//查询好友详情
	function ferFriendInfo(arg_friends_id_, callback) {

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
     **/

	function list() {

		//通讯录
		var indexList = $('.letters-nav');
		var LetterBox = $('.letter');
		setTimeout(function() {

			initials();
		}, 500);

		$(".letters-nav ul li").click(function() {
			var _this = $(this);
			var LetterHtml = _this.html();
			LetterBox.html(LetterHtml).show();

			setTimeout(function() {
				LetterBox.hide();
			}, 1000);
			var _index = _this.index();
			if(_index == 0) {
				$('.content').scrollTop(0);
			} else if(_index == indexList.find('ul').children().length - 1) {
				if($('#default').length > 0) {
					var DefaultTop = $('#default').position().top;
					$('.content').scrollTop(DefaultTop);
				}
			} else {
				var letter = _this.text();
				if($('#' + letter).length > 0) {
					var LetterTop = $('#' + letter).position().top;
					var aScrollTop = $('.content').scrollTop();
					$('.content').scrollTop(LetterTop + aScrollTop);
				}
			}

		});
	}

});

//添加首字母标签分组重排
function initials() {
	var SortList = $(".sort_list");
	var SortBox = $(".sort_list").parent();
	SortBox.append(SortList.sort(asc_sort)); //按首字母排序
	function asc_sort(a, b) {
		return $.getInitialsArrByStr($(b).find('.item-title').text().charAt(0))[0].toUpperCase() < $.getInitialsArrByStr($(a).find('.item-title').text().charAt(0))[0].toUpperCase() ? 1 : -1;
	}

	var initials = [];
	var num = 0;
	SortList.each(function(i) {
		var initial = $.getInitialsArrByStr($(this).find('.item-title').text().charAt(0))[0].toUpperCase();
		if(initial >= 'A' && initial <= 'Z') {
			if(initials.indexOf(initial) === -1)
				initials.push(initial);
		} else {
			num++;
		}

	});

	$.each(initials, function(index, value) { //添加首字母标签
		SortBox.append('<li class="list-group-title" id="' + value + '">' + value + '</li>');
	});
	if(num != 0) {
		SortBox.append('<li class="list-group-title" id="default"  style="line-height: 30px;">*</li>');
	}

	for(var i = 0; i < SortList.length; i++) { //插入到对应的首字母后面
		var letter = $.getInitialsArrByStr(SortList.eq(i).find('.item-title').text().charAt(0))[0].toUpperCase();
		switch(letter) {
			case "A":
				$('#A').after(SortList.eq(i));
				break;
			case "B":
				$('#B').after(SortList.eq(i));
				break;
			case "C":
				$('#C').after(SortList.eq(i));
				break;
			case "D":
				$('#D').after(SortList.eq(i));
				break;
			case "E":
				$('#E').after(SortList.eq(i));
				break;
			case "F":
				$('#F').after(SortList.eq(i));
				break;
			case "G":
				$('#G').after(SortList.eq(i));
				break;
			case "H":
				$('#H').after(SortList.eq(i));
				break;
			case "I":
				$('#I').after(SortList.eq(i));
				break;
			case "J":
				$('#J').after(SortList.eq(i));
				break;
			case "K":
				$('#K').after(SortList.eq(i));
				break;
			case "L":
				$('#L').after(SortList.eq(i));
				break;
			case "M":
				$('#M').after(SortList.eq(i));
				break;
			case "N":
				$('#N').after(SortList.eq(i));
				break;
			case "O":
				$('#O').after(SortList.eq(i));
				break;
			case "P":
				$('#P').after(SortList.eq(i));
				break;
			case "Q":
				$('#Q').after(SortList.eq(i));
				break;
			case "R":
				$('#R').after(SortList.eq(i));
				break;
			case "S":
				$('#S').after(SortList.eq(i));
				break;
			case "T":
				$('#T').after(SortList.eq(i));
				break;
			case "U":
				$('#U').after(SortList.eq(i));
				break;
			case "V":
				$('#V').after(SortList.eq(i));
				break;
			case "W":
				$('#W').after(SortList.eq(i));
				break;
			case "X":
				$('#X').after(SortList.eq(i));
				break;
			case "Y":
				$('#Y').after(SortList.eq(i));
				break;
			case "Z":
				$('#Z').after(SortList.eq(i));
				break;
			default:
				$('#default').after(SortList.eq(i));
				break;
		}
	};
}
getDeviceName();
