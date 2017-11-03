$(document).on("pageInit", "#page-friendslist_tpl", function() {
	setTimeout(geoLocation, 300);

	//自定义scrollTo方法
	$.fn.scrollTo = function(options) {
		var defaults = {
			toT : 0, //滚动目标位置
			durTime : 500, //过渡动画时间
			delay : 30, //定时器时间
			callback : null //回调函数
		};
		var opts = $.extend(defaults, options), timer = null, _this = this, curTop = _this.scrollTop(), //滚动条当前的位置
		subTop = opts.toT - curTop, //滚动条目标位置和当前位置的差值
		index = 0, dur = Math.round(opts.durTime / opts.delay), smoothScroll = function(t) {
			index++;
			var per = Math.round(subTop / dur);
			if (index >= dur) {
				_this.scrollTop(t);
				window.clearInterval(timer);
				if (opts.callback && typeof opts.callback == 'function') {
					opts.callback();
				}
				return;
			} else {
				_this.scrollTop(curTop + index * per);
			}
		};
		timer = window.setInterval(function() {
			smoothScroll(opts.toT);
		}, opts.delay);
		return _this;
	};

	//模拟数据
	var main = function() {
		//测试数据
		var testNative = [{
			upcase : 'A',
			data : ['A北京', 'A北京']
		}, {
			upcase : 'B',
			data : ['B北京', 'B北京']
		}, {
			upcase : 'C',
			data : ['C北京', 'C北京']
		}, {
			upcase : 'D',
			data : ['D北京', 'D北京']
		}, {
			upcase : 'E',
			data : ['E北京', 'E北京']
		}, {
			upcase : 'F',
			data : ['F北京', 'F北京']
		}, {
			upcase : 'G',
			data : ['北京', '北京']
		}, {
			upcase : 'H',
			data : ['北京', '北京']
		}, {
			upcase : 'I',
			data : ['北京', '北京']
		}, {
			upcase : 'J',
			data : ['北京', '北京']
		}];

		testNative = {
			list : testNative};
		var html = template('tpl_list_item_native', testNative);
		$('.cityList').html(html);

		//国内离开焦点检测
		$('#native-search').on('blur', function(e) {
			var key = $(this).val();
			if (!key)
				return;
			scroll(dataIndex(key, testNative.list));
		});

		$('#grv-search').on('blur', function(e) {
			var key = $(this).val();
			if (!key)
				return;
			scroll(dataIndex(key, testNative.list));
		});

		//选择城市
		$('.hot_citylist').on('click', 'li', function(e) {
			$.toast('您当前选中的城市是:' + $(this).text());
		});

		$('.cityName').on('click', function(e) {
			$.toast('您当前选中的城市是:' + $(this).text());
		});

		//监听滚动条位置
		$('.silider-search a').on('click', function() {
			scroll($(this).text());
		});

		touch();
	}
	function geoLocation() {
		AgreeSDK.Geolocation.getLocationInfo(function(msg) {
			var address = msg.checkAddr;
			var res = address.split('市')[0];
			address = res.substr(2, res.length - 1);
			$('#location_city').text(address);
		}, function(err) {
			alert(err);
		});
	}

	function dataIndex(key, testNative) {
		var refuse;

		testNative.map(function(v) {
			if (key.toString().toUpperCase() == v.upcase) {
				refuse = v.upcase;
				return;
			}

			v.data.map(function(sv) {
				if (sv.indexOf(key) != -1) {
					refuse = v.upcase;
					return;
				}
			})
		})
		return refuse;
	}

	function touch() {
		var el = document.getElementById('silider-search'), chars = 'ABCDEFGHIJKLMNPQRSTWXYZ', charOffsetX = 80, charOffsetY = 20, touching = false, lastChar, boxRect = el.getBoundingClientRect(), boxHeight = boxRect.height, boxClientTop = boxRect.top;

		// touch events
		if ('ontouchstart' in document) {
			el.addEventListener('touchstart', function(e) {
				if (!touching) {
					e.preventDefault()
					var t = e.touches[0]
					start(t.clientX, t.clientY)
				}
			}, false)
			document.addEventListener('touchmove', function handler(e) {
				if (touching) {
					e.preventDefault()
					var t = e.touches[0]
					move(t.clientX, t.clientY)
				}
			}, false)
			document.addEventListener('touchend', function(e) {
				if (touching) {
					e.preventDefault()
					end()
				}
			}, false)
		}
		// mouse events
		else {
			el.addEventListener('mousedown', function(e) {
				if (!touching) {
					e.preventDefault()
					start(e.clientX, e.clientY)
				}
			})
			document.addEventListener('mousemove', function(e) {
				if (touching) {
					e.preventDefault()
					move(e.clientX, e.clientY)
				}
			})
			document.addEventListener('mouseup', function(e) {
				if (touching) {
					e.preventDefault()
					end()
				}
			})
		}

		function start(clientX, clientY) {
			touching = true
			move(clientX, clientY)
		}

		function move(clientX, clientY) {
			var offset = calcRelativePosition(clientY)
			var percent = offset / boxHeight
			var ch = getPositionChar(percent)
			updateChar(clientX, clientY, ch)
		}

		function end() {
			touching = false
		}

		function updateChar(clientX, clientY, ch) {
			var x = Math.max(clientX, charOffsetX)
			var yMin = boxClientTop
			var yMax = window.innerHeight - charOffsetY
			var y = Math.min(Math.max(clientY, yMin), yMax)

			$.toast(ch, 0);
			scroll(ch);

			if (ch && lastChar !== ch) {
				lastChar = ch
			}
		}

		function calcRelativePosition(clientY) {
			var y = clientY - boxClientTop
			if (y < 0) {
				y = 0
			} else if (y > boxHeight) {
				y = boxHeight
			}
			return y
		}

		// yPercent {Number} in range of [0, 1]
		function getPositionChar(yPercent) {
			var min = 1
			var max = chars.length
			var index = Math.ceil(yPercent * max)
			if (index < min) {
				index = min
			} else if (index > max) {
				index = max
			}
			return chars[index - 1]
		}

	}

	var scroll = function(att) {
		var tab = $('.active').attr('ar-key'), offset = tab == '1' ? $('#' + att).offset() : $('#grv_' + att).offset(), scrollHeight = $('.content').scrollTop();
		if (!offset) {
			//	    	$.toast('暂无数据!');
			return;
		}
		$('.content').scrollTo({
			toT : offset.top + scrollHeight,
			durTime : 300
		});
	}
	//GO
	main();
});
getDeviceName();