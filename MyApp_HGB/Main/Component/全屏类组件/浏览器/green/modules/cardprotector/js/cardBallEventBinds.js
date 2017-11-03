$(document).on("pageInit", "#page-cardBall_tpl", function() {

	var temp_userinfo = {};
	//存储一个全局变量 - 页面对象
	var vue_modual = {};
	(function($) {
		var SwipeItemContent = function(ele, opts) {
			this.$ele = ele;
			var supportTouch = 'ontouchend' in document,
				touchStartEvent = supportTouch ? 'touchstart' : 'mousedown', //触屏
				touchMoveEvent = supportTouch ? 'touchmove' : 'mousemove', //移动
				touchEndEvent = supportTouch ? 'touchend' : 'mouseup', //离屏
				startPosition, movePosition, endPosition, down, moveWidth; //开始、移动、结束、
			//设置定位
			moveWidth = this.$ele.find('.item-after').width();
			this.$ele.find('.item-content').css('padding', '0');
			this.$ele.find('ul').css('overflow', 'hidden');
			this.$ele.find('.item-media').css({
				'position': 'absolute',
				'left': '0.75rem'
			});
			this.$ele.find('.item-title').css('left', '1.75rem');
			this.$ele.find('.item-inner').css({
				'position': 'absolute',
				'padding': '0',
				'margin': '0',
				'overflow': 'visible'
			});
			this.$ele.find('.item-after').css({
				'transform': 'translate3d(10px, 0px, 0px)',
				'position': 'absolute',
				'right': '0'
			})
			//获取开始位置
			this.$ele.on(touchStartEvent, 'li', function(e) {
				startPosition = supportTouch ? e.touches[0].pageX : e.pageX;
				down = true;
			})
			//实时移动
			this.$ele.on(touchMoveEvent, 'li', function(e) {
				if(down) {

					movePosition = supportTouch ? e.touches[0].pageX : e.pageX;
					endPosition = movePosition;
					movePosition = movePosition - startPosition;
					console.log(startPosition + "," + movePosition);
					$(this).find('.item-media')[0].style.transform = 'translate3d(' + movePosition + 'px, 0px, 0px)';
					$(this).find('.item-inner')[0].style.transform = 'translate3d(' + movePosition + 'px, 0px, 0px)';
				}
			})
			//结束位置
			this.$ele.on(touchEndEvent, 'li', function(e) {
				down = false;
				console.log(startPosition + "," + endPosition);
				console.log("--" + moveWidth);
				if(endPosition - startPosition < -50) {
					$(this).find('.item-media')[0].style.transform = 'translate3d(' + movePosition + 'px, 0px, 0px)';
					$(this).find('.item-inner')[0].style.transform = 'translate3d(-70px, 0px, 0px)';
				} else {
					$(this).find('.item-media')[0].style.transform = 'translate3d(0px, 0px, 0px)';
					$(this).find('.item-inner')[0].style.transform = 'translate3d(0px, 0px, 0px)';
				}
				down = false;
			})
		}
		$.fn.swipeItemContent = function(opt) {
			$(this).each(function(index, el) {
				var swipeItemContent = new SwipeItemContent($(this), opt);
			});
		}

		//添加绑定卡
		$('#addCard').on('click', function() {
			//点击卡包：分为未绑定和已经绑定页面
			//$.router.load('../../modules/cardprotector/card_ball_without_tpl.html');
			$.router.load('searchShops_tpl.html', true);
		});

	})(window.$)

	var vm = new Vue({
		el: '#page-cardBall_tpl', //@绑定节点
		data: { //@数据
			cardBollList: {},
			cardcount: 0
		},
		methods: { //@方法-事件调用(this指向data)
			getCardBollList: function() {

			},
			addCard: function() {
				$.router.load('searchShops_tpl.html', true);
			},
			unbundleCard: function(id) {
				var _this = this;
				$.confirm('解绑会员卡</br>此处解除只是在本平台无法查看会员商户信息，不影响真正商户会员关系。', function() {
						$.showPreloader('正在处理...');
						//点击确定按钮
						var post_adress = url_ + "mobile/cardPackage/carPackageUnBinding.jhtml";
						var data = {
							user_id_: id,
							member_id_: temp_userinfo.id_
						};
						var temp_token = temp_userinfo.token_;
						var temp_deviceid = temp_userinfo.device_id_;
						AgreeSDK.Connection.getNetWorkRequest(post_adress, data, temp_token, temp_deviceid, function(msg) {
							$.hidePreloader();
							$.toast(msg.appmsg);

							if(msg.appcode == 1) {
								loadCardList();
							}
						}, function(err) {
							$.hidePreloader();
							$.toast('网络请求失败!');
						});
					},
					function() {
						//点击canel按钮
					});
			}
		},
		created: function() { //@业务逻辑（this指向data）
			vue_modual = this;
			init();
			//this.getCardBollList();

		}
	});

	//界面初始化
	function init() {
		temp_userinfo = getsession("userInfo");
		//我绑定的卡包列表
		//               vue_modual.cardBollList = new Array();
		//               var obj = {};
		//               obj.id_ = 'itemContent_1';
		//               obj.name_ = '123';
		//               obj.imgae_ = '1.jpg';
		//               vue_modual.cardBollList.push(obj);
		//               var obj = {};
		//               obj.id_ = 'itemContent_2';
		//               obj.name_ = '123';
		//               obj.imgae_ = '1.jpg';
		//               vue_modual.cardBollList.push(obj);
		//               setTimeout(function(){
		//                          //初始化swipeItemContent(支持多元素选择)
		//                          $("#swipeItemContent_1").swipeItemContent();
		//                          },1000);
		loadCardList();
	}

	function loadCardList() {

		var post_adress = url_ + "mobile/cardPackage/carPackageList.jhtml";
		var data = {
			page: 1,
			start: 0,
			limit: 100,
			id_: temp_userinfo.id_
		};
		var temp_token = temp_userinfo.token_;
		var temp_deviceid = temp_userinfo.device_id_;
		AgreeSDK.Connection.getNetWorkRequest(post_adress, data, temp_token, temp_deviceid, function(msg) {
			if(msg.appcode == 1) {
				vue_modual.cardBollList = msg.data;
				vue_modual.cardcount = vue_modual.cardBollList.length;
				//记录当前已绑定的卡包列表
				conserve('usercardList', msg.data);

				saveFile("tenanInfo", msg.data, function() {
					conserve("temp_tenant_info", msg.data);
				}, function(error) {
					//未获取到数据
				});
				setTimeout(function() {
					//初始化swipeItemContent(支持多元素选择)
					$("#swipeItemContent_1").swipeItemContent();
				}, 10);
			}
		}, function(err) {
			$.toast('网络请求失败!');
		});
	}

	/*$(".list-block").swipeItemContent();*/

})