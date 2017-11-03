/*!
 * =====================================================
 * SUI Mobile - http://m.sui.taobao.org/
 *
 * =====================================================
 */
;
$.smVersion = "0.6.2"; +
function($) {
	"use strict";

	//全局配置
	var defaults = {
		autoInit: false, //自动初始化页面
		showPageLoadingIndicator: true, //push.js加载页面的时候显示一个加载提示
		router: true, //默认使用router
		swipePanel: "left", //滑动打开侧栏
		swipePanelOnlyClose: true //只允许滑动关闭，不允许滑动打开侧栏
	};

	$.smConfig = $.extend(defaults, $.config);

}(Zepto);

+
function($) {
	"use strict";

	//比较一个字符串版本号
	//a > b === 1
	//a = b === 0
	//a < b === -1
	$.compareVersion = function(a, b) {
		var as = a.split('.');
		var bs = b.split('.');
		if(a === b) return 0;

		for(var i = 0; i < as.length; i++) {
			var x = parseInt(as[i]);
			if(!bs[i]) return 1;
			var y = parseInt(bs[i]);
			if(x < y) return -1;
			if(x > y) return 1;
		}
		return -1;
	};

	$.getCurrentPage = function() {
		return $(".page-current")[0] || $(".page")[0] || document.body;
	};

}(Zepto);

/* global WebKitCSSMatrix:true */

(function($) {
	"use strict";
	['width', 'height'].forEach(function(dimension) {
		var Dimension = dimension.replace(/./, function(m) {
			return m[0].toUpperCase();
		});
		$.fn['outer' + Dimension] = function(margin) {
			var elem = this;
			if(elem) {
				var size = elem[dimension]();
				var sides = {
					'width': ['left', 'right'],
					'height': ['top', 'bottom']
				};
				sides[dimension].forEach(function(side) {
					if(margin) size += parseInt(elem.css('margin-' + side), 10);
				});
				return size;
			} else {
				return null;
			}
		};
	});

	//support
	$.support = (function() {
		var support = {
			touch: !!(('ontouchstart' in window) || window.DocumentTouch && document instanceof window.DocumentTouch)
		};
		return support;
	})();

	$.touchEvents = {
		start: $.support.touch ? 'touchstart' : 'mousedown',
		move: $.support.touch ? 'touchmove' : 'mousemove',
		end: $.support.touch ? 'touchend' : 'mouseup'
	};

	$.getTranslate = function(el, axis) {
		var matrix, curTransform, curStyle, transformMatrix;

		// automatic axis detection
		if(typeof axis === 'undefined') {
			axis = 'x';
		}

		curStyle = window.getComputedStyle(el, null);
		if(window.WebKitCSSMatrix) {
			// Some old versions of Webkit choke when 'none' is passed; pass
			// empty string instead in this case
			transformMatrix = new WebKitCSSMatrix(curStyle.webkitTransform === 'none' ? '' : curStyle.webkitTransform);
		} else {
			transformMatrix = curStyle.MozTransform || curStyle.transform || curStyle.getPropertyValue('transform').replace('translate(', 'matrix(1, 0, 0, 1,');
			matrix = transformMatrix.toString().split(',');
		}

		if(axis === 'x') {
			//Latest Chrome and webkits Fix
			if(window.WebKitCSSMatrix)
				curTransform = transformMatrix.m41;
			//Crazy IE10 Matrix
			else if(matrix.length === 16)
				curTransform = parseFloat(matrix[12]);
			//Normal Browsers
			else
				curTransform = parseFloat(matrix[4]);
		}
		if(axis === 'y') {
			//Latest Chrome and webkits Fix
			if(window.WebKitCSSMatrix)
				curTransform = transformMatrix.m42;
			//Crazy IE10 Matrix
			else if(matrix.length === 16)
				curTransform = parseFloat(matrix[13]);
			//Normal Browsers
			else
				curTransform = parseFloat(matrix[5]);
		}

		return curTransform || 0;
	};
	$.requestAnimationFrame = function(callback) {
		if(window.requestAnimationFrame) return window.requestAnimationFrame(callback);
		else if(window.webkitRequestAnimationFrame) return window.webkitRequestAnimationFrame(callback);
		else if(window.mozRequestAnimationFrame) return window.mozRequestAnimationFrame(callback);
		else {
			return window.setTimeout(callback, 1000 / 60);
		}
	};
	$.cancelAnimationFrame = function(id) {
		if(window.cancelAnimationFrame) return window.cancelAnimationFrame(id);
		else if(window.webkitCancelAnimationFrame) return window.webkitCancelAnimationFrame(id);
		else if(window.mozCancelAnimationFrame) return window.mozCancelAnimationFrame(id);
		else {
			return window.clearTimeout(id);
		}
	};

	$.fn.dataset = function() {
		var dataset = {},
			ds = this[0].dataset;
		for(var key in ds) {
			var item = (dataset[key] = ds[key]);
			if(item === 'false') dataset[key] = false;
			else if(item === 'true') dataset[key] = true;
			else if(parseFloat(item) === item * 1) dataset[key] = item * 1;
		}
		// mixin dataset and __eleData
		return $.extend({}, dataset, this[0].__eleData);
	};
	$.fn.data = function(key, value) {
		var tmpData = $(this).dataset();
		if(!key) {
			return tmpData;
		}
		// value may be 0, false, null
		if(typeof value === 'undefined') {
			// Get value
			var dataVal = tmpData[key],
				__eD = this[0].__eleData;

			//if (dataVal !== undefined) {
			if(__eD && (key in __eD)) {
				return __eD[key];
			} else {
				return dataVal;
			}

		} else {
			// Set value,uniformly set in extra ```__eleData```
			for(var i = 0; i < this.length; i++) {
				var el = this[i];
				// delete multiple data in dataset
				if(key in tmpData) delete el.dataset[key];

				if(!el.__eleData) el.__eleData = {};
				el.__eleData[key] = value;
			}
			return this;
		}
	};

	function __dealCssEvent(eventNameArr, callback) {
		var events = eventNameArr,
			i, dom = this;

		function fireCallBack(e) {
			if(e.target !== this) return;
			callback.call(this, e);
			for(i = 0; i < events.length; i++) {
				dom.off(events[i], fireCallBack);
			}
		}

		if(callback) {
			for(i = 0; i < events.length; i++) {
				dom.on(events[i], fireCallBack);
			}
		}
	}

	$.fn.animationEnd = function(callback) {
		__dealCssEvent.call(this, ['webkitAnimationEnd', 'animationend'], callback);
		return this;
	};
	$.fn.transitionEnd = function(callback) {
		__dealCssEvent.call(this, ['webkitTransitionEnd', 'transitionend'], callback);
		return this;
	};
	$.fn.transition = function(duration) {
		if(typeof duration !== 'string') {
			duration = duration + 'ms';
		}
		for(var i = 0; i < this.length; i++) {
			var elStyle = this[i].style;
			elStyle.webkitTransitionDuration = elStyle.MozTransitionDuration = elStyle.transitionDuration = duration;
		}
		return this;
	};
	$.fn.transform = function(transform) {
		for(var i = 0; i < this.length; i++) {
			var elStyle = this[i].style;
			elStyle.webkitTransform = elStyle.MozTransform = elStyle.transform = transform;
		}
		return this;
	};
	$.fn.prevAll = function(selector) {
		var prevEls = [];
		var el = this[0];
		if(!el) return $([]);
		while(el.previousElementSibling) {
			var prev = el.previousElementSibling;
			if(selector) {
				if($(prev).is(selector)) prevEls.push(prev);
			} else prevEls.push(prev);
			el = prev;
		}
		return $(prevEls);
	};
	$.fn.nextAll = function(selector) {
		var nextEls = [];
		var el = this[0];
		if(!el) return $([]);
		while(el.nextElementSibling) {
			var next = el.nextElementSibling;
			if(selector) {
				if($(next).is(selector)) nextEls.push(next);
			} else nextEls.push(next);
			el = next;
		}
		return $(nextEls);
	};

	//重置zepto的show方法，防止有些人引用的版本中 show 方法操作 opacity 属性影响动画执行
	$.fn.show = function() {
		var elementDisplay = {};

		function defaultDisplay(nodeName) {
			var element, display;
			if(!elementDisplay[nodeName]) {
				element = document.createElement(nodeName);
				document.body.appendChild(element);
				display = getComputedStyle(element, '').getPropertyValue("display");
				element.parentNode.removeChild(element);
				display === "none" && (display = "block");
				elementDisplay[nodeName] = display;
			}
			return elementDisplay[nodeName];
		}

		return this.each(function() {
			this.style.display === "none" && (this.style.display = '');
			if(getComputedStyle(this, '').getPropertyValue("display") === "none");
			this.style.display = defaultDisplay(this.nodeName);
		});
	};
})(Zepto);

/*===========================
 Device/OS Detection
 ===========================*/
;
(function($) {
	"use strict";
	var device = {};
	var ua = navigator.userAgent;

	var android = ua.match(/(Android);?[\s\/]+([\d.]+)?/);
	var ipad = ua.match(/(iPad).*OS\s([\d_]+)/);
	var ipod = ua.match(/(iPod)(.*OS\s([\d_]+))?/);
	var iphone = !ipad && ua.match(/(iPhone\sOS)\s([\d_]+)/);

	device.ios = device.android = device.iphone = device.ipad = device.androidChrome = false;

	// Android
	if(android) {
		device.os = 'android';
		device.osVersion = android[2];
		device.android = true;
		device.androidChrome = ua.toLowerCase().indexOf('chrome') >= 0;
	}
	if(ipad || iphone || ipod) {
		device.os = 'ios';
		device.ios = true;
	}
	// iOS
	if(iphone && !ipod) {
		device.osVersion = iphone[2].replace(/_/g, '.');
		device.iphone = true;
	}
	if(ipad) {
		device.osVersion = ipad[2].replace(/_/g, '.');
		device.ipad = true;
	}
	if(ipod) {
		device.osVersion = ipod[3] ? ipod[3].replace(/_/g, '.') : null;
		device.iphone = true;
	}
	// iOS 8+ changed UA
	if(device.ios && device.osVersion && ua.indexOf('Version/') >= 0) {
		if(device.osVersion.split('.')[0] === '10') {
			device.osVersion = ua.toLowerCase().split('version/')[1].split(' ')[0];
		}
	}

	// Webview
	device.webView = (iphone || ipad || ipod) && ua.match(/.*AppleWebKit(?!.*Safari)/i);

	// Minimal UI
	if(device.os && device.os === 'ios') {
		var osVersionArr = device.osVersion.split('.');
		device.minimalUi = !device.webView &&
			(ipod || iphone) &&
			(osVersionArr[0] * 1 === 7 ? osVersionArr[1] * 1 >= 1 : osVersionArr[0] * 1 > 7) &&
			$('meta[name="viewport"]').length > 0 && $('meta[name="viewport"]').attr('content').indexOf('minimal-ui') >= 0;
	}

	// Check for status bar and fullscreen app mode
	var windowWidth = $(window).width();
	var windowHeight = $(window).height();
	device.statusBar = false;
	if(device.webView && (windowWidth * windowHeight === screen.width * screen.height)) {
		device.statusBar = true;
	} else {
		device.statusBar = false;
	}

	// Classes
	var classNames = [];

	// Pixel Ratio
	device.pixelRatio = window.devicePixelRatio || 1;
	classNames.push('pixel-ratio-' + Math.floor(device.pixelRatio));
	if(device.pixelRatio >= 2) {
		classNames.push('retina');
	}

	// OS classes
	if(device.os) {
		classNames.push(device.os, device.os + '-' + device.osVersion.split('.')[0], device.os + '-' + device.osVersion.replace(/\./g, '-'));
		if(device.os === 'ios') {
			var major = parseInt(device.osVersion.split('.')[0], 10);
			for(var i = major - 1; i >= 6; i--) {
				classNames.push('ios-gt-' + i);
			}
		}

	}
	// Status bar classes
	if(device.statusBar) {
		classNames.push('with-statusbar-overlay');
	} else {
		$('html').removeClass('with-statusbar-overlay');
	}

	// Add html classes
	if(classNames.length > 0) $('html').addClass(classNames.join(' '));

	// keng..
	device.isWeixin = /MicroMessenger/i.test(ua);

	$.device = device;
})(Zepto);

;
(function() {
	'use strict';

	/**
	 * @preserve FastClick: polyfill to remove click delays on browsers with touch UIs.
	 *
	 * @codingstandard ftlabs-jsv2
	 * @copyright The Financial Times Limited [All Rights Reserved]
	 * @license MIT License (see LICENSE.txt)
	 */

	/*jslint browser:true, node:true, elision:true*/
	/*global Event, Node*/

	/**
	 * Instantiate fast-clicking listeners on the specified layer.
	 *
	 * @constructor
	 * @param {Element} layer The layer to listen on
	 * @param {Object} [options={}] The options to override the defaults
	 */
	function FastClick(layer, options) {
		var oldOnClick;

		options = options || {};

		/**
		 * Whether a click is currently being tracked.
		 *
		 * @type boolean
		 */
		this.trackingClick = false;

		/**
		 * Timestamp for when click tracking started.
		 *
		 * @type number
		 */
		this.trackingClickStart = 0;

		/**
		 * The element being tracked for a click.
		 *
		 * @type EventTarget
		 */
		this.targetElement = null;

		/**
		 * X-coordinate of touch start event.
		 *
		 * @type number
		 */
		this.touchStartX = 0;

		/**
		 * Y-coordinate of touch start event.
		 *
		 * @type number
		 */
		this.touchStartY = 0;

		/**
		 * ID of the last touch, retrieved from Touch.identifier.
		 *
		 * @type number
		 */
		this.lastTouchIdentifier = 0;

		/**
		 * Touchmove boundary, beyond which a click will be cancelled.
		 *
		 * @type number
		 */
		this.touchBoundary = options.touchBoundary || 10;

		/**
		 * The FastClick layer.
		 *
		 * @type Element
		 */
		this.layer = layer;

		/**
		 * The minimum time between tap(touchstart and touchend) events
		 *
		 * @type number
		 */
		this.tapDelay = options.tapDelay || 200;

		/**
		 * The maximum time for a tap
		 *
		 * @type number
		 */
		this.tapTimeout = options.tapTimeout || 700;

		if(FastClick.notNeeded(layer)) {
			return;
		}

		// Some old versions of Android don't have Function.prototype.bind
		function bind(method, context) {
			return function() {
				return method.apply(context, arguments);
			};
		}

		var methods = ['onMouse', 'onClick', 'onTouchStart', 'onTouchMove', 'onTouchEnd', 'onTouchCancel'];
		var context = this;
		for(var i = 0, l = methods.length; i < l; i++) {
			context[methods[i]] = bind(context[methods[i]], context);
		}

		// Set up event handlers as required
		if(deviceIsAndroid) {
			layer.addEventListener('mouseover', this.onMouse, true);
			layer.addEventListener('mousedown', this.onMouse, true);
			layer.addEventListener('mouseup', this.onMouse, true);
		}

		layer.addEventListener('click', this.onClick, true);
		layer.addEventListener('touchstart', this.onTouchStart, false);
		layer.addEventListener('touchmove', this.onTouchMove, false);
		layer.addEventListener('touchend', this.onTouchEnd, false);
		layer.addEventListener('touchcancel', this.onTouchCancel, false);

		// Hack is required for browsers that don't support Event#stopImmediatePropagation (e.g. Android 2)
		// which is how FastClick normally stops click events bubbling to callbacks registered on the FastClick
		// layer when they are cancelled.
		if(!Event.prototype.stopImmediatePropagation) {
			layer.removeEventListener = function(type, callback, capture) {
				var rmv = Node.prototype.removeEventListener;
				if(type === 'click') {
					rmv.call(layer, type, callback.hijacked || callback, capture);
				} else {
					rmv.call(layer, type, callback, capture);
				}
			};

			layer.addEventListener = function(type, callback, capture) {
				var adv = Node.prototype.addEventListener;
				if(type === 'click') {
					adv.call(layer, type, callback.hijacked || (callback.hijacked = function(event) {
						if(!event.propagationStopped) {
							callback(event);
						}
					}), capture);
				} else {
					adv.call(layer, type, callback, capture);
				}
			};
		}

		// If a handler is already declared in the element's onclick attribute, it will be fired before
		// FastClick's onClick handler. Fix this by pulling out the user-defined handler function and
		// adding it as listener.
		if(typeof layer.onclick === 'function') {

			// Android browser on at least 3.2 requires a new reference to the function in layer.onclick
			// - the old one won't work if passed to addEventListener directly.
			oldOnClick = layer.onclick;
			layer.addEventListener('click', function(event) {
				oldOnClick(event);
			}, false);
			layer.onclick = null;
		}
	}

	/**
	 * Windows Phone 8.1 fakes user agent string to look like Android and iPhone.
	 *
	 * @type boolean
	 */
	var deviceIsWindowsPhone = navigator.userAgent.indexOf("Windows Phone") >= 0;

	/**
	 * Android requires exceptions.
	 *
	 * @type boolean
	 */
	var deviceIsAndroid = navigator.userAgent.indexOf('Android') > 0 && !deviceIsWindowsPhone;

	/**
	 * iOS requires exceptions.
	 *
	 * @type boolean
	 */
	var deviceIsIOS = /iP(ad|hone|od)/.test(navigator.userAgent) && !deviceIsWindowsPhone;

	/**
	 * iOS 4 requires an exception for select elements.
	 *
	 * @type boolean
	 */
	var deviceIsIOS4 = deviceIsIOS && (/OS 4_\d(_\d)?/).test(navigator.userAgent);

	/**
	 * iOS 6.0-7.* requires the target element to be manually derived
	 *
	 * @type boolean
	 */
	var deviceIsIOSWithBadTarget = deviceIsIOS && (/OS [6-7]_\d/).test(navigator.userAgent);

	/**
	 * BlackBerry requires exceptions.
	 *
	 * @type boolean
	 */
	var deviceIsBlackBerry10 = navigator.userAgent.indexOf('BB10') > 0;

	/**
	 * 判断是否组合型label
	 * @type {Boolean}
	 */
	var isCompositeLabel = false;

	/**
	 * Determine whether a given element requires a native click.
	 *
	 * @param {EventTarget|Element} target Target DOM element
	 * @returns {boolean} Returns true if the element needs a native click
	 */
	FastClick.prototype.needsClick = function(target) {

		// 修复bug: 如果父元素中有 label
		// 如果label上有needsclick这个类，则用原生的点击，否则，用模拟点击
		var parent = target;
		while(parent && (parent.tagName.toUpperCase() !== "BODY")) {
			if(parent.tagName.toUpperCase() === "LABEL") {
				isCompositeLabel = true;
				if((/\bneedsclick\b/).test(parent.className)) return true;
			}
			parent = parent.parentNode;
		}

		switch(target.nodeName.toLowerCase()) {

			// Don't send a synthetic click to disabled inputs (issue #62)
			case 'button':
			case 'select':
			case 'textarea':
				if(target.disabled) {
					return true;
				}

				break;
			case 'input':

				// File inputs need real clicks on iOS 6 due to a browser bug (issue #68)
				if((deviceIsIOS && target.type === 'file') || target.disabled) {
					return true;
				}

				break;
			case 'label':
			case 'iframe': // iOS8 homescreen apps can prevent events bubbling into frames
			case 'video':
				return true;
		}

		return(/\bneedsclick\b/).test(target.className);
	};

	/**
	 * Determine whether a given element requires a call to focus to simulate click into element.
	 *
	 * @param {EventTarget|Element} target Target DOM element
	 * @returns {boolean} Returns true if the element requires a call to focus to simulate native click.
	 */
	FastClick.prototype.needsFocus = function(target) {
		switch(target.nodeName.toLowerCase()) {
			case 'textarea':
				return true;
			case 'select':
				return !deviceIsAndroid;
			case 'input':
				switch(target.type) {
					case 'button':
					case 'checkbox':
					case 'file':
					case 'image':
					case 'radio':
					case 'submit':
						return false;
				}

				// No point in attempting to focus disabled inputs
				return !target.disabled && !target.readOnly;
			default:
				return(/\bneedsfocus\b/).test(target.className);
		}
	};

	/**
	 * Send a click event to the specified element.
	 *
	 * @param {EventTarget|Element} targetElement
	 * @param {Event} event
	 */
	FastClick.prototype.sendClick = function(targetElement, event) {
		var clickEvent, touch;

		// On some Android devices activeElement needs to be blurred otherwise the synthetic click will have no effect (#24)
		if(document.activeElement && document.activeElement !== targetElement) {
			document.activeElement.blur();
		}

		touch = event.changedTouches[0];

		// Synthesise a click event, with an extra attribute so it can be tracked
		clickEvent = document.createEvent('MouseEvents');
		clickEvent.initMouseEvent(this.determineEventType(targetElement), true, true, window, 1, touch.screenX, touch.screenY, touch.clientX, touch.clientY, false, false, false, false, 0, null);
		clickEvent.forwardedTouchEvent = true;
		targetElement.dispatchEvent(clickEvent);
	};

	FastClick.prototype.determineEventType = function(targetElement) {

		//Issue #159: Android Chrome Select Box does not open with a synthetic click event
		if(deviceIsAndroid && targetElement.tagName.toLowerCase() === 'select') {
			return 'mousedown';
		}

		return 'click';
	};

	/**
	 * @param {EventTarget|Element} targetElement
	 */
	FastClick.prototype.focus = function(targetElement) {
		var length;

		// Issue #160: on iOS 7, some input elements (e.g. date datetime month) throw a vague TypeError on setSelectionRange. These elements don't have an integer value for the selectionStart and selectionEnd properties, but unfortunately that can't be used for detection because accessing the properties also throws a TypeError. Just check the type instead. Filed as Apple bug #15122724.
		var unsupportedType = ['date', 'time', 'month', 'number', 'email', 'range'];
		if(deviceIsIOS && targetElement.setSelectionRange && unsupportedType.indexOf(targetElement.type) === -1) {
			length = targetElement.value.length;
			targetElement.setSelectionRange(length, length);
		} else {
			targetElement.focus();
		}
	};

	/**
	 * Check whether the given target element is a child of a scrollable layer and if so, set a flag on it.
	 *
	 * @param {EventTarget|Element} targetElement
	 */
	FastClick.prototype.updateScrollParent = function(targetElement) {
		var scrollParent, parentElement;

		scrollParent = targetElement.fastClickScrollParent;

		// Attempt to discover whether the target element is contained within a scrollable layer. Re-check if the
		// target element was moved to another parent.
		if(!scrollParent || !scrollParent.contains(targetElement)) {
			parentElement = targetElement;
			do {
				if(parentElement.scrollHeight > parentElement.offsetHeight) {
					scrollParent = parentElement;
					targetElement.fastClickScrollParent = parentElement;
					break;
				}

				parentElement = parentElement.parentElement;
			} while (parentElement);
		}

		// Always update the scroll top tracker if possible.
		if(scrollParent) {
			scrollParent.fastClickLastScrollTop = scrollParent.scrollTop;
		}
	};

	/**
	 * @param {EventTarget} targetElement
	 * @returns {Element|EventTarget}
	 */
	FastClick.prototype.getTargetElementFromEventTarget = function(eventTarget) {

		// On some older browsers (notably Safari on iOS 4.1 - see issue #56) the event target may be a text node.
		if(eventTarget.nodeType === Node.TEXT_NODE) {
			return eventTarget.parentNode;
		}

		return eventTarget;
	};

	/**
	 * On touch start, record the position and scroll offset.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onTouchStart = function(event) {
		var targetElement, touch, selection;

		// Ignore multiple touches, otherwise pinch-to-zoom is prevented if both fingers are on the FastClick element (issue #111).
		if(event.targetTouches.length > 1) {
			return true;
		}

		targetElement = this.getTargetElementFromEventTarget(event.target);
		touch = event.targetTouches[0];

		if(deviceIsIOS) {

			// Only trusted events will deselect text on iOS (issue #49)
			selection = window.getSelection();
			if(selection.rangeCount && !selection.isCollapsed) {
				return true;
			}

			if(!deviceIsIOS4) {

				// Weird things happen on iOS when an alert or confirm dialog is opened from a click event callback (issue #23):
				// when the user next taps anywhere else on the page, new touchstart and touchend events are dispatched
				// with the same identifier as the touch event that previously triggered the click that triggered the alert.
				// Sadly, there is an issue on iOS 4 that causes some normal touch events to have the same identifier as an
				// immediately preceeding touch event (issue #52), so this fix is unavailable on that platform.
				// Issue 120: touch.identifier is 0 when Chrome dev tools 'Emulate touch events' is set with an iOS device UA string,
				// which causes all touch events to be ignored. As this block only applies to iOS, and iOS identifiers are always long,
				// random integers, it's safe to to continue if the identifier is 0 here.
				if(touch.identifier && touch.identifier === this.lastTouchIdentifier) {
					event.preventDefault();
					return false;
				}

				this.lastTouchIdentifier = touch.identifier;

				// If the target element is a child of a scrollable layer (using -webkit-overflow-scrolling: touch) and:
				// 1) the user does a fling scroll on the scrollable layer
				// 2) the user stops the fling scroll with another tap
				// then the event.target of the last 'touchend' event will be the element that was under the user's finger
				// when the fling scroll was started, causing FastClick to send a click event to that layer - unless a check
				// is made to ensure that a parent layer was not scrolled before sending a synthetic click (issue #42).
				this.updateScrollParent(targetElement);
			}
		}

		this.trackingClick = true;
		this.trackingClickStart = event.timeStamp;
		this.targetElement = targetElement;

		this.touchStartX = touch.pageX;
		this.touchStartY = touch.pageY;

		// Prevent phantom clicks on fast double-tap (issue #36)
		if((event.timeStamp - this.lastClickTime) < this.tapDelay) {
			event.preventDefault();
		}

		return true;
	};

	/**
	 * Based on a touchmove event object, check whether the touch has moved past a boundary since it started.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.touchHasMoved = function(event) {
		var touch = event.changedTouches[0],
			boundary = this.touchBoundary;

		if(Math.abs(touch.pageX - this.touchStartX) > boundary || Math.abs(touch.pageY - this.touchStartY) > boundary) {
			return true;
		}

		return false;
	};

	/**
	 * Update the last position.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onTouchMove = function(event) {
		if(!this.trackingClick) {
			return true;
		}

		// If the touch has moved, cancel the click tracking
		if(this.targetElement !== this.getTargetElementFromEventTarget(event.target) || this.touchHasMoved(event)) {
			this.trackingClick = false;
			this.targetElement = null;
		}

		return true;
	};

	/**
	 * Attempt to find the labelled control for the given label element.
	 *
	 * @param {EventTarget|HTMLLabelElement} labelElement
	 * @returns {Element|null}
	 */
	FastClick.prototype.findControl = function(labelElement) {

		// Fast path for newer browsers supporting the HTML5 control attribute
		if(labelElement.control !== undefined) {
			return labelElement.control;
		}

		// All browsers under test that support touch events also support the HTML5 htmlFor attribute
		if(labelElement.htmlFor) {
			return document.getElementById(labelElement.htmlFor);
		}

		// If no for attribute exists, attempt to retrieve the first labellable descendant element
		// the list of which is defined here: http://www.w3.org/TR/html5/forms.html#category-label
		return labelElement.querySelector('button, input:not([type=hidden]), keygen, meter, output, progress, select, textarea');
	};

	/**
	 * On touch end, determine whether to send a click event at once.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onTouchEnd = function(event) {
		var forElement, trackingClickStart, targetTagName, scrollParent, touch, targetElement = this.targetElement;

		if(!this.trackingClick) {
			return true;
		}

		// Prevent phantom clicks on fast double-tap (issue #36)
		if((event.timeStamp - this.lastClickTime) < this.tapDelay) {
			this.cancelNextClick = true;
			return true;
		}

		if((event.timeStamp - this.trackingClickStart) > this.tapTimeout) {
			return true;
		}
		//修复安卓微信下，input type="date" 的bug，经测试date,time,month已没问题
		var unsupportedType = ['date', 'time', 'month'];
		if(unsupportedType.indexOf(event.target.type) !== -1) {
			return false;
		}
		// Reset to prevent wrong click cancel on input (issue #156).
		this.cancelNextClick = false;

		this.lastClickTime = event.timeStamp;

		trackingClickStart = this.trackingClickStart;
		this.trackingClick = false;
		this.trackingClickStart = 0;

		// On some iOS devices, the targetElement supplied with the event is invalid if the layer
		// is performing a transition or scroll, and has to be re-detected manually. Note that
		// for this to function correctly, it must be called *after* the event target is checked!
		// See issue #57; also filed as rdar://13048589 .
		if(deviceIsIOSWithBadTarget) {
			touch = event.changedTouches[0];

			// In certain cases arguments of elementFromPoint can be negative, so prevent setting targetElement to null
			targetElement = document.elementFromPoint(touch.pageX - window.pageXOffset, touch.pageY - window.pageYOffset) || targetElement;
			targetElement.fastClickScrollParent = this.targetElement.fastClickScrollParent;
		}

		targetTagName = targetElement.tagName.toLowerCase();
		if(targetTagName === 'label') {
			forElement = this.findControl(targetElement);
			if(forElement) {
				this.focus(targetElement);
				if(deviceIsAndroid) {
					return false;
				}

				targetElement = forElement;
			}
		} else if(this.needsFocus(targetElement)) {

			// Case 1: If the touch started a while ago (best guess is 100ms based on tests for issue #36) then focus will be triggered anyway. Return early and unset the target element reference so that the subsequent click will be allowed through.
			// Case 2: Without this exception for input elements tapped when the document is contained in an iframe, then any inputted text won't be visible even though the value attribute is updated as the user types (issue #37).
			if((event.timeStamp - trackingClickStart) > 100 || (deviceIsIOS && window.top !== window && targetTagName === 'input')) {
				this.targetElement = null;
				return false;
			}

			this.focus(targetElement);
			this.sendClick(targetElement, event);

			// Select elements need the event to go through on iOS 4, otherwise the selector menu won't open.
			// Also this breaks opening selects when VoiceOver is active on iOS6, iOS7 (and possibly others)
			if(!deviceIsIOS || targetTagName !== 'select') {
				this.targetElement = null;
				event.preventDefault();
			}

			return false;
		}

		if(deviceIsIOS && !deviceIsIOS4) {

			// Don't send a synthetic click event if the target element is contained within a parent layer that was scrolled
			// and this tap is being used to stop the scrolling (usually initiated by a fling - issue #42).
			scrollParent = targetElement.fastClickScrollParent;
			if(scrollParent && scrollParent.fastClickLastScrollTop !== scrollParent.scrollTop) {
				return true;
			}
		}

		// Prevent the actual click from going though - unless the target node is marked as requiring
		// real clicks or if it is in the whitelist in which case only non-programmatic clicks are permitted.
		if(!this.needsClick(targetElement)) {
			event.preventDefault();
			this.sendClick(targetElement, event);
		}

		return false;
	};

	/**
	 * On touch cancel, stop tracking the click.
	 *
	 * @returns {void}
	 */
	FastClick.prototype.onTouchCancel = function() {
		this.trackingClick = false;
		this.targetElement = null;
	};

	/**
	 * Determine mouse events which should be permitted.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onMouse = function(event) {

		// If a target element was never set (because a touch event was never fired) allow the event
		if(!this.targetElement) {
			return true;
		}

		if(event.forwardedTouchEvent) {
			return true;
		}

		// Programmatically generated events targeting a specific element should be permitted
		if(!event.cancelable) {
			return true;
		}

		// Derive and check the target element to see whether the mouse event needs to be permitted;
		// unless explicitly enabled, prevent non-touch click events from triggering actions,
		// to prevent ghost/doubleclicks.
		if(!this.needsClick(this.targetElement) || this.cancelNextClick) {

			// Prevent any user-added listeners declared on FastClick element from being fired.
			if(event.stopImmediatePropagation) {
				event.stopImmediatePropagation();
			} else {

				// Part of the hack for browsers that don't support Event#stopImmediatePropagation (e.g. Android 2)
				event.propagationStopped = true;
			}

			// Cancel the event
			event.stopPropagation();
			// 允许组合型label冒泡
			if(!isCompositeLabel) {
				event.preventDefault();
			}
			// 允许组合型label冒泡
			return false;
		}

		// If the mouse event is permitted, return true for the action to go through.
		return true;
	};

	/**
	 * On actual clicks, determine whether this is a touch-generated click, a click action occurring
	 * naturally after a delay after a touch (which needs to be cancelled to avoid duplication), or
	 * an actual click which should be permitted.
	 *
	 * @param {Event} event
	 * @returns {boolean}
	 */
	FastClick.prototype.onClick = function(event) {
		var permitted;

		// It's possible for another FastClick-like library delivered with third-party code to fire a click event before FastClick does (issue #44). In that case, set the click-tracking flag back to false and return early. This will cause onTouchEnd to return early.
		if(this.trackingClick) {
			this.targetElement = null;
			this.trackingClick = false;
			return true;
		}

		// Very odd behaviour on iOS (issue #18): if a submit element is present inside a form and the user hits enter in the iOS simulator or clicks the Go button on the pop-up OS keyboard the a kind of 'fake' click event will be triggered with the submit-type input element as the target.
		if(event.target.type === 'submit' && event.detail === 0) {
			return true;
		}

		permitted = this.onMouse(event);

		// Only unset targetElement if the click is not permitted. This will ensure that the check for !targetElement in onMouse fails and the browser's click doesn't go through.
		if(!permitted) {
			this.targetElement = null;
		}

		// If clicks are permitted, return true for the action to go through.
		return permitted;
	};

	/**
	 * Remove all FastClick's event listeners.
	 *
	 * @returns {void}
	 */
	FastClick.prototype.destroy = function() {
		var layer = this.layer;

		if(deviceIsAndroid) {
			layer.removeEventListener('mouseover', this.onMouse, true);
			layer.removeEventListener('mousedown', this.onMouse, true);
			layer.removeEventListener('mouseup', this.onMouse, true);
		}

		layer.removeEventListener('click', this.onClick, true);
		layer.removeEventListener('touchstart', this.onTouchStart, false);
		layer.removeEventListener('touchmove', this.onTouchMove, false);
		layer.removeEventListener('touchend', this.onTouchEnd, false);
		layer.removeEventListener('touchcancel', this.onTouchCancel, false);
	};

	/**
	 * Check whether FastClick is needed.
	 *
	 * @param {Element} layer The layer to listen on
	 */
	FastClick.notNeeded = function(layer) {
		var metaViewport;
		var chromeVersion;
		var blackberryVersion;
		var firefoxVersion;

		// Devices that don't support touch don't need FastClick
		if(typeof window.ontouchstart === 'undefined') {
			return true;
		}

		// Chrome version - zero for other browsers
		chromeVersion = +(/Chrome\/([0-9]+)/.exec(navigator.userAgent) || [, 0])[1];

		if(chromeVersion) {

			if(deviceIsAndroid) {
				metaViewport = document.querySelector('meta[name=viewport]');

				if(metaViewport) {
					// Chrome on Android with user-scalable="no" doesn't need FastClick (issue #89)
					if(metaViewport.content.indexOf('user-scalable=no') !== -1) {
						return true;
					}
					// Chrome 32 and above with width=device-width or less don't need FastClick
					if(chromeVersion > 31 && document.documentElement.scrollWidth <= window.outerWidth) {
						return true;
					}
				}

				// Chrome desktop doesn't need FastClick (issue #15)
			} else {
				return true;
			}
		}

		if(deviceIsBlackBerry10) {
			blackberryVersion = navigator.userAgent.match(/Version\/([0-9]*)\.([0-9]*)/);

			// BlackBerry 10.3+ does not require Fastclick library.
			// https://github.com/ftlabs/fastclick/issues/251
			if(blackberryVersion[1] >= 10 && blackberryVersion[2] >= 3) {
				metaViewport = document.querySelector('meta[name=viewport]');

				if(metaViewport) {
					// user-scalable=no eliminates click delay.
					if(metaViewport.content.indexOf('user-scalable=no') !== -1) {
						return true;
					}
					// width=device-width (or less than device-width) eliminates click delay.
					if(document.documentElement.scrollWidth <= window.outerWidth) {
						return true;
					}
				}
			}
		}

		// IE10 with -ms-touch-action: none or manipulation, which disables double-tap-to-zoom (issue #97)
		if(layer.style.msTouchAction === 'none' || layer.style.touchAction === 'manipulation') {
			return true;
		}

		// Firefox version - zero for other browsers
		firefoxVersion = +(/Firefox\/([0-9]+)/.exec(navigator.userAgent) || [, 0])[1];

		if(firefoxVersion >= 27) {
			// Firefox 27+ does not have tap delay if the content is not zoomable - https://bugzilla.mozilla.org/show_bug.cgi?id=922896

			metaViewport = document.querySelector('meta[name=viewport]');
			if(metaViewport && (metaViewport.content.indexOf('user-scalable=no') !== -1 || document.documentElement.scrollWidth <= window.outerWidth)) {
				return true;
			}
		}

		// IE11: prefixed -ms-touch-action is no longer supported and it's recomended to use non-prefixed version
		// http://msdn.microsoft.com/en-us/library/windows/apps/Hh767313.aspx
		if(layer.style.touchAction === 'none' || layer.style.touchAction === 'manipulation') {
			return true;
		}

		return false;
	};

	/**
	 * Factory method for creating a FastClick object
	 *
	 * @param {Element} layer The layer to listen on
	 * @param {Object} [options={}] The options to override the defaults
	 */
	FastClick.attach = function(layer, options) {
		return new FastClick(layer, options);
	};

	window.FastClick = FastClick;
}());

/*======================================================
 ************   Modals   ************
 ======================================================*/
+
function($) {
	"use strict";
	var _modalTemplateTempDiv = document.createElement('div');

	$.modalStack = [];

	$.modalStackClearQueue = function() {
		if($.modalStack.length) {
			($.modalStack.shift())();
		}
	};
	$.modal = function(params) {
		params = params || {};
		var modalHTML = '';
		var buttonsHTML = '';
		if(params.buttons && params.buttons.length > 0) {
			for(var i = 0; i < params.buttons.length; i++) {
				buttonsHTML += '<span class="modal-button' + (params.buttons[i].bold ? ' modal-button-bold' : '') + '">' + params.buttons[i].text + '</span>';
			}
		}
		var extraClass = params.extraClass || '';
		var titleHTML = params.title ? '<div class="modal-title">' + params.title + '</div>' : '';
		var textHTML = params.text ? '<div class="modal-text">' + params.text + '</div>' : '';
		var afterTextHTML = params.afterText ? params.afterText : '';
		var noButtons = !params.buttons || params.buttons.length === 0 ? 'modal-no-buttons' : '';
		var verticalButtons = params.verticalButtons ? 'modal-buttons-vertical' : '';
		modalHTML = '<div class="modal ' + extraClass + ' ' + noButtons + '"><div class="modal-inner">' + (titleHTML + textHTML + afterTextHTML) + '</div><div class="modal-buttons ' + verticalButtons + '">' + buttonsHTML + '</div></div>';

		_modalTemplateTempDiv.innerHTML = modalHTML;

		var modal = $(_modalTemplateTempDiv).children();

		$(defaults.modalContainer).append(modal[0]);

		// Add events on buttons
		modal.find('.modal-button').each(function(index, el) {
			$(el).on('click', function(e) {
				if(params.buttons[index].close !== false) $.closeModal(modal);
				if(params.buttons[index].onClick) params.buttons[index].onClick(modal, e);
				if(params.onClick) params.onClick(modal, index);
			});
		});
		$.openModal(modal);
		return modal[0];
	};
	$.alert = function(text, title, callbackOk) {
		if(typeof title === 'function') {
			callbackOk = arguments[1];
			title = undefined;
		}
		return $.modal({
			text: text || '',
			title: typeof title === 'undefined' ? defaults.modalTitle : title,
			buttons: [{ text: defaults.modalButtonOk, bold: true, onClick: callbackOk }]
		});
	};
	$.confirm = function(text, title, callbackOk, callbackCancel) {
		if(typeof title === 'function') {
			callbackCancel = arguments[2];
			callbackOk = arguments[1];
			title = undefined;
		}
		return $.modal({
			text: text || '',
			title: typeof title === 'undefined' ? defaults.modalTitle : title,
			buttons: [
				{ text: defaults.modalButtonCancel, onClick: callbackCancel },
				{ text: defaults.modalButtonOk, bold: true, onClick: callbackOk }
			]
		});
	};
	$.prompt = function(text, title, callbackOk, callbackCancel) {
		if(typeof title === 'function') {
			callbackCancel = arguments[2];
			callbackOk = arguments[1];
			title = undefined;
		}
		return $.modal({
			text: text || '',
			title: typeof title === 'undefined' ? defaults.modalTitle : title,
			afterText: '<input type="text" class="modal-text-input">',
			buttons: [{
					text: defaults.modalButtonCancel
				},
				{
					text: defaults.modalButtonOk,
					bold: true
				}
			],
			onClick: function(modal, index) {
				if(index === 0 && callbackCancel) callbackCancel($(modal).find('.modal-text-input').val());
				if(index === 1 && callbackOk) callbackOk($(modal).find('.modal-text-input').val());
			}
		});
	};
	$.modalLogin = function(text, title, callbackOk, callbackCancel) {
		if(typeof title === 'function') {
			callbackCancel = arguments[2];
			callbackOk = arguments[1];
			title = undefined;
		}
		return $.modal({
			text: text || '',
			title: typeof title === 'undefined' ? defaults.modalTitle : title,
			afterText: '<input type="text" name="modal-username" placeholder="' + defaults.modalUsernamePlaceholder + '" class="modal-text-input modal-text-input-double"><input type="password" name="modal-password" placeholder="' + defaults.modalPasswordPlaceholder + '" class="modal-text-input modal-text-input-double">',
			buttons: [{
					text: defaults.modalButtonCancel
				},
				{
					text: defaults.modalButtonOk,
					bold: true
				}
			],
			onClick: function(modal, index) {
				var username = $(modal).find('.modal-text-input[name="modal-username"]').val();
				var password = $(modal).find('.modal-text-input[name="modal-password"]').val();
				if(index === 0 && callbackCancel) callbackCancel(username, password);
				if(index === 1 && callbackOk) callbackOk(username, password);
			}
		});
	};
	$.modalPassword = function(text, title, callbackOk, callbackCancel) {
		if(typeof title === 'function') {
			callbackCancel = arguments[2];
			callbackOk = arguments[1];
			title = undefined;
		}
		return $.modal({
			text: text || '',
			title: typeof title === 'undefined' ? defaults.modalTitle : title,
			afterText: '<input type="password" name="modal-password" placeholder="' + defaults.modalPasswordPlaceholder + '" class="modal-text-input">',
			buttons: [{
					text: defaults.modalButtonCancel
				},
				{
					text: defaults.modalButtonOk,
					bold: true
				}
			],
			onClick: function(modal, index) {
				var password = $(modal).find('.modal-text-input[name="modal-password"]').val();
				if(index === 0 && callbackCancel) callbackCancel(password);
				if(index === 1 && callbackOk) callbackOk(password);
			}
		});
	};
	$.showPreloader = function(title) {
		$.hidePreloader();
		$.showPreloader.preloaderModal = $.modal({
			title: title || defaults.modalPreloaderTitle, //edit
			text: '<div class="preloader"></div>'
		});

		return $.showPreloader.preloaderModal;
	};
	$.hidePreloader = function() {
		$.showPreloader.preloaderModal && $.closeModal($.showPreloader.preloaderModal);
	};
	$.showIndicator = function() {
		if($('.preloader-indicator-modal')[0]) return;
		$(defaults.modalContainer).append('<div class="preloader-indicator-overlay"></div><div class="preloader-indicator-modal"><span class="preloader preloader-white"></span></div>');
	};
	$.hideIndicator = function() {
		$('.preloader-indicator-overlay, .preloader-indicator-modal').remove();
	};
	// Action Sheet
	$.actions = function(params) {
		var modal, groupSelector, buttonSelector;
		params = params || [];

		if(params.length > 0 && !$.isArray(params[0])) {
			params = [params];
		}
		var modalHTML;
		var buttonsHTML = '';
		for(var i = 0; i < params.length; i++) {
			for(var j = 0; j < params[i].length; j++) {
				if(j === 0) buttonsHTML += '<div class="actions-modal-group">';
				var button = params[i][j];
				var buttonClass = button.label ? 'actions-modal-label' : 'actions-modal-button';
				if(button.bold) buttonClass += ' actions-modal-button-bold';
				if(button.color) buttonClass += ' color-' + button.color;
				if(button.bg) buttonClass += ' bg-' + button.bg;
				if(button.disabled) buttonClass += ' disabled';
				buttonsHTML += '<span class="' + buttonClass + '">' + button.text + '</span>';
				if(j === params[i].length - 1) buttonsHTML += '</div>';
			}
		}
		modalHTML = '<div class="actions-modal">' + buttonsHTML + '</div>';
		_modalTemplateTempDiv.innerHTML = modalHTML;
		modal = $(_modalTemplateTempDiv).children();
		$(defaults.modalContainer).append(modal[0]);
		groupSelector = '.actions-modal-group';
		buttonSelector = '.actions-modal-button';

		var groups = modal.find(groupSelector);
		groups.each(function(index, el) {
			var groupIndex = index;
			$(el).children().each(function(index, el) {
				var buttonIndex = index;
				var buttonParams = params[groupIndex][buttonIndex];
				var clickTarget;
				if($(el).is(buttonSelector)) clickTarget = $(el);
				// if (toPopover && $(el).find(buttonSelector).length > 0) clickTarget = $(el).find(buttonSelector);

				if(clickTarget) {
					clickTarget.on('click', function(e) {
						if(buttonParams.close !== false) $.closeModal(modal);
						if(buttonParams.onClick) buttonParams.onClick(modal, e);
					});
				}
			});
		});
		$.openModal(modal);
		return modal[0];
	};
	$.popup = function(modal, removeOnClose) {
		if(typeof removeOnClose === 'undefined') removeOnClose = true;
		if(typeof modal === 'string' && modal.indexOf('<') >= 0) {
			var _modal = document.createElement('div');
			_modal.innerHTML = modal.trim();
			if(_modal.childNodes.length > 0) {
				modal = _modal.childNodes[0];
				if(removeOnClose) modal.classList.add('remove-on-close');
				$(defaults.modalContainer).append(modal);
			} else return false; //nothing found
		}
		modal = $(modal);
		if(modal.length === 0) return false;
		modal.show();
		modal.find(".content").scroller("refresh");
		if(modal.find('.' + defaults.viewClass).length > 0) {
			$.sizeNavbars(modal.find('.' + defaults.viewClass)[0]);
		}
		$.openModal(modal);

		return modal[0];
	};
	$.pickerModal = function(pickerModal, removeOnClose) {
		if(typeof removeOnClose === 'undefined') removeOnClose = true;
		if(typeof pickerModal === 'string' && pickerModal.indexOf('<') >= 0) {
			pickerModal = $(pickerModal);
			if(pickerModal.length > 0) {
				if(removeOnClose) pickerModal.addClass('remove-on-close');
				$(defaults.modalContainer).append(pickerModal[0]);
			} else return false; //nothing found
		}
		pickerModal = $(pickerModal);
		if(pickerModal.length === 0) return false;
		pickerModal.show();
		$.openModal(pickerModal);
		return pickerModal[0];
	};
	$.loginScreen = function(modal) {
		if(!modal) modal = '.login2-screen';
		modal = $(modal);
		if(modal.length === 0) return false;
		modal.show();
		if(modal.find('.' + defaults.viewClass).length > 0) {
			$.sizeNavbars(modal.find('.' + defaults.viewClass)[0]);
		}
		$.openModal(modal);
		return modal[0];
	};
	//显示一个消息，会在2秒钟后自动消失
	$.toast = function(msg, duration, extraclass) {
		var $toast = $('<div class="modal toast ' + (extraclass || '') + '">' + msg + '</div>').appendTo(document.body);
		$.openModal($toast, function() {
			setTimeout(function() {
				$.closeModal($toast);
			}, duration || 2000);
		});
	};
	$.openModal = function(modal, cb) {
		modal = $(modal);
		var isModal = modal.hasClass('modal'),
			isNotToast = !modal.hasClass('toast');
		if($('.modal.modal-in:not(.modal-out)').length && defaults.modalStack && isModal && isNotToast) {
			$.modalStack.push(function() {
				$.openModal(modal, cb);
			});
			return;
		}
		var isPopup = modal.hasClass('popup');
		var isLoginScreen = modal.hasClass('login2-screen');
		var isPickerModal = modal.hasClass('picker-modal');
		var isToast = modal.hasClass('toast');
		if(isModal) {
			modal.show();
			modal.css({
				marginTop: -Math.round(modal.outerHeight() / 2) + 'px'
			});
		}
		if(isToast) {
			modal.css({
				marginLeft: -Math.round(modal.outerWidth() / 2 / 1.185) + 'px' //1.185 是初始化时候的放大效果
			});
		}

		var overlay;
		if(!isLoginScreen && !isPickerModal && !isToast) {
			if($('.modal-overlay').length === 0 && !isPopup) {
				$(defaults.modalContainer).append('<div class="modal-overlay"></div>');
			}
			if($('.popup-overlay').length === 0 && isPopup) {
				$(defaults.modalContainer).append('<div class="popup-overlay"></div>');
			}
			overlay = isPopup ? $('.popup-overlay') : $('.modal-overlay');
		}

		//Make sure that styles are applied, trigger relayout;
		var clientLeft = modal[0].clientLeft;

		// Trugger open event
		modal.trigger('open');

		// Picker modal body class
		if(isPickerModal) {
			$(defaults.modalContainer).addClass('with-picker-modal');
		}

		// Classes for transition in
		if(!isLoginScreen && !isPickerModal && !isToast) overlay.addClass('modal-overlay-visible');
		modal.removeClass('modal-out').addClass('modal-in').transitionEnd(function(e) {
			if(modal.hasClass('modal-out')) modal.trigger('closed');
			else modal.trigger('opened');
		});
		// excute callback
		if(typeof cb === 'function') {
			cb.call(this);
		}
		return true;
	};
	$.closeModal = function(modal) {
		modal = $(modal || '.modal-in');
		if(typeof modal !== 'undefined' && modal.length === 0) {
			return;
		}
		var isModal = modal.hasClass('modal'),
			isPopup = modal.hasClass('popup'),
			isToast = modal.hasClass('toast'),
			isLoginScreen = modal.hasClass('login2-screen'),
			isPickerModal = modal.hasClass('picker-modal'),
			removeOnClose = modal.hasClass('remove-on-close'),
			overlay = isPopup ? $('.popup-overlay') : $('.modal-overlay');
		if(isPopup) {
			if(modal.length === $('.popup.modal-in').length) {
				overlay.removeClass('modal-overlay-visible');
			}
		} else if(!(isPickerModal || isToast)) {
			overlay.removeClass('modal-overlay-visible');
		}

		modal.trigger('close');

		// Picker modal body class
		if(isPickerModal) {
			$(defaults.modalContainer).removeClass('with-picker-modal');
			$(defaults.modalContainer).addClass('picker-modal-closing');
		}

		modal.removeClass('modal-in').addClass('modal-out').transitionEnd(function(e) {
			if(modal.hasClass('modal-out')) modal.trigger('closed');
			else modal.trigger('opened');

			if(isPickerModal) {
				$(defaults.modalContainer).removeClass('picker-modal-closing');
			}
			if(isPopup || isLoginScreen || isPickerModal) {
				modal.removeClass('modal-out').hide();
				if(removeOnClose && modal.length > 0) {
					modal.remove();
				}
			} else {
				modal.remove();
			}
		});
		if(isModal && defaults.modalStack) {
			$.modalStackClearQueue();
		}

		return true;
	};

	function handleClicks(e) {
		/*jshint validthis:true */
		var clicked = $(this);
		var url = clicked.attr('href');

		//Collect Clicked data- attributes
		var clickedData = clicked.dataset();

		// Popup
		var popup;
		if(clicked.hasClass('open-popup')) {
			if(clickedData.popup) {
				popup = clickedData.popup;
			} else popup = '.popup';
			$.popup(popup);
		}
		if(clicked.hasClass('close-popup')) {
			if(clickedData.popup) {
				popup = clickedData.popup;
			} else popup = '.popup.modal-in';
			$.closeModal(popup);
		}

		// Close Modal
		if(clicked.hasClass('modal-overlay')) {
			if($('.modal.modal-in').length > 0 && defaults.modalCloseByOutside)
				$.closeModal('.modal.modal-in');
			if($('.actions-modal.modal-in').length > 0 && defaults.actionsCloseByOutside)
				$.closeModal('.actions-modal.modal-in');

		}
		if(clicked.hasClass('popup-overlay')) {
			if($('.popup.modal-in').length > 0 && defaults.popupCloseByOutside)
				$.closeModal('.popup.modal-in');
		}

	}

	$(document).on('click', ' .modal-overlay, .popup-overlay, .close-popup, .open-popup, .close-picker', handleClicks);
	var defaults = $.modal.prototype.defaults = {
		modalStack: true,
		modalButtonOk: '确定',
		modalButtonCancel: '取消',
		modalPreloaderTitle: '加载中',
		modalContainer: document.body ? document.body : 'body'
	};
}(Zepto);

/*======================================================
 ************   Calendar   ************
 ======================================================*/
+
function($) {
	"use strict";
	var rtl = false;
	var Calendar = function(params) {
		var p = this;
		var defaults = {
			monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
			monthNamesShort: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
			dayNames: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
			dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
			firstDay: 1, // First day of the week, Monday
			weekendDays: [0, 6], // Sunday and Saturday
			multiple: false,
			dateFormat: 'yyyy-mm-dd',
			direction: 'horizontal', // or 'vertical'
			minDate: null,
			maxDate: null,
			touchMove: true,
			animate: true,
			closeOnSelect: true,
			monthPicker: true,
			monthPickerTemplate: '<div class="picker-calendar-month-picker">' +
				'<a href="#" class="link icon-only picker-calendar-prev-month"><i class="icon icon-prev"></i></a>' +
				'<div class="current-month-value"></div>' +
				'<a href="#" class="link icon-only picker-calendar-next-month"><i class="icon icon-next"></i></a>' +
				'</div>',
			yearPicker: true,
			yearPickerTemplate: '<div class="picker-calendar-year-picker">' +
				'<a href="#" class="link icon-only picker-calendar-prev-year"><i class="icon icon-prev"></i></a>' +
				'<span class="current-year-value"></span>' +
				'<a href="#" class="link icon-only picker-calendar-next-year"><i class="icon icon-next"></i></a>' +
				'</div>',
			weekHeader: true,
			// Common settings
			scrollToInput: true,
			inputReadOnly: true,
			toolbar: true,
			toolbarCloseText: 'Done',
			toolbarTemplate: '<div class="toolbar">' +
				'<div class="toolbar-inner">' +
				'{{monthPicker}}' +
				'{{yearPicker}}' +
				// '<a href="#" class="link close-picker">{{closeText}}</a>' +
				'</div>' +
				'</div>',
			/* Callbacks
			 onMonthAdd
			 onChange
			 onOpen
			 onClose
			 onDayClick
			 onMonthYearChangeStart
			 onMonthYearChangeEnd
			 */
		};
		params = params || {};
		for(var def in defaults) {
			if(typeof params[def] === 'undefined') {
				params[def] = defaults[def];
			}
		}
		p.params = params;
		p.initialized = false;

		// Inline flag
		p.inline = p.params.container ? true : false;

		// Is horizontal
		p.isH = p.params.direction === 'horizontal';

		// RTL inverter
		var inverter = p.isH ? (rtl ? -1 : 1) : 1;

		// Animating flag
		p.animating = false;

		// Format date
		function formatDate(date) {
			date = new Date(date);
			var year = date.getFullYear();
			var month = date.getMonth();
			var month1 = month + 1;
			var day = date.getDate();
			var weekDay = date.getDay();
			return p.params.dateFormat
				.replace(/yyyy/g, year)
				.replace(/yy/g, (year + '').substring(2))
				.replace(/mm/g, month1 < 10 ? '0' + month1 : month1)
				.replace(/m/g, month1)
				.replace(/MM/g, p.params.monthNames[month])
				.replace(/M/g, p.params.monthNamesShort[month])
				.replace(/dd/g, day < 10 ? '0' + day : day)
				.replace(/d/g, day)
				.replace(/DD/g, p.params.dayNames[weekDay])
				.replace(/D/g, p.params.dayNamesShort[weekDay]);
		}

		// Value
		p.addValue = function(value) {
			if(p.params.multiple) {
				if(!p.value) p.value = [];
				var inValuesIndex;
				for(var i = 0; i < p.value.length; i++) {
					if(new Date(value).getTime() === new Date(p.value[i]).getTime()) {
						inValuesIndex = i;
					}
				}
				if(typeof inValuesIndex === 'undefined') {
					p.value.push(value);
				} else {
					p.value.splice(inValuesIndex, 1);
				}
				p.updateValue();
			} else {
				p.value = [value];
				p.updateValue();
			}
		};
		p.setValue = function(arrValues) {
			p.value = arrValues;
			p.updateValue();
		};
		p.updateValue = function() {
			p.wrapper.find('.picker-calendar-day-selected').removeClass('picker-calendar-day-selected');
			var i, inputValue;
			for(i = 0; i < p.value.length; i++) {
				var valueDate = new Date(p.value[i]);
				p.wrapper.find('.picker-calendar-day[data-date="' + valueDate.getFullYear() + '-' + valueDate.getMonth() + '-' + valueDate.getDate() + '"]').addClass('picker-calendar-day-selected');
			}
			if(p.params.onChange) {
				p.params.onChange(p, p.value, p.value.map(formatDate));
			}
			if(p.input && p.input.length > 0) {
				if(p.params.formatValue) inputValue = p.params.formatValue(p, p.value);
				else {
					inputValue = [];
					for(i = 0; i < p.value.length; i++) {
						inputValue.push(formatDate(p.value[i]));
					}
					inputValue = inputValue.join(', ');
				}
				$(p.input).val(inputValue);
				$(p.input).trigger('change');
			}
		};

		// Columns Handlers
		p.initCalendarEvents = function() {
			var col;
			var allowItemClick = true;
			var isTouched, isMoved, touchStartX, touchStartY, touchCurrentX, touchCurrentY, touchStartTime, touchEndTime, startTranslate, currentTranslate, wrapperWidth, wrapperHeight, percentage, touchesDiff, isScrolling;

			function handleTouchStart(e) {
				if(isMoved || isTouched) return;
				// e.preventDefault();
				isTouched = true;
				touchStartX = touchCurrentY = e.type === 'touchstart' ? e.targetTouches[0].pageX : e.pageX;
				touchStartY = touchCurrentY = e.type === 'touchstart' ? e.targetTouches[0].pageY : e.pageY;
				touchStartTime = (new Date()).getTime();
				percentage = 0;
				allowItemClick = true;
				isScrolling = undefined;
				startTranslate = currentTranslate = p.monthsTranslate;
			}

			function handleTouchMove(e) {
				if(!isTouched) return;

				touchCurrentX = e.type === 'touchmove' ? e.targetTouches[0].pageX : e.pageX;
				touchCurrentY = e.type === 'touchmove' ? e.targetTouches[0].pageY : e.pageY;
				if(typeof isScrolling === 'undefined') {
					isScrolling = !!(isScrolling || Math.abs(touchCurrentY - touchStartY) > Math.abs(touchCurrentX - touchStartX));
				}
				if(p.isH && isScrolling) {
					isTouched = false;
					return;
				}
				e.preventDefault();
				if(p.animating) {
					isTouched = false;
					return;
				}
				allowItemClick = false;
				if(!isMoved) {
					// First move
					isMoved = true;
					wrapperWidth = p.wrapper[0].offsetWidth;
					wrapperHeight = p.wrapper[0].offsetHeight;
					p.wrapper.transition(0);
				}
				e.preventDefault();

				touchesDiff = p.isH ? touchCurrentX - touchStartX : touchCurrentY - touchStartY;
				percentage = touchesDiff / (p.isH ? wrapperWidth : wrapperHeight);
				currentTranslate = (p.monthsTranslate * inverter + percentage) * 100;

				// Transform wrapper
				p.wrapper.transform('translate3d(' + (p.isH ? currentTranslate : 0) + '%, ' + (p.isH ? 0 : currentTranslate) + '%, 0)');

			}

			function handleTouchEnd(e) {
				if(!isTouched || !isMoved) {
					isTouched = isMoved = false;
					return;
				}
				isTouched = isMoved = false;

				touchEndTime = new Date().getTime();
				if(touchEndTime - touchStartTime < 300) {
					if(Math.abs(touchesDiff) < 10) {
						p.resetMonth();
					} else if(touchesDiff >= 10) {
						if(rtl) p.nextMonth();
						else p.prevMonth();
					} else {
						if(rtl) p.prevMonth();
						else p.nextMonth();
					}
				} else {
					if(percentage <= -0.5) {
						if(rtl) p.prevMonth();
						else p.nextMonth();
					} else if(percentage >= 0.5) {
						if(rtl) p.nextMonth();
						else p.prevMonth();
					} else {
						p.resetMonth();
					}
				}

				// Allow click
				setTimeout(function() {
					allowItemClick = true;
				}, 100);
			}

			function handleDayClick(e) {
				if(!allowItemClick) return;
				var day = $(e.target).parents('.picker-calendar-day');
				if(day.length === 0 && $(e.target).hasClass('picker-calendar-day')) {
					day = $(e.target);
				}
				if(day.length === 0) return;
				if(day.hasClass('picker-calendar-day-selected') && !p.params.multiple) return;
				if(day.hasClass('picker-calendar-day-disabled')) return;
				if(day.hasClass('picker-calendar-day-next')) p.nextMonth();
				if(day.hasClass('picker-calendar-day-prev')) p.prevMonth();
				var dateYear = day.attr('data-year');
				var dateMonth = day.attr('data-month');
				var dateDay = day.attr('data-day');
				if(p.params.onDayClick) {
					p.params.onDayClick(p, day[0], dateYear, dateMonth, dateDay);
				}
				p.addValue(new Date(dateYear, dateMonth, dateDay).getTime());
				if(p.params.closeOnSelect) p.close();
			}

			p.container.find('.picker-calendar-prev-month').on('click', p.prevMonth);
			p.container.find('.picker-calendar-next-month').on('click', p.nextMonth);
			p.container.find('.picker-calendar-prev-year').on('click', p.prevYear);
			p.container.find('.picker-calendar-next-year').on('click', p.nextYear);

			/**
			 * 处理选择年份时的手势操作事件
			 *
			 * Start - edit by JSoon
			 */
			function handleYearTouchStart(e) {
				if(isMoved || isTouched) return;
				// e.preventDefault();
				isTouched = true;
				touchStartX = touchCurrentY = e.type === 'touchstart' ? e.targetTouches[0].pageX : e.pageX;
				touchStartY = touchCurrentY = e.type === 'touchstart' ? e.targetTouches[0].pageY : e.pageY;
				touchStartTime = (new Date()).getTime();
				percentage = 0;
				allowItemClick = true;
				isScrolling = undefined;
				startTranslate = currentTranslate = p.yearsTranslate;
			}

			function handleYearTouchMove(e) {
				if(!isTouched) return;

				touchCurrentX = e.type === 'touchmove' ? e.targetTouches[0].pageX : e.pageX;
				touchCurrentY = e.type === 'touchmove' ? e.targetTouches[0].pageY : e.pageY;
				if(typeof isScrolling === 'undefined') {
					isScrolling = !!(isScrolling || Math.abs(touchCurrentY - touchStartY) > Math.abs(touchCurrentX - touchStartX));
				}
				if(p.isH && isScrolling) {
					isTouched = false;
					return;
				}
				e.preventDefault();
				if(p.animating) {
					isTouched = false;
					return;
				}
				allowItemClick = false;
				if(!isMoved) {
					// First move
					isMoved = true;
					wrapperWidth = p.yearsPickerWrapper[0].offsetWidth;
					wrapperHeight = p.yearsPickerWrapper[0].offsetHeight;
					p.yearsPickerWrapper.transition(0);
				}
				e.preventDefault();

				touchesDiff = p.isH ? touchCurrentX - touchStartX : touchCurrentY - touchStartY;
				percentage = touchesDiff / (p.isH ? wrapperWidth : wrapperHeight);
				currentTranslate = (p.yearsTranslate * inverter + percentage) * 100;

				// Transform wrapper
				p.yearsPickerWrapper.transform('translate3d(' + (p.isH ? currentTranslate : 0) + '%, ' + (p.isH ? 0 : currentTranslate) + '%, 0)');

			}

			function handleYearTouchEnd(e) {
				if(!isTouched || !isMoved) {
					isTouched = isMoved = false;
					return;
				}
				isTouched = isMoved = false;

				touchEndTime = new Date().getTime();
				if(touchEndTime - touchStartTime < 300) {
					if(Math.abs(touchesDiff) < 10) {
						p.resetYearsGroup();
					} else if(touchesDiff >= 10) {
						if(rtl) p.nextYearsGroup();
						else p.prevYearsGroup();
					} else {
						if(rtl) p.prevYearsGroup();
						else p.nextYearsGroup();
					}
				} else {
					if(percentage <= -0.5) {
						if(rtl) p.prevYearsGroup();
						else p.nextYearsGroup();
					} else if(percentage >= 0.5) {
						if(rtl) p.nextYearsGroup();
						else p.prevYearsGroup();
					} else {
						p.resetYearsGroup();
					}
				}

				// Allow click
				setTimeout(function() {
					allowItemClick = true;
				}, 100);
			}

			function handleYearSelector() {
				var curYear = $(this).text(),
					yearsPicker = p.container.find('.picker-calendar-years-picker');
				yearsPicker.show().transform('translate3d(0, 0, 0)');
				p.updateSelectedInPickers();
				yearsPicker.on('click', '.picker-calendar-year-unit', p.pickYear);
			}

			function handleMonthSelector() {
				var monthsPicker = p.container.find('.picker-calendar-months-picker');
				monthsPicker.show().transform('translate3d(0, 0, 0)');
				p.updateSelectedInPickers();
				monthsPicker.on('click', '.picker-calendar-month-unit', p.pickMonth);
			}

			// 选择年份
			p.container.find('.current-year-value').on('click', handleYearSelector);

			// 选择月份
			p.container.find('.current-month-value').on('click', handleMonthSelector);
			/**
			 * End - edit by JSoon
			 */

			p.wrapper.on('click', handleDayClick);
			if(p.params.touchMove) {
				/**
				 * 给年份选择器绑定手势操作事件
				 *
				 * Start - edit by JSoon
				 */
				p.yearsPickerWrapper.on($.touchEvents.start, handleYearTouchStart);
				p.yearsPickerWrapper.on($.touchEvents.move, handleYearTouchMove);
				p.yearsPickerWrapper.on($.touchEvents.end, handleYearTouchEnd);
				/**
				 * Start - edit by JSoon
				 */

				p.wrapper.on($.touchEvents.start, handleTouchStart);
				p.wrapper.on($.touchEvents.move, handleTouchMove);
				p.wrapper.on($.touchEvents.end, handleTouchEnd);
			}

			p.container[0].f7DestroyCalendarEvents = function() {
				p.container.find('.picker-calendar-prev-month').off('click', p.prevMonth);
				p.container.find('.picker-calendar-next-month').off('click', p.nextMonth);
				p.container.find('.picker-calendar-prev-year').off('click', p.prevYear);
				p.container.find('.picker-calendar-next-year').off('click', p.nextYear);
				p.wrapper.off('click', handleDayClick);
				if(p.params.touchMove) {
					p.wrapper.off($.touchEvents.start, handleTouchStart);
					p.wrapper.off($.touchEvents.move, handleTouchMove);
					p.wrapper.off($.touchEvents.end, handleTouchEnd);
				}
			};

		};
		p.destroyCalendarEvents = function(colContainer) {
			if('f7DestroyCalendarEvents' in p.container[0]) p.container[0].f7DestroyCalendarEvents();
		};

		// Calendar Methods

		/**
		 * 1. 生成年份和月份选择器DOM结构
		 * 2. 年份选择和月份选择的pick事件函数
		 * 3. 年份选择手势操作结束后，更新年分组DOM结构
		 *
		 * Start - edit by JSoon
		 */
		p.yearsGroupHTML = function(date, offset) {
			date = new Date(date);
			var curYear = date.getFullYear(), // 日历上的当前年份
				trueYear = new Date().getFullYear(), // 当前真实年份
				yearNum = 25, // 年份面板年份总数量
				firstYear = curYear - Math.floor(yearNum / 2), // 年份面板第一格年份
				yearsHTML = '';
			if(offset === 'next') {
				firstYear = firstYear + yearNum;
			}
			if(offset === 'prev') {
				firstYear = firstYear - yearNum;
			}
			for(var i = 0; i < 5; i += 1) {
				var rowHTML = '';
				var row = i;
				rowHTML += '<div class="picker-calendar-row">';
				for(var j = 0; j < 5; j += 1) {
					if(firstYear === trueYear) {
						rowHTML += '<div class="picker-calendar-year-unit current-calendar-year-unit" data-year="' + firstYear + '"><span>' + firstYear + '</span></div>';
					} else if(firstYear === curYear) {
						rowHTML += '<div class="picker-calendar-year-unit picker-calendar-year-unit-selected" data-year="' + firstYear + '"><span>' + firstYear + '</span></div>';
					} else {
						rowHTML += '<div class="picker-calendar-year-unit" data-year="' + firstYear + '"><span>' + firstYear + '</span></div>';
					}
					firstYear += 1;
				}
				rowHTML += '</div>';
				yearsHTML += rowHTML;
			}
			yearsHTML = '<div class="picker-calendar-years-group">' + yearsHTML + '</div>';
			return yearsHTML;
		};

		p.pickYear = function() {
			var year = $(this).text(),
				curYear = p.wrapper.find('.picker-calendar-month-current').attr('data-year');
			p.yearsPickerWrapper.find('.picker-calendar-year-unit').removeClass('picker-calendar-year-unit-selected');
			$(this).addClass('picker-calendar-year-unit-selected');
			if(curYear !== year) {
				p.setYearMonth(year);
				p.container.find('.picker-calendar-years-picker').hide().transform('translate3d(0, 100%, 0)');
			} else {
				p.container.find('.picker-calendar-years-picker').transform('translate3d(0, 100%, 0)');
			}
		};

		p.onYearsChangeEnd = function(dir) {
			p.animating = false;
			var nextYearsHTML, prevYearsHTML, newCurFirstYear;
			var yearNum = p.yearsPickerWrapper.children('.picker-calendar-years-next').find('.picker-calendar-year-unit').length;
			if(dir === 'next') {
				var newCurFirstYear = parseInt(p.yearsPickerWrapper.children('.picker-calendar-years-next').find('.picker-calendar-year-unit').eq(Math.floor(yearNum / 2)).text());
				nextYearsHTML = p.yearsGroupHTML(new Date(newCurFirstYear, p.currentMonth), 'next');
				p.yearsPickerWrapper.append(nextYearsHTML);
				p.yearsPickerWrapper.children().first().remove();
				p.yearsGroups = p.container.find('.picker-calendar-years-group');
			}
			if(dir === 'prev') {
				var newCurFirstYear = parseInt(p.yearsPickerWrapper.children('.picker-calendar-years-prev').find('.picker-calendar-year-unit').eq(Math.floor(yearNum / 2)).text());
				prevYearsHTML = p.yearsGroupHTML(new Date(newCurFirstYear, p.currentMonth), 'prev');
				p.yearsPickerWrapper.prepend(prevYearsHTML);
				p.yearsPickerWrapper.children().last().remove();
				p.yearsGroups = p.container.find('.picker-calendar-years-group');
			}
			p.setYearsTranslate(p.yearsTranslate);
		};

		p.monthsGroupHTML = function(date) {
			date = new Date(date);
			var curMonth = date.getMonth() + 1, // 日历上的当前月份
				trueMonth = new Date().getMonth() + 1, // 当前真实月份
				monthNum = 12, // 月份面板月份总数量
				firstMonth = 1,
				monthsHTML = '';
			for(var i = 0; i < 3; i += 1) {
				var rowHTML = '';
				var row = i;
				rowHTML += '<div class="picker-calendar-row">';
				for(var j = 0; j < 4; j += 1) {
					if(firstMonth === trueMonth) {
						rowHTML += '<div class="picker-calendar-month-unit current-calendar-month-unit" data-month="' + (firstMonth - 1) + '"><span>' + p.params.monthNames[firstMonth - 1] + '</span></div>';
					} else if(firstMonth === curMonth) {
						rowHTML += '<div class="picker-calendar-month-unit picker-calendar-month-selected" data-month="' + (firstMonth - 1) + '"><span>' + p.params.monthNames[firstMonth - 1] + '</span></div>';
					} else {
						rowHTML += '<div class="picker-calendar-month-unit" data-month="' + (firstMonth - 1) + '"><span>' + p.params.monthNames[firstMonth - 1] + '</span></div>';
					}
					firstMonth += 1;
				}
				rowHTML += '</div>';
				monthsHTML += rowHTML;
			}
			monthsHTML = '<div class="picker-calendar-months-group">' + monthsHTML + '</div>';
			return monthsHTML;
		};

		p.pickMonth = function() {
			var month = $(this).attr('data-month'),
				curYear = p.wrapper.find('.picker-calendar-month-current').attr('data-year'),
				curMonth = p.wrapper.find('.picker-calendar-month-current').attr('data-month');
			p.monthsPickerWrapper.find('.picker-calendar-month-unit').removeClass('picker-calendar-month-unit-selected');
			$(this).addClass('picker-calendar-month-unit-selected');
			if(curMonth !== month) {
				p.setYearMonth(curYear, month);
				p.container.find('.picker-calendar-months-picker').hide().transform('translate3d(0, 100%, 0)');
			} else {
				p.container.find('.picker-calendar-months-picker').transform('translate3d(0, 100%, 0)');
			}
		};
		/**
		 * End - edit by JSoon
		 */

		p.daysInMonth = function(date) {
			var d = new Date(date);
			return new Date(d.getFullYear(), d.getMonth() + 1, 0).getDate();
		};
		p.monthHTML = function(date, offset) {
			date = new Date(date);
			var year = date.getFullYear(),
				month = date.getMonth(),
				day = date.getDate();
			if(offset === 'next') {
				if(month === 11) date = new Date(year + 1, 0);
				else date = new Date(year, month + 1, 1);
			}
			if(offset === 'prev') {
				if(month === 0) date = new Date(year - 1, 11);
				else date = new Date(year, month - 1, 1);
			}
			if(offset === 'next' || offset === 'prev') {
				month = date.getMonth();
				year = date.getFullYear();
			}
			var daysInPrevMonth = p.daysInMonth(new Date(date.getFullYear(), date.getMonth()).getTime() - 10 * 24 * 60 * 60 * 1000),
				daysInMonth = p.daysInMonth(date),
				firstDayOfMonthIndex = new Date(date.getFullYear(), date.getMonth()).getDay();
			if(firstDayOfMonthIndex === 0) firstDayOfMonthIndex = 7;

			var dayDate, currentValues = [],
				i, j,
				rows = 6,
				cols = 7,
				monthHTML = '',
				dayIndex = 0 + (p.params.firstDay - 1),
				today = new Date().setHours(0, 0, 0, 0),
				minDate = p.params.minDate ? new Date(p.params.minDate).getTime() : null,
				maxDate = p.params.maxDate ? new Date(p.params.maxDate).getTime() : null;

			if(p.value && p.value.length) {
				for(i = 0; i < p.value.length; i++) {
					currentValues.push(new Date(p.value[i]).setHours(0, 0, 0, 0));
				}
			}

			for(i = 1; i <= rows; i++) {
				var rowHTML = '';
				var row = i;
				for(j = 1; j <= cols; j++) {
					var col = j;
					dayIndex++;
					var dayNumber = dayIndex - firstDayOfMonthIndex;
					var addClass = '';
					if(dayNumber < 0) {
						dayNumber = daysInPrevMonth + dayNumber + 1;
						addClass += ' picker-calendar-day-prev';
						dayDate = new Date(month - 1 < 0 ? year - 1 : year, month - 1 < 0 ? 11 : month - 1, dayNumber).getTime();
					} else {
						dayNumber = dayNumber + 1;
						if(dayNumber > daysInMonth) {
							dayNumber = dayNumber - daysInMonth;
							addClass += ' picker-calendar-day-next';
							dayDate = new Date(month + 1 > 11 ? year + 1 : year, month + 1 > 11 ? 0 : month + 1, dayNumber).getTime();
						} else {
							dayDate = new Date(year, month, dayNumber).getTime();
						}
					}
					// Today
					if(dayDate === today) addClass += ' picker-calendar-day-today';
					// Selected
					if(currentValues.indexOf(dayDate) >= 0) addClass += ' picker-calendar-day-selected';
					// Weekend
					if(p.params.weekendDays.indexOf(col - 1) >= 0) {
						addClass += ' picker-calendar-day-weekend';
					}
					// Disabled
					if((minDate && dayDate < minDate) || (maxDate && dayDate > maxDate)) {
						addClass += ' picker-calendar-day-disabled';
					}

					dayDate = new Date(dayDate);
					var dayYear = dayDate.getFullYear();
					var dayMonth = dayDate.getMonth();
					rowHTML += '<div data-year="' + dayYear + '" data-month="' + dayMonth + '" data-day="' + dayNumber + '" class="picker-calendar-day' + (addClass) + '" data-date="' + (dayYear + '-' + dayMonth + '-' + dayNumber) + '"><span>' + dayNumber + '</span></div>';
				}
				monthHTML += '<div class="picker-calendar-row">' + rowHTML + '</div>';
			}
			monthHTML = '<div class="picker-calendar-month" data-year="' + year + '" data-month="' + month + '">' + monthHTML + '</div>';
			return monthHTML;
		};
		p.animating = false;
		p.updateCurrentMonthYear = function(dir) {
			if(typeof dir === 'undefined') {
				p.currentMonth = parseInt(p.months.eq(1).attr('data-month'), 10);
				p.currentYear = parseInt(p.months.eq(1).attr('data-year'), 10);
			} else {
				p.currentMonth = parseInt(p.months.eq(dir === 'next' ? (p.months.length - 1) : 0).attr('data-month'), 10);
				p.currentYear = parseInt(p.months.eq(dir === 'next' ? (p.months.length - 1) : 0).attr('data-year'), 10);
			}
			p.container.find('.current-month-value').text(p.params.monthNames[p.currentMonth]);
			p.container.find('.current-year-value').text(p.currentYear);

		};
		p.onMonthChangeStart = function(dir) {
			p.updateCurrentMonthYear(dir);
			p.months.removeClass('picker-calendar-month-current picker-calendar-month-prev picker-calendar-month-next');
			var currentIndex = dir === 'next' ? p.months.length - 1 : 0;

			p.months.eq(currentIndex).addClass('picker-calendar-month-current');
			p.months.eq(dir === 'next' ? currentIndex - 1 : currentIndex + 1).addClass(dir === 'next' ? 'picker-calendar-month-prev' : 'picker-calendar-month-next');

			if(p.params.onMonthYearChangeStart) {
				p.params.onMonthYearChangeStart(p, p.currentYear, p.currentMonth);
			}
		};
		p.onMonthChangeEnd = function(dir, rebuildBoth) {
			p.animating = false;
			var nextMonthHTML, prevMonthHTML, newMonthHTML;
			p.wrapper.find('.picker-calendar-month:not(.picker-calendar-month-prev):not(.picker-calendar-month-current):not(.picker-calendar-month-next)').remove();

			if(typeof dir === 'undefined') {
				dir = 'next';
				rebuildBoth = true;
			}
			if(!rebuildBoth) {
				newMonthHTML = p.monthHTML(new Date(p.currentYear, p.currentMonth), dir);
			} else {
				p.wrapper.find('.picker-calendar-month-next, .picker-calendar-month-prev').remove();
				prevMonthHTML = p.monthHTML(new Date(p.currentYear, p.currentMonth), 'prev');
				nextMonthHTML = p.monthHTML(new Date(p.currentYear, p.currentMonth), 'next');
			}
			if(dir === 'next' || rebuildBoth) {
				p.wrapper.append(newMonthHTML || nextMonthHTML);
			}
			if(dir === 'prev' || rebuildBoth) {
				p.wrapper.prepend(newMonthHTML || prevMonthHTML);
			}
			p.months = p.wrapper.find('.picker-calendar-month');
			p.setMonthsTranslate(p.monthsTranslate);
			if(p.params.onMonthAdd) {
				p.params.onMonthAdd(p, dir === 'next' ? p.months.eq(p.months.length - 1)[0] : p.months.eq(0)[0]);
			}
			if(p.params.onMonthYearChangeEnd) {
				p.params.onMonthYearChangeEnd(p, p.currentYear, p.currentMonth);
			}
			/**
			 * 月历面板结束手势操作后，更新年份/月份选择器中的选中高亮状态
			 *
			 * Start - edit by JSoon
			 */
			p.updateSelectedInPickers();
			/**
			 * End - edit by JSoon
			 */
		};

		/**
		 * 1. 更新年份/月份选择器中的选中高亮状态函数
		 * 2. 年份选择器过渡动画函数
		 * 3. 下一个/上一个/当前年分组手势操作函数
		 *
		 * Start - edit by JSoon
		 */
		p.updateSelectedInPickers = function() {
			var curYear = parseInt(p.wrapper.find('.picker-calendar-month-current').attr('data-year'), 10),
				trueYear = new Date().getFullYear(),
				curMonth = parseInt(p.wrapper.find('.picker-calendar-month-current').attr('data-month'), 10),
				trueMonth = new Date().getMonth(),
				selectedYear = parseInt(p.yearsPickerWrapper.find('.picker-calendar-year-unit-selected').attr('data-year'), 10),
				selectedMonth = parseInt(p.monthsPickerWrapper.find('.picker-calendar-month-unit-selected').attr('data-month'), 10);
			if(selectedYear !== curYear) {
				p.yearsPickerWrapper.find('.picker-calendar-year-unit').removeClass('picker-calendar-year-unit-selected');
				p.yearsPickerWrapper.find('.picker-calendar-year-unit[data-year="' + curYear + '"]').addClass('picker-calendar-year-unit-selected');
			}
			if(selectedMonth !== curMonth) {
				p.monthsPickerWrapper.find('.picker-calendar-month-unit').removeClass('picker-calendar-month-unit-selected');
				p.monthsPickerWrapper.find('.picker-calendar-month-unit[data-month="' + curMonth + '"]').addClass('picker-calendar-month-unit-selected');
			}
			if(trueYear !== curYear) {
				p.monthsPickerWrapper.find('.picker-calendar-month-unit').removeClass('current-calendar-month-unit');
			} else {
				p.monthsPickerWrapper.find('.picker-calendar-month-unit[data-month="' + trueMonth + '"]').addClass('current-calendar-month-unit');
			}
		};

		p.setYearsTranslate = function(translate) {
			translate = translate || p.yearsTranslate || 0;
			if(typeof p.yearsTranslate === 'undefined') p.yearsTranslate = translate;
			p.yearsGroups.removeClass('picker-calendar-years-current picker-calendar-years-prev picker-calendar-years-next');
			var prevYearTranslate = -(translate + 1) * 100 * inverter;
			var currentYearTranslate = -translate * 100 * inverter;
			var nextYearTranslate = -(translate - 1) * 100 * inverter;
			p.yearsGroups.eq(0).transform('translate3d(' + (p.isH ? prevYearTranslate : 0) + '%, ' + (p.isH ? 0 : prevYearTranslate) + '%, 0)').addClass('picker-calendar-years-prev');
			p.yearsGroups.eq(1).transform('translate3d(' + (p.isH ? currentYearTranslate : 0) + '%, ' + (p.isH ? 0 : currentYearTranslate) + '%, 0)').addClass('picker-calendar-years-current');
			p.yearsGroups.eq(2).transform('translate3d(' + (p.isH ? nextYearTranslate : 0) + '%, ' + (p.isH ? 0 : nextYearTranslate) + '%, 0)').addClass('picker-calendar-years-next');
		};

		p.nextYearsGroup = function(transition) {
			if(typeof transition === 'undefined' || typeof transition === 'object') {
				transition = '';
				if(!p.params.animate) transition = 0;
			}
			var transitionEndCallback = p.animating ? false : true;
			p.yearsTranslate--;
			p.animating = true;
			var translate = (p.yearsTranslate * 100) * inverter;
			p.yearsPickerWrapper.transition(transition).transform('translate3d(' + (p.isH ? translate : 0) + '%, ' + (p.isH ? 0 : translate) + '%, 0)');
			if(transitionEndCallback) {
				p.yearsPickerWrapper.transitionEnd(function() {
					p.onYearsChangeEnd('next');
				});
			}
			if(!p.params.animate) {
				p.onYearsChangeEnd('next');
			}
		};

		p.prevYearsGroup = function(transition) {
			if(typeof transition === 'undefined' || typeof transition === 'object') {
				transition = '';
				if(!p.params.animate) transition = 0;
			}
			var transitionEndCallback = p.animating ? false : true;
			p.yearsTranslate++;
			p.animating = true;
			var translate = (p.yearsTranslate * 100) * inverter;
			p.yearsPickerWrapper.transition(transition).transform('translate3d(' + (p.isH ? translate : 0) + '%, ' + (p.isH ? 0 : translate) + '%, 0)');
			if(transitionEndCallback) {
				p.yearsPickerWrapper.transitionEnd(function() {
					p.onYearsChangeEnd('prev');
				});
			}
			if(!p.params.animate) {
				p.onYearsChangeEnd('prev');
			}
		};

		p.resetYearsGroup = function(transition) {
			if(typeof transition === 'undefined') transition = '';
			var translate = (p.yearsTranslate * 100) * inverter;
			p.yearsPickerWrapper.transition(transition).transform('translate3d(' + (p.isH ? translate : 0) + '%, ' + (p.isH ? 0 : translate) + '%, 0)');
		};
		/**
		 * End - edit by JSoon
		 */

		p.setMonthsTranslate = function(translate) {
			translate = translate || p.monthsTranslate || 0;
			if(typeof p.monthsTranslate === 'undefined') p.monthsTranslate = translate;
			p.months.removeClass('picker-calendar-month-current picker-calendar-month-prev picker-calendar-month-next');
			var prevMonthTranslate = -(translate + 1) * 100 * inverter;
			var currentMonthTranslate = -translate * 100 * inverter;
			var nextMonthTranslate = -(translate - 1) * 100 * inverter;
			p.months.eq(0).transform('translate3d(' + (p.isH ? prevMonthTranslate : 0) + '%, ' + (p.isH ? 0 : prevMonthTranslate) + '%, 0)').addClass('picker-calendar-month-prev');
			p.months.eq(1).transform('translate3d(' + (p.isH ? currentMonthTranslate : 0) + '%, ' + (p.isH ? 0 : currentMonthTranslate) + '%, 0)').addClass('picker-calendar-month-current');
			p.months.eq(2).transform('translate3d(' + (p.isH ? nextMonthTranslate : 0) + '%, ' + (p.isH ? 0 : nextMonthTranslate) + '%, 0)').addClass('picker-calendar-month-next');
		};
		p.nextMonth = function(transition) {
			if(typeof transition === 'undefined' || typeof transition === 'object') {
				transition = '';
				if(!p.params.animate) transition = 0;
			}
			var nextMonth = parseInt(p.months.eq(p.months.length - 1).attr('data-month'), 10);
			var nextYear = parseInt(p.months.eq(p.months.length - 1).attr('data-year'), 10);
			var nextDate = new Date(nextYear, nextMonth);
			var nextDateTime = nextDate.getTime();
			var transitionEndCallback = p.animating ? false : true;
			if(p.params.maxDate) {
				if(nextDateTime > new Date(p.params.maxDate).getTime()) {
					return p.resetMonth();
				}
			}
			p.monthsTranslate--;
			if(nextMonth === p.currentMonth) {
				var nextMonthTranslate = -(p.monthsTranslate) * 100 * inverter;
				var nextMonthHTML = $(p.monthHTML(nextDateTime, 'next')).transform('translate3d(' + (p.isH ? nextMonthTranslate : 0) + '%, ' + (p.isH ? 0 : nextMonthTranslate) + '%, 0)').addClass('picker-calendar-month-next');
				p.wrapper.append(nextMonthHTML[0]);
				p.months = p.wrapper.find('.picker-calendar-month');
				if(p.params.onMonthAdd) {
					p.params.onMonthAdd(p, p.months.eq(p.months.length - 1)[0]);
				}
			}
			p.animating = true;
			p.onMonthChangeStart('next');
			var translate = (p.monthsTranslate * 100) * inverter;

			p.wrapper.transition(transition).transform('translate3d(' + (p.isH ? translate : 0) + '%, ' + (p.isH ? 0 : translate) + '%, 0)');
			if(transitionEndCallback) {
				p.wrapper.transitionEnd(function() {
					p.onMonthChangeEnd('next');
				});
			}
			if(!p.params.animate) {
				p.onMonthChangeEnd('next');
			}
		};
		p.prevMonth = function(transition) {
			if(typeof transition === 'undefined' || typeof transition === 'object') {
				transition = '';
				if(!p.params.animate) transition = 0;
			}
			var prevMonth = parseInt(p.months.eq(0).attr('data-month'), 10);
			var prevYear = parseInt(p.months.eq(0).attr('data-year'), 10);
			var prevDate = new Date(prevYear, prevMonth + 1, -1);
			var prevDateTime = prevDate.getTime();
			var transitionEndCallback = p.animating ? false : true;
			if(p.params.minDate) {
				if(prevDateTime < new Date(p.params.minDate).getTime()) {
					return p.resetMonth();
				}
			}
			p.monthsTranslate++;
			if(prevMonth === p.currentMonth) {
				var prevMonthTranslate = -(p.monthsTranslate) * 100 * inverter;
				var prevMonthHTML = $(p.monthHTML(prevDateTime, 'prev')).transform('translate3d(' + (p.isH ? prevMonthTranslate : 0) + '%, ' + (p.isH ? 0 : prevMonthTranslate) + '%, 0)').addClass('picker-calendar-month-prev');
				p.wrapper.prepend(prevMonthHTML[0]);
				p.months = p.wrapper.find('.picker-calendar-month');
				if(p.params.onMonthAdd) {
					p.params.onMonthAdd(p, p.months.eq(0)[0]);
				}
			}
			p.animating = true;
			p.onMonthChangeStart('prev');
			var translate = (p.monthsTranslate * 100) * inverter;
			p.wrapper.transition(transition).transform('translate3d(' + (p.isH ? translate : 0) + '%, ' + (p.isH ? 0 : translate) + '%, 0)');
			if(transitionEndCallback) {
				p.wrapper.transitionEnd(function() {
					p.onMonthChangeEnd('prev');
				});
			}
			if(!p.params.animate) {
				p.onMonthChangeEnd('prev');
			}
		};
		p.resetMonth = function(transition) {
			if(typeof transition === 'undefined') transition = '';
			var translate = (p.monthsTranslate * 100) * inverter;
			p.wrapper.transition(transition).transform('translate3d(' + (p.isH ? translate : 0) + '%, ' + (p.isH ? 0 : translate) + '%, 0)');
		};
		p.setYearMonth = function(year, month, transition) {
			if(typeof year === 'undefined') year = p.currentYear;
			if(typeof month === 'undefined') month = p.currentMonth;
			if(typeof transition === 'undefined' || typeof transition === 'object') {
				transition = '';
				if(!p.params.animate) transition = 0;
			}
			var targetDate;
			if(year < p.currentYear) {
				targetDate = new Date(year, month + 1, -1).getTime();
			} else {
				targetDate = new Date(year, month).getTime();
			}
			if(p.params.maxDate && targetDate > new Date(p.params.maxDate).getTime()) {
				return false;
			}
			if(p.params.minDate && targetDate < new Date(p.params.minDate).getTime()) {
				return false;
			}
			var currentDate = new Date(p.currentYear, p.currentMonth).getTime();
			var dir = targetDate > currentDate ? 'next' : 'prev';
			var newMonthHTML = p.monthHTML(new Date(year, month));
			p.monthsTranslate = p.monthsTranslate || 0;
			var prevTranslate = p.monthsTranslate;
			var monthTranslate, wrapperTranslate;
			var transitionEndCallback = p.animating ? false : true;
			if(targetDate > currentDate) {
				// To next
				p.monthsTranslate--;
				if(!p.animating) p.months.eq(p.months.length - 1).remove();
				p.wrapper.append(newMonthHTML);
				p.months = p.wrapper.find('.picker-calendar-month');
				monthTranslate = -(prevTranslate - 1) * 100 * inverter;
				p.months.eq(p.months.length - 1).transform('translate3d(' + (p.isH ? monthTranslate : 0) + '%, ' + (p.isH ? 0 : monthTranslate) + '%, 0)').addClass('picker-calendar-month-next');
			} else {
				// To prev
				p.monthsTranslate++;
				if(!p.animating) p.months.eq(0).remove();
				p.wrapper.prepend(newMonthHTML);
				p.months = p.wrapper.find('.picker-calendar-month');
				monthTranslate = -(prevTranslate + 1) * 100 * inverter;
				p.months.eq(0).transform('translate3d(' + (p.isH ? monthTranslate : 0) + '%, ' + (p.isH ? 0 : monthTranslate) + '%, 0)').addClass('picker-calendar-month-prev');
			}
			if(p.params.onMonthAdd) {
				p.params.onMonthAdd(p, dir === 'next' ? p.months.eq(p.months.length - 1)[0] : p.months.eq(0)[0]);
			}
			p.animating = true;
			p.onMonthChangeStart(dir);
			wrapperTranslate = (p.monthsTranslate * 100) * inverter;
			p.wrapper.transition(transition).transform('translate3d(' + (p.isH ? wrapperTranslate : 0) + '%, ' + (p.isH ? 0 : wrapperTranslate) + '%, 0)');
			if(transitionEndCallback) {
				p.wrapper.transitionEnd(function() {
					p.onMonthChangeEnd(dir, true);
				});
			}
			if(!p.params.animate) {
				p.onMonthChangeEnd(dir);
			}
		};
		p.nextYear = function() {
			p.setYearMonth(p.currentYear + 1);
		};
		p.prevYear = function() {
			p.setYearMonth(p.currentYear - 1);
		};

		// HTML Layout
		p.layout = function() {
			var pickerHTML = '';
			var pickerClass = '';
			var i;

			var layoutDate = p.value && p.value.length ? p.value[0] : new Date().setHours(0, 0, 0, 0);
			/**
			 * 生成年份组和月份组DOM
			 *
			 * Start - edit by JSoon
			 */
			var prevYearsHTML = p.yearsGroupHTML(layoutDate, 'prev');
			var currentYearsHTML = p.yearsGroupHTML(layoutDate);
			var nextYearsHTML = p.yearsGroupHTML(layoutDate, 'next');
			var yearsGroupHTML = '<div class="picker-calendar-years-picker"><div class="picker-calendar-years-picker-wrapper">' + (prevYearsHTML + currentYearsHTML + nextYearsHTML) + '</div></div>';

			var monthsGroupHTML = '<div class="picker-calendar-months-picker"><div class="picker-calendar-months-picker-wrapper">' + p.monthsGroupHTML(layoutDate) + '</div></div>';
			/**
			 * End - edit by JSoon
			 */
			var prevMonthHTML = p.monthHTML(layoutDate, 'prev');
			var currentMonthHTML = p.monthHTML(layoutDate);
			var nextMonthHTML = p.monthHTML(layoutDate, 'next');
			var monthsHTML = '<div class="picker-calendar-months"><div class="picker-calendar-months-wrapper">' + (prevMonthHTML + currentMonthHTML + nextMonthHTML) + '</div></div>';
			// Week days header
			var weekHeaderHTML = '';
			if(p.params.weekHeader) {
				for(i = 0; i < 7; i++) {
					var weekDayIndex = (i + p.params.firstDay > 6) ? (i - 7 + p.params.firstDay) : (i + p.params.firstDay);
					var dayName = p.params.dayNamesShort[weekDayIndex];
					weekHeaderHTML += '<div class="picker-calendar-week-day ' + ((p.params.weekendDays.indexOf(weekDayIndex) >= 0) ? 'picker-calendar-week-day-weekend' : '') + '"> ' + dayName + '</div>';

				}
				weekHeaderHTML = '<div class="picker-calendar-week-days">' + weekHeaderHTML + '</div>';
			}
			pickerClass = 'picker-modal picker-calendar ' + (p.params.cssClass || '');
			var toolbarHTML = p.params.toolbar ? p.params.toolbarTemplate.replace(/{{closeText}}/g, p.params.toolbarCloseText) : '';
			if(p.params.toolbar) {
				toolbarHTML = p.params.toolbarTemplate
					.replace(/{{closeText}}/g, p.params.toolbarCloseText)
					.replace(/{{monthPicker}}/g, (p.params.monthPicker ? p.params.monthPickerTemplate : ''))
					.replace(/{{yearPicker}}/g, (p.params.yearPicker ? p.params.yearPickerTemplate : ''));
			}

			/**
			 * 将年份组/月份组DOM添加document中
			 *
			 * Start - edit by JSoon
			 */
			pickerHTML =
				'<div class="' + (pickerClass) + '">' +
				toolbarHTML +
				'<div class="picker-modal-inner">' +
				weekHeaderHTML +
				monthsHTML +
				'</div>' +
				monthsGroupHTML +
				yearsGroupHTML +
				'</div>';
			/**
			 * End - edit by JSoon
			 */

			p.pickerHTML = pickerHTML;
		};

		// Input Events
		function openOnInput(e) {
			e.preventDefault();
			// 安卓微信webviewreadonly的input依然弹出软键盘问题修复
			if($.device.isWeixin && $.device.android && p.params.inputReadOnly) {
				/*jshint validthis:true */
				this.focus();
				this.blur();
			}
			if(p.opened) return;
			p.open();
			if(p.params.scrollToInput) {
				var pageContent = p.input.parents('.content');
				if(pageContent.length === 0) return;

				var paddingTop = parseInt(pageContent.css('padding-top'), 10),
					paddingBottom = parseInt(pageContent.css('padding-bottom'), 10),
					pageHeight = pageContent[0].offsetHeight - paddingTop - p.container.height(),
					pageScrollHeight = pageContent[0].scrollHeight - paddingTop - p.container.height(),
					newPaddingBottom;

				var inputTop = p.input.offset().top - paddingTop + p.input[0].offsetHeight;
				if(inputTop > pageHeight) {
					var scrollTop = pageContent.scrollTop() + inputTop - pageHeight;
					if(scrollTop + pageHeight > pageScrollHeight) {
						newPaddingBottom = scrollTop + pageHeight - pageScrollHeight + paddingBottom;
						if(pageHeight === pageScrollHeight) {
							newPaddingBottom = p.container.height();
						}
						pageContent.css({ 'padding-bottom': (newPaddingBottom) + 'px' });
					}
					pageContent.scrollTop(scrollTop, 300);
				}
			}
		}

		function closeOnHTMLClick(e) {
			if(p.input && p.input.length > 0) {
				if(e.target !== p.input[0] && $(e.target).parents('.picker-modal').length === 0) p.close();
			} else {
				if($(e.target).parents('.picker-modal').length === 0) p.close();
			}
		}

		if(p.params.input) {
			p.input = $(p.params.input);
			if(p.input.length > 0) {
				if(p.params.inputReadOnly) p.input.prop('readOnly', true);
				if(!p.inline) {
					p.input.on('click', openOnInput);
				}
				/**
				 * 修复[#308](https://github.com/sdc-alibaba/SUI-Mobile/issues/308)
				 * 场景：内联页面中存在日历控件的input
				 * 问题：因未在关闭时unbind click openOnInput事件导致多次调用p.open()而生成多个日历
				 *
				 * Start - edit by JSoon
				 */
				$(document).on('beforePageSwitch', function() {
					p.input.off('click', openOnInput);
					$(document).off('beforePageSwitch');
				});
				/**
				 * End - edit by JSoon
				 */
			}

		}

		if(!p.inline) $('html').on('click', closeOnHTMLClick);

		// Open
		function onPickerClose() {
			p.opened = false;
			if(p.input && p.input.length > 0) p.input.parents('.content').css({ 'padding-bottom': '' });
			if(p.params.onClose) p.params.onClose(p);

			// Destroy events
			p.destroyCalendarEvents();
		}

		p.opened = false;
		p.open = function() {
			var updateValue = false;
			if(!p.opened) {
				// Set date value
				if(!p.value) {
					if(p.params.value) {
						p.value = p.params.value;
						updateValue = true;
					}
				}

				// Layout
				p.layout();

				// Append
				if(p.inline) {
					p.container = $(p.pickerHTML);
					p.container.addClass('picker-modal-inline');
					$(p.params.container).append(p.container);
				} else {
					p.container = $($.pickerModal(p.pickerHTML));
					$(p.container)
						.on('close', function() {
							onPickerClose();
						});
				}

				// Store calendar instance
				p.container[0].f7Calendar = p;
				p.wrapper = p.container.find('.picker-calendar-months-wrapper');

				/**
				 * 获取全局年份组及其wrapper的zepto对象
				 * 获取全局月份组wrapper的zepto对象
				 *
				 * Start - edit by JSoon
				 */
				p.yearsPickerWrapper = p.container.find('.picker-calendar-years-picker-wrapper');
				p.yearsGroups = p.yearsPickerWrapper.find('.picker-calendar-years-group');

				p.monthsPickerWrapper = p.container.find('.picker-calendar-months-picker-wrapper');
				/**
				 * End - edit by JSoon
				 */

				// Months
				p.months = p.wrapper.find('.picker-calendar-month');

				// Update current month and year
				p.updateCurrentMonthYear();

				// Set initial translate
				/**
				 * 初始化年份组过渡动画位置
				 *
				 * Start - edit by JSoon
				 */
				p.yearsTranslate = 0;
				p.setYearsTranslate();
				/**
				 * End - edit by JSoon
				 */
				p.monthsTranslate = 0;
				p.setMonthsTranslate();

				// Init events
				p.initCalendarEvents();

				// Update input value
				if(updateValue) p.updateValue();

			}

			// Set flag
			p.opened = true;
			p.initialized = true;
			if(p.params.onMonthAdd) {
				p.months.each(function() {
					p.params.onMonthAdd(p, this);
				});
			}
			if(p.params.onOpen) p.params.onOpen(p);
		};

		// Close
		p.close = function() {
			if(!p.opened || p.inline) return;
			$.closeModal(p.container);
			return;
		};

		// Destroy
		p.destroy = function() {
			p.close();
			if(p.params.input && p.input.length > 0) {
				p.input.off('click', openOnInput);
			}
			$('html').off('click', closeOnHTMLClick);
		};

		if(p.inline) {
			p.open();
		}

		return p;
	};
	$.fn.calendar = function(params) {
		return this.each(function() {
			var $this = $(this);
			if(!$this[0]) return;
			var p = {};
			if($this[0].tagName.toUpperCase() === "INPUT") {
				p.input = $this;
			} else {
				p.container = $this;
			}
			new Calendar($.extend(p, params));
		});
	};

	$.initCalendar = function(content) {
		var $content = content ? $(content) : $(document.body);
		$content.find("[data-toggle='date']").each(function() {
			$(this).calendar();
		});
	};
}(Zepto);

/*======================================================
 ************   Picker   ************
 ======================================================*/
+
function($) {
	"use strict";
	var Picker = function(params) {
		var p = this;
		var defaults = {
			updateValuesOnMomentum: false,
			updateValuesOnTouchmove: true,
			rotateEffect: false,
			momentumRatio: 7,
			freeMode: false,
			// Common settings
			scrollToInput: true,
			inputReadOnly: true,
			toolbar: true,
			toolbarCloseText: '确定',
			toolbarTemplate: '<header class="bar bar-nav">\
                <button class="button button-link pull-right close-picker">确定</button>\
                <h1 class="title">请选择</h1>\
                </header>',
		};
		params = params || {};
		for(var def in defaults) {
			if(typeof params[def] === 'undefined') {
				params[def] = defaults[def];
			}
		}
		p.params = params;
		p.cols = [];
		p.initialized = false;

		// Inline flag
		p.inline = p.params.container ? true : false;

		// 3D Transforms origin bug, only on safari
		var originBug = $.device.ios || (navigator.userAgent.toLowerCase().indexOf('safari') >= 0 && navigator.userAgent.toLowerCase().indexOf('chrome') < 0) && !$.device.android;

		// Value
		p.setValue = function(arrValues, transition) {
			var valueIndex = 0;
			for(var i = 0; i < p.cols.length; i++) {
				if(p.cols[i] && !p.cols[i].divider) {
					p.cols[i].setValue(arrValues[valueIndex], transition);
					valueIndex++;
				}
			}
		};
		p.updateValue = function() {
			var newValue = [];
			var newDisplayValue = [];
			for(var i = 0; i < p.cols.length; i++) {
				if(!p.cols[i].divider) {
					newValue.push(p.cols[i].value);
					newDisplayValue.push(p.cols[i].displayValue);
				}
			}
			if(newValue.indexOf(undefined) >= 0) {
				return;
			}
			p.value = newValue;
			p.displayValue = newDisplayValue;
			if(p.params.onChange) {
				p.params.onChange(p, p.value, p.displayValue);
			}
			if(p.input && p.input.length > 0) {
				$(p.input).val(p.params.formatValue ? p.params.formatValue(p, p.value, p.displayValue) : p.value.join(' '));
				$(p.input).trigger('change');
			}
		};

		// Columns Handlers
		p.initPickerCol = function(colElement, updateItems) {
			var colContainer = $(colElement);
			var colIndex = colContainer.index();
			var col = p.cols[colIndex];
			if(col.divider) return;
			col.container = colContainer;
			col.wrapper = col.container.find('.picker-items-col-wrapper');
			col.items = col.wrapper.find('.picker-item');

			var i, j;
			var wrapperHeight, itemHeight, itemsHeight, minTranslate, maxTranslate;
			col.replaceValues = function(values, displayValues) {
				col.destroyEvents();
				col.values = values;
				col.displayValues = displayValues;
				var newItemsHTML = p.columnHTML(col, true);
				col.wrapper.html(newItemsHTML);
				col.items = col.wrapper.find('.picker-item');
				col.calcSize();
				col.setValue(col.values[0], 0, true);
				col.initEvents();
			};
			col.calcSize = function() {
				if(p.params.rotateEffect) {
					col.container.removeClass('picker-items-col-absolute');
					if(!col.width) col.container.css({ width: '' });
				}
				var colWidth, colHeight;
				colWidth = 0;
				colHeight = col.container[0].offsetHeight;
				wrapperHeight = col.wrapper[0].offsetHeight;
				itemHeight = col.items[0].offsetHeight;
				itemsHeight = itemHeight * col.items.length;
				minTranslate = colHeight / 2 - itemsHeight + itemHeight / 2;
				maxTranslate = colHeight / 2 - itemHeight / 2;
				if(col.width) {
					colWidth = col.width;
					if(parseInt(colWidth, 10) === colWidth) colWidth = colWidth + 'px';
					col.container.css({ width: colWidth });
				}
				if(p.params.rotateEffect) {
					if(!col.width) {
						col.items.each(function() {
							var item = $(this);
							item.css({ width: 'auto' });
							colWidth = Math.max(colWidth, item[0].offsetWidth);
							item.css({ width: '' });
						});
						col.container.css({ width: (colWidth + 2) + 'px' });
					}
					col.container.addClass('picker-items-col-absolute');
				}
			};
			col.calcSize();

			col.wrapper.transform('translate3d(0,' + maxTranslate + 'px,0)').transition(0);

			var activeIndex = 0;
			var animationFrameId;

			// Set Value Function
			col.setValue = function(newValue, transition, valueCallbacks) {
				if(typeof transition === 'undefined') transition = '';
				var newActiveIndex = col.wrapper.find('.picker-item[data-picker-value="' + newValue + '"]').index();
				if(typeof newActiveIndex === 'undefined' || newActiveIndex === -1) {
					return;
				}
				var newTranslate = -newActiveIndex * itemHeight + maxTranslate;
				// Update wrapper
				col.wrapper.transition(transition);
				col.wrapper.transform('translate3d(0,' + (newTranslate) + 'px,0)');

				// Watch items
				if(p.params.updateValuesOnMomentum && col.activeIndex && col.activeIndex !== newActiveIndex) {
					$.cancelAnimationFrame(animationFrameId);
					col.wrapper.transitionEnd(function() {
						$.cancelAnimationFrame(animationFrameId);
					});
					updateDuringScroll();
				}

				// Update items
				col.updateItems(newActiveIndex, newTranslate, transition, valueCallbacks);
			};

			col.updateItems = function(activeIndex, translate, transition, valueCallbacks) {
				if(typeof translate === 'undefined') {
					translate = $.getTranslate(col.wrapper[0], 'y');
				}
				if(typeof activeIndex === 'undefined') activeIndex = -Math.round((translate - maxTranslate) / itemHeight);
				if(activeIndex < 0) activeIndex = 0;
				if(activeIndex >= col.items.length) activeIndex = col.items.length - 1;
				var previousActiveIndex = col.activeIndex;
				col.activeIndex = activeIndex;
				/*
				 col.wrapper.find('.picker-selected, .picker-after-selected, .picker-before-selected').removeClass('picker-selected picker-after-selected picker-before-selected');

				 col.items.transition(transition);
				 var selectedItem = col.items.eq(activeIndex).addClass('picker-selected').transform('');
				 var prevItems = selectedItem.prevAll().addClass('picker-before-selected');
				 var nextItems = selectedItem.nextAll().addClass('picker-after-selected');
				 */
				//去掉 .picker-after-selected, .picker-before-selected 以提高性能
				col.wrapper.find('.picker-selected').removeClass('picker-selected');
				if(p.params.rotateEffect) {
					col.items.transition(transition);
				}
				var selectedItem = col.items.eq(activeIndex).addClass('picker-selected').transform('');

				if(valueCallbacks || typeof valueCallbacks === 'undefined') {
					// Update values
					col.value = selectedItem.attr('data-picker-value');
					col.displayValue = col.displayValues ? col.displayValues[activeIndex] : col.value;
					// On change callback
					if(previousActiveIndex !== activeIndex) {
						if(col.onChange) {
							col.onChange(p, col.value, col.displayValue);
						}
						p.updateValue();
					}
				}

				// Set 3D rotate effect
				if(!p.params.rotateEffect) {
					return;
				}
				var percentage = (translate - (Math.floor((translate - maxTranslate) / itemHeight) * itemHeight + maxTranslate)) / itemHeight;

				col.items.each(function() {
					var item = $(this);
					var itemOffsetTop = item.index() * itemHeight;
					var translateOffset = maxTranslate - translate;
					var itemOffset = itemOffsetTop - translateOffset;
					var percentage = itemOffset / itemHeight;

					var itemsFit = Math.ceil(col.height / itemHeight / 2) + 1;

					var angle = (-18 * percentage);
					if(angle > 180) angle = 180;
					if(angle < -180) angle = -180;
					// Far class
					if(Math.abs(percentage) > itemsFit) item.addClass('picker-item-far');
					else item.removeClass('picker-item-far');
					// Set transform
					item.transform('translate3d(0, ' + (-translate + maxTranslate) + 'px, ' + (originBug ? -110 : 0) + 'px) rotateX(' + angle + 'deg)');
				});
			};

			function updateDuringScroll() {
				animationFrameId = $.requestAnimationFrame(function() {
					col.updateItems(undefined, undefined, 0);
					updateDuringScroll();
				});
			}

			// Update items on init
			if(updateItems) col.updateItems(0, maxTranslate, 0);

			var allowItemClick = true;
			var isTouched, isMoved, touchStartY, touchCurrentY, touchStartTime, touchEndTime, startTranslate, returnTo, currentTranslate, prevTranslate, velocityTranslate, velocityTime;

			function handleTouchStart(e) {
				if(isMoved || isTouched) return;
				e.preventDefault();
				isTouched = true;
				touchStartY = touchCurrentY = e.type === 'touchstart' ? e.targetTouches[0].pageY : e.pageY;
				touchStartTime = (new Date()).getTime();

				allowItemClick = true;
				startTranslate = currentTranslate = $.getTranslate(col.wrapper[0], 'y');
			}

			function handleTouchMove(e) {
				if(!isTouched) return;
				e.preventDefault();
				allowItemClick = false;
				touchCurrentY = e.type === 'touchmove' ? e.targetTouches[0].pageY : e.pageY;
				if(!isMoved) {
					// First move
					$.cancelAnimationFrame(animationFrameId);
					isMoved = true;
					startTranslate = currentTranslate = $.getTranslate(col.wrapper[0], 'y');
					col.wrapper.transition(0);
				}
				e.preventDefault();

				var diff = touchCurrentY - touchStartY;
				currentTranslate = startTranslate + diff;
				returnTo = undefined;

				// Normalize translate
				if(currentTranslate < minTranslate) {
					currentTranslate = minTranslate - Math.pow(minTranslate - currentTranslate, 0.8);
					returnTo = 'min';
				}
				if(currentTranslate > maxTranslate) {
					currentTranslate = maxTranslate + Math.pow(currentTranslate - maxTranslate, 0.8);
					returnTo = 'max';
				}
				// Transform wrapper
				col.wrapper.transform('translate3d(0,' + currentTranslate + 'px,0)');

				// Update items
				col.updateItems(undefined, currentTranslate, 0, p.params.updateValuesOnTouchmove);

				// Calc velocity
				velocityTranslate = currentTranslate - prevTranslate || currentTranslate;
				velocityTime = (new Date()).getTime();
				prevTranslate = currentTranslate;
			}

			function handleTouchEnd(e) {
				if(!isTouched || !isMoved) {
					isTouched = isMoved = false;
					return;
				}
				isTouched = isMoved = false;
				col.wrapper.transition('');
				if(returnTo) {
					if(returnTo === 'min') {
						col.wrapper.transform('translate3d(0,' + minTranslate + 'px,0)');
					} else col.wrapper.transform('translate3d(0,' + maxTranslate + 'px,0)');
				}
				touchEndTime = new Date().getTime();
				var velocity, newTranslate;
				if(touchEndTime - touchStartTime > 300) {
					newTranslate = currentTranslate;
				} else {
					velocity = Math.abs(velocityTranslate / (touchEndTime - velocityTime));
					newTranslate = currentTranslate + velocityTranslate * p.params.momentumRatio;
				}

				newTranslate = Math.max(Math.min(newTranslate, maxTranslate), minTranslate);

				// Active Index
				var activeIndex = -Math.floor((newTranslate - maxTranslate) / itemHeight);

				// Normalize translate
				if(!p.params.freeMode) newTranslate = -activeIndex * itemHeight + maxTranslate;

				// Transform wrapper
				col.wrapper.transform('translate3d(0,' + (parseInt(newTranslate, 10)) + 'px,0)');

				// Update items
				col.updateItems(activeIndex, newTranslate, '', true);

				// Watch items
				if(p.params.updateValuesOnMomentum) {
					updateDuringScroll();
					col.wrapper.transitionEnd(function() {
						$.cancelAnimationFrame(animationFrameId);
					});
				}

				// Allow click
				setTimeout(function() {
					allowItemClick = true;
				}, 100);
			}

			function handleClick(e) {
				if(!allowItemClick) return;
				$.cancelAnimationFrame(animationFrameId);
				/*jshint validthis:true */
				var value = $(this).attr('data-picker-value');
				col.setValue(value);
			}

			col.initEvents = function(detach) {
				var method = detach ? 'off' : 'on';
				col.container[method]($.touchEvents.start, handleTouchStart);
				col.container[method]($.touchEvents.move, handleTouchMove);
				col.container[method]($.touchEvents.end, handleTouchEnd);
				col.items[method]('click', handleClick);
			};
			col.destroyEvents = function() {
				col.initEvents(true);
			};

			col.container[0].f7DestroyPickerCol = function() {
				col.destroyEvents();
			};

			col.initEvents();

		};
		p.destroyPickerCol = function(colContainer) {
			colContainer = $(colContainer);
			if('f7DestroyPickerCol' in colContainer[0]) colContainer[0].f7DestroyPickerCol();
		};
		// Resize cols
		function resizeCols() {
			if(!p.opened) return;
			for(var i = 0; i < p.cols.length; i++) {
				if(!p.cols[i].divider) {
					p.cols[i].calcSize();
					p.cols[i].setValue(p.cols[i].value, 0, false);
				}
			}
		}

		$(window).on('resize', resizeCols);

		// HTML Layout
		p.columnHTML = function(col, onlyItems) {
			var columnItemsHTML = '';
			var columnHTML = '';
			if(col.divider) {
				columnHTML += '<div class="picker-items-col picker-items-col-divider ' + (col.textAlign ? 'picker-items-col-' + col.textAlign : '') + ' ' + (col.cssClass || '') + '">' + col.content + '</div>';
			} else {
				for(var j = 0; j < col.values.length; j++) {
					columnItemsHTML += '<div class="picker-item" data-picker-value="' + col.values[j] + '">' + (col.displayValues ? col.displayValues[j] : col.values[j]) + '</div>';
				}

				columnHTML += '<div class="picker-items-col ' + (col.textAlign ? 'picker-items-col-' + col.textAlign : '') + ' ' + (col.cssClass || '') + '"><div class="picker-items-col-wrapper">' + columnItemsHTML + '</div></div>';
			}
			return onlyItems ? columnItemsHTML : columnHTML;
		};
		p.layout = function() {
			var pickerHTML = '';
			var pickerClass = '';
			var i;
			p.cols = [];
			var colsHTML = '';
			for(i = 0; i < p.params.cols.length; i++) {
				var col = p.params.cols[i];
				colsHTML += p.columnHTML(p.params.cols[i]);
				p.cols.push(col);
			}
			pickerClass = 'picker-modal picker-columns ' + (p.params.cssClass || '') + (p.params.rotateEffect ? ' picker-3d' : '');
			pickerHTML =
				'<div class="' + (pickerClass) + '">' +
				(p.params.toolbar ? p.params.toolbarTemplate.replace(/{{closeText}}/g, p.params.toolbarCloseText) : '') +
				'<div class="picker-modal-inner picker-items">' +
				colsHTML +
				'<div class="picker-center-highlight"></div>' +
				'</div>' +
				'</div>';

			p.pickerHTML = pickerHTML;
		};

		// Input Events
		function openOnInput(e) {
			e.preventDefault();
			// 安卓微信webviewreadonly的input依然弹出软键盘问题修复
			if($.device.isWeixin && $.device.android && p.params.inputReadOnly) {
				/*jshint validthis:true */
				this.focus();
				this.blur();
			}
			if(p.opened) return;
			//关闭其他picker
			$.closeModal($('.picker-modal'));
			p.open();
			if(p.params.scrollToInput) {
				var pageContent = p.input.parents('.content');
				if(pageContent.length === 0) return;

				var paddingTop = parseInt(pageContent.css('padding-top'), 10),
					paddingBottom = parseInt(pageContent.css('padding-bottom'), 10),
					pageHeight = pageContent[0].offsetHeight - paddingTop - p.container.height(),
					pageScrollHeight = pageContent[0].scrollHeight - paddingTop - p.container.height(),
					newPaddingBottom;
				var inputTop = p.input.offset().top - paddingTop + p.input[0].offsetHeight;
				if(inputTop > pageHeight) {
					var scrollTop = pageContent.scrollTop() + inputTop - pageHeight;
					if(scrollTop + pageHeight > pageScrollHeight) {
						newPaddingBottom = scrollTop + pageHeight - pageScrollHeight + paddingBottom;
						if(pageHeight === pageScrollHeight) {
							newPaddingBottom = p.container.height();
						}
						pageContent.css({ 'padding-bottom': (newPaddingBottom) + 'px' });
					}
					pageContent.scrollTop(scrollTop, 300);
				}
			}
			//停止事件冒泡，主动处理
			e.stopPropagation();
		}

		function closeOnHTMLClick(e) {
			if(!p.opened) return;
			if(p.input && p.input.length > 0) {
				if(e.target !== p.input[0] && $(e.target).parents('.picker-modal').length === 0) p.close();
			} else {
				if($(e.target).parents('.picker-modal').length === 0) p.close();
			}
		}

		if(p.params.input) {
			p.input = $(p.params.input);
			if(p.input.length > 0) {
				if(p.params.inputReadOnly) p.input.prop('readOnly', true);
				if(!p.inline) {
					p.input.on('click', openOnInput);
				}
			}
		}

		if(!p.inline) $('html').on('click', closeOnHTMLClick);

		// Open
		function onPickerClose() {
			p.opened = false;
			if(p.input && p.input.length > 0) p.input.parents('.content').css({ 'padding-bottom': '' });
			if(p.params.onClose) p.params.onClose(p);

			// Destroy events
			p.container.find('.picker-items-col').each(function() {
				p.destroyPickerCol(this);
			});
		}

		p.opened = false;
		p.open = function() {

			if(!p.opened) {

				// Layout
				p.layout();
				p.opened = true;
				// Append
				if(p.inline) {
					p.container = $(p.pickerHTML);
					p.container.addClass('picker-modal-inline');
					$(p.params.container).append(p.container);

				} else {

					p.container = $($.pickerModal(p.pickerHTML));

					$(p.container)
						.on('close', function() {
							onPickerClose();
						});
				}

				// Store picker instance
				p.container[0].f7Picker = p;

				// Init Events
				p.container.find('.picker-items-col').each(function() {
					var updateItems = true;
					if((!p.initialized && p.params.value) || (p.initialized && p.value)) updateItems = false;
					p.initPickerCol(this, updateItems);
				});

				// Set value
				if(!p.initialized) {
					if(p.params.value) {
						p.setValue(p.params.value, 0);
					}
				} else {
					if(p.value) p.setValue(p.value, 0);
				}
			}

			// Set flag
			p.initialized = true;

			if(p.params.onOpen) p.params.onOpen(p);
		};

		// Close
		p.close = function() {
			if(!p.opened || p.inline) return;
			$.closeModal(p.container);
			return;
		};

		// Destroy
		p.destroy = function() {
			p.close();
			if(p.params.input && p.input.length > 0) {
				p.input.off('click', openOnInput);
			}
			$('html').off('click', closeOnHTMLClick);
			$(window).off('resize', resizeCols);
		};

		if(p.inline) {
			p.open();
		}

		return p;
	};

	$(document).on("click", ".close-picker", function() {
		var pickerToClose = $('.picker-modal.modal-in');
		$.closeModal(pickerToClose);
	});

	$.fn.picker = function(params) {
		var args = arguments;
		return this.each(function() {
			if(!this) return;
			var $this = $(this);

			var picker = $this.data("picker");
			if(!picker) {
				var p = $.extend({
					input: this,
					value: $this.val() ? $this.val().split(' ') : ''
				}, params);
				picker = new Picker(p);
				$this.data("picker", picker);
			}
			if(typeof params === typeof "a") {
				picker[params].apply(picker, Array.prototype.slice.call(args, 1));
			}
		});
	};
}(Zepto);

+
function($) {
	"use strict";

	var today = new Date();

	var getDays = function(max) {
		var days = [];
		for(var i = 1; i <= (max || 31); i++) {
			days.push(i < 10 ? "0" + i : i);
		}
		return days;
	};

	var getDaysByMonthAndYear = function(month, year) {
		var int_d = new Date(year, parseInt(month) + 1 - 1, 1);
		var d = new Date(int_d - 1);
		return getDays(d.getDate());
	};

	var formatNumber = function(n) {
		return n < 10 ? "0" + n : n;
	};

	var initMonthes = ('01 02 03 04 05 06 07 08 09 10 11 12').split(' ');

	var initYears = (function() {
		var arr = [];
		for(var i = 1950; i <= 2030; i++) {
			arr.push(i);
		}
		return arr;
	})();

	var defaults = {

		rotateEffect: false, //为了性能

		value: [today.getFullYear(), formatNumber(today.getMonth() + 1), formatNumber(today.getDate()), today.getHours(), formatNumber(today.getMinutes())],

		onChange: function(picker, values, displayValues) {
			var days = getDaysByMonthAndYear(picker.cols[1].value, picker.cols[0].value);
			var currentValue = picker.cols[2].value;
			if(currentValue > days.length) currentValue = days.length;
			picker.cols[2].setValue(currentValue);
		},

		formatValue: function(p, values, displayValues) {
			return displayValues[0] + '-' + values[1] + '-' + values[2] + ' ' + values[3] + ':' + values[4];
		},

		cols: [
			// Years
			{
				values: initYears
			},
			// Months
			{
				values: initMonthes
			},
			// Days
			{
				values: getDays()
			},

			// Space divider
			{
				divider: true,
				content: '  '
			},
			// Hours
			{
				values: (function() {
					var arr = [];
					for(var i = 0; i <= 23; i++) {
						arr.push(i);
					}
					return arr;
				})(),
			},
			// Divider
			{
				divider: true,
				content: ':'
			},
			// Minutes
			{
				values: (function() {
					var arr = [];
					for(var i = 0; i <= 59; i++) {
						arr.push(i < 10 ? '0' + i : i);
					}
					return arr;
				})(),
			}
		]
	};

	$.fn.datetimePicker = function(params) {
		return this.each(function() {
			if(!this) return;
			var p = $.extend(defaults, params);
			$(this).picker(p);
			if(params.value) $(this).val(p.formatValue(p, p.value, p.value));
		});
	};

}(Zepto);

+
function(window) {

	"use strict";

	var rAF = window.requestAnimationFrame ||
		window.webkitRequestAnimationFrame ||
		window.mozRequestAnimationFrame ||
		window.oRequestAnimationFrame ||
		window.msRequestAnimationFrame ||
		function(callback) {
			window.setTimeout(callback, 1000 / 60);
		};
	/*var cRAF = window.cancelRequestAnimationFrame ||
	 window.webkitCancelRequestAnimationFrame ||
	 window.mozCancelRequestAnimationFrame ||
	 window.oCancelRequestAnimationFrame ||
	 window.msCancelRequestAnimationFrame;*/

	var utils = (function() {
		var me = {};

		var _elementStyle = document.createElement('div').style;
		var _vendor = (function() {
			var vendors = ['t', 'webkitT', 'MozT', 'msT', 'OT'],
				transform,
				i = 0,
				l = vendors.length;

			for(; i < l; i++) {
				transform = vendors[i] + 'ransform';
				if(transform in _elementStyle) return vendors[i].substr(0, vendors[i].length - 1);
			}

			return false;
		})();

		function _prefixStyle(style) {
			if(_vendor === false) return false;
			if(_vendor === '') return style;
			return _vendor + style.charAt(0).toUpperCase() + style.substr(1);
		}

		me.getTime = Date.now || function getTime() {
			return new Date().getTime();
		};

		me.extend = function(target, obj) {
			for(var i in obj) {
				target[i] = obj[i];
			}
		};

		me.addEvent = function(el, type, fn, capture) {
			el.addEventListener(type, fn, !!capture);
		};

		me.removeEvent = function(el, type, fn, capture) {
			el.removeEventListener(type, fn, !!capture);
		};

		me.prefixPointerEvent = function(pointerEvent) {
			return window.MSPointerEvent ?
				'MSPointer' + pointerEvent.charAt(9).toUpperCase() + pointerEvent.substr(10) :
				pointerEvent;
		};

		me.momentum = function(current, start, time, lowerMargin, wrapperSize, deceleration, self) {
			var distance = current - start,
				speed = Math.abs(distance) / time,
				destination,
				duration;

			// var absDistance = Math.abs(distance);
			speed = speed / 2; //slowdown
			speed = speed > 1.5 ? 1.5 : speed; //set max speed to 1
			deceleration = deceleration === undefined ? 0.0006 : deceleration;

			destination = current + (speed * speed) / (2 * deceleration) * (distance < 0 ? -1 : 1);
			duration = speed / deceleration;

			if(destination < lowerMargin) {
				destination = wrapperSize ? lowerMargin - (wrapperSize / 2.5 * (speed / 8)) : lowerMargin;
				distance = Math.abs(destination - current);
				duration = distance / speed;
			} else if(destination > 0) {
				destination = wrapperSize ? wrapperSize / 2.5 * (speed / 8) : 0;
				distance = Math.abs(current) + destination;
				duration = distance / speed;
			}

			//simple trigger, every 50ms
			var t = +new Date();
			var l = t;

			function eventTrigger() {
				if(+new Date() - l > 50) {
					self._execEvent('scroll');
					l = +new Date();
				}
				if(+new Date() - t < duration) {
					rAF(eventTrigger);
				}
			}

			rAF(eventTrigger);

			return {
				destination: Math.round(destination),
				duration: duration
			};
		};

		var _transform = _prefixStyle('transform');

		me.extend(me, {
			hasTransform: _transform !== false,
			hasPerspective: _prefixStyle('perspective') in _elementStyle,
			hasTouch: 'ontouchstart' in window,
			hasPointer: window.PointerEvent || window.MSPointerEvent, // IE10 is prefixed
			hasTransition: _prefixStyle('transition') in _elementStyle
		});

		// This should find all Android browsers lower than build 535.19 (both stock browser and webview)
		me.isBadAndroid = /Android /.test(window.navigator.appVersion) && !(/Chrome\/\d/.test(window.navigator.appVersion)) && false; //this will cause many android device scroll flash; so set it to false!

		me.extend(me.style = {}, {
			transform: _transform,
			transitionTimingFunction: _prefixStyle('transitionTimingFunction'),
			transitionDuration: _prefixStyle('transitionDuration'),
			transitionDelay: _prefixStyle('transitionDelay'),
			transformOrigin: _prefixStyle('transformOrigin')
		});

		me.hasClass = function(e, c) {
			var re = new RegExp('(^|\\s)' + c + '(\\s|$)');
			return re.test(e.className);
		};

		me.addClass = function(e, c) {
			if(me.hasClass(e, c)) {
				return;
			}

			var newclass = e.className.split(' ');
			newclass.push(c);
			e.className = newclass.join(' ');
		};

		me.removeClass = function(e, c) {
			if(!me.hasClass(e, c)) {
				return;
			}

			var re = new RegExp('(^|\\s)' + c + '(\\s|$)', 'g');
			e.className = e.className.replace(re, ' ');
		};

		me.offset = function(el) {
			var left = -el.offsetLeft,
				top = -el.offsetTop;

			// jshint -W084
			while(el = el.offsetParent) {
				left -= el.offsetLeft;
				top -= el.offsetTop;
			}
			// jshint +W084

			return {
				left: left,
				top: top
			};
		};

		me.preventDefaultException = function(el, exceptions) {
			for(var i in exceptions) {
				if(exceptions[i].test(el[i])) {
					return true;
				}
			}

			return false;
		};

		me.extend(me.eventType = {}, {
			touchstart: 1,
			touchmove: 1,
			touchend: 1,

			mousedown: 2,
			mousemove: 2,
			mouseup: 2,

			pointerdown: 3,
			pointermove: 3,
			pointerup: 3,

			MSPointerDown: 3,
			MSPointerMove: 3,
			MSPointerUp: 3
		});

		me.extend(me.ease = {}, {
			quadratic: {
				style: 'cubic-bezier(0.25, 0.46, 0.45, 0.94)',
				fn: function(k) {
					return k * (2 - k);
				}
			},
			circular: {
				style: 'cubic-bezier(0.1, 0.57, 0.1, 1)', // Not properly 'circular' but this looks better, it should be (0.075, 0.82, 0.165, 1)
				fn: function(k) {
					return Math.sqrt(1 - (--k * k));
				}
			},
			back: {
				style: 'cubic-bezier(0.175, 0.885, 0.32, 1.275)',
				fn: function(k) {
					var b = 4;
					return(k = k - 1) * k * ((b + 1) * k + b) + 1;
				}
			},
			bounce: {
				style: '',
				fn: function(k) {
					if((k /= 1) < (1 / 2.75)) {
						return 7.5625 * k * k;
					} else if(k < (2 / 2.75)) {
						return 7.5625 * (k -= (1.5 / 2.75)) * k + 0.75;
					} else if(k < (2.5 / 2.75)) {
						return 7.5625 * (k -= (2.25 / 2.75)) * k + 0.9375;
					} else {
						return 7.5625 * (k -= (2.625 / 2.75)) * k + 0.984375;
					}
				}
			},
			elastic: {
				style: '',
				fn: function(k) {
					var f = 0.22,
						e = 0.4;

					if(k === 0) {
						return 0;
					}
					if(k === 1) {
						return 1;
					}

					return(e * Math.pow(2, -10 * k) * Math.sin((k - f / 4) * (2 * Math.PI) / f) + 1);
				}
			}
		});

		me.tap = function(e, eventName) {
			var ev = document.createEvent('Event');
			ev.initEvent(eventName, true, true);
			ev.pageX = e.pageX;
			ev.pageY = e.pageY;
			e.target.dispatchEvent(ev);
		};

		me.click = function(e) {
			var target = e.target,
				ev;

			if(!(/(SELECT|INPUT|TEXTAREA)/i).test(target.tagName)) {
				ev = document.createEvent('MouseEvents');
				ev.initMouseEvent('click', true, true, e.view, 1,
					target.screenX, target.screenY, target.clientX, target.clientY,
					e.ctrlKey, e.altKey, e.shiftKey, e.metaKey,
					0, null);

				ev._constructed = true;
				target.dispatchEvent(ev);
			}
		};

		return me;
	})();

	function IScroll(el, options) {
		this.wrapper = typeof el === 'string' ? document.querySelector(el) : el;
		this.scroller = $(this.wrapper).find('.content-inner')[0];

		this.scrollerStyle = this.scroller && this.scroller.style; // cache style for better performance

		this.options = {

			resizeScrollbars: true,

			mouseWheelSpeed: 20,

			snapThreshold: 0.334,

			// INSERT POINT: OPTIONS 

			startX: 0,
			startY: 0,
			scrollY: true,
			directionLockThreshold: 5,
			momentum: true,

			bounce: true,
			bounceTime: 600,
			bounceEasing: '',

			preventDefault: true,
			preventDefaultException: {
				tagName: /^(INPUT|TEXTAREA|BUTTON|SELECT)$/
			},

			HWCompositing: true,
			useTransition: true,
			useTransform: true,

			//other options
			eventPassthrough: undefined, //if you  want to use native scroll, you can set to: true or horizontal
		};

		for(var i in options) {
			this.options[i] = options[i];
		}

		// Normalize options
		this.translateZ = this.options.HWCompositing && utils.hasPerspective ? ' translateZ(0)' : '';

		this.options.useTransition = utils.hasTransition && this.options.useTransition;
		this.options.useTransform = utils.hasTransform && this.options.useTransform;

		this.options.eventPassthrough = this.options.eventPassthrough === true ? 'vertical' : this.options.eventPassthrough;
		this.options.preventDefault = !this.options.eventPassthrough && this.options.preventDefault;

		// If you want eventPassthrough I have to lock one of the axes
		this.options.scrollY = this.options.eventPassthrough === 'vertical' ? false : this.options.scrollY;
		this.options.scrollX = this.options.eventPassthrough === 'horizontal' ? false : this.options.scrollX;

		// With eventPassthrough we also need lockDirection mechanism
		this.options.freeScroll = this.options.freeScroll && !this.options.eventPassthrough;
		this.options.directionLockThreshold = this.options.eventPassthrough ? 0 : this.options.directionLockThreshold;

		this.options.bounceEasing = typeof this.options.bounceEasing === 'string' ? utils.ease[this.options.bounceEasing] || utils.ease.circular : this.options.bounceEasing;

		this.options.resizePolling = this.options.resizePolling === undefined ? 60 : this.options.resizePolling;

		if(this.options.tap === true) {
			this.options.tap = 'tap';
		}

		if(this.options.shrinkScrollbars === 'scale') {
			this.options.useTransition = false;
		}

		this.options.invertWheelDirection = this.options.invertWheelDirection ? -1 : 1;

		if(this.options.probeType === 3) {
			this.options.useTransition = false;
		}

		// INSERT POINT: NORMALIZATION

		// Some defaults    
		this.x = 0;
		this.y = 0;
		this.directionX = 0;
		this.directionY = 0;
		this._events = {};

		// INSERT POINT: DEFAULTS

		this._init();
		this.refresh();

		this.scrollTo(this.options.startX, this.options.startY);
		this.enable();
	}

	IScroll.prototype = {
		version: '5.1.3',

		_init: function() {
			this._initEvents();

			if(this.options.scrollbars || this.options.indicators) {
				this._initIndicators();
			}

			if(this.options.mouseWheel) {
				this._initWheel();
			}

			if(this.options.snap) {
				this._initSnap();
			}

			if(this.options.keyBindings) {
				this._initKeys();
			}

			// INSERT POINT: _init

		},

		destroy: function() {
			this._initEvents(true);

			this._execEvent('destroy');
		},

		_transitionEnd: function(e) {
			if(e.target !== this.scroller || !this.isInTransition) {
				return;
			}

			this._transitionTime();
			if(!this.resetPosition(this.options.bounceTime)) {
				this.isInTransition = false;
				this._execEvent('scrollEnd');
			}
		},

		_start: function(e) {
			// React to left mouse button only
			if(utils.eventType[e.type] !== 1) {
				if(e.button !== 0) {
					return;
				}
			}

			if(!this.enabled || (this.initiated && utils.eventType[e.type] !== this.initiated)) {
				return;
			}

			if(this.options.preventDefault && !utils.isBadAndroid && !utils.preventDefaultException(e.target, this.options.preventDefaultException)) {
				e.preventDefault();
			}

			var point = e.touches ? e.touches[0] : e,
				pos;

			this.initiated = utils.eventType[e.type];
			this.moved = false;
			this.distX = 0;
			this.distY = 0;
			this.directionX = 0;
			this.directionY = 0;
			this.directionLocked = 0;

			this._transitionTime();

			this.startTime = utils.getTime();

			if(this.options.useTransition && this.isInTransition) {
				this.isInTransition = false;
				pos = this.getComputedPosition();
				this._translate(Math.round(pos.x), Math.round(pos.y));
				this._execEvent('scrollEnd');
			} else if(!this.options.useTransition && this.isAnimating) {
				this.isAnimating = false;
				this._execEvent('scrollEnd');
			}

			this.startX = this.x;
			this.startY = this.y;
			this.absStartX = this.x;
			this.absStartY = this.y;
			this.pointX = point.pageX;
			this.pointY = point.pageY;

			this._execEvent('beforeScrollStart');
		},

		_move: function(e) {
			if(!this.enabled || utils.eventType[e.type] !== this.initiated) {
				return;
			}

			if(this.options.preventDefault) { // increases performance on Android? TODO: check!
				e.preventDefault();
			}

			var point = e.touches ? e.touches[0] : e,
				deltaX = point.pageX - this.pointX,
				deltaY = point.pageY - this.pointY,
				timestamp = utils.getTime(),
				newX, newY,
				absDistX, absDistY;

			this.pointX = point.pageX;
			this.pointY = point.pageY;

			this.distX += deltaX;
			this.distY += deltaY;
			absDistX = Math.abs(this.distX);
			absDistY = Math.abs(this.distY);

			// We need to move at least 10 pixels for the scrolling to initiate
			if(timestamp - this.endTime > 300 && (absDistX < 10 && absDistY < 10)) {
				return;
			}

			// If you are scrolling in one direction lock the other
			if(!this.directionLocked && !this.options.freeScroll) {
				if(absDistX > absDistY + this.options.directionLockThreshold) {
					this.directionLocked = 'h'; // lock horizontally
				} else if(absDistY >= absDistX + this.options.directionLockThreshold) {
					this.directionLocked = 'v'; // lock vertically
				} else {
					this.directionLocked = 'n'; // no lock
				}
			}

			if(this.directionLocked === 'h') {
				if(this.options.eventPassthrough === 'vertical') {
					e.preventDefault();
				} else if(this.options.eventPassthrough === 'horizontal') {
					this.initiated = false;
					return;
				}

				deltaY = 0;
			} else if(this.directionLocked === 'v') {
				if(this.options.eventPassthrough === 'horizontal') {
					e.preventDefault();
				} else if(this.options.eventPassthrough === 'vertical') {
					this.initiated = false;
					return;
				}

				deltaX = 0;
			}

			deltaX = this.hasHorizontalScroll ? deltaX : 0;
			deltaY = this.hasVerticalScroll ? deltaY : 0;

			newX = this.x + deltaX;
			newY = this.y + deltaY;

			// Slow down if outside of the boundaries
			if(newX > 0 || newX < this.maxScrollX) {
				newX = this.options.bounce ? this.x + deltaX / 3 : newX > 0 ? 0 : this.maxScrollX;
			}
			if(newY > 0 || newY < this.maxScrollY) {
				newY = this.options.bounce ? this.y + deltaY / 3 : newY > 0 ? 0 : this.maxScrollY;
			}

			this.directionX = deltaX > 0 ? -1 : deltaX < 0 ? 1 : 0;
			this.directionY = deltaY > 0 ? -1 : deltaY < 0 ? 1 : 0;

			if(!this.moved) {
				this._execEvent('scrollStart');
			}

			this.moved = true;

			this._translate(newX, newY);

			/* REPLACE START: _move */
			if(timestamp - this.startTime > 300) {
				this.startTime = timestamp;
				this.startX = this.x;
				this.startY = this.y;

				if(this.options.probeType === 1) {
					this._execEvent('scroll');
				}
			}

			if(this.options.probeType > 1) {
				this._execEvent('scroll');
			}
			/* REPLACE END: _move */

		},

		_end: function(e) {
			if(!this.enabled || utils.eventType[e.type] !== this.initiated) {
				return;
			}

			if(this.options.preventDefault && !utils.preventDefaultException(e.target, this.options.preventDefaultException)) {
				e.preventDefault();
			}

			var /*point = e.changedTouches ? e.changedTouches[0] : e,*/
				momentumX,
				momentumY,
				duration = utils.getTime() - this.startTime,
				newX = Math.round(this.x),
				newY = Math.round(this.y),
				distanceX = Math.abs(newX - this.startX),
				distanceY = Math.abs(newY - this.startY),
				time = 0,
				easing = '';

			this.isInTransition = 0;
			this.initiated = 0;
			this.endTime = utils.getTime();

			// reset if we are outside of the boundaries
			if(this.resetPosition(this.options.bounceTime)) {
				return;
			}

			this.scrollTo(newX, newY); // ensures that the last position is rounded

			// we scrolled less than 10 pixels
			if(!this.moved) {
				if(this.options.tap) {
					utils.tap(e, this.options.tap);
				}

				if(this.options.click) {
					utils.click(e);
				}

				this._execEvent('scrollCancel');
				return;
			}

			if(this._events.flick && duration < 200 && distanceX < 100 && distanceY < 100) {
				this._execEvent('flick');
				return;
			}

			// start momentum animation if needed
			if(this.options.momentum && duration < 300) {
				momentumX = this.hasHorizontalScroll ? utils.momentum(this.x, this.startX, duration, this.maxScrollX, this.options.bounce ? this.wrapperWidth : 0, this.options.deceleration, this) : {
					destination: newX,
					duration: 0
				};
				momentumY = this.hasVerticalScroll ? utils.momentum(this.y, this.startY, duration, this.maxScrollY, this.options.bounce ? this.wrapperHeight : 0, this.options.deceleration, this) : {
					destination: newY,
					duration: 0
				};
				newX = momentumX.destination;
				newY = momentumY.destination;
				time = Math.max(momentumX.duration, momentumY.duration);
				this.isInTransition = 1;
			}

			if(this.options.snap) {
				var snap = this._nearestSnap(newX, newY);
				this.currentPage = snap;
				time = this.options.snapSpeed || Math.max(
					Math.max(
						Math.min(Math.abs(newX - snap.x), 1000),
						Math.min(Math.abs(newY - snap.y), 1000)
					), 300);
				newX = snap.x;
				newY = snap.y;

				this.directionX = 0;
				this.directionY = 0;
				easing = this.options.bounceEasing;
			}

			// INSERT POINT: _end

			if(newX !== this.x || newY !== this.y) {
				// change easing function when scroller goes out of the boundaries
				if(newX > 0 || newX < this.maxScrollX || newY > 0 || newY < this.maxScrollY) {
					easing = utils.ease.quadratic;
				}

				this.scrollTo(newX, newY, time, easing);
				return;
			}

			this._execEvent('scrollEnd');
		},

		_resize: function() {
			var that = this;

			clearTimeout(this.resizeTimeout);

			this.resizeTimeout = setTimeout(function() {
				that.refresh();
			}, this.options.resizePolling);
		},

		resetPosition: function(time) {
			var x = this.x,
				y = this.y;

			time = time || 0;

			if(!this.hasHorizontalScroll || this.x > 0) {
				x = 0;
			} else if(this.x < this.maxScrollX) {
				x = this.maxScrollX;
			}

			if(!this.hasVerticalScroll || this.y > 0) {
				y = 0;
			} else if(this.y < this.maxScrollY) {
				y = this.maxScrollY;
			}

			if(x === this.x && y === this.y) {
				return false;
			}

			if(this.options.ptr && this.y > 44 && this.startY * -1 < $(window).height() && !this.ptrLock) {
				// not trigger ptr when user want to scroll to top
				y = this.options.ptrOffset || 44;
				this._execEvent('ptr');
				// 防止返回的过程中再次触发了 ptr ，导致被定位到 44px（因为可能done事件触发很快，在返回到44px以前就触发done
				this.ptrLock = true;
				var self = this;
				setTimeout(function() {
					self.ptrLock = false;
				}, 500);
			}

			this.scrollTo(x, y, time, this.options.bounceEasing);

			return true;
		},

		disable: function() {
			this.enabled = false;
		},

		enable: function() {
			this.enabled = true;
		},

		refresh: function() {
			// var rf = this.wrapper.offsetHeight; // Force reflow

			this.wrapperWidth = this.wrapper.clientWidth;
			this.wrapperHeight = this.wrapper.clientHeight;

			/* REPLACE START: refresh */

			this.scrollerWidth = this.scroller.offsetWidth;
			this.scrollerHeight = this.scroller.offsetHeight;

			this.maxScrollX = this.wrapperWidth - this.scrollerWidth;
			this.maxScrollY = this.wrapperHeight - this.scrollerHeight;

			/* REPLACE END: refresh */

			this.hasHorizontalScroll = this.options.scrollX && this.maxScrollX < 0;
			this.hasVerticalScroll = this.options.scrollY && this.maxScrollY < 0;

			if(!this.hasHorizontalScroll) {
				this.maxScrollX = 0;
				this.scrollerWidth = this.wrapperWidth;
			}

			if(!this.hasVerticalScroll) {
				this.maxScrollY = 0;
				this.scrollerHeight = this.wrapperHeight;
			}

			this.endTime = 0;
			this.directionX = 0;
			this.directionY = 0;

			this.wrapperOffset = utils.offset(this.wrapper);

			this._execEvent('refresh');

			this.resetPosition();

			// INSERT POINT: _refresh

		},

		on: function(type, fn) {
			if(!this._events[type]) {
				this._events[type] = [];
			}

			this._events[type].push(fn);
		},

		off: function(type, fn) {
			if(!this._events[type]) {
				return;
			}

			var index = this._events[type].indexOf(fn);

			if(index > -1) {
				this._events[type].splice(index, 1);
			}
		},

		_execEvent: function(type) {
			if(!this._events[type]) {
				return;
			}

			var i = 0,
				l = this._events[type].length;

			if(!l) {
				return;
			}

			for(; i < l; i++) {
				this._events[type][i].apply(this, [].slice.call(arguments, 1));
			}
		},

		scrollBy: function(x, y, time, easing) {
			x = this.x + x;
			y = this.y + y;
			time = time || 0;

			this.scrollTo(x, y, time, easing);
		},

		scrollTo: function(x, y, time, easing) {
			easing = easing || utils.ease.circular;

			this.isInTransition = this.options.useTransition && time > 0;

			if(!time || (this.options.useTransition && easing.style)) {
				this._transitionTimingFunction(easing.style);
				this._transitionTime(time);
				this._translate(x, y);
			} else {
				this._animate(x, y, time, easing.fn);
			}
		},

		scrollToElement: function(el, time, offsetX, offsetY, easing) {
			el = el.nodeType ? el : this.scroller.querySelector(el);

			if(!el) {
				return;
			}

			var pos = utils.offset(el);

			pos.left -= this.wrapperOffset.left;
			pos.top -= this.wrapperOffset.top;

			// if offsetX/Y are true we center the element to the screen
			if(offsetX === true) {
				offsetX = Math.round(el.offsetWidth / 2 - this.wrapper.offsetWidth / 2);
			}
			if(offsetY === true) {
				offsetY = Math.round(el.offsetHeight / 2 - this.wrapper.offsetHeight / 2);
			}

			pos.left -= offsetX || 0;
			pos.top -= offsetY || 0;

			pos.left = pos.left > 0 ? 0 : pos.left < this.maxScrollX ? this.maxScrollX : pos.left;
			pos.top = pos.top > 0 ? 0 : pos.top < this.maxScrollY ? this.maxScrollY : pos.top;

			time = time === undefined || time === null || time === 'auto' ? Math.max(Math.abs(this.x - pos.left), Math.abs(this.y - pos.top)) : time;

			this.scrollTo(pos.left, pos.top, time, easing);
		},

		_transitionTime: function(time) {
			time = time || 0;

			this.scrollerStyle[utils.style.transitionDuration] = time + 'ms';

			if(!time && utils.isBadAndroid) {
				this.scrollerStyle[utils.style.transitionDuration] = '0.001s';
			}

			if(this.indicators) {
				for(var i = this.indicators.length; i--;) {
					this.indicators[i].transitionTime(time);
				}
			}

			// INSERT POINT: _transitionTime

		},

		_transitionTimingFunction: function(easing) {
			this.scrollerStyle[utils.style.transitionTimingFunction] = easing;

			if(this.indicators) {
				for(var i = this.indicators.length; i--;) {
					this.indicators[i].transitionTimingFunction(easing);
				}
			}

			// INSERT POINT: _transitionTimingFunction

		},

		_translate: function(x, y) {
			if(this.options.useTransform) {

				/* REPLACE START: _translate */

				this.scrollerStyle[utils.style.transform] = 'translate(' + x + 'px,' + y + 'px)' + this.translateZ;

				/* REPLACE END: _translate */

			} else {
				x = Math.round(x);
				y = Math.round(y);
				this.scrollerStyle.left = x + 'px';
				this.scrollerStyle.top = y + 'px';
			}

			this.x = x;
			this.y = y;

			if(this.indicators) {
				for(var i = this.indicators.length; i--;) {
					this.indicators[i].updatePosition();
				}
			}

			// INSERT POINT: _translate

		},

		_initEvents: function(remove) {
			var eventType = remove ? utils.removeEvent : utils.addEvent,
				target = this.options.bindToWrapper ? this.wrapper : window;

			eventType(window, 'orientationchange', this);
			eventType(window, 'resize', this);

			if(this.options.click) {
				eventType(this.wrapper, 'click', this, true);
			}

			if(!this.options.disableMouse) {
				eventType(this.wrapper, 'mousedown', this);
				eventType(target, 'mousemove', this);
				eventType(target, 'mousecancel', this);
				eventType(target, 'mouseup', this);
			}

			if(utils.hasPointer && !this.options.disablePointer) {
				eventType(this.wrapper, utils.prefixPointerEvent('pointerdown'), this);
				eventType(target, utils.prefixPointerEvent('pointermove'), this);
				eventType(target, utils.prefixPointerEvent('pointercancel'), this);
				eventType(target, utils.prefixPointerEvent('pointerup'), this);
			}

			if(utils.hasTouch && !this.options.disableTouch) {
				eventType(this.wrapper, 'touchstart', this);
				eventType(target, 'touchmove', this);
				eventType(target, 'touchcancel', this);
				eventType(target, 'touchend', this);
			}

			eventType(this.scroller, 'transitionend', this);
			eventType(this.scroller, 'webkitTransitionEnd', this);
			eventType(this.scroller, 'oTransitionEnd', this);
			eventType(this.scroller, 'MSTransitionEnd', this);
		},

		getComputedPosition: function() {
			var matrix = window.getComputedStyle(this.scroller, null),
				x, y;

			if(this.options.useTransform) {
				matrix = matrix[utils.style.transform].split(')')[0].split(', ');
				x = +(matrix[12] || matrix[4]);
				y = +(matrix[13] || matrix[5]);
			} else {
				x = +matrix.left.replace(/[^-\d.]/g, '');
				y = +matrix.top.replace(/[^-\d.]/g, '');
			}

			return {
				x: x,
				y: y
			};
		},

		_initIndicators: function() {
			var interactive = this.options.interactiveScrollbars,
				customStyle = typeof this.options.scrollbars !== 'string',
				indicators = [],
				indicator;

			var that = this;

			this.indicators = [];

			if(this.options.scrollbars) {
				// Vertical scrollbar
				if(this.options.scrollY) {
					indicator = {
						el: createDefaultScrollbar('v', interactive, this.options.scrollbars),
						interactive: interactive,
						defaultScrollbars: true,
						customStyle: customStyle,
						resize: this.options.resizeScrollbars,
						shrink: this.options.shrinkScrollbars,
						fade: this.options.fadeScrollbars,
						listenX: false
					};

					this.wrapper.appendChild(indicator.el);
					indicators.push(indicator);
				}

				// Horizontal scrollbar
				if(this.options.scrollX) {
					indicator = {
						el: createDefaultScrollbar('h', interactive, this.options.scrollbars),
						interactive: interactive,
						defaultScrollbars: true,
						customStyle: customStyle,
						resize: this.options.resizeScrollbars,
						shrink: this.options.shrinkScrollbars,
						fade: this.options.fadeScrollbars,
						listenY: false
					};

					this.wrapper.appendChild(indicator.el);
					indicators.push(indicator);
				}
			}

			if(this.options.indicators) {
				// TODO: check concat compatibility
				indicators = indicators.concat(this.options.indicators);
			}

			for(var i = indicators.length; i--;) {
				this.indicators.push(new Indicator(this, indicators[i]));
			}

			// TODO: check if we can use array.map (wide compatibility and performance issues)
			function _indicatorsMap(fn) {
				for(var i = that.indicators.length; i--;) {
					fn.call(that.indicators[i]);
				}
			}

			if(this.options.fadeScrollbars) {
				this.on('scrollEnd', function() {
					_indicatorsMap(function() {
						this.fade();
					});
				});

				this.on('scrollCancel', function() {
					_indicatorsMap(function() {
						this.fade();
					});
				});

				this.on('scrollStart', function() {
					_indicatorsMap(function() {
						this.fade(1);
					});
				});

				this.on('beforeScrollStart', function() {
					_indicatorsMap(function() {
						this.fade(1, true);
					});
				});
			}

			this.on('refresh', function() {
				_indicatorsMap(function() {
					this.refresh();
				});
			});

			this.on('destroy', function() {
				_indicatorsMap(function() {
					this.destroy();
				});

				delete this.indicators;
			});
		},

		_initWheel: function() {
			utils.addEvent(this.wrapper, 'wheel', this);
			utils.addEvent(this.wrapper, 'mousewheel', this);
			utils.addEvent(this.wrapper, 'DOMMouseScroll', this);

			this.on('destroy', function() {
				utils.removeEvent(this.wrapper, 'wheel', this);
				utils.removeEvent(this.wrapper, 'mousewheel', this);
				utils.removeEvent(this.wrapper, 'DOMMouseScroll', this);
			});
		},

		_wheel: function(e) {
			if(!this.enabled) {
				return;
			}

			e.preventDefault();
			e.stopPropagation();

			var wheelDeltaX, wheelDeltaY,
				newX, newY,
				that = this;

			if(this.wheelTimeout === undefined) {
				that._execEvent('scrollStart');
			}

			// Execute the scrollEnd event after 400ms the wheel stopped scrolling
			clearTimeout(this.wheelTimeout);
			this.wheelTimeout = setTimeout(function() {
				that._execEvent('scrollEnd');
				that.wheelTimeout = undefined;
			}, 400);

			if('deltaX' in e) {
				if(e.deltaMode === 1) {
					wheelDeltaX = -e.deltaX * this.options.mouseWheelSpeed;
					wheelDeltaY = -e.deltaY * this.options.mouseWheelSpeed;
				} else {
					wheelDeltaX = -e.deltaX;
					wheelDeltaY = -e.deltaY;
				}
			} else if('wheelDeltaX' in e) {
				wheelDeltaX = e.wheelDeltaX / 120 * this.options.mouseWheelSpeed;
				wheelDeltaY = e.wheelDeltaY / 120 * this.options.mouseWheelSpeed;
			} else if('wheelDelta' in e) {
				wheelDeltaX = wheelDeltaY = e.wheelDelta / 120 * this.options.mouseWheelSpeed;
			} else if('detail' in e) {
				wheelDeltaX = wheelDeltaY = -e.detail / 3 * this.options.mouseWheelSpeed;
			} else {
				return;
			}

			wheelDeltaX *= this.options.invertWheelDirection;
			wheelDeltaY *= this.options.invertWheelDirection;

			if(!this.hasVerticalScroll) {
				wheelDeltaX = wheelDeltaY;
				wheelDeltaY = 0;
			}

			if(this.options.snap) {
				newX = this.currentPage.pageX;
				newY = this.currentPage.pageY;

				if(wheelDeltaX > 0) {
					newX--;
				} else if(wheelDeltaX < 0) {
					newX++;
				}

				if(wheelDeltaY > 0) {
					newY--;
				} else if(wheelDeltaY < 0) {
					newY++;
				}

				this.goToPage(newX, newY);

				return;
			}

			newX = this.x + Math.round(this.hasHorizontalScroll ? wheelDeltaX : 0);
			newY = this.y + Math.round(this.hasVerticalScroll ? wheelDeltaY : 0);

			if(newX > 0) {
				newX = 0;
			} else if(newX < this.maxScrollX) {
				newX = this.maxScrollX;
			}

			if(newY > 0) {
				newY = 0;
			} else if(newY < this.maxScrollY) {
				newY = this.maxScrollY;
			}

			this.scrollTo(newX, newY, 0);

			this._execEvent('scroll');

			// INSERT POINT: _wheel
		},

		_initSnap: function() {
			this.currentPage = {};

			if(typeof this.options.snap === 'string') {
				this.options.snap = this.scroller.querySelectorAll(this.options.snap);
			}

			this.on('refresh', function() {
				var i = 0,
					l,
					m = 0,
					n,
					cx, cy,
					x = 0,
					y,
					stepX = this.options.snapStepX || this.wrapperWidth,
					stepY = this.options.snapStepY || this.wrapperHeight,
					el;

				this.pages = [];

				if(!this.wrapperWidth || !this.wrapperHeight || !this.scrollerWidth || !this.scrollerHeight) {
					return;
				}

				if(this.options.snap === true) {
					cx = Math.round(stepX / 2);
					cy = Math.round(stepY / 2);

					while(x > -this.scrollerWidth) {
						this.pages[i] = [];
						l = 0;
						y = 0;

						while(y > -this.scrollerHeight) {
							this.pages[i][l] = {
								x: Math.max(x, this.maxScrollX),
								y: Math.max(y, this.maxScrollY),
								width: stepX,
								height: stepY,
								cx: x - cx,
								cy: y - cy
							};

							y -= stepY;
							l++;
						}

						x -= stepX;
						i++;
					}
				} else {
					el = this.options.snap;
					l = el.length;
					n = -1;

					for(; i < l; i++) {
						if(i === 0 || el[i].offsetLeft <= el[i - 1].offsetLeft) {
							m = 0;
							n++;
						}

						if(!this.pages[m]) {
							this.pages[m] = [];
						}

						x = Math.max(-el[i].offsetLeft, this.maxScrollX);
						y = Math.max(-el[i].offsetTop, this.maxScrollY);
						cx = x - Math.round(el[i].offsetWidth / 2);
						cy = y - Math.round(el[i].offsetHeight / 2);

						this.pages[m][n] = {
							x: x,
							y: y,
							width: el[i].offsetWidth,
							height: el[i].offsetHeight,
							cx: cx,
							cy: cy
						};

						if(x > this.maxScrollX) {
							m++;
						}
					}
				}

				this.goToPage(this.currentPage.pageX || 0, this.currentPage.pageY || 0, 0);

				// Update snap threshold if needed
				if(this.options.snapThreshold % 1 === 0) {
					this.snapThresholdX = this.options.snapThreshold;
					this.snapThresholdY = this.options.snapThreshold;
				} else {
					this.snapThresholdX = Math.round(this.pages[this.currentPage.pageX][this.currentPage.pageY].width * this.options.snapThreshold);
					this.snapThresholdY = Math.round(this.pages[this.currentPage.pageX][this.currentPage.pageY].height * this.options.snapThreshold);
				}
			});

			this.on('flick', function() {
				var time = this.options.snapSpeed || Math.max(
					Math.max(
						Math.min(Math.abs(this.x - this.startX), 1000),
						Math.min(Math.abs(this.y - this.startY), 1000)
					), 300);

				this.goToPage(
					this.currentPage.pageX + this.directionX,
					this.currentPage.pageY + this.directionY,
					time
				);
			});
		},

		_nearestSnap: function(x, y) {
			if(!this.pages.length) {
				return {
					x: 0,
					y: 0,
					pageX: 0,
					pageY: 0
				};
			}

			var i = 0,
				l = this.pages.length,
				m = 0;

			// Check if we exceeded the snap threshold
			if(Math.abs(x - this.absStartX) < this.snapThresholdX &&
				Math.abs(y - this.absStartY) < this.snapThresholdY) {
				return this.currentPage;
			}

			if(x > 0) {
				x = 0;
			} else if(x < this.maxScrollX) {
				x = this.maxScrollX;
			}

			if(y > 0) {
				y = 0;
			} else if(y < this.maxScrollY) {
				y = this.maxScrollY;
			}

			for(; i < l; i++) {
				if(x >= this.pages[i][0].cx) {
					x = this.pages[i][0].x;
					break;
				}
			}

			l = this.pages[i].length;

			for(; m < l; m++) {
				if(y >= this.pages[0][m].cy) {
					y = this.pages[0][m].y;
					break;
				}
			}

			if(i === this.currentPage.pageX) {
				i += this.directionX;

				if(i < 0) {
					i = 0;
				} else if(i >= this.pages.length) {
					i = this.pages.length - 1;
				}

				x = this.pages[i][0].x;
			}

			if(m === this.currentPage.pageY) {
				m += this.directionY;

				if(m < 0) {
					m = 0;
				} else if(m >= this.pages[0].length) {
					m = this.pages[0].length - 1;
				}

				y = this.pages[0][m].y;
			}

			return {
				x: x,
				y: y,
				pageX: i,
				pageY: m
			};
		},

		goToPage: function(x, y, time, easing) {
			easing = easing || this.options.bounceEasing;

			if(x >= this.pages.length) {
				x = this.pages.length - 1;
			} else if(x < 0) {
				x = 0;
			}

			if(y >= this.pages[x].length) {
				y = this.pages[x].length - 1;
			} else if(y < 0) {
				y = 0;
			}

			var posX = this.pages[x][y].x,
				posY = this.pages[x][y].y;

			time = time === undefined ? this.options.snapSpeed || Math.max(
				Math.max(
					Math.min(Math.abs(posX - this.x), 1000),
					Math.min(Math.abs(posY - this.y), 1000)
				), 300) : time;

			this.currentPage = {
				x: posX,
				y: posY,
				pageX: x,
				pageY: y
			};

			this.scrollTo(posX, posY, time, easing);
		},

		next: function(time, easing) {
			var x = this.currentPage.pageX,
				y = this.currentPage.pageY;

			x++;

			if(x >= this.pages.length && this.hasVerticalScroll) {
				x = 0;
				y++;
			}

			this.goToPage(x, y, time, easing);
		},

		prev: function(time, easing) {
			var x = this.currentPage.pageX,
				y = this.currentPage.pageY;

			x--;

			if(x < 0 && this.hasVerticalScroll) {
				x = 0;
				y--;
			}

			this.goToPage(x, y, time, easing);
		},

		_initKeys: function() {
			// default key bindings
			var keys = {
				pageUp: 33,
				pageDown: 34,
				end: 35,
				home: 36,
				left: 37,
				up: 38,
				right: 39,
				down: 40
			};
			var i;

			// if you give me characters I give you keycode
			if(typeof this.options.keyBindings === 'object') {
				for(i in this.options.keyBindings) {
					if(typeof this.options.keyBindings[i] === 'string') {
						this.options.keyBindings[i] = this.options.keyBindings[i].toUpperCase().charCodeAt(0);
					}
				}
			} else {
				this.options.keyBindings = {};
			}

			for(i in keys) {
				this.options.keyBindings[i] = this.options.keyBindings[i] || keys[i];
			}

			utils.addEvent(window, 'keydown', this);

			this.on('destroy', function() {
				utils.removeEvent(window, 'keydown', this);
			});
		},

		_key: function(e) {
			if(!this.enabled) {
				return;
			}

			var snap = this.options.snap, // we are using this alot, better to cache it
				newX = snap ? this.currentPage.pageX : this.x,
				newY = snap ? this.currentPage.pageY : this.y,
				now = utils.getTime(),
				prevTime = this.keyTime || 0,
				acceleration = 0.250,
				pos;

			if(this.options.useTransition && this.isInTransition) {
				pos = this.getComputedPosition();

				this._translate(Math.round(pos.x), Math.round(pos.y));
				this.isInTransition = false;
			}

			this.keyAcceleration = now - prevTime < 200 ? Math.min(this.keyAcceleration + acceleration, 50) : 0;

			switch(e.keyCode) {
				case this.options.keyBindings.pageUp:
					if(this.hasHorizontalScroll && !this.hasVerticalScroll) {
						newX += snap ? 1 : this.wrapperWidth;
					} else {
						newY += snap ? 1 : this.wrapperHeight;
					}
					break;
				case this.options.keyBindings.pageDown:
					if(this.hasHorizontalScroll && !this.hasVerticalScroll) {
						newX -= snap ? 1 : this.wrapperWidth;
					} else {
						newY -= snap ? 1 : this.wrapperHeight;
					}
					break;
				case this.options.keyBindings.end:
					newX = snap ? this.pages.length - 1 : this.maxScrollX;
					newY = snap ? this.pages[0].length - 1 : this.maxScrollY;
					break;
				case this.options.keyBindings.home:
					newX = 0;
					newY = 0;
					break;
				case this.options.keyBindings.left:
					newX += snap ? -1 : 5 + this.keyAcceleration >> 0;
					break;
				case this.options.keyBindings.up:
					newY += snap ? 1 : 5 + this.keyAcceleration >> 0;
					break;
				case this.options.keyBindings.right:
					newX -= snap ? -1 : 5 + this.keyAcceleration >> 0;
					break;
				case this.options.keyBindings.down:
					newY -= snap ? 1 : 5 + this.keyAcceleration >> 0;
					break;
				default:
					return;
			}

			if(snap) {
				this.goToPage(newX, newY);
				return;
			}

			if(newX > 0) {
				newX = 0;
				this.keyAcceleration = 0;
			} else if(newX < this.maxScrollX) {
				newX = this.maxScrollX;
				this.keyAcceleration = 0;
			}

			if(newY > 0) {
				newY = 0;
				this.keyAcceleration = 0;
			} else if(newY < this.maxScrollY) {
				newY = this.maxScrollY;
				this.keyAcceleration = 0;
			}

			this.scrollTo(newX, newY, 0);

			this.keyTime = now;
		},

		_animate: function(destX, destY, duration, easingFn) {
			var that = this,
				startX = this.x,
				startY = this.y,
				startTime = utils.getTime(),
				destTime = startTime + duration;

			function step() {
				var now = utils.getTime(),
					newX, newY,
					easing;

				if(now >= destTime) {
					that.isAnimating = false;
					that._translate(destX, destY);

					if(!that.resetPosition(that.options.bounceTime)) {
						that._execEvent('scrollEnd');
					}

					return;
				}

				now = (now - startTime) / duration;
				easing = easingFn(now);
				newX = (destX - startX) * easing + startX;
				newY = (destY - startY) * easing + startY;
				that._translate(newX, newY);

				if(that.isAnimating) {
					rAF(step);
				}

				if(that.options.probeType === 3) {
					that._execEvent('scroll');
				}
			}

			this.isAnimating = true;
			step();
		},

		handleEvent: function(e) {
			switch(e.type) {
				case 'touchstart':
				case 'pointerdown':
				case 'MSPointerDown':
				case 'mousedown':
					this._start(e);
					break;
				case 'touchmove':
				case 'pointermove':
				case 'MSPointerMove':
				case 'mousemove':
					this._move(e);
					break;
				case 'touchend':
				case 'pointerup':
				case 'MSPointerUp':
				case 'mouseup':
				case 'touchcancel':
				case 'pointercancel':
				case 'MSPointerCancel':
				case 'mousecancel':
					this._end(e);
					break;
				case 'orientationchange':
				case 'resize':
					this._resize();
					break;
				case 'transitionend':
				case 'webkitTransitionEnd':
				case 'oTransitionEnd':
				case 'MSTransitionEnd':
					this._transitionEnd(e);
					break;
				case 'wheel':
				case 'DOMMouseScroll':
				case 'mousewheel':
					this._wheel(e);
					break;
				case 'keydown':
					this._key(e);
					break;
				case 'click':
					if(!e._constructed) {
						e.preventDefault();
						e.stopPropagation();
					}
					break;
			}
		}
	};

	function createDefaultScrollbar(direction, interactive, type) {
		var scrollbar = document.createElement('div'),
			indicator = document.createElement('div');

		if(type === true) {
			scrollbar.style.cssText = 'position:absolute;z-index:9999';
			indicator.style.cssText = '-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;position:absolute;background:rgba(0,0,0,0.5);border:1px solid rgba(255,255,255,0.9);border-radius:3px';
		}

		indicator.className = 'iScrollIndicator';

		if(direction === 'h') {
			if(type === true) {
				scrollbar.style.cssText += ';height:5px;left:2px;right:2px;bottom:0';
				indicator.style.height = '100%';
			}
			scrollbar.className = 'iScrollHorizontalScrollbar';
		} else {
			if(type === true) {
				scrollbar.style.cssText += ';width:5px;bottom:2px;top:2px;right:1px';
				indicator.style.width = '100%';
			}
			scrollbar.className = 'iScrollVerticalScrollbar';
		}

		scrollbar.style.cssText += ';overflow:hidden';

		if(!interactive) {
			scrollbar.style.pointerEvents = 'none';
		}

		scrollbar.appendChild(indicator);

		return scrollbar;
	}

	function Indicator(scroller, options) {
		this.wrapper = typeof options.el === 'string' ? document.querySelector(options.el) : options.el;
		this.wrapperStyle = this.wrapper.style;
		this.indicator = this.wrapper.children[0];
		this.indicatorStyle = this.indicator.style;
		this.scroller = scroller;

		this.options = {
			listenX: true,
			listenY: true,
			interactive: false,
			resize: true,
			defaultScrollbars: false,
			shrink: false,
			fade: false,
			speedRatioX: 0,
			speedRatioY: 0
		};

		for(var i in options) {
			this.options[i] = options[i];

		}

		this.sizeRatioX = 1;
		this.sizeRatioY = 1;
		this.maxPosX = 0;
		this.maxPosY = 0;

		if(this.options.interactive) {
			if(!this.options.disableTouch) {
				utils.addEvent(this.indicator, 'touchstart', this);
				utils.addEvent(window, 'touchend', this);
			}
			if(!this.options.disablePointer) {
				utils.addEvent(this.indicator, utils.prefixPointerEvent('pointerdown'), this);
				utils.addEvent(window, utils.prefixPointerEvent('pointerup'), this);
			}
			if(!this.options.disableMouse) {
				utils.addEvent(this.indicator, 'mousedown', this);
				utils.addEvent(window, 'mouseup', this);
			}
		}

		if(this.options.fade) {
			this.wrapperStyle[utils.style.transform] = this.scroller.translateZ;
			this.wrapperStyle[utils.style.transitionDuration] = utils.isBadAndroid ? '0.001s' : '0ms';
			this.wrapperStyle.opacity = '0';
		}
	}

	Indicator.prototype = {
		handleEvent: function(e) {
			switch(e.type) {
				case 'touchstart':
				case 'pointerdown':
				case 'MSPointerDown':
				case 'mousedown':
					this._start(e);
					break;
				case 'touchmove':
				case 'pointermove':
				case 'MSPointerMove':
				case 'mousemove':
					this._move(e);
					break;
				case 'touchend':
				case 'pointerup':
				case 'MSPointerUp':
				case 'mouseup':
				case 'touchcancel':
				case 'pointercancel':
				case 'MSPointerCancel':
				case 'mousecancel':
					this._end(e);
					break;
			}
		},

		destroy: function() {
			if(this.options.interactive) {
				utils.removeEvent(this.indicator, 'touchstart', this);
				utils.removeEvent(this.indicator, utils.prefixPointerEvent('pointerdown'), this);
				utils.removeEvent(this.indicator, 'mousedown', this);

				utils.removeEvent(window, 'touchmove', this);
				utils.removeEvent(window, utils.prefixPointerEvent('pointermove'), this);
				utils.removeEvent(window, 'mousemove', this);

				utils.removeEvent(window, 'touchend', this);
				utils.removeEvent(window, utils.prefixPointerEvent('pointerup'), this);
				utils.removeEvent(window, 'mouseup', this);
			}

			if(this.options.defaultScrollbars) {
				this.wrapper.parentNode.removeChild(this.wrapper);
			}
		},

		_start: function(e) {
			var point = e.touches ? e.touches[0] : e;

			e.preventDefault();
			e.stopPropagation();

			this.transitionTime();

			this.initiated = true;
			this.moved = false;
			this.lastPointX = point.pageX;
			this.lastPointY = point.pageY;

			this.startTime = utils.getTime();

			if(!this.options.disableTouch) {
				utils.addEvent(window, 'touchmove', this);
			}
			if(!this.options.disablePointer) {
				utils.addEvent(window, utils.prefixPointerEvent('pointermove'), this);
			}
			if(!this.options.disableMouse) {
				utils.addEvent(window, 'mousemove', this);
			}

			this.scroller._execEvent('beforeScrollStart');
		},

		_move: function(e) {
			var point = e.touches ? e.touches[0] : e,
				deltaX, deltaY,
				newX, newY,
				timestamp = utils.getTime();

			if(!this.moved) {
				this.scroller._execEvent('scrollStart');
			}

			this.moved = true;

			deltaX = point.pageX - this.lastPointX;
			this.lastPointX = point.pageX;

			deltaY = point.pageY - this.lastPointY;
			this.lastPointY = point.pageY;

			newX = this.x + deltaX;
			newY = this.y + deltaY;

			this._pos(newX, newY);

			if(this.scroller.options.probeType === 1 && timestamp - this.startTime > 300) {
				this.startTime = timestamp;
				this.scroller._execEvent('scroll');
			} else if(this.scroller.options.probeType > 1) {
				this.scroller._execEvent('scroll');
			}

			// INSERT POINT: indicator._move

			e.preventDefault();
			e.stopPropagation();
		},

		_end: function(e) {
			if(!this.initiated) {
				return;
			}

			this.initiated = false;

			e.preventDefault();
			e.stopPropagation();

			utils.removeEvent(window, 'touchmove', this);
			utils.removeEvent(window, utils.prefixPointerEvent('pointermove'), this);
			utils.removeEvent(window, 'mousemove', this);

			if(this.scroller.options.snap) {
				var snap = this.scroller._nearestSnap(this.scroller.x, this.scroller.y);

				var time = this.options.snapSpeed || Math.max(
					Math.max(
						Math.min(Math.abs(this.scroller.x - snap.x), 1000),
						Math.min(Math.abs(this.scroller.y - snap.y), 1000)
					), 300);

				if(this.scroller.x !== snap.x || this.scroller.y !== snap.y) {
					this.scroller.directionX = 0;
					this.scroller.directionY = 0;
					this.scroller.currentPage = snap;
					this.scroller.scrollTo(snap.x, snap.y, time, this.scroller.options.bounceEasing);
				}
			}

			if(this.moved) {
				this.scroller._execEvent('scrollEnd');
			}
		},

		transitionTime: function(time) {
			time = time || 0;
			this.indicatorStyle[utils.style.transitionDuration] = time + 'ms';

			if(!time && utils.isBadAndroid) {
				this.indicatorStyle[utils.style.transitionDuration] = '0.001s';
			}
		},

		transitionTimingFunction: function(easing) {
			this.indicatorStyle[utils.style.transitionTimingFunction] = easing;
		},

		refresh: function() {
			this.transitionTime();

			if(this.options.listenX && !this.options.listenY) {
				this.indicatorStyle.display = this.scroller.hasHorizontalScroll ? 'block' : 'none';
			} else if(this.options.listenY && !this.options.listenX) {
				this.indicatorStyle.display = this.scroller.hasVerticalScroll ? 'block' : 'none';
			} else {
				this.indicatorStyle.display = this.scroller.hasHorizontalScroll || this.scroller.hasVerticalScroll ? 'block' : 'none';
			}

			if(this.scroller.hasHorizontalScroll && this.scroller.hasVerticalScroll) {
				utils.addClass(this.wrapper, 'iScrollBothScrollbars');
				utils.removeClass(this.wrapper, 'iScrollLoneScrollbar');

				if(this.options.defaultScrollbars && this.options.customStyle) {
					if(this.options.listenX) {
						this.wrapper.style.right = '8px';
					} else {
						this.wrapper.style.bottom = '8px';
					}
				}
			} else {
				utils.removeClass(this.wrapper, 'iScrollBothScrollbars');
				utils.addClass(this.wrapper, 'iScrollLoneScrollbar');

				if(this.options.defaultScrollbars && this.options.customStyle) {
					if(this.options.listenX) {
						this.wrapper.style.right = '2px';
					} else {
						this.wrapper.style.bottom = '2px';
					}
				}
			}

			// var r = this.wrapper.offsetHeight; // force refresh

			if(this.options.listenX) {
				this.wrapperWidth = this.wrapper.clientWidth;
				if(this.options.resize) {
					this.indicatorWidth = Math.max(Math.round(this.wrapperWidth * this.wrapperWidth / (this.scroller.scrollerWidth || this.wrapperWidth || 1)), 8);
					this.indicatorStyle.width = this.indicatorWidth + 'px';
				} else {
					this.indicatorWidth = this.indicator.clientWidth;
				}

				this.maxPosX = this.wrapperWidth - this.indicatorWidth;

				if(this.options.shrink === 'clip') {
					this.minBoundaryX = -this.indicatorWidth + 8;
					this.maxBoundaryX = this.wrapperWidth - 8;
				} else {
					this.minBoundaryX = 0;
					this.maxBoundaryX = this.maxPosX;
				}

				this.sizeRatioX = this.options.speedRatioX || (this.scroller.maxScrollX && (this.maxPosX / this.scroller.maxScrollX));
			}

			if(this.options.listenY) {
				this.wrapperHeight = this.wrapper.clientHeight;
				if(this.options.resize) {
					this.indicatorHeight = Math.max(Math.round(this.wrapperHeight * this.wrapperHeight / (this.scroller.scrollerHeight || this.wrapperHeight || 1)), 8);
					this.indicatorStyle.height = this.indicatorHeight + 'px';
				} else {
					this.indicatorHeight = this.indicator.clientHeight;
				}

				this.maxPosY = this.wrapperHeight - this.indicatorHeight;

				if(this.options.shrink === 'clip') {
					this.minBoundaryY = -this.indicatorHeight + 8;
					this.maxBoundaryY = this.wrapperHeight - 8;
				} else {
					this.minBoundaryY = 0;
					this.maxBoundaryY = this.maxPosY;
				}

				this.maxPosY = this.wrapperHeight - this.indicatorHeight;
				this.sizeRatioY = this.options.speedRatioY || (this.scroller.maxScrollY && (this.maxPosY / this.scroller.maxScrollY));
			}

			this.updatePosition();
		},

		updatePosition: function() {
			var x = this.options.listenX && Math.round(this.sizeRatioX * this.scroller.x) || 0,
				y = this.options.listenY && Math.round(this.sizeRatioY * this.scroller.y) || 0;

			if(!this.options.ignoreBoundaries) {
				if(x < this.minBoundaryX) {
					if(this.options.shrink === 'scale') {
						this.width = Math.max(this.indicatorWidth + x, 8);
						this.indicatorStyle.width = this.width + 'px';
					}
					x = this.minBoundaryX;
				} else if(x > this.maxBoundaryX) {
					if(this.options.shrink === 'scale') {
						this.width = Math.max(this.indicatorWidth - (x - this.maxPosX), 8);
						this.indicatorStyle.width = this.width + 'px';
						x = this.maxPosX + this.indicatorWidth - this.width;
					} else {
						x = this.maxBoundaryX;
					}
				} else if(this.options.shrink === 'scale' && this.width !== this.indicatorWidth) {
					this.width = this.indicatorWidth;
					this.indicatorStyle.width = this.width + 'px';
				}

				if(y < this.minBoundaryY) {
					if(this.options.shrink === 'scale') {
						this.height = Math.max(this.indicatorHeight + y * 3, 8);
						this.indicatorStyle.height = this.height + 'px';
					}
					y = this.minBoundaryY;
				} else if(y > this.maxBoundaryY) {
					if(this.options.shrink === 'scale') {
						this.height = Math.max(this.indicatorHeight - (y - this.maxPosY) * 3, 8);
						this.indicatorStyle.height = this.height + 'px';
						y = this.maxPosY + this.indicatorHeight - this.height;
					} else {
						y = this.maxBoundaryY;
					}
				} else if(this.options.shrink === 'scale' && this.height !== this.indicatorHeight) {
					this.height = this.indicatorHeight;
					this.indicatorStyle.height = this.height + 'px';
				}
			}

			this.x = x;
			this.y = y;

			if(this.scroller.options.useTransform) {
				this.indicatorStyle[utils.style.transform] = 'translate(' + x + 'px,' + y + 'px)' + this.scroller.translateZ;
			} else {
				this.indicatorStyle.left = x + 'px';
				this.indicatorStyle.top = y + 'px';
			}
		},

		_pos: function(x, y) {
			if(x < 0) {
				x = 0;
			} else if(x > this.maxPosX) {
				x = this.maxPosX;
			}

			if(y < 0) {
				y = 0;
			} else if(y > this.maxPosY) {
				y = this.maxPosY;
			}

			x = this.options.listenX ? Math.round(x / this.sizeRatioX) : this.scroller.x;
			y = this.options.listenY ? Math.round(y / this.sizeRatioY) : this.scroller.y;

			this.scroller.scrollTo(x, y);
		},

		fade: function(val, hold) {
			if(hold && !this.visible) {
				return;
			}

			clearTimeout(this.fadeTimeout);
			this.fadeTimeout = null;

			var time = val ? 250 : 500,
				delay = val ? 0 : 300;

			val = val ? '1' : '0';

			this.wrapperStyle[utils.style.transitionDuration] = time + 'ms';

			this.fadeTimeout = setTimeout((function(val) {
				this.wrapperStyle.opacity = val;
				this.visible = +val;
			}).bind(this, val), delay);
		}
	};

	IScroll.utils = utils;

	window.IScroll = IScroll;
}(window);

/* ===============================================================================
 ************   scroller   ************
 =============================================================================== */
+
function($) {
	"use strict";
	//重置zepto自带的滚动条
	var _zeptoMethodCache = {
		"scrollTop": $.fn.scrollTop,
		"scrollLeft": $.fn.scrollLeft
	};
	//重置scrollLeft和scrollRight
	(function() {
		$.extend($.fn, {
			scrollTop: function(top, dur) {
				if(!this.length) return;
				var scroller = this.data('scroller');
				if(scroller && scroller.scroller) { //js滚动
					return scroller.scrollTop(top, dur);
				} else {
					return _zeptoMethodCache.scrollTop.apply(this, arguments);
				}
			}
		});
		$.extend($.fn, {
			scrollLeft: function(left, dur) {
				if(!this.length) return;
				var scroller = this.data('scroller');
				if(scroller && scroller.scroller) { //js滚动
					return scroller.scrollLeft(left, dur);
				} else {
					return _zeptoMethodCache.scrollLeft.apply(this, arguments);
				}
			}
		});
	})();

	//自定义的滚动条
	var Scroller = function(pageContent, _options) {
		var $pageContent = this.$pageContent = $(pageContent);

		this.options = $.extend({}, this._defaults, _options);

		var type = this.options.type;
		//auto的type,系统版本的小于4.4.0的安卓设备和系统版本小于6.0.0的ios设备，启用js版的iscoll
		var useJSScroller = (type === 'js') || (type === 'auto' && ($.device.android && $.compareVersion('4.4.0', $.device.osVersion) > -1) || (type === 'auto' && ($.device.ios && $.compareVersion('6.0.0', $.device.osVersion) > -1)));

		if(useJSScroller) {

			var $pageContentInner = $pageContent.find('.content-inner');
			//如果滚动内容没有被包裹，自动添加wrap
			if(!$pageContentInner[0]) {
				// $pageContent.html('<div class="content-inner">' + $pageContent.html() + '</div>');
				var children = $pageContent.children();
				if(children.length < 1) {
					$pageContent.children().wrapAll('<div class="content-inner"></div>');
				} else {
					$pageContent.html('<div class="content-inner">' + $pageContent.html() + '</div>');
				}
			}

			if($pageContent.hasClass('pull-to-refresh-content')) {
				//因为iscroll 当页面高度不足 100% 时无法滑动，所以无法触发下拉动作，这里改动一下高度
				//区分是否有.bar容器，如有，则content的top:0，无则content的top:-2.2rem,这里取2.2rem的最大值，近60
				var minHeight = $(window).height() + ($pageContent.prev().hasClass(".bar") ? 1 : 61);
				$pageContent.find('.content-inner').css('min-height', minHeight + 'px');
			}

			var ptr = $(pageContent).hasClass('pull-to-refresh-content');
			//js滚动模式，用transform移动内容区位置，会导致fixed失效，表现类似absolute。因此禁用transform模式
			var useTransform = $pageContent.find('.fixed-tab').length === 0;
			var options = {
				probeType: 1,
				mouseWheel: true,
				//解决安卓js模式下，刷新滚动条后绑定的事件不响应，对chrome内核浏览器设置click:true
				click: $.device.androidChrome,
				useTransform: useTransform,
				//js模式下允许滚动条横向滚动，但是需要注意，滚动容易宽度必须大于屏幕宽度滚动才生效
				scrollX: true
			};
			if(ptr) {
				options.ptr = true;
				options.ptrOffset = 44;
			}
			//如果用js滚动条，用transform计算内容区位置，position：fixed将实效。若有.fixed-tab，强制使用native滚动条；备选方案，略粗暴
			// if($(pageContent).find('.fixed-tab').length>0){
			//     $pageContent.addClass('native-scroll');
			//     return;
			// }
			this.scroller = new IScroll(pageContent, options);
			//和native滚动统一起来
			this._bindEventToDomWhenJs();
			$.initPullToRefresh = $._pullToRefreshJSScroll.initPullToRefresh;
			$.pullToRefreshDone = $._pullToRefreshJSScroll.pullToRefreshDone;
			$.pullToRefreshTrigger = $._pullToRefreshJSScroll.pullToRefreshTrigger;
			$.destroyToRefresh = $._pullToRefreshJSScroll.destroyToRefresh;
			$pageContent.addClass('javascript-scroll');
			if(!useTransform) {
				$pageContent.find('.content-inner').css({
					width: '100%',
					position: 'absolute'
				});
			}

			//如果页面本身已经进行了原生滚动，那么把这个滚动换成JS的滚动
			var nativeScrollTop = this.$pageContent[0].scrollTop;
			if(nativeScrollTop) {
				this.$pageContent[0].scrollTop = 0;
				this.scrollTop(nativeScrollTop);
			}
		} else {
			$pageContent.addClass('native-scroll');
		}
	};
	Scroller.prototype = {
		_defaults: {
			type: 'native',
		},
		_bindEventToDomWhenJs: function() {
			//"scrollStart", //the scroll started.
			//"scroll", //the content is scrolling. Available only in scroll-probe.js edition. See onScroll event.
			//"scrollEnd", //content stopped scrolling.
			if(this.scroller) {
				var self = this;
				this.scroller.on('scrollStart', function() {
					self.$pageContent.trigger('scrollstart');
				});
				this.scroller.on('scroll', function() {
					self.$pageContent.trigger('scroll');
				});
				this.scroller.on('scrollEnd', function() {
					self.$pageContent.trigger('scrollend');
				});
			} else {
				//TODO: 实现native的scrollStart和scrollEnd
			}
		},
		scrollTop: function(top, dur) {
			if(this.scroller) {
				if(top !== undefined) {
					this.scroller.scrollTo(0, -1 * top, dur);
				} else {
					return this.scroller.getComputedPosition().y * -1;
				}
			} else {
				return this.$pageContent.scrollTop(top, dur);
			}
			return this;
		},
		scrollLeft: function(left, dur) {
			if(this.scroller) {
				if(left !== undefined) {
					this.scroller.scrollTo(-1 * left, 0);
				} else {
					return this.scroller.getComputedPosition().x * -1;
				}
			} else {
				return this.$pageContent.scrollTop(left, dur);
			}
			return this;
		},
		on: function(event, callback) {
			if(this.scroller) {
				this.scroller.on(event, function() {
					callback.call(this.wrapper);
				});
			} else {
				this.$pageContent.on(event, callback);
			}
			return this;
		},
		off: function(event, callback) {
			if(this.scroller) {
				this.scroller.off(event, callback);
			} else {
				this.$pageContent.off(event, callback);
			}
			return this;
		},
		refresh: function() {
			if(this.scroller) this.scroller.refresh();
			return this;
		},
		scrollHeight: function() {
			if(this.scroller) {
				return this.scroller.scrollerHeight;
			} else {
				return this.$pageContent[0].scrollHeight;
			}
		}

	};

	//Scroller PLUGIN DEFINITION
	// =======================

	function Plugin(option) {
		var args = Array.apply(null, arguments);
		args.shift();
		var internal_return;

		this.each(function() {

			var $this = $(this);

			var options = $.extend({}, $this.dataset(), typeof option === 'object' && option);

			var data = $this.data('scroller');
			//如果 scroller 没有被初始化，对scroller 进行初始化r
			if(!data) {
				//获取data-api的
				$this.data('scroller', (data = new Scroller(this, options)));

			}
			if(typeof option === 'string' && typeof data[option] === 'function') {
				internal_return = data[option].apply(data, args);
				if(internal_return !== undefined)
					return false;
			}

		});

		if(internal_return !== undefined)
			return internal_return;
		else
			return this;

	}

	var old = $.fn.scroller;

	$.fn.scroller = Plugin;
	$.fn.scroller.Constructor = Scroller;

	// Scroll NO CONFLICT
	// =================

	$.fn.scroller.noConflict = function() {
		$.fn.scroller = old;
		return this;
	};
	//添加data-api
	$(function() {
		$('[data-toggle="scroller"]').scroller();
	});

	//统一的接口,带有 .javascript-scroll 的content 进行刷新
	$.refreshScroller = function(content) {
		if(content) {
			$(content).scroller('refresh');
		} else {
			$('.javascript-scroll').each(function() {
				$(this).scroller('refresh');
			});
		}

	};
	//全局初始化方法，会对页面上的 [data-toggle="scroller"]，.content. 进行滚动条初始化
	$.initScroller = function(option) {
		this.options = $.extend({}, typeof option === 'object' && option);
		$('[data-toggle="scroller"],.content').scroller(option);
	};
	//获取scroller对象
	$.getScroller = function(content) {
		//以前默认只能有一个无限滚动，因此infinitescroll都是加在content上，现在允许里面有多个，因此要判断父元素是否有content
		content = content.hasClass('content') ? content : content.parents('.content');
		if(content) {
			return $(content).data('scroller');
		} else {
			return $('.content.javascript-scroll').data('scroller');
		}
	};
	//检测滚动类型,
	//‘js’: javascript 滚动条
	//‘native’: 原生滚动条
	$.detectScrollerType = function(content) {
		if(content) {
			if($(content).data('scroller') && $(content).data('scroller').scroller) {
				return 'js';
			} else {
				return 'native';
			}
		}
	};

}(Zepto);

/* ===============================================================================
 ************   Tabs   ************
 =============================================================================== */
+
function($) {
	"use strict";

	var showTab = function(tab, tabLink, force) {
		var newTab = $(tab);
		if(arguments.length === 2) {
			if(typeof tabLink === 'boolean') {
				force = tabLink;
			}
		}
		if(newTab.length === 0) return false;
		if(newTab.hasClass('active')) {
			if(force) newTab.trigger('show');
			return false;
		}
		var tabs = newTab.parent('.tabs');
		if(tabs.length === 0) return false;

		// Animated tabs
		/*var isAnimatedTabs = tabs.parent().hasClass('tabs-animated-wrap');
		 if (isAnimatedTabs) {
		 tabs.transform('translate3d(' + -newTab.index() * 100 + '%,0,0)');
		 }*/

		// Remove active class from old tabs
		var oldTab = tabs.children('.tab.active').removeClass('active');
		// Add active class to new tab
		newTab.addClass('active');
		// Trigger 'show' event on new tab
		newTab.trigger('show');

		// Update navbars in new tab
		/*if (!isAnimatedTabs && newTab.find('.navbar').length > 0) {
		 // Find tab's view
		 var viewContainer;
		 if (newTab.hasClass(app.params.viewClass)) viewContainer = newTab[0];
		 else viewContainer = newTab.parents('.' + app.params.viewClass)[0];
		 app.sizeNavbars(viewContainer);
		 }*/

		// Find related link for new tab
		if(tabLink) tabLink = $(tabLink);
		else {
			// Search by id
			if(typeof tab === 'string') tabLink = $('.tab-link[href="' + tab + '"]');
			else tabLink = $('.tab-link[href="#' + newTab.attr('id') + '"]');
			// Search by data-tab
			if(!tabLink || tabLink && tabLink.length === 0) {
				$('[data-tab]').each(function() {
					if(newTab.is($(this).attr('data-tab'))) tabLink = $(this);
				});
			}
		}
		if(tabLink.length === 0) return;

		// Find related link for old tab
		var oldTabLink;
		if(oldTab && oldTab.length > 0) {
			// Search by id
			var oldTabId = oldTab.attr('id');
			if(oldTabId) oldTabLink = $('.tab-link[href="#' + oldTabId + '"]');
			// Search by data-tab
			if(!oldTabLink || oldTabLink && oldTabLink.length === 0) {
				$('[data-tab]').each(function() {
					if(oldTab.is($(this).attr('data-tab'))) oldTabLink = $(this);
				});
			}
		}

		// Update links' classes
		if(tabLink && tabLink.length > 0) tabLink.addClass('active');
		if(oldTabLink && oldTabLink.length > 0) oldTabLink.removeClass('active');
		tabLink.trigger('active');

		//app.refreshScroller();

		return true;
	};

	var old = $.showTab;
	$.showTab = showTab;

	$.showTab.noConflict = function() {
		$.showTab = old;
		return this;
	};
	//a标签上的click事件，在iscroll下响应有问题
	$(document).on("click", ".tab-link", function(e) {
		e.preventDefault();
		var clicked = $(this);
		showTab(clicked.data("tab") || clicked.attr('href'), clicked);
	});

}(Zepto);

/* ===============================================================================
 ************   Tabs   ************
 =============================================================================== */
+
function($) {
	"use strict";
	$.initFixedTab = function() {
		var $fixedTab = $('.fixed-tab');
		if($fixedTab.length === 0) return;
		$('.fixed-tab').fixedTab(); //默认{offset: 0}
	};
	var FixedTab = function(pageContent, _options) {
		var $pageContent = this.$pageContent = $(pageContent);
		var shadow = $pageContent.clone();
		var fixedTop = $pageContent[0].getBoundingClientRect().top;

		shadow.css('visibility', 'hidden');
		this.options = $.extend({}, this._defaults, {
			fixedTop: fixedTop,
			shadow: shadow,
			offset: 0
		}, _options);

		this._bindEvents();
	};

	FixedTab.prototype = {
		_defaults: {
			offset: 0,
		},
		_bindEvents: function() {
			this.$pageContent.parents('.content').on('scroll', this._scrollHandler.bind(this));
			this.$pageContent.on('active', '.tab-link', this._tabLinkHandler.bind(this));
		},
		_tabLinkHandler: function(ev) {
			var isFixed = $(ev.target).parents('.buttons-fixed').length > 0;
			var fixedTop = this.options.fixedTop;
			var offset = this.options.offset;
			$.refreshScroller();
			if(!isFixed) return;
			this.$pageContent.parents('.content').scrollTop(fixedTop - offset);
		},
		// 滚动核心代码
		_scrollHandler: function(ev) {
			var $scroller = $(ev.target);
			var $pageContent = this.$pageContent;
			var shadow = this.options.shadow;
			var offset = this.options.offset;
			var fixedTop = this.options.fixedTop;
			var scrollTop = $scroller.scrollTop();
			var isFixed = scrollTop >= fixedTop - offset;
			if(isFixed) {
				shadow.insertAfter($pageContent);
				$pageContent.addClass('buttons-fixed').css('top', offset);
			} else {
				shadow.remove();
				$pageContent.removeClass('buttons-fixed').css('top', 0);
			}
		}
	};

	//FixedTab PLUGIN DEFINITION
	// =======================

	function Plugin(option) {
		var args = Array.apply(null, arguments);
		args.shift();
		this.each(function() {
			var $this = $(this);
			var options = $.extend({}, $this.dataset(), typeof option === 'object' && option);
			var data = $this.data('fixedtab');
			if(!data) {
				//获取data-api的
				$this.data('fixedtab', (data = new FixedTab(this, options)));
			}
		});

	}

	$.fn.fixedTab = Plugin;
	$.fn.fixedTab.Constructor = FixedTab;
	$(document).on('pageInit', function() {
		$.initFixedTab();
	});

}(Zepto);

+
function($) {
	"use strict";
	//这里实在js滚动时使用的下拉刷新代码。

	var refreshTime = 0;
	var initPullToRefreshJS = function(pageContainer) {
		var eventsTarget = $(pageContainer);
		if(!eventsTarget.hasClass('pull-to-refresh-content')) {
			eventsTarget = eventsTarget.find('.pull-to-refresh-content');
		}
		if(!eventsTarget || eventsTarget.length === 0) return;

		var page = eventsTarget.hasClass('content') ? eventsTarget : eventsTarget.parents('.content');
		var scroller = $.getScroller(page[0]);
		if(!scroller) return;

		var container = eventsTarget;

		function handleScroll() {
			if(container.hasClass('refreshing')) return;
			if(scroller.scrollTop() * -1 >= 44) {
				container.removeClass('pull-down').addClass('pull-up');
			} else {
				container.removeClass('pull-up').addClass('pull-down');
			}
		}

		function handleRefresh() {
			if(container.hasClass('refreshing')) return;
			container.removeClass('pull-down pull-up');
			container.addClass('refreshing transitioning');
			container.trigger('refresh');
			refreshTime = +new Date();
		}

		scroller.on('scroll', handleScroll);
		scroller.scroller.on('ptr', handleRefresh);

		// Detach Events on page remove
		function destroyPullToRefresh() {
			scroller.off('scroll', handleScroll);
			scroller.scroller.off('ptr', handleRefresh);
		}

		eventsTarget[0].destroyPullToRefresh = destroyPullToRefresh;

	};

	var pullToRefreshDoneJS = function(container) {
		container = $(container);
		if(container.length === 0) container = $('.pull-to-refresh-content.refreshing');
		if(container.length === 0) return;
		var interval = (+new Date()) - refreshTime;
		var timeOut = interval > 1000 ? 0 : 1000 - interval; //long than bounce time
		var scroller = $.getScroller(container);
		setTimeout(function() {
			scroller.refresh();
			container.removeClass('refreshing');
			container.transitionEnd(function() {
				container.removeClass("transitioning");
			});
		}, timeOut);
	};
	var pullToRefreshTriggerJS = function(container) {
		container = $(container);
		if(container.length === 0) container = $('.pull-to-refresh-content');
		if(container.hasClass('refreshing')) return;
		container.addClass('refreshing');
		var scroller = $.getScroller(container);
		scroller.scrollTop(44 + 1, 200);
		container.trigger('refresh');
	};

	var destroyPullToRefreshJS = function(pageContainer) {
		pageContainer = $(pageContainer);
		var pullToRefreshContent = pageContainer.hasClass('pull-to-refresh-content') ? pageContainer : pageContainer.find('.pull-to-refresh-content');
		if(pullToRefreshContent.length === 0) return;
		if(pullToRefreshContent[0].destroyPullToRefresh) pullToRefreshContent[0].destroyPullToRefresh();
	};

	$._pullToRefreshJSScroll = {
		"initPullToRefresh": initPullToRefreshJS,
		"pullToRefreshDone": pullToRefreshDoneJS,
		"pullToRefreshTrigger": pullToRefreshTriggerJS,
		"destroyPullToRefresh": destroyPullToRefreshJS,
	};
}(Zepto);

+
function($) {
	'use strict';
	$.initPullToRefresh = function(pageContainer) {
		var eventsTarget = $(pageContainer);
		if(!eventsTarget.hasClass('pull-to-refresh-content')) {
			eventsTarget = eventsTarget.find('.pull-to-refresh-content');
		}
		if(!eventsTarget || eventsTarget.length === 0) return;

		var isTouched, isMoved, touchesStart = {},
			isScrolling, touchesDiff, touchStartTime, container, refresh = false,
			useTranslate = false,
			startTranslate = 0,
			translate, scrollTop, wasScrolled, triggerDistance, dynamicTriggerDistance;

		container = eventsTarget;

		// Define trigger distance
		if(container.attr('data-ptr-distance')) {
			dynamicTriggerDistance = true;
		} else {
			triggerDistance = 44;
		}

		function handleTouchStart(e) {
			if(isTouched) {
				if($.device.android) {
					if('targetTouches' in e && e.targetTouches.length > 1) return;
				} else return;
			}
			isMoved = false;
			isTouched = true;
			isScrolling = undefined;
			wasScrolled = undefined;
			touchesStart.x = e.type === 'touchstart' ? e.targetTouches[0].pageX : e.pageX;
			touchesStart.y = e.type === 'touchstart' ? e.targetTouches[0].pageY : e.pageY;
			touchStartTime = (new Date()).getTime();
			container = $(this);
		}

		function handleTouchMove(e) {
			if(!isTouched) return;
			var pageX = e.type === 'touchmove' ? e.targetTouches[0].pageX : e.pageX;
			var pageY = e.type === 'touchmove' ? e.targetTouches[0].pageY : e.pageY;
			if(typeof isScrolling === 'undefined') {
				isScrolling = !!(isScrolling || Math.abs(pageY - touchesStart.y) > Math.abs(pageX - touchesStart.x));
			}
			if(!isScrolling) {
				isTouched = false;
				return;
			}

			scrollTop = container[0].scrollTop;
			if(typeof wasScrolled === 'undefined' && scrollTop !== 0) wasScrolled = true;

			if(!isMoved) {
				container.removeClass('transitioning');
				if(scrollTop > container[0].offsetHeight) {
					isTouched = false;
					return;
				}
				if(dynamicTriggerDistance) {
					triggerDistance = container.attr('data-ptr-distance');
					if(triggerDistance.indexOf('%') >= 0) triggerDistance = container[0].offsetHeight * parseInt(triggerDistance, 10) / 100;
				}
				startTranslate = container.hasClass('refreshing') ? triggerDistance : 0;
				if(container[0].scrollHeight === container[0].offsetHeight || !$.device.ios) {
					useTranslate = true;
				} else {
					useTranslate = false;
				}
				useTranslate = true;
			}
			isMoved = true;
			touchesDiff = pageY - touchesStart.y;

			if(touchesDiff > 0 && scrollTop <= 0 || scrollTop < 0) {
				// iOS 8 fix
				if($.device.ios && parseInt($.device.osVersion.split('.')[0], 10) > 7 && scrollTop === 0 && !wasScrolled) useTranslate = true;

				if(useTranslate) {
					e.preventDefault();
					translate = (Math.pow(touchesDiff, 0.85) + startTranslate);
					container.transform('translate3d(0,' + translate + 'px,0)');
				} else {}
				if((useTranslate && Math.pow(touchesDiff, 0.85) > triggerDistance) || (!useTranslate && touchesDiff >= triggerDistance * 2)) {
					refresh = true;
					container.addClass('pull-up').removeClass('pull-down');
				} else {
					refresh = false;
					container.removeClass('pull-up').addClass('pull-down');
				}
			} else {

				container.removeClass('pull-up pull-down');
				refresh = false;
				return;
			}
		}

		function handleTouchEnd() {
			if(!isTouched || !isMoved) {
				isTouched = false;
				isMoved = false;
				return;
			}
			if(translate) {
				container.addClass('transitioning');
				translate = 0;
			}
			container.transform('');
			if(refresh) {
				//防止二次触发
				if(container.hasClass('refreshing')) return;
				container.addClass('refreshing');
				container.trigger('refresh');
			} else {
				container.removeClass('pull-down');
			}
			isTouched = false;
			isMoved = false;
		}

		// Attach Events
		eventsTarget.on($.touchEvents.start, handleTouchStart);
		eventsTarget.on($.touchEvents.move, handleTouchMove);
		eventsTarget.on($.touchEvents.end, handleTouchEnd);

		function destroyPullToRefresh() {
			eventsTarget.off($.touchEvents.start, handleTouchStart);
			eventsTarget.off($.touchEvents.move, handleTouchMove);
			eventsTarget.off($.touchEvents.end, handleTouchEnd);
		}

		eventsTarget[0].destroyPullToRefresh = destroyPullToRefresh;

	};
	$.pullToRefreshDone = function(container) {
		$(window).scrollTop(0); //解决微信下拉刷新顶部消失的问题
		container = $(container);
		if(container.length === 0) container = $('.pull-to-refresh-content.refreshing');
		container.removeClass('refreshing').addClass('transitioning');
		container.transitionEnd(function() {
			container.removeClass('transitioning pull-up pull-down');
		});
	};
	$.pullToRefreshTrigger = function(container) {
		container = $(container);
		if(container.length === 0) container = $('.pull-to-refresh-content');
		if(container.hasClass('refreshing')) return;
		container.addClass('transitioning refreshing');
		container.trigger('refresh');
	};
	$.destroyPullToRefresh = function(pageContainer) {
		pageContainer = $(pageContainer);
		var pullToRefreshContent = pageContainer.hasClass('pull-to-refresh-content') ? pageContainer : pageContainer.find('.pull-to-refresh-content');
		if(pullToRefreshContent.length === 0) return;
		if(pullToRefreshContent[0].destroyPullToRefresh) pullToRefreshContent[0].destroyPullToRefresh();
	};
}(Zepto);

+
function($) {
	'use strict';

	function handleInfiniteScroll() {
		var inf = $(this);
		var scroller = $.getScroller(inf);
		var scrollTop = scroller.scrollTop();
		var scrollHeight = scroller.scrollHeight();
		var height = inf[0].offsetHeight;
		var distance = inf[0].getAttribute('data-distance');
		var virtualListContainer = inf.find('.virtual-list');
		var virtualList;
		var onTop = inf.hasClass('infinite-scroll-top');
		if(!distance) distance = 50;
		if(typeof distance === 'string' && distance.indexOf('%') >= 0) {
			distance = parseInt(distance, 10) / 100 * height;
		}
		if(distance > height) distance = height;
		if(onTop) {
			if(scrollTop < distance) {
				inf.trigger('infinite');
			}
		} else {
			if(scrollTop + height >= scrollHeight - distance) {
				if(virtualListContainer.length > 0) {
					virtualList = virtualListContainer[0].f7VirtualList;
					if(virtualList && !virtualList.reachEnd) return;
				}
				inf.trigger('infinite');
			}
		}

	}

	$.attachInfiniteScroll = function(infiniteContent) {
		for (var i = 0; i < infiniteContent.length; i++)
		{
		$.getScroller($(infiniteContent[i])).on('scroll', handleInfiniteScroll);
		}
	};
	$.detachInfiniteScroll = function(infiniteContent) {
		$.getScroller(infiniteContent).off('scroll', handleInfiniteScroll);
	};

	$.initInfiniteScroll = function(pageContainer) {
		pageContainer = $(pageContainer);
		var infiniteContent = pageContainer.hasClass('infinite-scroll') ? pageContainer : pageContainer.find('.infinite-scroll');
		if(infiniteContent.length === 0) return;
		$.attachInfiniteScroll(infiniteContent);
		//如果是顶部无限刷新，要将滚动条初始化于最下端
		pageContainer.forEach(function(v) {
			if($(v).hasClass('infinite-scroll-top')) {
				var height = v.scrollHeight - v.clientHeight;
				$(v).scrollTop(height);
			}
		});

		function detachEvents() {
			$.detachInfiniteScroll(infiniteContent);
			pageContainer.off('pageBeforeRemove', detachEvents);
		}

		pageContainer.on('pageBeforeRemove', detachEvents);
	};
}(Zepto);

+
function($) {
	"use strict";
	$(function() {
		$(document).on("focus", ".searchbar input", function(e) {
			var $input = $(e.target);
			$input.parents(".searchbar").addClass("searchbar-active");
		});
		$(document).on("click", ".searchbar-cancel", function(e) {
			var $btn = $(e.target);
			$btn.parents(".searchbar").removeClass("searchbar-active");
		});
		$(document).on("blur", ".searchbar input", function(e) {
			var $input = $(e.target);
			$input.parents(".searchbar").removeClass("searchbar-active");
		});
	});
}(Zepto);

/*======================================================
 ************   Panels   ************
 ======================================================*/
+
function($) {
	"use strict";
	$.allowPanelOpen = true;
	$.openPanel = function(panel) {
		if(!$.allowPanelOpen) return false;
		if(panel === 'left' || panel === 'right') panel = ".panel-" + panel; //可以传入一个方向
		panel = panel ? $(panel) : $(".panel").eq(0);
		var direction = panel.hasClass("panel-right") ? "right" : "left";
		if(panel.length === 0 || panel.hasClass('active')) return false;
		$.closePanel(); // Close if some panel is opened
		$.allowPanelOpen = false;
		var effect = panel.hasClass('panel-reveal') ? 'reveal' : 'cover';
		panel.css({ display: 'block' }).addClass('active');
		panel.trigger('open');

		// Trigger reLayout
		var clientLeft = panel[0].clientLeft;

		// Transition End;
		var transitionEndTarget = effect === 'reveal' ? $($.getCurrentPage()) : panel;
		var openedTriggered = false;

		function panelTransitionEnd() {
			transitionEndTarget.transitionEnd(function(e) {
				if(e.target === transitionEndTarget[0]) {
					if(panel.hasClass('active')) {
						panel.trigger('opened');
					} else {
						panel.trigger('closed');
					}
					$.allowPanelOpen = true;
				} else panelTransitionEnd();
			});
		}

		panelTransitionEnd();

		$(document.body).addClass('with-panel-' + direction + '-' + effect);
		return true;
	};
	$.closePanel = function() {
		var activePanel = $('.panel.active');
		if(activePanel.length === 0) return false;
		var effect = activePanel.hasClass('panel-reveal') ? 'reveal' : 'cover';
		var panelPosition = activePanel.hasClass('panel-left') ? 'left' : 'right';
		activePanel.removeClass('active');
		var transitionEndTarget = effect === 'reveal' ? $('.page') : activePanel;
		activePanel.trigger('close');
		$.allowPanelOpen = false;

		transitionEndTarget.transitionEnd(function() {
			if(activePanel.hasClass('active')) return;
			activePanel.css({ display: '' });
			activePanel.trigger('closed');
			$('body').removeClass('panel-closing');
			$.allowPanelOpen = true;
		});

		$('body').addClass('panel-closing').removeClass('with-panel-' + panelPosition + '-' + effect);
	};

	$(document).on("click", ".open-panel", function(e) {
		var panel = $(e.target).data('panel');
		$.openPanel(panel);
	});
	$(document).on("click", ".close-panel, .panel-overlay", function(e) {
		$.closePanel();
	});
	/*======================================================
	 ************   Swipe panels   ************
	 ======================================================*/
	$.initSwipePanels = function() {
		var panel, side;
		var swipePanel = $.smConfig.swipePanel;
		var swipePanelOnlyClose = $.smConfig.swipePanelOnlyClose;
		var swipePanelCloseOpposite = true;
		var swipePanelActiveArea = false;
		var swipePanelThreshold = 2;
		var swipePanelNoFollow = false;

		if(!(swipePanel || swipePanelOnlyClose)) return;

		var panelOverlay = $('.panel-overlay');
		var isTouched, isMoved, isScrolling, touchesStart = {},
			touchStartTime, touchesDiff, translate, opened, panelWidth, effect, direction;
		var views = $('.page');

		function handleTouchStart(e) {
			if(!$.allowPanelOpen || (!swipePanel && !swipePanelOnlyClose) || isTouched) return;
			if($('.modal-in, .photo-browser-in').length > 0) return;
			if(!(swipePanelCloseOpposite || swipePanelOnlyClose)) {
				if($('.panel.active').length > 0 && !panel.hasClass('active')) return;
			}
			touchesStart.x = e.type === 'touchstart' ? e.targetTouches[0].pageX : e.pageX;
			touchesStart.y = e.type === 'touchstart' ? e.targetTouches[0].pageY : e.pageY;
			if(swipePanelCloseOpposite || swipePanelOnlyClose) {
				if($('.panel.active').length > 0) {
					side = $('.panel.active').hasClass('panel-left') ? 'left' : 'right';
				} else {
					if(swipePanelOnlyClose) return;
					side = swipePanel;
				}
				if(!side) return;
			}
			panel = $('.panel.panel-' + side);
			if(!panel[0]) return;
			opened = panel.hasClass('active');
			if(swipePanelActiveArea && !opened) {
				if(side === 'left') {
					if(touchesStart.x > swipePanelActiveArea) return;
				}
				if(side === 'right') {
					if(touchesStart.x < window.innerWidth - swipePanelActiveArea) return;
				}
			}
			isMoved = false;
			isTouched = true;
			isScrolling = undefined;

			touchStartTime = (new Date()).getTime();
			direction = undefined;
		}

		function handleTouchMove(e) {
			if(!isTouched) return;
			if(!panel[0]) return;
			if(e.f7PreventPanelSwipe) return;
			var pageX = e.type === 'touchmove' ? e.targetTouches[0].pageX : e.pageX;
			var pageY = e.type === 'touchmove' ? e.targetTouches[0].pageY : e.pageY;
			if(typeof isScrolling === 'undefined') {
				isScrolling = !!(isScrolling || Math.abs(pageY - touchesStart.y) > Math.abs(pageX - touchesStart.x));
			}
			if(isScrolling) {
				isTouched = false;
				return;
			}
			if(!direction) {
				if(pageX > touchesStart.x) {
					direction = 'to-right';
				} else {
					direction = 'to-left';
				}

				if(
					side === 'left' &&
					(
						direction === 'to-left' && !panel.hasClass('active')
					) ||
					side === 'right' &&
					(
						direction === 'to-right' && !panel.hasClass('active')
					)
				) {
					isTouched = false;
					return;
				}
			}

			if(swipePanelNoFollow) {
				var timeDiff = (new Date()).getTime() - touchStartTime;
				if(timeDiff < 300) {
					if(direction === 'to-left') {
						if(side === 'right') $.openPanel(side);
						if(side === 'left' && panel.hasClass('active')) $.closePanel();
					}
					if(direction === 'to-right') {
						if(side === 'left') $.openPanel(side);
						if(side === 'right' && panel.hasClass('active')) $.closePanel();
					}
				}
				isTouched = false;
				isMoved = false;
				return;
			}

			if(!isMoved) {
				effect = panel.hasClass('panel-cover') ? 'cover' : 'reveal';
				if(!opened) {
					panel.show();
					panelOverlay.show();
				}
				panelWidth = panel[0].offsetWidth;
				panel.transition(0);
				/*
				 if (panel.find('.' + app.params.viewClass).length > 0) {
				 if (app.sizeNavbars) app.sizeNavbars(panel.find('.' + app.params.viewClass)[0]);
				 }
				 */
			}

			isMoved = true;

			e.preventDefault();
			var threshold = opened ? 0 : -swipePanelThreshold;
			if(side === 'right') threshold = -threshold;

			touchesDiff = pageX - touchesStart.x + threshold;

			if(side === 'right') {
				translate = touchesDiff - (opened ? panelWidth : 0);
				if(translate > 0) translate = 0;
				if(translate < -panelWidth) {
					translate = -panelWidth;
				}
			} else {
				translate = touchesDiff + (opened ? panelWidth : 0);
				if(translate < 0) translate = 0;
				if(translate > panelWidth) {
					translate = panelWidth;
				}
			}
			if(effect === 'reveal') {
				views.transform('translate3d(' + translate + 'px,0,0)').transition(0);
				panelOverlay.transform('translate3d(' + translate + 'px,0,0)');
				//app.pluginHook('swipePanelSetTransform', views[0], panel[0], Math.abs(translate / panelWidth));
			} else {
				panel.transform('translate3d(' + translate + 'px,0,0)').transition(0);
				//app.pluginHook('swipePanelSetTransform', views[0], panel[0], Math.abs(translate / panelWidth));
			}
		}

		function handleTouchEnd(e) {
			if(!isTouched || !isMoved) {
				isTouched = false;
				isMoved = false;
				return;
			}
			isTouched = false;
			isMoved = false;
			var timeDiff = (new Date()).getTime() - touchStartTime;
			var action;
			var edge = (translate === 0 || Math.abs(translate) === panelWidth);

			if(!opened) {
				if(translate === 0) {
					action = 'reset';
				} else if(
					timeDiff < 300 && Math.abs(translate) > 0 ||
					timeDiff >= 300 && (Math.abs(translate) >= panelWidth / 2)
				) {
					action = 'swap';
				} else {
					action = 'reset';
				}
			} else {
				if(translate === -panelWidth) {
					action = 'reset';
				} else if(
					timeDiff < 300 && Math.abs(translate) >= 0 ||
					timeDiff >= 300 && (Math.abs(translate) <= panelWidth / 2)
				) {
					if(side === 'left' && translate === panelWidth) action = 'reset';
					else action = 'swap';
				} else {
					action = 'reset';
				}
			}
			if(action === 'swap') {
				$.allowPanelOpen = true;
				if(opened) {
					$.closePanel();
					if(edge) {
						panel.css({ display: '' });
						$('body').removeClass('panel-closing');
					}
				} else {
					$.openPanel(side);
				}
				if(edge) $.allowPanelOpen = true;
			}
			if(action === 'reset') {
				if(opened) {
					$.allowPanelOpen = true;
					$.openPanel(side);
				} else {
					$.closePanel();
					if(edge) {
						$.allowPanelOpen = true;
						panel.css({ display: '' });
					} else {
						var target = effect === 'reveal' ? views : panel;
						$('body').addClass('panel-closing');
						target.transitionEnd(function() {
							$.allowPanelOpen = true;
							panel.css({ display: '' });
							$('body').removeClass('panel-closing');
						});
					}
				}
			}
			if(effect === 'reveal') {
				views.transition('');
				views.transform('');
			}
			panel.transition('').transform('');
			panelOverlay.css({ display: '' }).transform('');
		}

		$(document).on($.touchEvents.start, handleTouchStart);
		$(document).on($.touchEvents.move, handleTouchMove);
		$(document).on($.touchEvents.end, handleTouchEnd);
	};

	$.initSwipePanels();
}(Zepto);

/**
 * 路由
 *
 * 路由功能将接管页面的链接点击行为，最后达到动画切换的效果，具体如下：
 *  1. 链接对应的是另一个页面，那么则尝试 ajax 加载，然后把新页面里的符合约定的结构提取出来，然后做动画切换；如果没法 ajax 或结构不符合，那么则回退为普通的页面跳转
 *  2. 链接是当前页面的锚点，并且该锚点对应的元素存在且符合路由约定，那么则把该元素做动画切入
 *  3. 浏览器前进后退（history.forward/history.back）时，也使用动画效果
 *  4. 如果链接有 back 这个 class，那么则忽略一切，直接调用 history.back() 来后退
 *
 * 路由功能默认开启，如果需要关闭路由功能，那么在 zepto 之后，msui 脚本之前设置 $.config.router = false 即可（intro.js 中会 extend 到 $.smConfig 中）。
 *
 * 可以设置 $.config.routerFilter 函数来设置当前点击链接是否使用路由功能，实参是 a 链接的 zepto 对象；返回 false 表示不使用 router 功能。
 *
 * ajax 载入新的文档时，并不会执行里面的 js。到目前为止，在开启路由功能时，建议的做法是：
 *  把所有页面的 js 都放到同一个脚本里，js 里面的事件绑定使用委托而不是直接的绑定在元素上（因为动态加载的页面元素还不存在），然后所有页面都引用相同的 js 脚本。非事件类可以通过监控 pageInit 事件，根据里面的 pageId 来做对应区别处理。
 *
 * 如果有需要
 *
 * 对外暴露的方法
 *  - load （原 loadPage 效果一致,但后者已标记为待移除）
 *  - forward
 *  - back
 *
 * 事件
 * pageLoad* 系列在发生 ajax 加载时才会触发；当是块切换或已缓存的情况下，不会发送这些事件
 *  - pageLoadCancel: 如果前一个还没加载完,那么取消并发送该事件
 *  - pageLoadStart: 开始加载
 *  - pageLodComplete: ajax complete 完成
 *  - pageLoadError: ajax 发生 error
 *  - pageAnimationStart: 执行动画切换前，实参是 event，sectionId 和 $section
 *  - pageAnimationEnd: 执行动画完毕，实参是 event，sectionId 和 $section
 *  - beforePageRemove: 新 document 载入且动画切换完毕，旧的 document remove 之前在 window 上触发，实参是 event 和 $pageContainer
 *  - pageRemoved: 新的 document 载入且动画切换完毕，旧的 document remove 之后在 window 上触发
 *  - beforePageSwitch: page 切换前，在 pageAnimationStart 前，beforePageSwitch 之后会做一些额外的处理才触发 pageAnimationStart
 *  - pageInitInternal: （经 init.js 处理后，对外是 pageInit）紧跟着动画完成的事件，实参是 event，sectionId 和 $section
 *
 * 术语
 *  - 文档（document），不带 hash 的 url 关联着的应答 html 结构
 *  - 块（section），一个文档内有指定块标识的元素
 *
 * 路由实现约定
 *  - 每个文档的需要展示的内容必需位于指定的标识（routerConfig.sectionGroupClass）的元素里面，默认是: div.page-group （注意,如果改变这个需要同时改变 less 中的命名）
 *  - 每个块必需带有指定的块标识（routerConfig.pageClass），默认是 .page
 *
 *  即，使用路由功能的每一个文档应当是下面这样的结构（省略 <body> 等）:
 *      <div class="page-group">
 *          <div class="page">xxx</div>
 *          <div class="page">yyy</div>
 *      </div>
 *
 * 另，每一个块都应当有一个唯一的 ID，这样才能通过 #the-id 的形式来切换定位。
 * 当一个块没有 id 时，如果是第一个的默认的需要展示的块，那么会给其添加一个随机的 id；否则，没有 id 的块将不会被切换展示。
 *
 * 通过 history.state/history.pushState 以及用 sessionStorage 来记录当前 state 以及最大的 state id 来辅助前进后退的切换效果，所以在不支持 sessionStorage 的情况下，将不开启路由功能。
 *
 * 为了解决 ajax 载入页面导致重复 ID 以及重复 popup 等功能，上面约定了使用路由功能的所有可展示内容都必需位于指定元素内。从而可以在进行文档间切换时可以进行两个文档的整体移动，切换完毕后再把前一个文档的内容从页面之间移除。
 *
 * 默认地过滤了部分协议的链接，包括 tel:, javascript:, mailto:，这些链接将不会使用路由功能。如果有更多的自定义控制需求，可以在 $.config.routerFilter 实现
 *
 * 注: 以 _ 开头的函数标明用于此处内部使用，可根据需要随时重构变更，不对外确保兼容性。
 *
 */
+
function($) {
	'use strict';

	if(!window.CustomEvent) {
		window.CustomEvent = function(type, config) {
			config = config || { bubbles: false, cancelable: false, detail: undefined };
			var e = document.createEvent('CustomEvent');
			e.initCustomEvent(type, config.bubbles, config.cancelable, config.detail);
			return e;
		};

		window.CustomEvent.prototype = window.Event.prototype;
	}

	var EVENTS = {
		pageLoadStart: 'pageLoadStart', // ajax 开始加载新页面前
		pageLoadCancel: 'pageLoadCancel', // 取消前一个 ajax 加载动作后
		pageLoadError: 'pageLoadError', // ajax 加载页面失败后
		pageLoadComplete: 'pageLoadComplete', // ajax 加载页面完成后（不论成功与否）
		pageAnimationStart: 'pageAnimationStart', // 动画切换 page 前
		pageAnimationEnd: 'pageAnimationEnd', // 动画切换 page 结束后
		beforePageRemove: 'beforePageRemove', // 移除旧 document 前（适用于非内联 page 切换）
		pageRemoved: 'pageRemoved', // 移除旧 document 后（适用于非内联 page 切换）
		beforePageSwitch: 'beforePageSwitch', // page 切换前，在 pageAnimationStart 前，beforePageSwitch 之后会做一些额外的处理才触发 pageAnimationStart
		pageInit: 'pageInitInternal' // 目前是定义为一个 page 加载完毕后（实际和 pageAnimationEnd 等同）
	};

	var Util = {
		basePath: "",
		/**
		 * 获取 url 的 fragment（即 hash 中去掉 # 的剩余部分）
		 *
		 * 如果没有则返回空字符串
		 * 如: http://example.com/path/?query=d#123 => 123
		 *
		 * @param {String} url url
		 * @returns {String}
		 */
		getUrlFragment: function(url) {
			var hashIndex = url.indexOf('#');
			return hashIndex === -1 ? '' : url.slice(hashIndex + 1);
		},
		/**
		 * 获取一个链接相对于当前页面的绝对地址形式
		 *
		 * 假设当前页面是 http://a.com/b/c
		 * 那么有以下情况:
		 * d => http://a.com/b/d
		 * /e => http://a.com/e
		 * #1 => http://a.com/b/c#1
		 * http://b.com/f => http://b.com/f
		 *
		 * @param {String} url url
		 * @returns {String}
		 */
		getAbsoluteUrl: function(url) {
			var link = document.createElement('a');
			link.setAttribute('href', url);
			var absoluteUrl = link.href;
			link = null;
			return absoluteUrl;
		},
		/**
		 * 获取一个 url 的基本部分，即不包括 hash
		 *
		 * @param {String} url url
		 * @returns {String}
		 */
		getBaseUrl: function(url) {
			var hashIndex = url.indexOf('#');
			return hashIndex === -1 ? url.slice(0) : url.slice(0, hashIndex);
		},
		/**
		 * 把一个字符串的 url 转为一个可获取其 base 和 fragment 等的对象
		 *
		 * @param {String} url url
		 * @returns {UrlObject}
		 */
		toUrlObject: function(url) {
			var fullUrl = this.getAbsoluteUrl(url),
				baseUrl = this.getBaseUrl(fullUrl),
				fragment = this.getUrlFragment(url);

			return {
				base: baseUrl,
				full: fullUrl,
				original: url,
				fragment: fragment
			};
		},
		/**
		 * 判断浏览器是否支持 sessionStorage，支持返回 true，否则返回 false
		 * @returns {Boolean}
		 */
		supportStorage: function() {
			var mod = 'sm.router.storage.ability';
			try {
				sessionStorage.setItem(mod, mod);
				sessionStorage.removeItem(mod);
				return true;
			} catch(e) {
				return false;
			}
		}
	};

	var routerConfig = {
		sectionGroupClass: 'page-group',
		// 表示是当前 page 的 class
		curPageClass: 'page-current',
		// 用来辅助切换时表示 page 是 visible 的,
		// 之所以不用 curPageClass，是因为 page-current 已被赋予了「当前 page」这一含义而不仅仅是 display: block
		// 并且，别的地方已经使用了，所以不方便做变更，故新增一个
		visiblePageClass: 'page-visible',
		// 表示是 page 的 class，注意，仅是标志 class，而不是所有的 class
		pageClass: 'page'
	};

	var DIRECTION = {
		leftToRight: 'from-left-to-right',
		rightToLeft: 'from-right-to-left'
	};

	var theHistory = window.history;

	var Router = function() {
		this.sessionNames = {
			currentState: 'sm.router.currentState',
			maxStateId: 'sm.router.maxStateId'
		};

		this._init();
		this.xhr = null;
		window.addEventListener('popstate', this._onPopState.bind(this));
	};

	/**
	 * 初始化
	 *
	 * - 把当前文档内容缓存起来
	 * - 查找默认展示的块内容，查找顺序如下
	 *      1. id 是 url 中的 fragment 的元素
	 *      2. 有当前块 class 标识的第一个元素
	 *      3. 第一个块
	 * - 初始页面 state 处理
	 *
	 * @private
	 */
	Router.prototype._init = function() {

		this.$view = $('body');

		// 用来保存 document 的 map
		this.cache = {};
		var $doc = $(document);
		var currentUrl = location.href;
		this._saveDocumentIntoCache($doc, currentUrl);

		var curPageId;

		var currentUrlObj = Util.toUrlObject(currentUrl);
		var $allSection = $doc.find('.' + routerConfig.pageClass);
		var $visibleSection = $doc.find('.' + routerConfig.curPageClass);
		var $curVisibleSection = $visibleSection.eq(0);
		var $hashSection;

		if(currentUrlObj.fragment) {
			$hashSection = $doc.find('#' + currentUrlObj.fragment);
		}
		if($hashSection && $hashSection.length) {
			$visibleSection = $hashSection.eq(0);
		} else if(!$visibleSection.length) {
			$visibleSection = $allSection.eq(0);
		}
		if(!$visibleSection.attr('id')) {
			$visibleSection.attr('id', this._generateRandomId());
		}

		if($curVisibleSection.length &&
			($curVisibleSection.attr('id') !== $visibleSection.attr('id'))) {
			// 在 router 到 inner page 的情况下，刷新（或者直接访问该链接）
			// 直接切换 class 会有「闪」的现象,或许可以采用 animateSection 来减缓一下
			$curVisibleSection.removeClass(routerConfig.curPageClass);
			$visibleSection.addClass(routerConfig.curPageClass);
		} else {
			$visibleSection.addClass(routerConfig.curPageClass);
		}
		curPageId = $visibleSection.attr('id');

		// 新进入一个使用 history.state 相关技术的页面时，如果第一个 state 不 push/replace,
		// 那么在后退回该页面时，将不触发 popState 事件
		if(theHistory.state === null) {
			var curState = {
				id: this._getNextStateId(),
				url: Util.toUrlObject(currentUrl),
				pageId: curPageId
			};

			theHistory.replaceState(curState, '', currentUrl);
			this._saveAsCurrentState(curState);
			this._incMaxStateId();
		}

		this.initBase(currentUrl);
	};

	/**
	 * 在页面中初始化base元素    ---edit 2017-04-25
	 */
	Router.prototype.initBase = function(baseUrl) {
		var head = $('head');
		head.prepend('<base href="' + baseUrl + '"/>');
		Util.basePath = baseUrl;
	};

	/**
	 * 获取通过路由地址栏方式传值的参数   ---edit 2017-04-25
	 */
	Router.prototype.query = function(key) {
		//构造一个含有目标参数的正则表达式对象
		var reg = new RegExp("(^|&)" + key + "=([^&]*)(&|$)");
		var r = null;
		if(window.location.search.indexOf('?') >= 0) {
			r = window.location.search.substr(1).match(reg); //匹配目标参数
		} else {
			r = Util.urlParams.match(reg); //匹配目标参数
		}
		//返回参数值
		if(r != null) return decodeURI(r[2]);
		return null;
	}

	/**
	 * 切换到 url 指定的块或文档
	 *
	 * 如果 url 指向的是当前页面，那么认为是切换块；
	 * 否则是切换文档
	 *
	 * @param {String} url url
	 * @param {Boolean=} ignoreCache 是否强制请求不使用缓存，对 document 生效，默认是 false
	 */
	Router.prototype.load = function(url, ignoreCache, params) {
		if(ignoreCache === undefined) {
			ignoreCache = false;
		}
		//记录历史访问
		if(sessionStorage.isBack==='y'){
			sessionStorage.isBack='n';
		}else{
			if(!sessionStorage.lastUrl){
				var temp=[window.location.href];
				temp=JSON.stringify(temp);
				sessionStorage.setItem("lastUrl",temp);
				
			}else{
				var temp=sessionStorage.getItem("lastUrl");
				temp=JSON.parse(temp);
				temp.push(window.location.href);
				temp=JSON.stringify(temp);
				sessionStorage.setItem("lastUrl",temp);
			}
		}
		
		
		/* 封装路由传值方式 */
		if(params) {
			var urlParams = "";
			for(var key in params) {
				urlParams += "&" + key + "=" + params[key];
			}
			urlParams = urlParams.substring(1);
			Util.urlParams = urlParams; //记载当前url传递的参数值
		}
		if(!ignoreCache) {
			saveInputValue();
		}
		if(this._isTheSameDocument(location.href, url)) {
			this._switchToSection(Util.getUrlFragment(url));
		} else {
			this._saveDocumentIntoCache($(document), location.href);
			this._switchToDocument(url, ignoreCache);
		}
	};

	/**
	 * 调用 history.forward()
	 */
	Router.prototype.forward = function() {
		theHistory.forward();
	};

	/**
	 * 调用 history.back()
	 */
	Router.prototype.back = function() {
		var temp=sessionStorage.getItem('lastUrl');
		temp=JSON.parse(temp);
		var toUrl=temp.pop();
		temp=JSON.stringify(temp);
		sessionStorage.setItem('lastUrl',temp);
		sessionStorage.setItem('isBack','y');
		this.load(toUrl,true);
	};

	/**
	 * @deprecated
	 */
	Router.prototype.loadPage = Router.prototype.load;

	/**
	 * 切换显示当前文档另一个块
	 *
	 * 把新块从右边切入展示，同时会把新的块的记录用 history.pushState 来保存起来
	 *
	 * 如果已经是当前显示的块，那么不做任何处理；
	 * 如果没对应的块，那么忽略。
	 *
	 * @param {String} sectionId 待切换显示的块的 id
	 * @private
	 */
	Router.prototype._switchToSection = function(sectionId) {
		if(!sectionId) {
			return;
		}

		var $curPage = this._getCurrentSection(),
			$newPage = $('#' + sectionId);

		// 如果已经是当前页，不做任何处理
		if($curPage === $newPage) {
			return;
		}

		this._animateSection($curPage, $newPage, DIRECTION.rightToLeft);
		this._pushNewState('#' + sectionId, sectionId);
	};

	/**
	 * 载入显示一个新的文档
	 *
	 * - 如果有缓存，那么直接利用缓存来切换
	 * - 否则，先把页面加载过来缓存，然后再切换
	 *      - 如果解析失败，那么用 location.href 的方式来跳转
	 *
	 * 注意：不能在这里以及其之后用 location.href 来 **读取** 切换前的页面的 url，
	 *     因为如果是 popState 时的调用，那么此时 location 已经是 pop 出来的 state 的了
	 *
	 * @param {String} url 新的文档的 url
	 * @param {Boolean=} ignoreCache 是否不使用缓存强制加载页面
	 * @param {Boolean=} isPushState 是否需要 pushState
	 * @param {String=} direction 新文档切入的方向
	 * @private
	 */
	Router.prototype._switchToDocument = function(url, ignoreCache, isPushState, direction) {
		var baseUrl = Util.toUrlObject(url).base;

		if(ignoreCache) {
			delete this.cache[baseUrl];
		}

		var cacheDocument = this.cache[baseUrl];
		var context = this;

		if(cacheDocument) {
			this._doSwitchDocument(url, isPushState, direction);
		} else {
			loadPageResource(baseUrl, function() {
				context._loadDocument(url, {
					success: function($doc) {
						try {
							context._parseDocument(url, $doc);
							context._doSwitchDocument(url, isPushState, direction);
						} catch(e) {
							context.setBase(Util.basePath);
							location.href = url;
						}
					},
					error: function() {
						location.href = url;
					}
				});
			});
		}
	};

	/**
	 * 利用缓存来做具体的切换文档操作
	 *
	 * - 确定待切入的文档的默认展示 section
	 * - 把新文档 append 到 view 中
	 * - 动画切换文档
	 * - 如果需要 pushState，那么把最新的状态 push 进去并把当前状态更新为该状态
	 *
	 * @param {String} url 待切换的文档的 url
	 * @param {Boolean} isPushState 加载页面后是否需要 pushState，默认是 true
	 * @param {String} direction 动画切换方向，默认是 DIRECTION.rightToLeft
	 * @private
	 */
	Router.prototype._doSwitchDocument = function(url, isPushState, direction) {
		if(typeof isPushState === 'undefined') {
			isPushState = true;
		}

		var urlObj = Util.toUrlObject(url);
		var $currentDoc = this.$view.find('.' + routerConfig.sectionGroupClass);
		this.setBase(urlObj.base);
		var $newDoc = $($('<div></div>').append(this.cache[urlObj.base].$content).html());
		// 确定一个 document 展示 section 的顺序
		// 1. 与 hash 关联的 element
		// 2. 默认的标识为 current 的 element
		// 3. 第一个 section
		var $allSection = $newDoc.find('.' + routerConfig.pageClass);
		var $visibleSection = $newDoc.find('.' + routerConfig.curPageClass);
		var $hashSection;

		if(urlObj.fragment) {
			$hashSection = $newDoc.find('#' + urlObj.fragment);
		}
		if($hashSection && $hashSection.length) {
			$visibleSection = $hashSection.eq(0);
		} else if(!$visibleSection.length) {
			$visibleSection = $allSection.eq(0);
		}
		if(!$visibleSection.attr('id')) {
			$visibleSection.attr('id', this._generateRandomId());
		}

		var $currentSection = this._getCurrentSection();
		$currentSection.trigger(EVENTS.beforePageSwitch, [$currentSection.attr('id'), $currentSection]);

		$allSection.removeClass(routerConfig.curPageClass);
		$visibleSection.addClass(routerConfig.curPageClass);

		if(isPushState) {
			//this._pushNewState(url, $visibleSection.attr('id'));
			this._pushNewState(urlObj.base, $visibleSection.attr('id'));
		}

		// prepend 而不 append 的目的是避免 append 进去新的 document 在后面，
		// 其里面的默认展示的(.page-current) 的页面直接就覆盖了原显示的页面（因为都是 absolute）
		this.$view.prepend($newDoc);

		this._animateDocument($currentDoc, $newDoc, $visibleSection, direction);
	};

	/**
	 * 设置base元素的路径
	 * @param fullUrl
	 */
	Router.prototype.setBase = function(fullUrl) {
		$('base').attr('href', fullUrl);
	};

	/**
	 * 判断两个 url 指向的页面是否是同一个
	 *
	 * 判断方式: 如果两个 url 的 base 形式（不带 hash 的绝对形式）相同，那么认为是同一个页面
	 *
	 * @param {String} url
	 * @param {String} anotherUrl
	 * @returns {Boolean}
	 * @private
	 */
	Router.prototype._isTheSameDocument = function(url, anotherUrl) {
		return Util.toUrlObject(url).base === Util.toUrlObject(anotherUrl).base;
	};

	/**
	 * ajax 加载 url 指定的页面内容
	 *
	 * 加载过程中会发出以下事件
	 *  pageLoadCancel: 如果前一个还没加载完,那么取消并发送该事件
	 *  pageLoadStart: 开始加载
	 *  pageLodComplete: ajax complete 完成
	 *  pageLoadError: ajax 发生 error
	 *
	 *
	 * @param {String} url url
	 * @param {Object=} callback 回调函数配置，可选，可以配置 success\error 和 complete
	 *      所有回调函数的 this 都是 null，各自实参如下：
	 *      success: $doc, status, xhr
	 *      error: xhr, status, err
	 *      complete: xhr, status
	 *
	 * @private
	 */
	Router.prototype._loadDocument = function(url, callback) {
		if(this.xhr && this.xhr.readyState < 4) {
			this.xhr.onreadystatechange = function() {};
			this.xhr.abort();
			this.dispatch(EVENTS.pageLoadCancel);
		}

		this.dispatch(EVENTS.pageLoadStart);

		callback = callback || {};
		var self = this;

		this.xhr = $.ajax({
			url: url,
			success: $.proxy(function(data, status, xhr) {
				this.setBase(Util.getAbsoluteUrl(url));
				// 给包一层 <html/>，从而可以拿到完整的结构
				var $doc = $('<html></html>');
				$doc.append(data);
				var $targetSection = $doc.find('.' + routerConfig.sectionGroupClass);

				var $docSection = $('<html></html>');
				$docSection.append('<div class="' + routerConfig.sectionGroupClass + '">' + $targetSection.html() + '</div>');
				callback.success && callback.success.call(null, $docSection, status, xhr);
			}, this),
			error: function(xhr, status, err) {
				callback.error && callback.error.call(null, xhr, status, err);
				self.dispatch(EVENTS.pageLoadError);
			},
			complete: function(xhr, status) {
				callback.complete && callback.complete.call(null, xhr, status);
				self.dispatch(EVENTS.pageLoadComplete);
			}
		});
	};

	/**
	 * 对于 ajax 加载进来的页面，把其缓存起来
	 *
	 * @param {String} url url
	 * @param $doc ajax 载入的页面的 jq 对象，可以看做是该页面的 $(document)
	 * @private
	 */
	Router.prototype._parseDocument = function(url, $doc) {
		var $innerView = $doc.find('.' + routerConfig.sectionGroupClass);

		if(!$innerView.length) {
			throw new Error('missing router view mark: ' + routerConfig.sectionGroupClass);
		}

		if(location.href === Util.basePath) {
			this.setBase(Util.basePath);
		}
		this._saveDocumentIntoCache($doc, url);
	};

	/**
	 * 把一个页面的相关信息保存到 this.cache 中
	 *
	 * 以页面的 baseUrl 为 key,而 value 则是一个 DocumentCache
	 *
	 * @param {*} doc doc
	 * @param {String} url url
	 * @private
	 */
	Router.prototype._saveDocumentIntoCache = function(doc, url) {
		var urlAsKey = Util.toUrlObject(url).base;
		var $doc = $(doc);
		this.cache[urlAsKey] = {
			$doc: $doc,
			$content: $doc.find('.' + routerConfig.sectionGroupClass)
		};
	};

	/**
	 * 从 sessionStorage 中获取保存下来的「当前状态」
	 *
	 * 如果解析失败，那么认为当前状态是 null
	 *
	 * @returns {State|null}
	 * @private
	 */
	Router.prototype._getLastState = function() {
		var currentState = sessionStorage.getItem(this.sessionNames.currentState);
		try {
			currentState = JSON.parse(currentState);
		} catch(e) {
			currentState = null;
		}

		return currentState;
	};

	/**
	 * 把一个状态设为当前状态，保存仅 sessionStorage 中
	 *
	 * @param {State} state
	 * @private
	 */
	Router.prototype._saveAsCurrentState = function(state) {
		sessionStorage.setItem(this.sessionNames.currentState, JSON.stringify(state));
	};

	/**
	 * 获取下一个 state 的 id
	 *
	 * 读取 sessionStorage 里的最后的状态的 id，然后 + 1；如果原没设置，那么返回 1
	 *
	 * @returns {number}
	 * @private
	 */
	Router.prototype._getNextStateId = function() {
		var maxStateId = sessionStorage.getItem(this.sessionNames.maxStateId);
		return maxStateId ? parseInt(maxStateId, 10) + 1 : 1;
	};

	/**
	 * 把 sessionStorage 里的最后状态的 id 自加 1
	 *
	 * @private
	 */
	Router.prototype._incMaxStateId = function() {
		sessionStorage.setItem(this.sessionNames.maxStateId, this._getNextStateId());
	};

	/**
	 * 从一个文档切换为显示另一个文档
	 *
	 * @param $from 目前显示的文档
	 * @param $to 待切换显示的新文档
	 * @param $visibleSection 新文档中展示的 section 元素
	 * @param direction 新文档切入方向
	 * @private
	 */
	Router.prototype._animateDocument = function($from, $to, $visibleSection, direction) {
		var sectionId = $visibleSection.attr('id');

		var $visibleSectionInFrom = $from.find('.' + routerConfig.curPageClass);
		$visibleSectionInFrom.addClass(routerConfig.visiblePageClass).removeClass(routerConfig.curPageClass);

		$visibleSection.trigger(EVENTS.pageAnimationStart, [sectionId, $visibleSection]);

		this._animateElement($from, $to, direction);

		$from.animationEnd(function() {
			$visibleSectionInFrom.removeClass(routerConfig.visiblePageClass);
			// 移除 document 前后，发送 beforePageRemove 和 pageRemoved 事件
			$(window).trigger(EVENTS.beforePageRemove, [$from]);
			$from.remove();
			$(window).trigger(EVENTS.pageRemoved);
		});

		$to.animationEnd(function() {
			$visibleSection.trigger(EVENTS.pageAnimationEnd, [sectionId, $visibleSection]);
			// 外层（init.js）中会绑定 pageInitInternal 事件，然后对页面进行初始化
			$visibleSection.trigger(EVENTS.pageInit, [sectionId, $visibleSection]);
		});
		initInputValue();
	};

	/**
	 * 把当前文档的展示 section 从一个 section 切换到另一个 section
	 *
	 * @param $from
	 * @param $to
	 * @param direction
	 * @private
	 */
	Router.prototype._animateSection = function($from, $to, direction) {
		var toId = $to.attr('id');
		$from.trigger(EVENTS.beforePageSwitch, [$from.attr('id'), $from]);

		$from.removeClass(routerConfig.curPageClass);
		$to.addClass(routerConfig.curPageClass);
		$to.trigger(EVENTS.pageAnimationStart, [toId, $to]);
		this._animateElement($from, $to, direction);
		$to.animationEnd(function() {
			$to.trigger(EVENTS.pageAnimationEnd, [toId, $to]);
			// 外层（init.js）中会绑定 pageInitInternal 事件，然后对页面进行初始化
			$to.trigger(EVENTS.pageInit, [toId, $to]);
		});
	};

	/**
	 * 切换显示两个元素
	 *
	 * 切换是通过更新 class 来实现的，而具体的切换动画则是 class 关联的 css 来实现
	 *
	 * @param $from 当前显示的元素
	 * @param $to 待显示的元素
	 * @param direction 切换的方向
	 * @private
	 */
	Router.prototype._animateElement = function($from, $to, direction) {
		// todo: 可考虑如果入参不指定，那么尝试读取 $to 的属性，再没有再使用默认的
		// 考虑读取点击的链接上指定的方向
		if(typeof direction === 'undefined') {
			direction = DIRECTION.rightToLeft;
		}

		var animPageClasses = [
			'page-from-center-to-left',
			'page-from-center-to-right',
			'page-from-right-to-center',
			'page-from-left-to-center'
		].join(' ');

		var classForFrom, classForTo;
		switch(direction) {
			case DIRECTION.rightToLeft:
				classForFrom = 'page-from-center-to-left';
				classForTo = 'page-from-right-to-center';
				break;
			case DIRECTION.leftToRight:
				classForFrom = 'page-from-center-to-right';
				classForTo = 'page-from-left-to-center';
				break;
			default:
				classForFrom = 'page-from-center-to-left';
				classForTo = 'page-from-right-to-center';
				break;
		}

		$from.removeClass(animPageClasses).addClass(classForFrom);
		$to.removeClass(animPageClasses).addClass(classForTo);

		$from.animationEnd(function() {
			$from.removeClass(animPageClasses);
		});
		$to.animationEnd(function() {
			$to.removeClass(animPageClasses);
		});
	};

	/**
	 * 获取当前显示的第一个 section
	 *
	 * @returns {*}
	 * @private
	 */
	Router.prototype._getCurrentSection = function() {
		return this.$view.find('.' + routerConfig.curPageClass).eq(0);
	};

	/**
	 * popState 事件关联着的后退处理
	 *
	 * 判断两个 state 判断是否是属于同一个文档，然后做对应的 section 或文档切换；
	 * 同时在切换后把新 state 设为当前 state
	 *
	 * @param {State} state 新 state
	 * @param {State} fromState 旧 state
	 * @private
	 */
	Router.prototype._back = function(state, fromState) {
		if(this._isTheSameDocument(state.url.full, fromState.url.full)) {
			var $newPage = $('#' + state.pageId);
			if($newPage.length) {
				var $currentPage = this._getCurrentSection();
				this._animateSection($currentPage, $newPage, DIRECTION.leftToRight);
				this._saveAsCurrentState(state);
			} else {
				location.href = state.url.full;
			}
		} else {
			this._saveDocumentIntoCache($(document), fromState.url.full);
			this._switchToDocument(state.url.full, false, false, DIRECTION.leftToRight);
			this._saveAsCurrentState(state);
		}
	};

	/**
	 * popState 事件关联着的前进处理,类似于 _back，不同的是切换方向
	 *
	 * @param {State} state 新 state
	 * @param {State} fromState 旧 state
	 * @private
	 */
	Router.prototype._forward = function(state, fromState) {
		if(this._isTheSameDocument(state.url.full, fromState.url.full)) {
			var $newPage = $('#' + state.pageId);
			if($newPage.length) {
				var $currentPage = this._getCurrentSection();
				this._animateSection($currentPage, $newPage, DIRECTION.rightToLeft);
				this._saveAsCurrentState(state);
			} else {
				location.href = state.url.full;
			}
		} else {
			this._saveDocumentIntoCache($(document), fromState.url.full);
			this._switchToDocument(state.url.full, false, false, DIRECTION.rightToLeft);
			this._saveAsCurrentState(state);
		}
	};

	/**
	 * popState 事件处理
	 *
	 * 根据 pop 出来的 state 和当前 state 来判断是前进还是后退
	 *
	 * @param event
	 * @private
	 */
	Router.prototype._onPopState = function(event) {
		var state = event.state;
		// if not a valid state, do nothing
		if(!state || !state.pageId) {
			return;
		}

		var lastState = this._getLastState();

		if(!lastState) {
			console.error && console.error('Missing last state when backward or forward');
			return;
		}

		if(state.id === lastState.id) {
			return;
		}

		if(state.id < lastState.id) {
			this._back(state, lastState);
		} else {
			this._forward(state, lastState);
		}
	};

	/**
	 * 页面进入到一个新状态
	 *
	 * 把新状态 push 进去，设置为当前的状态，然后把 maxState 的 id +1。
	 *
	 * @param {String} url 新状态的 url
	 * @param {String} sectionId 新状态中显示的 section 元素的 id
	 * @private
	 */
	Router.prototype._pushNewState = function(url, sectionId) {
		var state = {
			id: this._getNextStateId(),
			pageId: sectionId,
			url: Util.toUrlObject(url)
		};

		theHistory.pushState(state, '', url);
		this._saveAsCurrentState(state);
		this._incMaxStateId();
	};

	/**
	 * 生成一个随机的 id
	 *
	 * @returns {string}
	 * @private
	 */
	Router.prototype._generateRandomId = function() {
		return "page-" + (+new Date());
	};

	Router.prototype.dispatch = function(event) {
		var e = new CustomEvent(event, {
			bubbles: true,
			cancelable: true
		});

		//noinspection JSUnresolvedFunction
		window.dispatchEvent(e);
	};

	/**
	 * 判断一个链接是否使用 router 来处理
	 *
	 * @param $link
	 * @returns {boolean}
	 */
	function isInRouterBlackList($link) {
		var classBlackList = [
			'external',
			'tab-link',
			'open-popup',
			'close-popup',
			'open-panel',
			'close-panel'
		];

		for(var i = classBlackList.length - 1; i >= 0; i--) {
			if($link.hasClass(classBlackList[i])) {
				return true;
			}
		}

		var linkEle = $link.get(0);
		var linkHref = linkEle.getAttribute('href');

		var protoWhiteList = [
			'http',
			'https'
		];

		//如果非noscheme形式的链接，且协议不是http(s)，那么路由不会处理这类链接
		if(/^(\w+):/.test(linkHref) && protoWhiteList.indexOf(RegExp.$1) < 0) {
			return true;
		}

		//noinspection RedundantIfStatementJS
		if(linkEle.hasAttribute('external')) {
			return true;
		}

		return false;
	}

	/**
	 * 自定义是否执行路由功能的过滤器
	 *
	 * 可以在外部定义 $.config.routerFilter 函数，实参是点击链接的 Zepto 对象。
	 *
	 * @param $link 当前点击的链接的 Zepto 对象
	 * @returns {boolean} 返回 true 表示执行路由功能，否则不做路由处理
	 */
	function customClickFilter($link) {
		var customRouterFilter = $.smConfig.routerFilter;
		if($.isFunction(customRouterFilter)) {
			var filterResult = customRouterFilter($link);
			if(typeof filterResult === 'boolean') {
				return filterResult;
			}
		}

		return true;
	}

	/**
	 * 按需加载js和css                 ---edit 2017-04-25
	 *
	 * 非阻塞的加载，后面的js会先执行
	 * @param url
	 * @param callback
	 */
	function loadJsCss(url, callback) {
		var isJs = !!/\/.+\.js($|\?)/i.test(url);

		function onloaded(resource, callback) { //绑定加载完的回调函数
			if(resource.readyState) { //ie
				resource.attachEvent('onreadystatechange', function() {
					if(resource.readyState == 'loaded' || resource.readyState == 'complete') {
						resource.className = 'loaded';
					} else {
						resource.className = 'error';
					}
					callback && callback.constructor === Function && callback();
				});
			} else {
				resource.addEventListener('load', function() {
					resource.className = "loaded";
					callback && callback.constructor === Function && callback();
				}, false);

				resource.addEventListener('error', function() {
					resource.className = "error";
					callback && callback.constructor === Function && callback();
				}, false);
			}
		}

		if(!isJs) { //加载css
			var links = document.getElementsByTagName('link');
			for(var i = 0; i < links.length; i++) { //判断是否已加载
				if(links[i].href.indexOf(url) > -1 && callback && (callback.constructor === Function)) { //已创建link
					callback(); //已加载
					return;
				}
			}

			var link = document.createElement('link');
			link.rel = "stylesheet";
			link.href = url;
			var head = document.getElementsByTagName('head')[0];
			head.appendChild(link);
			onloaded(link, callback);
		} else { //加载js
			var scripts = document.getElementsByTagName('script');
			for(var i = 0; i < scripts.length; i++) { //是否已加载
				if(scripts[i].src.indexOf(url) > -1 && callback && (callback.constructor === Function)) { //已创建script
					callback();
					return;
				}
			}
			var script = document.createElement('script');
			script.src = url;
			document.body.appendChild(script);
			onloaded(script, callback);
		}

	}

	/**
	 * 加载页面资源                    ---edit 2017-04-25
	 * @param url
	 * @param callback
	 */
	function loadPageResource(url, callback) {
		// url: login2/login2.html
		var lastIndex = url.lastIndexOf('/');
		var basePath = url.slice(0, lastIndex);
		//资源前缀地址
		var cssPathPriex = basePath + '/css/';
		var jsPathPriex = basePath + '/js/';

		//判断单页模板页面(区别业务模板中其他页面或用户新建页面)
		var urlTargetName = url.slice(url.lastIndexOf('/') + 1, url.lastIndexOf('.'));
		if(urlTargetName.indexOf('tpl') > -1) {
			//单页模板
			var singleModuleCssPath = cssPathPriex + urlTargetName.split('_')[0] + '.css';
			var singleModuleJSPath = jsPathPriex + urlTargetName.split('_')[0] + 'EventBinds.js';
			//加载单页模板的资源
			loadJsCss(singleModuleCssPath, function() {
				loadJsCss(singleModuleJSPath, function() {
					callback();
				});
			});
		} else {
			//业务模板
			var moduleName = basePath;
			lastIndex = basePath.lastIndexOf('/');
			if(lastIndex > -1) {
				moduleName = basePath.slice(lastIndex + 1);
			}
			var moduleCssPath = cssPathPriex + moduleName + '.css';
			var moduleJSPath = jsPathPriex + moduleName + 'EventBinds.js';
			//加载业务模板的资源
			loadJsCss(moduleCssPath, function() {
				loadJsCss(moduleJSPath, function() {
					callback();
				});
			});
		}

	}

	/**
	 * 5-26 路由新增方法
	 * 路由记录输入框数据
	 */
	//记录input数据
	function saveInputValue() {
		$("input").each(function() {
			var _this = $(this);
			_this.attr("data-catch", _this.val());
		})
	}

	//初始化inputvalue
	function initInputValue() {
		$("input").each(function() {
			var _this = $(this);
			if(_this.attr("data-catch")) {
				_this.val(_this.attr("data-catch"));
			}
		})
	}

	/**
	 * *  * * * * end * * * *  * *
	 */
	$(function() {
		// 用户可选关闭router功能
		if(!$.smConfig.router) {
			return;
		}

		if(!Util.supportStorage()) {
			return;
		}

		var $pages = $('.' + routerConfig.pageClass);
		if(!$pages.length) {
			var warnMsg = 'Disable router function because of no .page elements';
			if(window.console && window.console.warn) {
				console.warn(warnMsg);
			}
			return;
		}

		var router = $.router = new Router();

		$(document).on('click', 'a', function(e) {
			var $target = $(e.currentTarget);

			var filterResult = customClickFilter($target);
			if(!filterResult) {
				return;
			}

			if(isInRouterBlackList($target)) {
				return;
			}

			e.preventDefault();

			if($target.hasClass('back')) {
				router.back();
			} else {
				var url = $target.attr('href');
				if(!url || url === '#') {
					return;
				}

				var ignoreCache = $target.attr('data-no-cache') === 'true';

				router.load(url, ignoreCache);
			}
		});
	});
}(Zepto);

/*======================================================
 ************   Modals   ************
 ======================================================*/
+
function($) {
	"use strict";
	$.lastPosition = function(options) {
		if(!sessionStorage) {
			return;
		}
		// 需要记忆模块的className
		var needMemoryClass = options.needMemoryClass || [];

		$(window).off('beforePageSwitch').on('beforePageSwitch', function(event, id, arg) {
			updateMemory(id, arg);
		});
		$(window).off('pageAnimationStart').on('pageAnimationStart', function(event, id, arg) {
			getMemory(id, arg);
		});
		//让后退页面回到之前的高度
		function getMemory(id, arg) {
			needMemoryClass.forEach(function(item, index) {
				if($(item).length === 0) {
					return;
				}
				var positionName = id;
				// 遍历对应节点设置存储的高度
				var memoryHeight = sessionStorage.getItem(positionName);
				arg.find(item).scrollTop(parseInt(memoryHeight));

			});
		}

		//记住即将离开的页面的高度
		function updateMemory(id, arg) {
			var positionName = id;
			// 存储需要记忆模块的高度
			needMemoryClass.forEach(function(item, index) {
				if($(item).length === 0) {
					return;
				}
				sessionStorage.setItem(
					positionName,
					arg.find(item).scrollTop()
				);

			});
		}
	};
}(Zepto);

+
function($) {
	'use strict';

	var getPage = function() {
		var $page = $(".page-current");
		if(!$page[0]) $page = $(".page").addClass('page-current');
		return $page;
	};

	//初始化页面中的JS组件
	$.initPage = function(page) {
		var $page = getPage();
		if(!$page[0]) $page = $(document.body);
		var $content = $page.hasClass('content') ?
			$page :
			$page.find('.content');
		$content.scroller(); //注意滚动条一定要最先初始化

		$.initPullToRefresh($content);
		$.initInfiniteScroll($content);
		$.initCalendar($content);

		//extend
		if($.initSwiper) $.initSwiper($content);
	};

	if($.smConfig.showPageLoadingIndicator) {
		//这里的 以 push 开头的是私有事件，不要用
		$(window).on('pageLoadStart', function() {
			$.showIndicator();

		});
		$(window).on('pageAnimationStart', function() {
			$.hideIndicator();
		});
		$(window).on('pageLoadCancel', function() {
			$.hideIndicator();
		});
		$(window).on('pageLoadComplete', function() {
			$.hideIndicator();
		});
		$(window).on('pageLoadError', function() {
			$.hideIndicator();
			$.toast('加载失败');
		});
	}

	$(window).on('pageAnimationStart', function(event, id, page) {
		// 在路由切换页面动画开始前,为了把位于 .page 之外的 popup 等隐藏,此处做些处理
		$.closeModal();
		$.closePanel();
		// 如果 panel 的 effect 是 reveal 时,似乎是 page 的动画或别的样式原因导致了 transitionEnd 时间不会触发
		// 这里暂且处理一下
		$('body').removeClass('panel-closing');
		$.allowPanelOpen = true;
	});

	$(window).on('pageInit', function() {
		$.hideIndicator();
		$.lastPosition({
			needMemoryClass: [
				'.content'
			]
		});
	});
	// safari 在后退的时候会使用缓存技术，但实现上似乎存在些问题，
	// 导致路由中绑定的点击事件不会正常如期的运行（log 和 debugger 都没法调试），
	// 从而后续的跳转等完全乱了套。
	// 所以，这里检测到是 safari 的 cache 的情况下，做一次 reload
	// 测试路径(后缀 D 表示是 document，E 表示 external，不使用路由跳转）：
	// 1. aD -> bDE
	// 2. back
	// 3. aD -> bD
	window.addEventListener('pageshow', function(event) {
		if(event.persisted) {
			location.reload();
		}
	});

	$.init = function() {
		var $page = getPage();
		var id = $page[0].id;
		$.initPage();
		$page.trigger('pageInit', [id, $page]);
	};

	//DOM READY
	$(function() {
		//直接绑定
		FastClick.attach(document.body);

		if($.smConfig.autoInit) {
			$.init();
		}
		$(document).on('pageInitInternal', function(e, id, page) {
			$.init();
		});
	});

}(Zepto);

/**
 * ScrollFix v0.1
 * http://www.joelambert.co.uk
 *
 * Copyright 2011, Joe Lambert.
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 */
/* ===============================================================================
 ************   ScrollFix   ************
 =============================================================================== */
+
function($) {
	"use strict";
	//安卓微信中使用scrollfix会有问题，因此只在ios中使用，安卓机器按照原来的逻辑

	if($.device.ios) {
		var ScrollFix = function(elem) {

			// Variables to track inputs
			var startY;
			var startTopScroll;

			elem = elem || document.querySelector(elem);

			// If there is no element, then do nothing
			if(!elem)
				return;

			// Handle the start of interactions
			elem.addEventListener('touchstart', function(event) {
				startY = event.touches[0].pageY;
				startTopScroll = elem.scrollTop;

				if(startTopScroll <= 0)
					elem.scrollTop = 1;

				if(startTopScroll + elem.offsetHeight >= elem.scrollHeight)
					elem.scrollTop = elem.scrollHeight - elem.offsetHeight - 1;
			}, false);
		};

		var initScrollFix = function() {
			var prefix = $('.page-current').length > 0 ? '.page-current ' : '';
			var scrollable = $(prefix + ".content");
			new ScrollFix(scrollable[0]);
		};

		$(document).on($.touchEvents.move, ".page-current .bar", function() {
			event.preventDefault();
		});
		//监听ajax页面跳转
		$(document).on("pageLoadComplete", function() {
			initScrollFix();
		});
		//监听内联页面跳转
		$(document).on("pageAnimationEnd", function() {
			initScrollFix();
		});
		initScrollFix();
	}

}(Zepto);

/**
 * MD5加密
 */
;
(function($) {
	'use strict'

	/*
	 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
	 * to work around bugs in some JS interpreters.
	 */
	function safeAdd(x, y) {
		var lsw = (x & 0xFFFF) + (y & 0xFFFF)
		var msw = (x >> 16) + (y >> 16) + (lsw >> 16)
		return(msw << 16) | (lsw & 0xFFFF)
	}

	/*
	 * Bitwise rotate a 32-bit number to the left.
	 */
	function bitRotateLeft(num, cnt) {
		return(num << cnt) | (num >>> (32 - cnt))
	}

	/*
	 * These functions implement the four basic operations the algorithm uses.
	 */
	function md5cmn(q, a, b, x, s, t) {
		return safeAdd(bitRotateLeft(safeAdd(safeAdd(a, q), safeAdd(x, t)), s), b)
	}

	function md5ff(a, b, c, d, x, s, t) {
		return md5cmn((b & c) | ((~b) & d), a, b, x, s, t)
	}

	function md5gg(a, b, c, d, x, s, t) {
		return md5cmn((b & d) | (c & (~d)), a, b, x, s, t)
	}

	function md5hh(a, b, c, d, x, s, t) {
		return md5cmn(b ^ c ^ d, a, b, x, s, t)
	}

	function md5ii(a, b, c, d, x, s, t) {
		return md5cmn(c ^ (b | (~d)), a, b, x, s, t)
	}

	/*
	 * Calculate the MD5 of an array of little-endian words, and a bit length.
	 */
	function binlMD5(x, len) {
		/* append padding */
		x[len >> 5] |= 0x80 << (len % 32)
		x[(((len + 64) >>> 9) << 4) + 14] = len

		var i
		var olda
		var oldb
		var oldc
		var oldd
		var a = 1732584193
		var b = -271733879
		var c = -1732584194
		var d = 271733878

		for(i = 0; i < x.length; i += 16) {
			olda = a
			oldb = b
			oldc = c
			oldd = d

			a = md5ff(a, b, c, d, x[i], 7, -680876936)
			d = md5ff(d, a, b, c, x[i + 1], 12, -389564586)
			c = md5ff(c, d, a, b, x[i + 2], 17, 606105819)
			b = md5ff(b, c, d, a, x[i + 3], 22, -1044525330)
			a = md5ff(a, b, c, d, x[i + 4], 7, -176418897)
			d = md5ff(d, a, b, c, x[i + 5], 12, 1200080426)
			c = md5ff(c, d, a, b, x[i + 6], 17, -1473231341)
			b = md5ff(b, c, d, a, x[i + 7], 22, -45705983)
			a = md5ff(a, b, c, d, x[i + 8], 7, 1770035416)
			d = md5ff(d, a, b, c, x[i + 9], 12, -1958414417)
			c = md5ff(c, d, a, b, x[i + 10], 17, -42063)
			b = md5ff(b, c, d, a, x[i + 11], 22, -1990404162)
			a = md5ff(a, b, c, d, x[i + 12], 7, 1804603682)
			d = md5ff(d, a, b, c, x[i + 13], 12, -40341101)
			c = md5ff(c, d, a, b, x[i + 14], 17, -1502002290)
			b = md5ff(b, c, d, a, x[i + 15], 22, 1236535329)

			a = md5gg(a, b, c, d, x[i + 1], 5, -165796510)
			d = md5gg(d, a, b, c, x[i + 6], 9, -1069501632)
			c = md5gg(c, d, a, b, x[i + 11], 14, 643717713)
			b = md5gg(b, c, d, a, x[i], 20, -373897302)
			a = md5gg(a, b, c, d, x[i + 5], 5, -701558691)
			d = md5gg(d, a, b, c, x[i + 10], 9, 38016083)
			c = md5gg(c, d, a, b, x[i + 15], 14, -660478335)
			b = md5gg(b, c, d, a, x[i + 4], 20, -405537848)
			a = md5gg(a, b, c, d, x[i + 9], 5, 568446438)
			d = md5gg(d, a, b, c, x[i + 14], 9, -1019803690)
			c = md5gg(c, d, a, b, x[i + 3], 14, -187363961)
			b = md5gg(b, c, d, a, x[i + 8], 20, 1163531501)
			a = md5gg(a, b, c, d, x[i + 13], 5, -1444681467)
			d = md5gg(d, a, b, c, x[i + 2], 9, -51403784)
			c = md5gg(c, d, a, b, x[i + 7], 14, 1735328473)
			b = md5gg(b, c, d, a, x[i + 12], 20, -1926607734)

			a = md5hh(a, b, c, d, x[i + 5], 4, -378558)
			d = md5hh(d, a, b, c, x[i + 8], 11, -2022574463)
			c = md5hh(c, d, a, b, x[i + 11], 16, 1839030562)
			b = md5hh(b, c, d, a, x[i + 14], 23, -35309556)
			a = md5hh(a, b, c, d, x[i + 1], 4, -1530992060)
			d = md5hh(d, a, b, c, x[i + 4], 11, 1272893353)
			c = md5hh(c, d, a, b, x[i + 7], 16, -155497632)
			b = md5hh(b, c, d, a, x[i + 10], 23, -1094730640)
			a = md5hh(a, b, c, d, x[i + 13], 4, 681279174)
			d = md5hh(d, a, b, c, x[i], 11, -358537222)
			c = md5hh(c, d, a, b, x[i + 3], 16, -722521979)
			b = md5hh(b, c, d, a, x[i + 6], 23, 76029189)
			a = md5hh(a, b, c, d, x[i + 9], 4, -640364487)
			d = md5hh(d, a, b, c, x[i + 12], 11, -421815835)
			c = md5hh(c, d, a, b, x[i + 15], 16, 530742520)
			b = md5hh(b, c, d, a, x[i + 2], 23, -995338651)

			a = md5ii(a, b, c, d, x[i], 6, -198630844)
			d = md5ii(d, a, b, c, x[i + 7], 10, 1126891415)
			c = md5ii(c, d, a, b, x[i + 14], 15, -1416354905)
			b = md5ii(b, c, d, a, x[i + 5], 21, -57434055)
			a = md5ii(a, b, c, d, x[i + 12], 6, 1700485571)
			d = md5ii(d, a, b, c, x[i + 3], 10, -1894986606)
			c = md5ii(c, d, a, b, x[i + 10], 15, -1051523)
			b = md5ii(b, c, d, a, x[i + 1], 21, -2054922799)
			a = md5ii(a, b, c, d, x[i + 8], 6, 1873313359)
			d = md5ii(d, a, b, c, x[i + 15], 10, -30611744)
			c = md5ii(c, d, a, b, x[i + 6], 15, -1560198380)
			b = md5ii(b, c, d, a, x[i + 13], 21, 1309151649)
			a = md5ii(a, b, c, d, x[i + 4], 6, -145523070)
			d = md5ii(d, a, b, c, x[i + 11], 10, -1120210379)
			c = md5ii(c, d, a, b, x[i + 2], 15, 718787259)
			b = md5ii(b, c, d, a, x[i + 9], 21, -343485551)

			a = safeAdd(a, olda)
			b = safeAdd(b, oldb)
			c = safeAdd(c, oldc)
			d = safeAdd(d, oldd)
		}
		return [a, b, c, d]
	}

	/*
	 * Convert an array of little-endian words to a string
	 */
	function binl2rstr(input) {
		var i
		var output = ''
		var length32 = input.length * 32
		for(i = 0; i < length32; i += 8) {
			output += String.fromCharCode((input[i >> 5] >>> (i % 32)) & 0xFF)
		}
		return output
	}

	/*
	 * Convert a raw string to an array of little-endian words
	 * Characters >255 have their high-byte silently ignored.
	 */
	function rstr2binl(input) {
		var i
		var output = []
		output[(input.length >> 2) - 1] = undefined
		for(i = 0; i < output.length; i += 1) {
			output[i] = 0
		}
		var length8 = input.length * 8
		for(i = 0; i < length8; i += 8) {
			output[i >> 5] |= (input.charCodeAt(i / 8) & 0xFF) << (i % 32)
		}
		return output
	}

	/*
	 * Calculate the MD5 of a raw string
	 */
	function rstrMD5(s) {
		return binl2rstr(binlMD5(rstr2binl(s), s.length * 8))
	}

	/*
	 * Calculate the HMAC-MD5, of a key and some data (raw strings)
	 */
	function rstrHMACMD5(key, data) {
		var i
		var bkey = rstr2binl(key)
		var ipad = []
		var opad = []
		var hash
		ipad[15] = opad[15] = undefined
		if(bkey.length > 16) {
			bkey = binlMD5(bkey, key.length * 8)
		}
		for(i = 0; i < 16; i += 1) {
			ipad[i] = bkey[i] ^ 0x36363636
			opad[i] = bkey[i] ^ 0x5C5C5C5C
		}
		hash = binlMD5(ipad.concat(rstr2binl(data)), 512 + data.length * 8)
		return binl2rstr(binlMD5(opad.concat(hash), 512 + 128))
	}

	/*
	 * Convert a raw string to a hex string
	 */
	function rstr2hex(input) {
		var hexTab = '0123456789abcdef'
		var output = ''
		var x
		var i
		for(i = 0; i < input.length; i += 1) {
			x = input.charCodeAt(i)
			output += hexTab.charAt((x >>> 4) & 0x0F) +
				hexTab.charAt(x & 0x0F)
		}
		return output
	}

	/*
	 * Encode a string as utf-8
	 */
	function str2rstrUTF8(input) {
		return unescape(encodeURIComponent(input))
	}

	/*
	 * Take string arguments and return either raw or hex encoded strings
	 */
	function rawMD5(s) {
		return rstrMD5(str2rstrUTF8(s))
	}

	function hexMD5(s) {
		return rstr2hex(rawMD5(s))
	}

	function rawHMACMD5(k, d) {
		return rstrHMACMD5(str2rstrUTF8(k), str2rstrUTF8(d))
	}

	function hexHMACMD5(k, d) {
		return rstr2hex(rawHMACMD5(k, d))
	}

	function md5(string, key, raw) {
		if(!key) {
			if(!raw) {
				return hexMD5(string)
			}
			return rawMD5(string)
		}
		if(!raw) {
			return hexHMACMD5(key, string)
		}
		return rawHMACMD5(key, string)
	}

	if(typeof define === 'function' && define.amd) {
		define(function() {
			return md5
		})
	} else if(typeof module === 'object' && module.exports) {
		module.exports = md5
	} else {
		$.md5 = md5
	}
}(Zepto));

/**
 * Swiper 3.3.1
 * http://www.idangero.us/swiper/
 */
;
(function() {
	'use strict';
	var $;
	/*===========================
	 Swiper
	 ===========================*/
	var Swiper = function(container, params) {
		if(!(this instanceof Swiper)) return new Swiper(container, params);

		var defaults = {
			direction: 'horizontal',
			touchEventsTarget: 'container',
			initialSlide: 0,
			speed: 300,
			// autoplay
			autoplay: false,
			autoplayDisableOnInteraction: true,
			autoplayStopOnLast: false,
			// To support iOS's swipe-to-go-back gesture (when being used in-app, with UIWebView).
			iOSEdgeSwipeDetection: false,
			iOSEdgeSwipeThreshold: 20,
			// Free mode
			freeMode: false,
			freeModeMomentum: true,
			freeModeMomentumRatio: 1,
			freeModeMomentumBounce: true,
			freeModeMomentumBounceRatio: 1,
			freeModeSticky: false,
			freeModeMinimumVelocity: 0.02,
			// Autoheight
			autoHeight: false,
			// Set wrapper width
			setWrapperSize: false,
			// Virtual Translate
			virtualTranslate: false,
			// Effects
			effect: 'slide', // 'slide' or 'fade' or 'cube' or 'coverflow' or 'flip'
			coverflow: {
				rotate: 50,
				stretch: 0,
				depth: 100,
				modifier: 1,
				slideShadows: true
			},
			flip: {
				slideShadows: true,
				limitRotation: true
			},
			cube: {
				slideShadows: true,
				shadow: true,
				shadowOffset: 20,
				shadowScale: 0.94
			},
			fade: {
				crossFade: false
			},
			// Parallax
			parallax: false,
			// Scrollbar
			scrollbar: null,
			scrollbarHide: true,
			scrollbarDraggable: false,
			scrollbarSnapOnRelease: false,
			// Keyboard Mousewheel
			keyboardControl: false,
			mousewheelControl: false,
			mousewheelReleaseOnEdges: false,
			mousewheelInvert: false,
			mousewheelForceToAxis: false,
			mousewheelSensitivity: 1,
			// Hash Navigation
			hashnav: false,
			// Breakpoints
			breakpoints: undefined,
			// Slides grid
			spaceBetween: 0,
			slidesPerView: 1,
			slidesPerColumn: 1,
			slidesPerColumnFill: 'column',
			slidesPerGroup: 1,
			centeredSlides: false,
			slidesOffsetBefore: 0, // in px
			slidesOffsetAfter: 0, // in px
			// Round length
			roundLengths: false,
			// Touches
			touchRatio: 1,
			touchAngle: 45,
			simulateTouch: true,
			shortSwipes: true,
			longSwipes: true,
			longSwipesRatio: 0.5,
			longSwipesMs: 300,
			followFinger: true,
			onlyExternal: false,
			threshold: 0,
			touchMoveStopPropagation: true,
			// Unique Navigation Elements
			uniqueNavElements: true,
			// Pagination
			pagination: null,
			paginationElement: 'span',
			paginationClickable: false,
			paginationHide: false,
			paginationBulletRender: null,
			paginationProgressRender: null,
			paginationFractionRender: null,
			paginationCustomRender: null,
			paginationType: 'bullets', // 'bullets' or 'progress' or 'fraction' or 'custom'
			// Resistance
			resistance: true,
			resistanceRatio: 0.85,
			// Next/prev buttons
			nextButton: null,
			prevButton: null,
			// Progress
			watchSlidesProgress: false,
			watchSlidesVisibility: false,
			// Cursor
			grabCursor: false,
			// Clicks
			preventClicks: true,
			preventClicksPropagation: true,
			slideToClickedSlide: false,
			// Lazy Loading
			lazyLoading: false,
			lazyLoadingInPrevNext: false,
			lazyLoadingInPrevNextAmount: 1,
			lazyLoadingOnTransitionStart: false,
			// Images
			preloadImages: true,
			updateOnImagesReady: true,
			// loop
			loop: false,
			loopAdditionalSlides: 0,
			loopedSlides: null,
			// Control
			control: undefined,
			controlInverse: false,
			controlBy: 'slide', //or 'container'
			// Swiping/no swiping
			allowSwipeToPrev: true,
			allowSwipeToNext: true,
			swipeHandler: null, //'.swipe-handler',
			noSwiping: true,
			noSwipingClass: 'swiper-no-swiping',
			// NS
			slideClass: 'swiper-slide',
			slideActiveClass: 'swiper-slide-active',
			slideVisibleClass: 'swiper-slide-visible',
			slideDuplicateClass: 'swiper-slide-duplicate',
			slideNextClass: 'swiper-slide-next',
			slidePrevClass: 'swiper-slide-prev',
			wrapperClass: 'swiper-wrapper',
			bulletClass: 'swiper-pagination-bullet',
			bulletActiveClass: 'swiper-pagination-bullet-active',
			buttonDisabledClass: 'swiper-button-disabled',
			paginationCurrentClass: 'swiper-pagination-current',
			paginationTotalClass: 'swiper-pagination-total',
			paginationHiddenClass: 'swiper-pagination-hidden',
			paginationProgressbarClass: 'swiper-pagination-progressbar',
			// Observer
			observer: false,
			observeParents: false,
			// Accessibility
			a11y: false,
			prevSlideMessage: 'Previous slide',
			nextSlideMessage: 'Next slide',
			firstSlideMessage: 'This is the first slide',
			lastSlideMessage: 'This is the last slide',
			paginationBulletMessage: 'Go to slide {{index}}',
			// Callbacks
			runCallbacksOnInit: true
			/*
			 Callbacks:
			 onInit: function (swiper)
			 onDestroy: function (swiper)
			 onClick: function (swiper, e)
			 onTap: function (swiper, e)
			 onDoubleTap: function (swiper, e)
			 onSliderMove: function (swiper, e)
			 onSlideChangeStart: function (swiper)
			 onSlideChangeEnd: function (swiper)
			 onTransitionStart: function (swiper)
			 onTransitionEnd: function (swiper)
			 onImagesReady: function (swiper)
			 onProgress: function (swiper, progress)
			 onTouchStart: function (swiper, e)
			 onTouchMove: function (swiper, e)
			 onTouchMoveOpposite: function (swiper, e)
			 onTouchEnd: function (swiper, e)
			 onReachBeginning: function (swiper)
			 onReachEnd: function (swiper)
			 onSetTransition: function (swiper, duration)
			 onSetTranslate: function (swiper, translate)
			 onAutoplayStart: function (swiper)
			 onAutoplayStop: function (swiper),
			 onLazyImageLoad: function (swiper, slide, image)
			 onLazyImageReady: function (swiper, slide, image)
			 */

		};
		var initialVirtualTranslate = params && params.virtualTranslate;

		params = params || {};
		var originalParams = {};
		for(var param in params) {
			if(typeof params[param] === 'object' && params[param] !== null && !(params[param].nodeType || params[param] === window || params[param] === document || (typeof Dom7 !== 'undefined' && params[param] instanceof Dom7) || (typeof jQuery !== 'undefined' && params[param] instanceof jQuery))) {
				originalParams[param] = {};
				for(var deepParam in params[param]) {
					originalParams[param][deepParam] = params[param][deepParam];
				}
			} else {
				originalParams[param] = params[param];
			}
		}
		for(var def in defaults) {
			if(typeof params[def] === 'undefined') {
				params[def] = defaults[def];
			} else if(typeof params[def] === 'object') {
				for(var deepDef in defaults[def]) {
					if(typeof params[def][deepDef] === 'undefined') {
						params[def][deepDef] = defaults[def][deepDef];
					}
				}
			}
		}

		// Swiper
		var s = this;

		// Params
		s.params = params;
		s.originalParams = originalParams;

		// Classname
		s.classNames = [];
		/*=========================
		 Dom Library and plugins
		 ===========================*/
		if(typeof $ !== 'undefined' && typeof Dom7 !== 'undefined') {
			$ = Dom7;
		}
		if(typeof $ === 'undefined') {
			if(typeof Dom7 === 'undefined') {
				$ = window.Dom7 || window.Zepto || window.jQuery;
			} else {
				$ = Dom7;
			}
			if(!$) return;
		}
		// Export it to Swiper instance
		s.$ = $;

		/*=========================
		 Breakpoints
		 ===========================*/
		s.currentBreakpoint = undefined;
		s.getActiveBreakpoint = function() {
			//Get breakpoint for window width
			if(!s.params.breakpoints) return false;
			var breakpoint = false;
			var points = [],
				point;
			for(point in s.params.breakpoints) {
				if(s.params.breakpoints.hasOwnProperty(point)) {
					points.push(point);
				}
			}
			points.sort(function(a, b) {
				return parseInt(a, 10) > parseInt(b, 10);
			});
			for(var i = 0; i < points.length; i++) {
				point = points[i];
				if(point >= window.innerWidth && !breakpoint) {
					breakpoint = point;
				}
			}
			return breakpoint || 'max';
		};
		s.setBreakpoint = function() {
			//Set breakpoint for window width and update parameters
			var breakpoint = s.getActiveBreakpoint();
			if(breakpoint && s.currentBreakpoint !== breakpoint) {
				var breakPointsParams = breakpoint in s.params.breakpoints ? s.params.breakpoints[breakpoint] : s.originalParams;
				var needsReLoop = s.params.loop && (breakPointsParams.slidesPerView !== s.params.slidesPerView);
				for(var param in breakPointsParams) {
					s.params[param] = breakPointsParams[param];
				}
				s.currentBreakpoint = breakpoint;
				if(needsReLoop && s.destroyLoop) {
					s.reLoop(true);
				}
			}
		};
		// Set breakpoint on load
		if(s.params.breakpoints) {
			s.setBreakpoint();
		}

		/*=========================
		 Preparation - Define Container, Wrapper and Pagination
		 ===========================*/
		s.container = $(container);
		if(s.container.length === 0) return;
		if(s.container.length > 1) {
			var swipers = [];
			s.container.each(function() {
				var container = this;
				swipers.push(new Swiper(this, params));
			});
			return swipers;
		}

		// Save instance in container HTML Element and in data
		s.container[0].swiper = s;
		s.container.data('swiper', s);

		s.classNames.push('swiper-container-' + s.params.direction);

		if(s.params.freeMode) {
			s.classNames.push('swiper-container-free-mode');
		}
		if(!s.support.flexbox) {
			s.classNames.push('swiper-container-no-flexbox');
			s.params.slidesPerColumn = 1;
		}
		if(s.params.autoHeight) {
			s.classNames.push('swiper-container-autoheight');
		}
		// Enable slides progress when required
		if(s.params.parallax || s.params.watchSlidesVisibility) {
			s.params.watchSlidesProgress = true;
		}
		// Coverflow / 3D
		if(['cube', 'coverflow', 'flip'].indexOf(s.params.effect) >= 0) {
			if(s.support.transforms3d) {
				s.params.watchSlidesProgress = true;
				s.classNames.push('swiper-container-3d');
			} else {
				s.params.effect = 'slide';
			}
		}
		if(s.params.effect !== 'slide') {
			s.classNames.push('swiper-container-' + s.params.effect);
		}
		if(s.params.effect === 'cube') {
			s.params.resistanceRatio = 0;
			s.params.slidesPerView = 1;
			s.params.slidesPerColumn = 1;
			s.params.slidesPerGroup = 1;
			s.params.centeredSlides = false;
			s.params.spaceBetween = 0;
			s.params.virtualTranslate = true;
			s.params.setWrapperSize = false;
		}
		if(s.params.effect === 'fade' || s.params.effect === 'flip') {
			s.params.slidesPerView = 1;
			s.params.slidesPerColumn = 1;
			s.params.slidesPerGroup = 1;
			s.params.watchSlidesProgress = true;
			s.params.spaceBetween = 0;
			s.params.setWrapperSize = false;
			if(typeof initialVirtualTranslate === 'undefined') {
				s.params.virtualTranslate = true;
			}
		}

		// Grab Cursor
		if(s.params.grabCursor && s.support.touch) {
			s.params.grabCursor = false;
		}

		// Wrapper
		s.wrapper = s.container.children('.' + s.params.wrapperClass);

		// Pagination
		if(s.params.pagination) {
			s.paginationContainer = $(s.params.pagination);
			if(s.params.uniqueNavElements && typeof s.params.pagination === 'string' && s.paginationContainer.length > 1 && s.container.find(s.params.pagination).length === 1) {
				s.paginationContainer = s.container.find(s.params.pagination);
			}

			if(s.params.paginationType === 'bullets' && s.params.paginationClickable) {
				s.paginationContainer.addClass('swiper-pagination-clickable');
			} else {
				s.params.paginationClickable = false;
			}
			s.paginationContainer.addClass('swiper-pagination-' + s.params.paginationType);
		}
		// Next/Prev Buttons
		if(s.params.nextButton || s.params.prevButton) {
			if(s.params.nextButton) {
				s.nextButton = $(s.params.nextButton);
				if(s.params.uniqueNavElements && typeof s.params.nextButton === 'string' && s.nextButton.length > 1 && s.container.find(s.params.nextButton).length === 1) {
					s.nextButton = s.container.find(s.params.nextButton);
				}
			}
			if(s.params.prevButton) {
				s.prevButton = $(s.params.prevButton);
				if(s.params.uniqueNavElements && typeof s.params.prevButton === 'string' && s.prevButton.length > 1 && s.container.find(s.params.prevButton).length === 1) {
					s.prevButton = s.container.find(s.params.prevButton);
				}
			}
		}

		// Is Horizontal
		s.isHorizontal = function() {
			return s.params.direction === 'horizontal';
		};
		// s.isH = isH;

		// RTL
		s.rtl = s.isHorizontal() && (s.container[0].dir.toLowerCase() === 'rtl' || s.container.css('direction') === 'rtl');
		if(s.rtl) {
			s.classNames.push('swiper-container-rtl');
		}

		// Wrong RTL support
		if(s.rtl) {
			s.wrongRTL = s.wrapper.css('display') === '-webkit-box';
		}

		// Columns
		if(s.params.slidesPerColumn > 1) {
			s.classNames.push('swiper-container-multirow');
		}

		// Check for Android
		if(s.device.android) {
			s.classNames.push('swiper-container-android');
		}

		// Add classes
		s.container.addClass(s.classNames.join(' '));

		// Translate
		s.translate = 0;

		// Progress
		s.progress = 0;

		// Velocity
		s.velocity = 0;

		/*=========================
		 Locks, unlocks
		 ===========================*/
		s.lockSwipeToNext = function() {
			s.params.allowSwipeToNext = false;
		};
		s.lockSwipeToPrev = function() {
			s.params.allowSwipeToPrev = false;
		};
		s.lockSwipes = function() {
			s.params.allowSwipeToNext = s.params.allowSwipeToPrev = false;
		};
		s.unlockSwipeToNext = function() {
			s.params.allowSwipeToNext = true;
		};
		s.unlockSwipeToPrev = function() {
			s.params.allowSwipeToPrev = true;
		};
		s.unlockSwipes = function() {
			s.params.allowSwipeToNext = s.params.allowSwipeToPrev = true;
		};

		/*=========================
		 Round helper
		 ===========================*/
		function round(a) {
			return Math.floor(a);
		}

		/*=========================
		 Set grab cursor
		 ===========================*/
		if(s.params.grabCursor) {
			s.container[0].style.cursor = 'move';
			s.container[0].style.cursor = '-webkit-grab';
			s.container[0].style.cursor = '-moz-grab';
			s.container[0].style.cursor = 'grab';
		}
		/*=========================
		 Update on Images Ready
		 ===========================*/
		s.imagesToLoad = [];
		s.imagesLoaded = 0;

		s.loadImage = function(imgElement, src, srcset, checkForComplete, callback) {
			var image;

			function onReady() {
				if(callback) callback();
			}

			if(!imgElement.complete || !checkForComplete) {
				if(src) {
					image = new window.Image();
					image.onload = onReady;
					image.onerror = onReady;
					if(srcset) {
						image.srcset = srcset;
					}
					if(src) {
						image.src = src;
					}
				} else {
					onReady();
				}

			} else { //image already loaded...
				onReady();
			}
		};
		s.preloadImages = function() {
			s.imagesToLoad = s.container.find('img');

			function _onReady() {
				if(typeof s === 'undefined' || s === null) return;
				if(s.imagesLoaded !== undefined) s.imagesLoaded++;
				if(s.imagesLoaded === s.imagesToLoad.length) {
					if(s.params.updateOnImagesReady) s.update();
					s.emit('onImagesReady', s);
				}
			}

			for(var i = 0; i < s.imagesToLoad.length; i++) {
				s.loadImage(s.imagesToLoad[i], (s.imagesToLoad[i].currentSrc || s.imagesToLoad[i].getAttribute('src')), (s.imagesToLoad[i].srcset || s.imagesToLoad[i].getAttribute('srcset')), true, _onReady);
			}
		};

		/*=========================
		 Autoplay
		 ===========================*/
		s.autoplayTimeoutId = undefined;
		s.autoplaying = false;
		s.autoplayPaused = false;

		function autoplay() {
			s.autoplayTimeoutId = setTimeout(function() {
				if(s.params.loop) {
					s.fixLoop();
					s._slideNext();
					s.emit('onAutoplay', s);
				} else {
					if(!s.isEnd) {
						s._slideNext();
						s.emit('onAutoplay', s);
					} else {
						if(!params.autoplayStopOnLast) {
							s._slideTo(0);
							s.emit('onAutoplay', s);
						} else {
							s.stopAutoplay();
						}
					}
				}
			}, s.params.autoplay);
		}

		s.startAutoplay = function() {
			if(typeof s.autoplayTimeoutId !== 'undefined') return false;
			if(!s.params.autoplay) return false;
			if(s.autoplaying) return false;
			s.autoplaying = true;
			s.emit('onAutoplayStart', s);
			autoplay();
		};
		s.stopAutoplay = function(internal) {
			if(!s.autoplayTimeoutId) return;
			if(s.autoplayTimeoutId) clearTimeout(s.autoplayTimeoutId);
			s.autoplaying = false;
			s.autoplayTimeoutId = undefined;
			s.emit('onAutoplayStop', s);
		};
		s.pauseAutoplay = function(speed) {
			if(s.autoplayPaused) return;
			if(s.autoplayTimeoutId) clearTimeout(s.autoplayTimeoutId);
			s.autoplayPaused = true;
			if(speed === 0) {
				s.autoplayPaused = false;
				autoplay();
			} else {
				s.wrapper.transitionEnd(function() {
					if(!s) return;
					s.autoplayPaused = false;
					if(!s.autoplaying) {
						s.stopAutoplay();
					} else {
						autoplay();
					}
				});
			}
		};
		/*=========================
		 Min/Max Translate
		 ===========================*/
		s.minTranslate = function() {
			return(-s.snapGrid[0]);
		};
		s.maxTranslate = function() {
			return(-s.snapGrid[s.snapGrid.length - 1]);
		};
		/*=========================
		 Slider/slides sizes
		 ===========================*/
		s.updateAutoHeight = function() {
			// Update Height
			var slide = s.slides.eq(s.activeIndex)[0];
			if(typeof slide !== 'undefined') {
				var newHeight = slide.offsetHeight;
				if(newHeight) s.wrapper.css('height', newHeight + 'px');
			}
		};
		s.updateContainerSize = function() {
			var width, height;
			if(typeof s.params.width !== 'undefined') {
				width = s.params.width;
			} else {
				width = s.container[0].clientWidth;
			}
			if(typeof s.params.height !== 'undefined') {
				height = s.params.height;
			} else {
				height = s.container[0].clientHeight;
			}
			if(width === 0 && s.isHorizontal() || height === 0 && !s.isHorizontal()) {
				return;
			}

			//Subtract paddings
			width = width - parseInt(s.container.css('padding-left'), 10) - parseInt(s.container.css('padding-right'), 10);
			height = height - parseInt(s.container.css('padding-top'), 10) - parseInt(s.container.css('padding-bottom'), 10);

			// Store values
			s.width = width;
			s.height = height;
			s.size = s.isHorizontal() ? s.width : s.height;
		};

		s.updateSlidesSize = function() {
			s.slides = s.wrapper.children('.' + s.params.slideClass);
			s.snapGrid = [];
			s.slidesGrid = [];
			s.slidesSizesGrid = [];

			var spaceBetween = s.params.spaceBetween,
				slidePosition = -s.params.slidesOffsetBefore,
				i,
				prevSlideSize = 0,
				index = 0;
			if(typeof s.size === 'undefined') return;
			if(typeof spaceBetween === 'string' && spaceBetween.indexOf('%') >= 0) {
				spaceBetween = parseFloat(spaceBetween.replace('%', '')) / 100 * s.size;
			}

			s.virtualSize = -spaceBetween;
			// reset margins
			if(s.rtl) s.slides.css({ marginLeft: '', marginTop: '' });
			else s.slides.css({ marginRight: '', marginBottom: '' });

			var slidesNumberEvenToRows;
			if(s.params.slidesPerColumn > 1) {
				if(Math.floor(s.slides.length / s.params.slidesPerColumn) === s.slides.length / s.params.slidesPerColumn) {
					slidesNumberEvenToRows = s.slides.length;
				} else {
					slidesNumberEvenToRows = Math.ceil(s.slides.length / s.params.slidesPerColumn) * s.params.slidesPerColumn;
				}
				if(s.params.slidesPerView !== 'auto' && s.params.slidesPerColumnFill === 'row') {
					slidesNumberEvenToRows = Math.max(slidesNumberEvenToRows, s.params.slidesPerView * s.params.slidesPerColumn);
				}
			}

			// Calc slides
			var slideSize;
			var slidesPerColumn = s.params.slidesPerColumn;
			var slidesPerRow = slidesNumberEvenToRows / slidesPerColumn;
			var numFullColumns = slidesPerRow - (s.params.slidesPerColumn * slidesPerRow - s.slides.length);
			for(i = 0; i < s.slides.length; i++) {
				slideSize = 0;
				var slide = s.slides.eq(i);
				if(s.params.slidesPerColumn > 1) {
					// Set slides order
					var newSlideOrderIndex;
					var column, row;
					if(s.params.slidesPerColumnFill === 'column') {
						column = Math.floor(i / slidesPerColumn);
						row = i - column * slidesPerColumn;
						if(column > numFullColumns || (column === numFullColumns && row === slidesPerColumn - 1)) {
							if(++row >= slidesPerColumn) {
								row = 0;
								column++;
							}
						}
						newSlideOrderIndex = column + row * slidesNumberEvenToRows / slidesPerColumn;
						slide
							.css({
								'-webkit-box-ordinal-group': newSlideOrderIndex,
								'-moz-box-ordinal-group': newSlideOrderIndex,
								'-ms-flex-order': newSlideOrderIndex,
								'-webkit-order': newSlideOrderIndex,
								'order': newSlideOrderIndex
							});
					} else {
						row = Math.floor(i / slidesPerRow);
						column = i - row * slidesPerRow;
					}
					slide
						.css({
							'margin-top': (row !== 0 && s.params.spaceBetween) && (s.params.spaceBetween + 'px')
						})
						.attr('data-swiper-column', column)
						.attr('data-swiper-row', row);

				}
				if(slide.css('display') === 'none') continue;
				if(s.params.slidesPerView === 'auto') {
					slideSize = s.isHorizontal() ? slide.outerWidth(true) : slide.outerHeight(true);
					if(s.params.roundLengths) slideSize = round(slideSize);
				} else {
					slideSize = (s.size - (s.params.slidesPerView - 1) * spaceBetween) / s.params.slidesPerView;
					if(s.params.roundLengths) slideSize = round(slideSize);

					if(s.isHorizontal()) {
						s.slides[i].style.width = slideSize + 'px';
					} else {
						s.slides[i].style.height = slideSize + 'px';
					}
				}
				s.slides[i].swiperSlideSize = slideSize;
				s.slidesSizesGrid.push(slideSize);

				if(s.params.centeredSlides) {
					slidePosition = slidePosition + slideSize / 2 + prevSlideSize / 2 + spaceBetween;
					if(i === 0) slidePosition = slidePosition - s.size / 2 - spaceBetween;
					if(Math.abs(slidePosition) < 1 / 1000) slidePosition = 0;
					if((index) % s.params.slidesPerGroup === 0) s.snapGrid.push(slidePosition);
					s.slidesGrid.push(slidePosition);
				} else {
					if((index) % s.params.slidesPerGroup === 0) s.snapGrid.push(slidePosition);
					s.slidesGrid.push(slidePosition);
					slidePosition = slidePosition + slideSize + spaceBetween;
				}

				s.virtualSize += slideSize + spaceBetween;

				prevSlideSize = slideSize;

				index++;
			}
			s.virtualSize = Math.max(s.virtualSize, s.size) + s.params.slidesOffsetAfter;
			var newSlidesGrid;

			if(
				s.rtl && s.wrongRTL && (s.params.effect === 'slide' || s.params.effect === 'coverflow')) {
				s.wrapper.css({ width: s.virtualSize + s.params.spaceBetween + 'px' });
			}
			if(!s.support.flexbox || s.params.setWrapperSize) {
				if(s.isHorizontal()) s.wrapper.css({ width: s.virtualSize + s.params.spaceBetween + 'px' });
				else s.wrapper.css({ height: s.virtualSize + s.params.spaceBetween + 'px' });
			}

			if(s.params.slidesPerColumn > 1) {
				s.virtualSize = (slideSize + s.params.spaceBetween) * slidesNumberEvenToRows;
				s.virtualSize = Math.ceil(s.virtualSize / s.params.slidesPerColumn) - s.params.spaceBetween;
				s.wrapper.css({ width: s.virtualSize + s.params.spaceBetween + 'px' });
				if(s.params.centeredSlides) {
					newSlidesGrid = [];
					for(i = 0; i < s.snapGrid.length; i++) {
						if(s.snapGrid[i] < s.virtualSize + s.snapGrid[0]) newSlidesGrid.push(s.snapGrid[i]);
					}
					s.snapGrid = newSlidesGrid;
				}
			}

			// Remove last grid elements depending on width
			if(!s.params.centeredSlides) {
				newSlidesGrid = [];
				for(i = 0; i < s.snapGrid.length; i++) {
					if(s.snapGrid[i] <= s.virtualSize - s.size) {
						newSlidesGrid.push(s.snapGrid[i]);
					}
				}
				s.snapGrid = newSlidesGrid;
				if(Math.floor(s.virtualSize - s.size) - Math.floor(s.snapGrid[s.snapGrid.length - 1]) > 1) {
					s.snapGrid.push(s.virtualSize - s.size);
				}
			}
			if(s.snapGrid.length === 0) s.snapGrid = [0];

			if(s.params.spaceBetween !== 0) {
				if(s.isHorizontal()) {
					if(s.rtl) s.slides.css({ marginLeft: spaceBetween + 'px' });
					else s.slides.css({ marginRight: spaceBetween + 'px' });
				} else s.slides.css({ marginBottom: spaceBetween + 'px' });
			}
			if(s.params.watchSlidesProgress) {
				s.updateSlidesOffset();
			}
		};
		s.updateSlidesOffset = function() {
			for(var i = 0; i < s.slides.length; i++) {
				s.slides[i].swiperSlideOffset = s.isHorizontal() ? s.slides[i].offsetLeft : s.slides[i].offsetTop;
			}
		};

		/*=========================
		 Slider/slides progress
		 ===========================*/
		s.updateSlidesProgress = function(translate) {
			if(typeof translate === 'undefined') {
				translate = s.translate || 0;
			}
			if(s.slides.length === 0) return;
			if(typeof s.slides[0].swiperSlideOffset === 'undefined') s.updateSlidesOffset();

			var offsetCenter = -translate;
			if(s.rtl) offsetCenter = translate;

			// Visible Slides
			s.slides.removeClass(s.params.slideVisibleClass);
			for(var i = 0; i < s.slides.length; i++) {
				var slide = s.slides[i];
				var slideProgress = (offsetCenter - slide.swiperSlideOffset) / (slide.swiperSlideSize + s.params.spaceBetween);
				if(s.params.watchSlidesVisibility) {
					var slideBefore = -(offsetCenter - slide.swiperSlideOffset);
					var slideAfter = slideBefore + s.slidesSizesGrid[i];
					var isVisible =
						(slideBefore >= 0 && slideBefore < s.size) ||
						(slideAfter > 0 && slideAfter <= s.size) ||
						(slideBefore <= 0 && slideAfter >= s.size);
					if(isVisible) {
						s.slides.eq(i).addClass(s.params.slideVisibleClass);
					}
				}
				slide.progress = s.rtl ? -slideProgress : slideProgress;
			}
		};
		s.updateProgress = function(translate) {
			if(typeof translate === 'undefined') {
				translate = s.translate || 0;
			}
			var translatesDiff = s.maxTranslate() - s.minTranslate();
			var wasBeginning = s.isBeginning;
			var wasEnd = s.isEnd;
			if(translatesDiff === 0) {
				s.progress = 0;
				s.isBeginning = s.isEnd = true;
			} else {
				s.progress = (translate - s.minTranslate()) / (translatesDiff);
				s.isBeginning = s.progress <= 0;
				s.isEnd = s.progress >= 1;
			}
			if(s.isBeginning && !wasBeginning) s.emit('onReachBeginning', s);
			if(s.isEnd && !wasEnd) s.emit('onReachEnd', s);

			if(s.params.watchSlidesProgress) s.updateSlidesProgress(translate);
			s.emit('onProgress', s, s.progress);
		};
		s.updateActiveIndex = function() {
			var translate = s.rtl ? s.translate : -s.translate;
			var newActiveIndex, i, snapIndex;
			for(i = 0; i < s.slidesGrid.length; i++) {
				if(typeof s.slidesGrid[i + 1] !== 'undefined') {
					if(translate >= s.slidesGrid[i] && translate < s.slidesGrid[i + 1] - (s.slidesGrid[i + 1] - s.slidesGrid[i]) / 2) {
						newActiveIndex = i;
					} else if(translate >= s.slidesGrid[i] && translate < s.slidesGrid[i + 1]) {
						newActiveIndex = i + 1;
					}
				} else {
					if(translate >= s.slidesGrid[i]) {
						newActiveIndex = i;
					}
				}
			}
			// Normalize slideIndex
			if(newActiveIndex < 0 || typeof newActiveIndex === 'undefined') newActiveIndex = 0;
			// for (i = 0; i < s.slidesGrid.length; i++) {
			// if (- translate >= s.slidesGrid[i]) {
			// newActiveIndex = i;
			// }
			// }
			snapIndex = Math.floor(newActiveIndex / s.params.slidesPerGroup);
			if(snapIndex >= s.snapGrid.length) snapIndex = s.snapGrid.length - 1;

			if(newActiveIndex === s.activeIndex) {
				return;
			}
			s.snapIndex = snapIndex;
			s.previousIndex = s.activeIndex;
			s.activeIndex = newActiveIndex;
			s.updateClasses();
		};

		/*=========================
		 Classes
		 ===========================*/
		s.updateClasses = function() {
			s.slides.removeClass(s.params.slideActiveClass + ' ' + s.params.slideNextClass + ' ' + s.params.slidePrevClass);
			var activeSlide = s.slides.eq(s.activeIndex);
			// Active classes
			activeSlide.addClass(s.params.slideActiveClass);
			// Next Slide
			var nextSlide = activeSlide.next('.' + s.params.slideClass).addClass(s.params.slideNextClass);
			if(s.params.loop && nextSlide.length === 0) {
				s.slides.eq(0).addClass(s.params.slideNextClass);
			}
			// Prev Slide
			var prevSlide = activeSlide.prev('.' + s.params.slideClass).addClass(s.params.slidePrevClass);
			if(s.params.loop && prevSlide.length === 0) {
				s.slides.eq(-1).addClass(s.params.slidePrevClass);
			}

			// Pagination
			if(s.paginationContainer && s.paginationContainer.length > 0) {
				// Current/Total
				var current,
					total = s.params.loop ? Math.ceil((s.slides.length - s.loopedSlides * 2) / s.params.slidesPerGroup) : s.snapGrid.length;
				if(s.params.loop) {
					current = Math.ceil((s.activeIndex - s.loopedSlides) / s.params.slidesPerGroup);
					if(current > s.slides.length - 1 - s.loopedSlides * 2) {
						current = current - (s.slides.length - s.loopedSlides * 2);
					}
					if(current > total - 1) current = current - total;
					if(current < 0 && s.params.paginationType !== 'bullets') current = total + current;
				} else {
					if(typeof s.snapIndex !== 'undefined') {
						current = s.snapIndex;
					} else {
						current = s.activeIndex || 0;
					}
				}
				// Types
				if(s.params.paginationType === 'bullets' && s.bullets && s.bullets.length > 0) {
					s.bullets.removeClass(s.params.bulletActiveClass);
					if(s.paginationContainer.length > 1) {
						s.bullets.each(function() {
							if($(this).index() === current) $(this).addClass(s.params.bulletActiveClass);
						});
					} else {
						s.bullets.eq(current).addClass(s.params.bulletActiveClass);
					}
				}
				if(s.params.paginationType === 'fraction') {
					s.paginationContainer.find('.' + s.params.paginationCurrentClass).text(current + 1);
					s.paginationContainer.find('.' + s.params.paginationTotalClass).text(total);
				}
				if(s.params.paginationType === 'progress') {
					var scale = (current + 1) / total,
						scaleX = scale,
						scaleY = 1;
					if(!s.isHorizontal()) {
						scaleY = scale;
						scaleX = 1;
					}
					s.paginationContainer.find('.' + s.params.paginationProgressbarClass).transform('translate3d(0,0,0) scaleX(' + scaleX + ') scaleY(' + scaleY + ')').transition(s.params.speed);
				}
				if(s.params.paginationType === 'custom' && s.params.paginationCustomRender) {
					s.paginationContainer.html(s.params.paginationCustomRender(s, current + 1, total));
					s.emit('onPaginationRendered', s, s.paginationContainer[0]);
				}
			}

			// Next/active buttons
			if(!s.params.loop) {
				if(s.params.prevButton && s.prevButton && s.prevButton.length > 0) {
					if(s.isBeginning) {
						s.prevButton.addClass(s.params.buttonDisabledClass);
						if(s.params.a11y && s.a11y) s.a11y.disable(s.prevButton);
					} else {
						s.prevButton.removeClass(s.params.buttonDisabledClass);
						if(s.params.a11y && s.a11y) s.a11y.enable(s.prevButton);
					}
				}
				if(s.params.nextButton && s.nextButton && s.nextButton.length > 0) {
					if(s.isEnd) {
						s.nextButton.addClass(s.params.buttonDisabledClass);
						if(s.params.a11y && s.a11y) s.a11y.disable(s.nextButton);
					} else {
						s.nextButton.removeClass(s.params.buttonDisabledClass);
						if(s.params.a11y && s.a11y) s.a11y.enable(s.nextButton);
					}
				}
			}
		};

		/*=========================
		 Pagination
		 ===========================*/
		s.updatePagination = function() {
			if(!s.params.pagination) return;
			if(s.paginationContainer && s.paginationContainer.length > 0) {
				var paginationHTML = '';
				if(s.params.paginationType === 'bullets') {
					var numberOfBullets = s.params.loop ? Math.ceil((s.slides.length - s.loopedSlides * 2) / s.params.slidesPerGroup) : s.snapGrid.length;
					for(var i = 0; i < numberOfBullets; i++) {
						if(s.params.paginationBulletRender) {
							paginationHTML += s.params.paginationBulletRender(i, s.params.bulletClass);
						} else {
							paginationHTML += '<' + s.params.paginationElement + ' class="' + s.params.bulletClass + '"></' + s.params.paginationElement + '>';
						}
					}
					s.paginationContainer.html(paginationHTML);
					s.bullets = s.paginationContainer.find('.' + s.params.bulletClass);
					if(s.params.paginationClickable && s.params.a11y && s.a11y) {
						s.a11y.initPagination();
					}
				}
				if(s.params.paginationType === 'fraction') {
					if(s.params.paginationFractionRender) {
						paginationHTML = s.params.paginationFractionRender(s, s.params.paginationCurrentClass, s.params.paginationTotalClass);
					} else {
						paginationHTML =
							'<span class="' + s.params.paginationCurrentClass + '"></span>' +
							' / ' +
							'<span class="' + s.params.paginationTotalClass + '"></span>';
					}
					s.paginationContainer.html(paginationHTML);
				}
				if(s.params.paginationType === 'progress') {
					if(s.params.paginationProgressRender) {
						paginationHTML = s.params.paginationProgressRender(s, s.params.paginationProgressbarClass);
					} else {
						paginationHTML = '<span class="' + s.params.paginationProgressbarClass + '"></span>';
					}
					s.paginationContainer.html(paginationHTML);
				}
				if(s.params.paginationType !== 'custom') {
					s.emit('onPaginationRendered', s, s.paginationContainer[0]);
				}
			}
		};
		/*=========================
		 Common update method
		 ===========================*/
		s.update = function(updateTranslate) {
			s.updateContainerSize();
			s.updateSlidesSize();
			s.updateProgress();
			s.updatePagination();
			s.updateClasses();
			if(s.params.scrollbar && s.scrollbar) {
				s.scrollbar.set();
			}

			function forceSetTranslate() {
				newTranslate = Math.min(Math.max(s.translate, s.maxTranslate()), s.minTranslate());
				s.setWrapperTranslate(newTranslate);
				s.updateActiveIndex();
				s.updateClasses();
			}

			if(updateTranslate) {
				var translated, newTranslate;
				if(s.controller && s.controller.spline) {
					s.controller.spline = undefined;
				}
				if(s.params.freeMode) {
					forceSetTranslate();
					if(s.params.autoHeight) {
						s.updateAutoHeight();
					}
				} else {
					if((s.params.slidesPerView === 'auto' || s.params.slidesPerView > 1) && s.isEnd && !s.params.centeredSlides) {
						translated = s.slideTo(s.slides.length - 1, 0, false, true);
					} else {
						translated = s.slideTo(s.activeIndex, 0, false, true);
					}
					if(!translated) {
						forceSetTranslate();
					}
				}
			} else if(s.params.autoHeight) {
				s.updateAutoHeight();
			}
		};

		/*=========================
		 Resize Handler
		 ===========================*/
		s.onResize = function(forceUpdatePagination) {
			//Breakpoints
			if(s.params.breakpoints) {
				s.setBreakpoint();
			}

			// Disable locks on resize
			var allowSwipeToPrev = s.params.allowSwipeToPrev;
			var allowSwipeToNext = s.params.allowSwipeToNext;
			s.params.allowSwipeToPrev = s.params.allowSwipeToNext = true;

			s.updateContainerSize();
			s.updateSlidesSize();
			if(s.params.slidesPerView === 'auto' || s.params.freeMode || forceUpdatePagination) s.updatePagination();
			if(s.params.scrollbar && s.scrollbar) {
				s.scrollbar.set();
			}
			if(s.controller && s.controller.spline) {
				s.controller.spline = undefined;
			}
			var slideChangedBySlideTo = false;
			if(s.params.freeMode) {
				var newTranslate = Math.min(Math.max(s.translate, s.maxTranslate()), s.minTranslate());
				s.setWrapperTranslate(newTranslate);
				s.updateActiveIndex();
				s.updateClasses();

				if(s.params.autoHeight) {
					s.updateAutoHeight();
				}
			} else {
				s.updateClasses();
				if((s.params.slidesPerView === 'auto' || s.params.slidesPerView > 1) && s.isEnd && !s.params.centeredSlides) {
					slideChangedBySlideTo = s.slideTo(s.slides.length - 1, 0, false, true);
				} else {
					slideChangedBySlideTo = s.slideTo(s.activeIndex, 0, false, true);
				}
			}
			if(s.params.lazyLoading && !slideChangedBySlideTo && s.lazy) {
				s.lazy.load();
			}
			// Return locks after resize
			s.params.allowSwipeToPrev = allowSwipeToPrev;
			s.params.allowSwipeToNext = allowSwipeToNext;
		};

		/*=========================
		 Events
		 ===========================*/

		//Define Touch Events
		var desktopEvents = ['mousedown', 'mousemove', 'mouseup'];
		if(window.navigator.pointerEnabled) desktopEvents = ['pointerdown', 'pointermove', 'pointerup'];
		else if(window.navigator.msPointerEnabled) desktopEvents = ['MSPointerDown', 'MSPointerMove', 'MSPointerUp'];
		s.touchEvents = {
			start: s.support.touch || !s.params.simulateTouch ? 'touchstart' : desktopEvents[0],
			move: s.support.touch || !s.params.simulateTouch ? 'touchmove' : desktopEvents[1],
			end: s.support.touch || !s.params.simulateTouch ? 'touchend' : desktopEvents[2]
		};

		// WP8 Touch Events Fix
		if(window.navigator.pointerEnabled || window.navigator.msPointerEnabled) {
			(s.params.touchEventsTarget === 'container' ? s.container : s.wrapper).addClass('swiper-wp8-' + s.params.direction);
		}

		// Attach/detach events
		s.initEvents = function(detach) {
			var actionDom = detach ? 'off' : 'on';
			var action = detach ? 'removeEventListener' : 'addEventListener';
			var touchEventsTarget = s.params.touchEventsTarget === 'container' ? s.container[0] : s.wrapper[0];
			var target = s.support.touch ? touchEventsTarget : document;

			var moveCapture = s.params.nested ? true : false;

			//Touch Events
			if(s.browser.ie) {
				touchEventsTarget[action](s.touchEvents.start, s.onTouchStart, false);
				target[action](s.touchEvents.move, s.onTouchMove, moveCapture);
				target[action](s.touchEvents.end, s.onTouchEnd, false);
			} else {
				if(s.support.touch) {
					touchEventsTarget[action](s.touchEvents.start, s.onTouchStart, false);
					touchEventsTarget[action](s.touchEvents.move, s.onTouchMove, moveCapture);
					touchEventsTarget[action](s.touchEvents.end, s.onTouchEnd, false);
				}
				if(params.simulateTouch && !s.device.ios && !s.device.android) {
					touchEventsTarget[action]('mousedown', s.onTouchStart, false);
					document[action]('mousemove', s.onTouchMove, moveCapture);
					document[action]('mouseup', s.onTouchEnd, false);
				}
			}
			window[action]('resize', s.onResize);

			// Next, Prev, Index
			if(s.params.nextButton && s.nextButton && s.nextButton.length > 0) {
				s.nextButton[actionDom]('click', s.onClickNext);
				if(s.params.a11y && s.a11y) s.nextButton[actionDom]('keydown', s.a11y.onEnterKey);
			}
			if(s.params.prevButton && s.prevButton && s.prevButton.length > 0) {
				s.prevButton[actionDom]('click', s.onClickPrev);
				if(s.params.a11y && s.a11y) s.prevButton[actionDom]('keydown', s.a11y.onEnterKey);
			}
			if(s.params.pagination && s.params.paginationClickable) {
				s.paginationContainer[actionDom]('click', '.' + s.params.bulletClass, s.onClickIndex);
				if(s.params.a11y && s.a11y) s.paginationContainer[actionDom]('keydown', '.' + s.params.bulletClass, s.a11y.onEnterKey);
			}

			// Prevent Links Clicks
			if(s.params.preventClicks || s.params.preventClicksPropagation) touchEventsTarget[action]('click', s.preventClicks, true);
		};
		s.attachEvents = function() {
			s.initEvents();
		};
		s.detachEvents = function() {
			s.initEvents(true);
		};

		/*=========================
		 Handle Clicks
		 ===========================*/
		// Prevent Clicks
		s.allowClick = true;
		s.preventClicks = function(e) {
			if(!s.allowClick) {
				if(s.params.preventClicks) e.preventDefault();
				if(s.params.preventClicksPropagation && s.animating) {
					e.stopPropagation();
					e.stopImmediatePropagation();
				}
			}
		};
		// Clicks
		s.onClickNext = function(e) {
			e.preventDefault();
			if(s.isEnd && !s.params.loop) return;
			s.slideNext();
		};
		s.onClickPrev = function(e) {
			e.preventDefault();
			if(s.isBeginning && !s.params.loop) return;
			s.slidePrev();
		};
		s.onClickIndex = function(e) {
			e.preventDefault();
			var index = $(this).index() * s.params.slidesPerGroup;
			if(s.params.loop) index = index + s.loopedSlides;
			s.slideTo(index);
		};

		/*=========================
		 Handle Touches
		 ===========================*/
		function findElementInEvent(e, selector) {
			var el = $(e.target);
			if(!el.is(selector)) {
				if(typeof selector === 'string') {
					el = el.parents(selector);
				} else if(selector.nodeType) {
					var found;
					el.parents().each(function(index, _el) {
						if(_el === selector) found = selector;
					});
					if(!found) return undefined;
					else return selector;
				}
			}
			if(el.length === 0) {
				return undefined;
			}
			return el[0];
		}

		s.updateClickedSlide = function(e) {
			var slide = findElementInEvent(e, '.' + s.params.slideClass);
			var slideFound = false;
			if(slide) {
				for(var i = 0; i < s.slides.length; i++) {
					if(s.slides[i] === slide) slideFound = true;
				}
			}

			if(slide && slideFound) {
				s.clickedSlide = slide;
				s.clickedIndex = $(slide).index();
			} else {
				s.clickedSlide = undefined;
				s.clickedIndex = undefined;
				return;
			}
			if(s.params.slideToClickedSlide && s.clickedIndex !== undefined && s.clickedIndex !== s.activeIndex) {
				var slideToIndex = s.clickedIndex,
					realIndex,
					duplicatedSlides;
				if(s.params.loop) {
					if(s.animating) return;
					realIndex = $(s.clickedSlide).attr('data-swiper-slide-index');
					if(s.params.centeredSlides) {
						if((slideToIndex < s.loopedSlides - s.params.slidesPerView / 2) || (slideToIndex > s.slides.length - s.loopedSlides + s.params.slidesPerView / 2)) {
							s.fixLoop();
							slideToIndex = s.wrapper.children('.' + s.params.slideClass + '[data-swiper-slide-index="' + realIndex + '"]:not(.swiper-slide-duplicate)').eq(0).index();
							setTimeout(function() {
								s.slideTo(slideToIndex);
							}, 0);
						} else {
							s.slideTo(slideToIndex);
						}
					} else {
						if(slideToIndex > s.slides.length - s.params.slidesPerView) {
							s.fixLoop();
							slideToIndex = s.wrapper.children('.' + s.params.slideClass + '[data-swiper-slide-index="' + realIndex + '"]:not(.swiper-slide-duplicate)').eq(0).index();
							setTimeout(function() {
								s.slideTo(slideToIndex);
							}, 0);
						} else {
							s.slideTo(slideToIndex);
						}
					}
				} else {
					s.slideTo(slideToIndex);
				}
			}
		};

		var isTouched,
			isMoved,
			allowTouchCallbacks,
			touchStartTime,
			isScrolling,
			currentTranslate,
			startTranslate,
			allowThresholdMove,
			// Form elements to match
			formElements = 'input, select, textarea, button',
			// Last click time
			lastClickTime = Date.now(),
			clickTimeout,
			//Velocities
			velocities = [],
			allowMomentumBounce;

		// Animating Flag
		s.animating = false;

		// Touches information
		s.touches = {
			startX: 0,
			startY: 0,
			currentX: 0,
			currentY: 0,
			diff: 0
		};

		// Touch handlers
		var isTouchEvent, startMoving;
		s.onTouchStart = function(e) {
			if(e.originalEvent) e = e.originalEvent;
			isTouchEvent = e.type === 'touchstart';
			if(!isTouchEvent && 'which' in e && e.which === 3) return;
			if(s.params.noSwiping && findElementInEvent(e, '.' + s.params.noSwipingClass)) {
				s.allowClick = true;
				return;
			}
			if(s.params.swipeHandler) {
				if(!findElementInEvent(e, s.params.swipeHandler)) return;
			}

			var startX = s.touches.currentX = e.type === 'touchstart' ? e.targetTouches[0].pageX : e.pageX;
			var startY = s.touches.currentY = e.type === 'touchstart' ? e.targetTouches[0].pageY : e.pageY;

			// Do NOT start if iOS edge swipe is detected. Otherwise iOS app (UIWebView) cannot swipe-to-go-back anymore
			if(s.device.ios && s.params.iOSEdgeSwipeDetection && startX <= s.params.iOSEdgeSwipeThreshold) {
				return;
			}

			isTouched = true;
			isMoved = false;
			allowTouchCallbacks = true;
			isScrolling = undefined;
			startMoving = undefined;
			s.touches.startX = startX;
			s.touches.startY = startY;
			touchStartTime = Date.now();
			s.allowClick = true;
			s.updateContainerSize();
			s.swipeDirection = undefined;
			if(s.params.threshold > 0) allowThresholdMove = false;
			if(e.type !== 'touchstart') {
				var preventDefault = true;
				if($(e.target).is(formElements)) preventDefault = false;
				if(document.activeElement && $(document.activeElement).is(formElements)) {
					document.activeElement.blur();
				}
				if(preventDefault) {
					e.preventDefault();
				}
			}
			s.emit('onTouchStart', s, e);
		};

		s.onTouchMove = function(e) {
			if(e.originalEvent) e = e.originalEvent;
			if(isTouchEvent && e.type === 'mousemove') return;
			if(e.preventedByNestedSwiper) {
				s.touches.startX = e.type === 'touchmove' ? e.targetTouches[0].pageX : e.pageX;
				s.touches.startY = e.type === 'touchmove' ? e.targetTouches[0].pageY : e.pageY;
				return;
			}
			if(s.params.onlyExternal) {
				// isMoved = true;
				s.allowClick = false;
				if(isTouched) {
					s.touches.startX = s.touches.currentX = e.type === 'touchmove' ? e.targetTouches[0].pageX : e.pageX;
					s.touches.startY = s.touches.currentY = e.type === 'touchmove' ? e.targetTouches[0].pageY : e.pageY;
					touchStartTime = Date.now();
				}
				return;
			}
			if(isTouchEvent && document.activeElement) {
				if(e.target === document.activeElement && $(e.target).is(formElements)) {
					isMoved = true;
					s.allowClick = false;
					return;
				}
			}
			if(allowTouchCallbacks) {
				s.emit('onTouchMove', s, e);
			}
			if(e.targetTouches && e.targetTouches.length > 1) return;

			s.touches.currentX = e.type === 'touchmove' ? e.targetTouches[0].pageX : e.pageX;
			s.touches.currentY = e.type === 'touchmove' ? e.targetTouches[0].pageY : e.pageY;

			if(typeof isScrolling === 'undefined') {
				var touchAngle = Math.atan2(Math.abs(s.touches.currentY - s.touches.startY), Math.abs(s.touches.currentX - s.touches.startX)) * 180 / Math.PI;
				isScrolling = s.isHorizontal() ? touchAngle > s.params.touchAngle : (90 - touchAngle > s.params.touchAngle);
			}
			if(isScrolling) {
				s.emit('onTouchMoveOpposite', s, e);
			}
			if(typeof startMoving === 'undefined' && s.browser.ieTouch) {
				if(s.touches.currentX !== s.touches.startX || s.touches.currentY !== s.touches.startY) {
					startMoving = true;
				}
			}
			if(!isTouched) return;
			if(isScrolling) {
				isTouched = false;
				return;
			}
			if(!startMoving && s.browser.ieTouch) {
				return;
			}
			s.allowClick = false;
			s.emit('onSliderMove', s, e);
			e.preventDefault();
			if(s.params.touchMoveStopPropagation && !s.params.nested) {
				e.stopPropagation();
			}

			if(!isMoved) {
				if(params.loop) {
					s.fixLoop();
				}
				startTranslate = s.getWrapperTranslate();
				s.setWrapperTransition(0);
				if(s.animating) {
					s.wrapper.trigger('webkitTransitionEnd transitionend oTransitionEnd MSTransitionEnd msTransitionEnd');
				}
				if(s.params.autoplay && s.autoplaying) {
					if(s.params.autoplayDisableOnInteraction) {
						s.stopAutoplay();
					} else {
						s.pauseAutoplay();
					}
				}
				allowMomentumBounce = false;
				//Grab Cursor
				if(s.params.grabCursor) {
					s.container[0].style.cursor = 'move';
					s.container[0].style.cursor = '-webkit-grabbing';
					s.container[0].style.cursor = '-moz-grabbin';
					s.container[0].style.cursor = 'grabbing';
				}
			}
			isMoved = true;

			var diff = s.touches.diff = s.isHorizontal() ? s.touches.currentX - s.touches.startX : s.touches.currentY - s.touches.startY;

			diff = diff * s.params.touchRatio;
			if(s.rtl) diff = -diff;

			s.swipeDirection = diff > 0 ? 'prev' : 'next';
			currentTranslate = diff + startTranslate;

			var disableParentSwiper = true;
			if((diff > 0 && currentTranslate > s.minTranslate())) {
				disableParentSwiper = false;
				if(s.params.resistance) currentTranslate = s.minTranslate() - 1 + Math.pow(-s.minTranslate() + startTranslate + diff, s.params.resistanceRatio);
			} else if(diff < 0 && currentTranslate < s.maxTranslate()) {
				disableParentSwiper = false;
				if(s.params.resistance) currentTranslate = s.maxTranslate() + 1 - Math.pow(s.maxTranslate() - startTranslate - diff, s.params.resistanceRatio);
			}

			if(disableParentSwiper) {
				e.preventedByNestedSwiper = true;
			}

			// Directions locks
			if(!s.params.allowSwipeToNext && s.swipeDirection === 'next' && currentTranslate < startTranslate) {
				currentTranslate = startTranslate;
			}
			if(!s.params.allowSwipeToPrev && s.swipeDirection === 'prev' && currentTranslate > startTranslate) {
				currentTranslate = startTranslate;
			}

			if(!s.params.followFinger) return;

			// Threshold
			if(s.params.threshold > 0) {
				if(Math.abs(diff) > s.params.threshold || allowThresholdMove) {
					if(!allowThresholdMove) {
						allowThresholdMove = true;
						s.touches.startX = s.touches.currentX;
						s.touches.startY = s.touches.currentY;
						currentTranslate = startTranslate;
						s.touches.diff = s.isHorizontal() ? s.touches.currentX - s.touches.startX : s.touches.currentY - s.touches.startY;
						return;
					}
				} else {
					currentTranslate = startTranslate;
					return;
				}
			}
			// Update active index in free mode
			if(s.params.freeMode || s.params.watchSlidesProgress) {
				s.updateActiveIndex();
			}
			if(s.params.freeMode) {
				//Velocity
				if(velocities.length === 0) {
					velocities.push({
						position: s.touches[s.isHorizontal() ? 'startX' : 'startY'],
						time: touchStartTime
					});
				}
				velocities.push({
					position: s.touches[s.isHorizontal() ? 'currentX' : 'currentY'],
					time: (new window.Date()).getTime()
				});
			}
			// Update progress
			s.updateProgress(currentTranslate);
			// Update translate
			s.setWrapperTranslate(currentTranslate);
		};
		s.onTouchEnd = function(e) {
			if(e.originalEvent) e = e.originalEvent;
			if(allowTouchCallbacks) {
				s.emit('onTouchEnd', s, e);
			}
			allowTouchCallbacks = false;
			if(!isTouched) return;
			//Return Grab Cursor
			if(s.params.grabCursor && isMoved && isTouched) {
				s.container[0].style.cursor = 'move';
				s.container[0].style.cursor = '-webkit-grab';
				s.container[0].style.cursor = '-moz-grab';
				s.container[0].style.cursor = 'grab';
			}

			// Time diff
			var touchEndTime = Date.now();
			var timeDiff = touchEndTime - touchStartTime;

			// Tap, doubleTap, Click
			if(s.allowClick) {
				s.updateClickedSlide(e);
				s.emit('onTap', s, e);
				if(timeDiff < 300 && (touchEndTime - lastClickTime) > 300) {
					if(clickTimeout) clearTimeout(clickTimeout);
					clickTimeout = setTimeout(function() {
						if(!s) return;
						if(s.params.paginationHide && s.paginationContainer.length > 0 && !$(e.target).hasClass(s.params.bulletClass)) {
							s.paginationContainer.toggleClass(s.params.paginationHiddenClass);
						}
						s.emit('onClick', s, e);
					}, 300);

				}
				if(timeDiff < 300 && (touchEndTime - lastClickTime) < 300) {
					if(clickTimeout) clearTimeout(clickTimeout);
					s.emit('onDoubleTap', s, e);
				}
			}

			lastClickTime = Date.now();
			setTimeout(function() {
				if(s) s.allowClick = true;
			}, 0);

			if(!isTouched || !isMoved || !s.swipeDirection || s.touches.diff === 0 || currentTranslate === startTranslate) {
				isTouched = isMoved = false;
				return;
			}
			isTouched = isMoved = false;

			var currentPos;
			if(s.params.followFinger) {
				currentPos = s.rtl ? s.translate : -s.translate;
			} else {
				currentPos = -currentTranslate;
			}
			if(s.params.freeMode) {
				if(currentPos < -s.minTranslate()) {
					s.slideTo(s.activeIndex);
					return;
				} else if(currentPos > -s.maxTranslate()) {
					if(s.slides.length < s.snapGrid.length) {
						s.slideTo(s.snapGrid.length - 1);
					} else {
						s.slideTo(s.slides.length - 1);
					}
					return;
				}

				if(s.params.freeModeMomentum) {
					if(velocities.length > 1) {
						var lastMoveEvent = velocities.pop(),
							velocityEvent = velocities.pop();

						var distance = lastMoveEvent.position - velocityEvent.position;
						var time = lastMoveEvent.time - velocityEvent.time;
						s.velocity = distance / time;
						s.velocity = s.velocity / 2;
						if(Math.abs(s.velocity) < s.params.freeModeMinimumVelocity) {
							s.velocity = 0;
						}
						// this implies that the user stopped moving a finger then released.
						// There would be no events with distance zero, so the last event is stale.
						if(time > 150 || (new window.Date().getTime() - lastMoveEvent.time) > 300) {
							s.velocity = 0;
						}
					} else {
						s.velocity = 0;
					}

					velocities.length = 0;
					var momentumDuration = 1000 * s.params.freeModeMomentumRatio;
					var momentumDistance = s.velocity * momentumDuration;

					var newPosition = s.translate + momentumDistance;
					if(s.rtl) newPosition = -newPosition;
					var doBounce = false;
					var afterBouncePosition;
					var bounceAmount = Math.abs(s.velocity) * 20 * s.params.freeModeMomentumBounceRatio;
					if(newPosition < s.maxTranslate()) {
						if(s.params.freeModeMomentumBounce) {
							if(newPosition + s.maxTranslate() < -bounceAmount) {
								newPosition = s.maxTranslate() - bounceAmount;
							}
							afterBouncePosition = s.maxTranslate();
							doBounce = true;
							allowMomentumBounce = true;
						} else {
							newPosition = s.maxTranslate();
						}
					} else if(newPosition > s.minTranslate()) {
						if(s.params.freeModeMomentumBounce) {
							if(newPosition - s.minTranslate() > bounceAmount) {
								newPosition = s.minTranslate() + bounceAmount;
							}
							afterBouncePosition = s.minTranslate();
							doBounce = true;
							allowMomentumBounce = true;
						} else {
							newPosition = s.minTranslate();
						}
					} else if(s.params.freeModeSticky) {
						var j = 0,
							nextSlide;
						for(j = 0; j < s.snapGrid.length; j += 1) {
							if(s.snapGrid[j] > -newPosition) {
								nextSlide = j;
								break;
							}

						}
						if(Math.abs(s.snapGrid[nextSlide] - newPosition) < Math.abs(s.snapGrid[nextSlide - 1] - newPosition) || s.swipeDirection === 'next') {
							newPosition = s.snapGrid[nextSlide];
						} else {
							newPosition = s.snapGrid[nextSlide - 1];
						}
						if(!s.rtl) newPosition = -newPosition;
					}
					//Fix duration
					if(s.velocity !== 0) {
						if(s.rtl) {
							momentumDuration = Math.abs((-newPosition - s.translate) / s.velocity);
						} else {
							momentumDuration = Math.abs((newPosition - s.translate) / s.velocity);
						}
					} else if(s.params.freeModeSticky) {
						s.slideReset();
						return;
					}

					if(s.params.freeModeMomentumBounce && doBounce) {
						s.updateProgress(afterBouncePosition);
						s.setWrapperTransition(momentumDuration);
						s.setWrapperTranslate(newPosition);
						s.onTransitionStart();
						s.animating = true;
						s.wrapper.transitionEnd(function() {
							if(!s || !allowMomentumBounce) return;
							s.emit('onMomentumBounce', s);

							s.setWrapperTransition(s.params.speed);
							s.setWrapperTranslate(afterBouncePosition);
							s.wrapper.transitionEnd(function() {
								if(!s) return;
								s.onTransitionEnd();
							});
						});
					} else if(s.velocity) {
						s.updateProgress(newPosition);
						s.setWrapperTransition(momentumDuration);
						s.setWrapperTranslate(newPosition);
						s.onTransitionStart();
						if(!s.animating) {
							s.animating = true;
							s.wrapper.transitionEnd(function() {
								if(!s) return;
								s.onTransitionEnd();
							});
						}

					} else {
						s.updateProgress(newPosition);
					}

					s.updateActiveIndex();
				}
				if(!s.params.freeModeMomentum || timeDiff >= s.params.longSwipesMs) {
					s.updateProgress();
					s.updateActiveIndex();
				}
				return;
			}

			// Find current slide
			var i, stopIndex = 0,
				groupSize = s.slidesSizesGrid[0];
			for(i = 0; i < s.slidesGrid.length; i += s.params.slidesPerGroup) {
				if(typeof s.slidesGrid[i + s.params.slidesPerGroup] !== 'undefined') {
					if(currentPos >= s.slidesGrid[i] && currentPos < s.slidesGrid[i + s.params.slidesPerGroup]) {
						stopIndex = i;
						groupSize = s.slidesGrid[i + s.params.slidesPerGroup] - s.slidesGrid[i];
					}
				} else {
					if(currentPos >= s.slidesGrid[i]) {
						stopIndex = i;
						groupSize = s.slidesGrid[s.slidesGrid.length - 1] - s.slidesGrid[s.slidesGrid.length - 2];
					}
				}
			}

			// Find current slide size
			var ratio = (currentPos - s.slidesGrid[stopIndex]) / groupSize;

			if(timeDiff > s.params.longSwipesMs) {
				// Long touches
				if(!s.params.longSwipes) {
					s.slideTo(s.activeIndex);
					return;
				}
				if(s.swipeDirection === 'next') {
					if(ratio >= s.params.longSwipesRatio) s.slideTo(stopIndex + s.params.slidesPerGroup);
					else s.slideTo(stopIndex);

				}
				if(s.swipeDirection === 'prev') {
					if(ratio > (1 - s.params.longSwipesRatio)) s.slideTo(stopIndex + s.params.slidesPerGroup);
					else s.slideTo(stopIndex);
				}
			} else {
				// Short swipes
				if(!s.params.shortSwipes) {
					s.slideTo(s.activeIndex);
					return;
				}
				if(s.swipeDirection === 'next') {
					s.slideTo(stopIndex + s.params.slidesPerGroup);

				}
				if(s.swipeDirection === 'prev') {
					s.slideTo(stopIndex);
				}
			}
		};
		/*=========================
		 Transitions
		 ===========================*/
		s._slideTo = function(slideIndex, speed) {
			return s.slideTo(slideIndex, speed, true, true);
		};
		s.slideTo = function(slideIndex, speed, runCallbacks, internal) {
			if(typeof runCallbacks === 'undefined') runCallbacks = true;
			if(typeof slideIndex === 'undefined') slideIndex = 0;
			if(slideIndex < 0) slideIndex = 0;
			s.snapIndex = Math.floor(slideIndex / s.params.slidesPerGroup);
			if(s.snapIndex >= s.snapGrid.length) s.snapIndex = s.snapGrid.length - 1;

			var translate = -s.snapGrid[s.snapIndex];
			// Stop autoplay
			if(s.params.autoplay && s.autoplaying) {
				if(internal || !s.params.autoplayDisableOnInteraction) {
					s.pauseAutoplay(speed);
				} else {
					s.stopAutoplay();
				}
			}
			// Update progress
			s.updateProgress(translate);

			// Normalize slideIndex
			for(var i = 0; i < s.slidesGrid.length; i++) {
				if(-Math.floor(translate * 100) >= Math.floor(s.slidesGrid[i] * 100)) {
					slideIndex = i;
				}
			}

			// Directions locks
			if(!s.params.allowSwipeToNext && translate < s.translate && translate < s.minTranslate()) {
				return false;
			}
			if(!s.params.allowSwipeToPrev && translate > s.translate && translate > s.maxTranslate()) {
				if((s.activeIndex || 0) !== slideIndex) return false;
			}

			// Update Index
			if(typeof speed === 'undefined') speed = s.params.speed;
			s.previousIndex = s.activeIndex || 0;
			s.activeIndex = slideIndex;

			if((s.rtl && -translate === s.translate) || (!s.rtl && translate === s.translate)) {
				// Update Height
				if(s.params.autoHeight) {
					s.updateAutoHeight();
				}
				s.updateClasses();
				if(s.params.effect !== 'slide') {
					s.setWrapperTranslate(translate);
				}
				return false;
			}
			s.updateClasses();
			s.onTransitionStart(runCallbacks);

			if(speed === 0) {
				s.setWrapperTranslate(translate);
				s.setWrapperTransition(0);
				s.onTransitionEnd(runCallbacks);
			} else {
				s.setWrapperTranslate(translate);
				s.setWrapperTransition(speed);
				if(!s.animating) {
					s.animating = true;
					s.wrapper.transitionEnd(function() {
						if(!s) return;
						s.onTransitionEnd(runCallbacks);
					});
				}

			}

			return true;
		};

		s.onTransitionStart = function(runCallbacks) {
			if(typeof runCallbacks === 'undefined') runCallbacks = true;
			if(s.params.autoHeight) {
				s.updateAutoHeight();
			}
			if(s.lazy) s.lazy.onTransitionStart();
			if(runCallbacks) {
				s.emit('onTransitionStart', s);
				if(s.activeIndex !== s.previousIndex) {
					s.emit('onSlideChangeStart', s);
					if(s.activeIndex > s.previousIndex) {
						s.emit('onSlideNextStart', s);
					} else {
						s.emit('onSlidePrevStart', s);
					}
				}

			}
		};
		s.onTransitionEnd = function(runCallbacks) {
			s.animating = false;
			s.setWrapperTransition(0);
			if(typeof runCallbacks === 'undefined') runCallbacks = true;
			if(s.lazy) s.lazy.onTransitionEnd();
			if(runCallbacks) {
				s.emit('onTransitionEnd', s);
				if(s.activeIndex !== s.previousIndex) {
					s.emit('onSlideChangeEnd', s);
					if(s.activeIndex > s.previousIndex) {
						s.emit('onSlideNextEnd', s);
					} else {
						s.emit('onSlidePrevEnd', s);
					}
				}
			}
			if(s.params.hashnav && s.hashnav) {
				s.hashnav.setHash();
			}

		};
		s.slideNext = function(runCallbacks, speed, internal) {
			if(s.params.loop) {
				if(s.animating) return false;
				s.fixLoop();
				var clientLeft = s.container[0].clientLeft;
				return s.slideTo(s.activeIndex + s.params.slidesPerGroup, speed, runCallbacks, internal);
			} else return s.slideTo(s.activeIndex + s.params.slidesPerGroup, speed, runCallbacks, internal);
		};
		s._slideNext = function(speed) {
			return s.slideNext(true, speed, true);
		};
		s.slidePrev = function(runCallbacks, speed, internal) {
			if(s.params.loop) {
				if(s.animating) return false;
				s.fixLoop();
				var clientLeft = s.container[0].clientLeft;
				return s.slideTo(s.activeIndex - 1, speed, runCallbacks, internal);
			} else return s.slideTo(s.activeIndex - 1, speed, runCallbacks, internal);
		};
		s._slidePrev = function(speed) {
			return s.slidePrev(true, speed, true);
		};
		s.slideReset = function(runCallbacks, speed, internal) {
			return s.slideTo(s.activeIndex, speed, runCallbacks);
		};

		/*=========================
		 Translate/transition helpers
		 ===========================*/
		s.setWrapperTransition = function(duration, byController) {
			s.wrapper.transition(duration);
			if(s.params.effect !== 'slide' && s.effects[s.params.effect]) {
				s.effects[s.params.effect].setTransition(duration);
			}
			if(s.params.parallax && s.parallax) {
				s.parallax.setTransition(duration);
			}
			if(s.params.scrollbar && s.scrollbar) {
				s.scrollbar.setTransition(duration);
			}
			if(s.params.control && s.controller) {
				s.controller.setTransition(duration, byController);
			}
			s.emit('onSetTransition', s, duration);
		};
		s.setWrapperTranslate = function(translate, updateActiveIndex, byController) {
			var x = 0,
				y = 0,
				z = 0;
			if(s.isHorizontal()) {
				x = s.rtl ? -translate : translate;
			} else {
				y = translate;
			}

			if(s.params.roundLengths) {
				x = round(x);
				y = round(y);
			}

			if(!s.params.virtualTranslate) {
				if(s.support.transforms3d) s.wrapper.transform('translate3d(' + x + 'px, ' + y + 'px, ' + z + 'px)');
				else s.wrapper.transform('translate(' + x + 'px, ' + y + 'px)');
			}

			s.translate = s.isHorizontal() ? x : y;

			// Check if we need to update progress
			var progress;
			var translatesDiff = s.maxTranslate() - s.minTranslate();
			if(translatesDiff === 0) {
				progress = 0;
			} else {
				progress = (translate - s.minTranslate()) / (translatesDiff);
			}
			if(progress !== s.progress) {
				s.updateProgress(translate);
			}

			if(updateActiveIndex) s.updateActiveIndex();
			if(s.params.effect !== 'slide' && s.effects[s.params.effect]) {
				s.effects[s.params.effect].setTranslate(s.translate);
			}
			if(s.params.parallax && s.parallax) {
				s.parallax.setTranslate(s.translate);
			}
			if(s.params.scrollbar && s.scrollbar) {
				s.scrollbar.setTranslate(s.translate);
			}
			if(s.params.control && s.controller) {
				s.controller.setTranslate(s.translate, byController);
			}
			s.emit('onSetTranslate', s, s.translate);
		};

		s.getTranslate = function(el, axis) {
			var matrix, curTransform, curStyle, transformMatrix;

			// automatic axis detection
			if(typeof axis === 'undefined') {
				axis = 'x';
			}

			if(s.params.virtualTranslate) {
				return s.rtl ? -s.translate : s.translate;
			}

			curStyle = window.getComputedStyle(el, null);
			if(window.WebKitCSSMatrix) {
				curTransform = curStyle.transform || curStyle.webkitTransform;
				if(curTransform.split(',').length > 6) {
					curTransform = curTransform.split(', ').map(function(a) {
						return a.replace(',', '.');
					}).join(', ');
				}
				// Some old versions of Webkit choke when 'none' is passed; pass
				// empty string instead in this case
				transformMatrix = new window.WebKitCSSMatrix(curTransform === 'none' ? '' : curTransform);
			} else {
				transformMatrix = curStyle.MozTransform || curStyle.OTransform || curStyle.MsTransform || curStyle.msTransform || curStyle.transform || curStyle.getPropertyValue('transform').replace('translate(', 'matrix(1, 0, 0, 1,');
				matrix = transformMatrix.toString().split(',');
			}

			if(axis === 'x') {
				//Latest Chrome and webkits Fix
				if(window.WebKitCSSMatrix)
					curTransform = transformMatrix.m41;
				//Crazy IE10 Matrix
				else if(matrix.length === 16)
					curTransform = parseFloat(matrix[12]);
				//Normal Browsers
				else
					curTransform = parseFloat(matrix[4]);
			}
			if(axis === 'y') {
				//Latest Chrome and webkits Fix
				if(window.WebKitCSSMatrix)
					curTransform = transformMatrix.m42;
				//Crazy IE10 Matrix
				else if(matrix.length === 16)
					curTransform = parseFloat(matrix[13]);
				//Normal Browsers
				else
					curTransform = parseFloat(matrix[5]);
			}
			if(s.rtl && curTransform) curTransform = -curTransform;
			return curTransform || 0;
		};
		s.getWrapperTranslate = function(axis) {
			if(typeof axis === 'undefined') {
				axis = s.isHorizontal() ? 'x' : 'y';
			}
			return s.getTranslate(s.wrapper[0], axis);
		};

		/*=========================
		 Observer
		 ===========================*/
		s.observers = [];

		function initObserver(target, options) {
			options = options || {};
			// create an observer instance
			var ObserverFunc = window.MutationObserver || window.WebkitMutationObserver;
			var observer = new ObserverFunc(function(mutations) {
				mutations.forEach(function(mutation) {
					s.onResize(true);
					s.emit('onObserverUpdate', s, mutation);
				});
			});

			observer.observe(target, {
				attributes: typeof options.attributes === 'undefined' ? true : options.attributes,
				childList: typeof options.childList === 'undefined' ? true : options.childList,
				characterData: typeof options.characterData === 'undefined' ? true : options.characterData
			});

			s.observers.push(observer);
		}

		s.initObservers = function() {
			if(s.params.observeParents) {
				var containerParents = s.container.parents();
				for(var i = 0; i < containerParents.length; i++) {
					initObserver(containerParents[i]);
				}
			}

			// Observe container
			initObserver(s.container[0], { childList: false });

			// Observe wrapper
			initObserver(s.wrapper[0], { attributes: false });
		};
		s.disconnectObservers = function() {
			for(var i = 0; i < s.observers.length; i++) {
				s.observers[i].disconnect();
			}
			s.observers = [];
		};
		/*=========================
		 Loop
		 ===========================*/
		// Create looped slides
		s.createLoop = function() {
			// Remove duplicated slides
			s.wrapper.children('.' + s.params.slideClass + '.' + s.params.slideDuplicateClass).remove();

			var slides = s.wrapper.children('.' + s.params.slideClass);

			if(s.params.slidesPerView === 'auto' && !s.params.loopedSlides) s.params.loopedSlides = slides.length;

			s.loopedSlides = parseInt(s.params.loopedSlides || s.params.slidesPerView, 10);
			s.loopedSlides = s.loopedSlides + s.params.loopAdditionalSlides;
			if(s.loopedSlides > slides.length) {
				s.loopedSlides = slides.length;
			}

			var prependSlides = [],
				appendSlides = [],
				i;
			slides.each(function(index, el) {
				var slide = $(this);
				if(index < s.loopedSlides) appendSlides.push(el);
				if(index < slides.length && index >= slides.length - s.loopedSlides) prependSlides.push(el);
				slide.attr('data-swiper-slide-index', index);
			});
			for(i = 0; i < appendSlides.length; i++) {
				s.wrapper.append($(appendSlides[i].cloneNode(true)).addClass(s.params.slideDuplicateClass));
			}
			for(i = prependSlides.length - 1; i >= 0; i--) {
				s.wrapper.prepend($(prependSlides[i].cloneNode(true)).addClass(s.params.slideDuplicateClass));
			}
		};
		s.destroyLoop = function() {
			s.wrapper.children('.' + s.params.slideClass + '.' + s.params.slideDuplicateClass).remove();
			s.slides.removeAttr('data-swiper-slide-index');
		};
		s.reLoop = function(updatePosition) {
			var oldIndex = s.activeIndex - s.loopedSlides;
			s.destroyLoop();
			s.createLoop();
			s.updateSlidesSize();
			if(updatePosition) {
				s.slideTo(oldIndex + s.loopedSlides, 0, false);
			}

		};
		s.fixLoop = function() {
			var newIndex;
			//Fix For Negative Oversliding
			if(s.activeIndex < s.loopedSlides) {
				newIndex = s.slides.length - s.loopedSlides * 3 + s.activeIndex;
				newIndex = newIndex + s.loopedSlides;
				s.slideTo(newIndex, 0, false, true);
			}
			//Fix For Positive Oversliding
			else if((s.params.slidesPerView === 'auto' && s.activeIndex >= s.loopedSlides * 2) || (s.activeIndex > s.slides.length - s.params.slidesPerView * 2)) {
				newIndex = -s.slides.length + s.activeIndex + s.loopedSlides;
				newIndex = newIndex + s.loopedSlides;
				s.slideTo(newIndex, 0, false, true);
			}
		};
		/*=========================
		 Append/Prepend/Remove Slides
		 ===========================*/
		s.appendSlide = function(slides) {
			if(s.params.loop) {
				s.destroyLoop();
			}
			if(typeof slides === 'object' && slides.length) {
				for(var i = 0; i < slides.length; i++) {
					if(slides[i]) s.wrapper.append(slides[i]);
				}
			} else {
				s.wrapper.append(slides);
			}
			if(s.params.loop) {
				s.createLoop();
			}
			if(!(s.params.observer && s.support.observer)) {
				s.update(true);
			}
		};
		s.prependSlide = function(slides) {
			if(s.params.loop) {
				s.destroyLoop();
			}
			var newActiveIndex = s.activeIndex + 1;
			if(typeof slides === 'object' && slides.length) {
				for(var i = 0; i < slides.length; i++) {
					if(slides[i]) s.wrapper.prepend(slides[i]);
				}
				newActiveIndex = s.activeIndex + slides.length;
			} else {
				s.wrapper.prepend(slides);
			}
			if(s.params.loop) {
				s.createLoop();
			}
			if(!(s.params.observer && s.support.observer)) {
				s.update(true);
			}
			s.slideTo(newActiveIndex, 0, false);
		};
		s.removeSlide = function(slidesIndexes) {
			if(s.params.loop) {
				s.destroyLoop();
				s.slides = s.wrapper.children('.' + s.params.slideClass);
			}
			var newActiveIndex = s.activeIndex,
				indexToRemove;
			if(typeof slidesIndexes === 'object' && slidesIndexes.length) {
				for(var i = 0; i < slidesIndexes.length; i++) {
					indexToRemove = slidesIndexes[i];
					if(s.slides[indexToRemove]) s.slides.eq(indexToRemove).remove();
					if(indexToRemove < newActiveIndex) newActiveIndex--;
				}
				newActiveIndex = Math.max(newActiveIndex, 0);
			} else {
				indexToRemove = slidesIndexes;
				if(s.slides[indexToRemove]) s.slides.eq(indexToRemove).remove();
				if(indexToRemove < newActiveIndex) newActiveIndex--;
				newActiveIndex = Math.max(newActiveIndex, 0);
			}

			if(s.params.loop) {
				s.createLoop();
			}

			if(!(s.params.observer && s.support.observer)) {
				s.update(true);
			}
			if(s.params.loop) {
				s.slideTo(newActiveIndex + s.loopedSlides, 0, false);
			} else {
				s.slideTo(newActiveIndex, 0, false);
			}

		};
		s.removeAllSlides = function() {
			var slidesIndexes = [];
			for(var i = 0; i < s.slides.length; i++) {
				slidesIndexes.push(i);
			}
			s.removeSlide(slidesIndexes);
		};

		/*=========================
		 Effects
		 ===========================*/
		s.effects = {
			fade: {
				setTranslate: function() {
					for(var i = 0; i < s.slides.length; i++) {
						var slide = s.slides.eq(i);
						var offset = slide[0].swiperSlideOffset;
						var tx = -offset;
						if(!s.params.virtualTranslate) tx = tx - s.translate;
						var ty = 0;
						if(!s.isHorizontal()) {
							ty = tx;
							tx = 0;
						}
						var slideOpacity = s.params.fade.crossFade ?
							Math.max(1 - Math.abs(slide[0].progress), 0) :
							1 + Math.min(Math.max(slide[0].progress, -1), 0);
						slide
							.css({
								opacity: slideOpacity
							})
							.transform('translate3d(' + tx + 'px, ' + ty + 'px, 0px)');

					}

				},
				setTransition: function(duration) {
					s.slides.transition(duration);
					if(s.params.virtualTranslate && duration !== 0) {
						var eventTriggered = false;
						s.slides.transitionEnd(function() {
							if(eventTriggered) return;
							if(!s) return;
							eventTriggered = true;
							s.animating = false;
							var triggerEvents = ['webkitTransitionEnd', 'transitionend', 'oTransitionEnd', 'MSTransitionEnd', 'msTransitionEnd'];
							for(var i = 0; i < triggerEvents.length; i++) {
								s.wrapper.trigger(triggerEvents[i]);
							}
						});
					}
				}
			},
			flip: {
				setTranslate: function() {
					for(var i = 0; i < s.slides.length; i++) {
						var slide = s.slides.eq(i);
						var progress = slide[0].progress;
						if(s.params.flip.limitRotation) {
							progress = Math.max(Math.min(slide[0].progress, 1), -1);
						}
						var offset = slide[0].swiperSlideOffset;
						var rotate = -180 * progress,
							rotateY = rotate,
							rotateX = 0,
							tx = -offset,
							ty = 0;
						if(!s.isHorizontal()) {
							ty = tx;
							tx = 0;
							rotateX = -rotateY;
							rotateY = 0;
						} else if(s.rtl) {
							rotateY = -rotateY;
						}

						slide[0].style.zIndex = -Math.abs(Math.round(progress)) + s.slides.length;

						if(s.params.flip.slideShadows) {
							//Set shadows
							var shadowBefore = s.isHorizontal() ? slide.find('.swiper-slide-shadow-left') : slide.find('.swiper-slide-shadow-top');
							var shadowAfter = s.isHorizontal() ? slide.find('.swiper-slide-shadow-right') : slide.find('.swiper-slide-shadow-bottom');
							if(shadowBefore.length === 0) {
								shadowBefore = $('<div class="swiper-slide-shadow-' + (s.isHorizontal() ? 'left' : 'top') + '"></div>');
								slide.append(shadowBefore);
							}
							if(shadowAfter.length === 0) {
								shadowAfter = $('<div class="swiper-slide-shadow-' + (s.isHorizontal() ? 'right' : 'bottom') + '"></div>');
								slide.append(shadowAfter);
							}
							if(shadowBefore.length) shadowBefore[0].style.opacity = Math.max(-progress, 0);
							if(shadowAfter.length) shadowAfter[0].style.opacity = Math.max(progress, 0);
						}

						slide
							.transform('translate3d(' + tx + 'px, ' + ty + 'px, 0px) rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg)');
					}
				},
				setTransition: function(duration) {
					s.slides.transition(duration).find('.swiper-slide-shadow-top, .swiper-slide-shadow-right, .swiper-slide-shadow-bottom, .swiper-slide-shadow-left').transition(duration);
					if(s.params.virtualTranslate && duration !== 0) {
						var eventTriggered = false;
						s.slides.eq(s.activeIndex).transitionEnd(function() {
							if(eventTriggered) return;
							if(!s) return;
							if(!$(this).hasClass(s.params.slideActiveClass)) return;
							eventTriggered = true;
							s.animating = false;
							var triggerEvents = ['webkitTransitionEnd', 'transitionend', 'oTransitionEnd', 'MSTransitionEnd', 'msTransitionEnd'];
							for(var i = 0; i < triggerEvents.length; i++) {
								s.wrapper.trigger(triggerEvents[i]);
							}
						});
					}
				}
			},
			cube: {
				setTranslate: function() {
					var wrapperRotate = 0,
						cubeShadow;
					if(s.params.cube.shadow) {
						if(s.isHorizontal()) {
							cubeShadow = s.wrapper.find('.swiper-cube-shadow');
							if(cubeShadow.length === 0) {
								cubeShadow = $('<div class="swiper-cube-shadow"></div>');
								s.wrapper.append(cubeShadow);
							}
							cubeShadow.css({ height: s.width + 'px' });
						} else {
							cubeShadow = s.container.find('.swiper-cube-shadow');
							if(cubeShadow.length === 0) {
								cubeShadow = $('<div class="swiper-cube-shadow"></div>');
								s.container.append(cubeShadow);
							}
						}
					}
					for(var i = 0; i < s.slides.length; i++) {
						var slide = s.slides.eq(i);
						var slideAngle = i * 90;
						var round = Math.floor(slideAngle / 360);
						if(s.rtl) {
							slideAngle = -slideAngle;
							round = Math.floor(-slideAngle / 360);
						}
						var progress = Math.max(Math.min(slide[0].progress, 1), -1);
						var tx = 0,
							ty = 0,
							tz = 0;
						if(i % 4 === 0) {
							tx = -round * 4 * s.size;
							tz = 0;
						} else if((i - 1) % 4 === 0) {
							tx = 0;
							tz = -round * 4 * s.size;
						} else if((i - 2) % 4 === 0) {
							tx = s.size + round * 4 * s.size;
							tz = s.size;
						} else if((i - 3) % 4 === 0) {
							tx = -s.size;
							tz = 3 * s.size + s.size * 4 * round;
						}
						if(s.rtl) {
							tx = -tx;
						}

						if(!s.isHorizontal()) {
							ty = tx;
							tx = 0;
						}

						var transform = 'rotateX(' + (s.isHorizontal() ? 0 : -slideAngle) + 'deg) rotateY(' + (s.isHorizontal() ? slideAngle : 0) + 'deg) translate3d(' + tx + 'px, ' + ty + 'px, ' + tz + 'px)';
						if(progress <= 1 && progress > -1) {
							wrapperRotate = i * 90 + progress * 90;
							if(s.rtl) wrapperRotate = -i * 90 - progress * 90;
						}
						slide.transform(transform);
						if(s.params.cube.slideShadows) {
							//Set shadows
							var shadowBefore = s.isHorizontal() ? slide.find('.swiper-slide-shadow-left') : slide.find('.swiper-slide-shadow-top');
							var shadowAfter = s.isHorizontal() ? slide.find('.swiper-slide-shadow-right') : slide.find('.swiper-slide-shadow-bottom');
							if(shadowBefore.length === 0) {
								shadowBefore = $('<div class="swiper-slide-shadow-' + (s.isHorizontal() ? 'left' : 'top') + '"></div>');
								slide.append(shadowBefore);
							}
							if(shadowAfter.length === 0) {
								shadowAfter = $('<div class="swiper-slide-shadow-' + (s.isHorizontal() ? 'right' : 'bottom') + '"></div>');
								slide.append(shadowAfter);
							}
							if(shadowBefore.length) shadowBefore[0].style.opacity = Math.max(-progress, 0);
							if(shadowAfter.length) shadowAfter[0].style.opacity = Math.max(progress, 0);
						}
					}
					s.wrapper.css({
						'-webkit-transform-origin': '50% 50% -' + (s.size / 2) + 'px',
						'-moz-transform-origin': '50% 50% -' + (s.size / 2) + 'px',
						'-ms-transform-origin': '50% 50% -' + (s.size / 2) + 'px',
						'transform-origin': '50% 50% -' + (s.size / 2) + 'px'
					});

					if(s.params.cube.shadow) {
						if(s.isHorizontal()) {
							cubeShadow.transform('translate3d(0px, ' + (s.width / 2 + s.params.cube.shadowOffset) + 'px, ' + (-s.width / 2) + 'px) rotateX(90deg) rotateZ(0deg) scale(' + (s.params.cube.shadowScale) + ')');
						} else {
							var shadowAngle = Math.abs(wrapperRotate) - Math.floor(Math.abs(wrapperRotate) / 90) * 90;
							var multiplier = 1.5 - (Math.sin(shadowAngle * 2 * Math.PI / 360) / 2 + Math.cos(shadowAngle * 2 * Math.PI / 360) / 2);
							var scale1 = s.params.cube.shadowScale,
								scale2 = s.params.cube.shadowScale / multiplier,
								offset = s.params.cube.shadowOffset;
							cubeShadow.transform('scale3d(' + scale1 + ', 1, ' + scale2 + ') translate3d(0px, ' + (s.height / 2 + offset) + 'px, ' + (-s.height / 2 / scale2) + 'px) rotateX(-90deg)');
						}
					}
					var zFactor = (s.isSafari || s.isUiWebView) ? (-s.size / 2) : 0;
					s.wrapper.transform('translate3d(0px,0,' + zFactor + 'px) rotateX(' + (s.isHorizontal() ? 0 : wrapperRotate) + 'deg) rotateY(' + (s.isHorizontal() ? -wrapperRotate : 0) + 'deg)');
				},
				setTransition: function(duration) {
					s.slides.transition(duration).find('.swiper-slide-shadow-top, .swiper-slide-shadow-right, .swiper-slide-shadow-bottom, .swiper-slide-shadow-left').transition(duration);
					if(s.params.cube.shadow && !s.isHorizontal()) {
						s.container.find('.swiper-cube-shadow').transition(duration);
					}
				}
			},
			coverflow: {
				setTranslate: function() {
					var transform = s.translate;
					var center = s.isHorizontal() ? -transform + s.width / 2 : -transform + s.height / 2;
					var rotate = s.isHorizontal() ? s.params.coverflow.rotate : -s.params.coverflow.rotate;
					var translate = s.params.coverflow.depth;
					//Each slide offset from center
					for(var i = 0, length = s.slides.length; i < length; i++) {
						var slide = s.slides.eq(i);
						var slideSize = s.slidesSizesGrid[i];
						var slideOffset = slide[0].swiperSlideOffset;
						var offsetMultiplier = (center - slideOffset - slideSize / 2) / slideSize * s.params.coverflow.modifier;

						var rotateY = s.isHorizontal() ? rotate * offsetMultiplier : 0;
						var rotateX = s.isHorizontal() ? 0 : rotate * offsetMultiplier;
						// var rotateZ = 0
						var translateZ = -translate * Math.abs(offsetMultiplier);

						var translateY = s.isHorizontal() ? 0 : s.params.coverflow.stretch * (offsetMultiplier);
						var translateX = s.isHorizontal() ? s.params.coverflow.stretch * (offsetMultiplier) : 0;

						//Fix for ultra small values
						if(Math.abs(translateX) < 0.001) translateX = 0;
						if(Math.abs(translateY) < 0.001) translateY = 0;
						if(Math.abs(translateZ) < 0.001) translateZ = 0;
						if(Math.abs(rotateY) < 0.001) rotateY = 0;
						if(Math.abs(rotateX) < 0.001) rotateX = 0;

						var slideTransform = 'translate3d(' + translateX + 'px,' + translateY + 'px,' + translateZ + 'px)  rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg)';

						slide.transform(slideTransform);
						slide[0].style.zIndex = -Math.abs(Math.round(offsetMultiplier)) + 1;
						if(s.params.coverflow.slideShadows) {
							//Set shadows
							var shadowBefore = s.isHorizontal() ? slide.find('.swiper-slide-shadow-left') : slide.find('.swiper-slide-shadow-top');
							var shadowAfter = s.isHorizontal() ? slide.find('.swiper-slide-shadow-right') : slide.find('.swiper-slide-shadow-bottom');
							if(shadowBefore.length === 0) {
								shadowBefore = $('<div class="swiper-slide-shadow-' + (s.isHorizontal() ? 'left' : 'top') + '"></div>');
								slide.append(shadowBefore);
							}
							if(shadowAfter.length === 0) {
								shadowAfter = $('<div class="swiper-slide-shadow-' + (s.isHorizontal() ? 'right' : 'bottom') + '"></div>');
								slide.append(shadowAfter);
							}
							if(shadowBefore.length) shadowBefore[0].style.opacity = offsetMultiplier > 0 ? offsetMultiplier : 0;
							if(shadowAfter.length) shadowAfter[0].style.opacity = (-offsetMultiplier) > 0 ? -offsetMultiplier : 0;
						}
					}

					//Set correct perspective for IE10
					if(s.browser.ie) {
						var ws = s.wrapper[0].style;
						ws.perspectiveOrigin = center + 'px 50%';
					}
				},
				setTransition: function(duration) {
					s.slides.transition(duration).find('.swiper-slide-shadow-top, .swiper-slide-shadow-right, .swiper-slide-shadow-bottom, .swiper-slide-shadow-left').transition(duration);
				}
			}
		};

		/*=========================
		 Images Lazy Loading
		 ===========================*/
		s.lazy = {
			initialImageLoaded: false,
			loadImageInSlide: function(index, loadInDuplicate) {
				if(typeof index === 'undefined') return;
				if(typeof loadInDuplicate === 'undefined') loadInDuplicate = true;
				if(s.slides.length === 0) return;

				var slide = s.slides.eq(index);
				var img = slide.find('.swiper-lazy:not(.swiper-lazy-loaded):not(.swiper-lazy-loading)');
				if(slide.hasClass('swiper-lazy') && !slide.hasClass('swiper-lazy-loaded') && !slide.hasClass('swiper-lazy-loading')) {
					img = img.add(slide[0]);
				}
				if(img.length === 0) return;

				img.each(function() {
					var _img = $(this);
					_img.addClass('swiper-lazy-loading');
					var background = _img.attr('data-background');
					var src = _img.attr('data-src'),
						srcset = _img.attr('data-srcset');
					s.loadImage(_img[0], (src || background), srcset, false, function() {
						if(background) {
							_img.css('background-image', 'url("' + background + '")');
							_img.removeAttr('data-background');
						} else {
							if(srcset) {
								_img.attr('srcset', srcset);
								_img.removeAttr('data-srcset');
							}
							if(src) {
								_img.attr('src', src);
								_img.removeAttr('data-src');
							}

						}

						_img.addClass('swiper-lazy-loaded').removeClass('swiper-lazy-loading');
						slide.find('.swiper-lazy-preloader, .preloader').remove();
						if(s.params.loop && loadInDuplicate) {
							var slideOriginalIndex = slide.attr('data-swiper-slide-index');
							if(slide.hasClass(s.params.slideDuplicateClass)) {
								var originalSlide = s.wrapper.children('[data-swiper-slide-index="' + slideOriginalIndex + '"]:not(.' + s.params.slideDuplicateClass + ')');
								s.lazy.loadImageInSlide(originalSlide.index(), false);
							} else {
								var duplicatedSlide = s.wrapper.children('.' + s.params.slideDuplicateClass + '[data-swiper-slide-index="' + slideOriginalIndex + '"]');
								s.lazy.loadImageInSlide(duplicatedSlide.index(), false);
							}
						}
						s.emit('onLazyImageReady', s, slide[0], _img[0]);
					});

					s.emit('onLazyImageLoad', s, slide[0], _img[0]);
				});

			},
			load: function() {
				var i;
				if(s.params.watchSlidesVisibility) {
					s.wrapper.children('.' + s.params.slideVisibleClass).each(function() {
						s.lazy.loadImageInSlide($(this).index());
					});
				} else {
					if(s.params.slidesPerView > 1) {
						for(i = s.activeIndex; i < s.activeIndex + s.params.slidesPerView; i++) {
							if(s.slides[i]) s.lazy.loadImageInSlide(i);
						}
					} else {
						s.lazy.loadImageInSlide(s.activeIndex);
					}
				}
				if(s.params.lazyLoadingInPrevNext) {
					if(s.params.slidesPerView > 1 || (s.params.lazyLoadingInPrevNextAmount && s.params.lazyLoadingInPrevNextAmount > 1)) {
						var amount = s.params.lazyLoadingInPrevNextAmount;
						var spv = s.params.slidesPerView;
						var maxIndex = Math.min(s.activeIndex + spv + Math.max(amount, spv), s.slides.length);
						var minIndex = Math.max(s.activeIndex - Math.max(spv, amount), 0);
						// Next Slides
						for(i = s.activeIndex + s.params.slidesPerView; i < maxIndex; i++) {
							if(s.slides[i]) s.lazy.loadImageInSlide(i);
						}
						// Prev Slides
						for(i = minIndex; i < s.activeIndex; i++) {
							if(s.slides[i]) s.lazy.loadImageInSlide(i);
						}
					} else {
						var nextSlide = s.wrapper.children('.' + s.params.slideNextClass);
						if(nextSlide.length > 0) s.lazy.loadImageInSlide(nextSlide.index());

						var prevSlide = s.wrapper.children('.' + s.params.slidePrevClass);
						if(prevSlide.length > 0) s.lazy.loadImageInSlide(prevSlide.index());
					}
				}
			},
			onTransitionStart: function() {
				if(s.params.lazyLoading) {
					if(s.params.lazyLoadingOnTransitionStart || (!s.params.lazyLoadingOnTransitionStart && !s.lazy.initialImageLoaded)) {
						s.lazy.load();
					}
				}
			},
			onTransitionEnd: function() {
				if(s.params.lazyLoading && !s.params.lazyLoadingOnTransitionStart) {
					s.lazy.load();
				}
			}
		};

		/*=========================
		 Scrollbar
		 ===========================*/
		s.scrollbar = {
			isTouched: false,
			setDragPosition: function(e) {
				var sb = s.scrollbar;
				var x = 0,
					y = 0;
				var translate;
				var pointerPosition = s.isHorizontal() ?
					((e.type === 'touchstart' || e.type === 'touchmove') ? e.targetTouches[0].pageX : e.pageX || e.clientX) :
					((e.type === 'touchstart' || e.type === 'touchmove') ? e.targetTouches[0].pageY : e.pageY || e.clientY);
				var position = (pointerPosition) - sb.track.offset()[s.isHorizontal() ? 'left' : 'top'] - sb.dragSize / 2;
				var positionMin = -s.minTranslate() * sb.moveDivider;
				var positionMax = -s.maxTranslate() * sb.moveDivider;
				if(position < positionMin) {
					position = positionMin;
				} else if(position > positionMax) {
					position = positionMax;
				}
				position = -position / sb.moveDivider;
				s.updateProgress(position);
				s.setWrapperTranslate(position, true);
			},
			dragStart: function(e) {
				var sb = s.scrollbar;
				sb.isTouched = true;
				e.preventDefault();
				e.stopPropagation();

				sb.setDragPosition(e);
				clearTimeout(sb.dragTimeout);

				sb.track.transition(0);
				if(s.params.scrollbarHide) {
					sb.track.css('opacity', 1);
				}
				s.wrapper.transition(100);
				sb.drag.transition(100);
				s.emit('onScrollbarDragStart', s);
			},
			dragMove: function(e) {
				var sb = s.scrollbar;
				if(!sb.isTouched) return;
				if(e.preventDefault) e.preventDefault();
				else e.returnValue = false;
				sb.setDragPosition(e);
				s.wrapper.transition(0);
				sb.track.transition(0);
				sb.drag.transition(0);
				s.emit('onScrollbarDragMove', s);
			},
			dragEnd: function(e) {
				var sb = s.scrollbar;
				if(!sb.isTouched) return;
				sb.isTouched = false;
				if(s.params.scrollbarHide) {
					clearTimeout(sb.dragTimeout);
					sb.dragTimeout = setTimeout(function() {
						sb.track.css('opacity', 0);
						sb.track.transition(400);
					}, 1000);

				}
				s.emit('onScrollbarDragEnd', s);
				if(s.params.scrollbarSnapOnRelease) {
					s.slideReset();
				}
			},
			enableDraggable: function() {
				var sb = s.scrollbar;
				var target = s.support.touch ? sb.track : document;
				$(sb.track).on(s.touchEvents.start, sb.dragStart);
				$(target).on(s.touchEvents.move, sb.dragMove);
				$(target).on(s.touchEvents.end, sb.dragEnd);
			},
			disableDraggable: function() {
				var sb = s.scrollbar;
				var target = s.support.touch ? sb.track : document;
				$(sb.track).off(s.touchEvents.start, sb.dragStart);
				$(target).off(s.touchEvents.move, sb.dragMove);
				$(target).off(s.touchEvents.end, sb.dragEnd);
			},
			set: function() {
				if(!s.params.scrollbar) return;
				var sb = s.scrollbar;
				sb.track = $(s.params.scrollbar);
				if(s.params.uniqueNavElements && typeof s.params.scrollbar === 'string' && sb.track.length > 1 && s.container.find(s.params.scrollbar).length === 1) {
					sb.track = s.container.find(s.params.scrollbar);
				}
				sb.drag = sb.track.find('.swiper-scrollbar-drag');
				if(sb.drag.length === 0) {
					sb.drag = $('<div class="swiper-scrollbar-drag"></div>');
					sb.track.append(sb.drag);
				}
				sb.drag[0].style.width = '';
				sb.drag[0].style.height = '';
				sb.trackSize = s.isHorizontal() ? sb.track[0].offsetWidth : sb.track[0].offsetHeight;

				sb.divider = s.size / s.virtualSize;
				sb.moveDivider = sb.divider * (sb.trackSize / s.size);
				sb.dragSize = sb.trackSize * sb.divider;

				if(s.isHorizontal()) {
					sb.drag[0].style.width = sb.dragSize + 'px';
				} else {
					sb.drag[0].style.height = sb.dragSize + 'px';
				}

				if(sb.divider >= 1) {
					sb.track[0].style.display = 'none';
				} else {
					sb.track[0].style.display = '';
				}
				if(s.params.scrollbarHide) {
					sb.track[0].style.opacity = 0;
				}
			},
			setTranslate: function() {
				if(!s.params.scrollbar) return;
				var diff;
				var sb = s.scrollbar;
				var translate = s.translate || 0;
				var newPos;

				var newSize = sb.dragSize;
				newPos = (sb.trackSize - sb.dragSize) * s.progress;
				if(s.rtl && s.isHorizontal()) {
					newPos = -newPos;
					if(newPos > 0) {
						newSize = sb.dragSize - newPos;
						newPos = 0;
					} else if(-newPos + sb.dragSize > sb.trackSize) {
						newSize = sb.trackSize + newPos;
					}
				} else {
					if(newPos < 0) {
						newSize = sb.dragSize + newPos;
						newPos = 0;
					} else if(newPos + sb.dragSize > sb.trackSize) {
						newSize = sb.trackSize - newPos;
					}
				}
				if(s.isHorizontal()) {
					if(s.support.transforms3d) {
						sb.drag.transform('translate3d(' + (newPos) + 'px, 0, 0)');
					} else {
						sb.drag.transform('translateX(' + (newPos) + 'px)');
					}
					sb.drag[0].style.width = newSize + 'px';
				} else {
					if(s.support.transforms3d) {
						sb.drag.transform('translate3d(0px, ' + (newPos) + 'px, 0)');
					} else {
						sb.drag.transform('translateY(' + (newPos) + 'px)');
					}
					sb.drag[0].style.height = newSize + 'px';
				}
				if(s.params.scrollbarHide) {
					clearTimeout(sb.timeout);
					sb.track[0].style.opacity = 1;
					sb.timeout = setTimeout(function() {
						sb.track[0].style.opacity = 0;
						sb.track.transition(400);
					}, 1000);
				}
			},
			setTransition: function(duration) {
				if(!s.params.scrollbar) return;
				s.scrollbar.drag.transition(duration);
			}
		};

		/*=========================
		 Controller
		 ===========================*/
		s.controller = {
			LinearSpline: function(x, y) {
				this.x = x;
				this.y = y;
				this.lastIndex = x.length - 1;
				// Given an x value (x2), return the expected y2 value:
				// (x1,y1) is the known point before given value,
				// (x3,y3) is the known point after given value.
				var i1, i3;
				var l = this.x.length;

				this.interpolate = function(x2) {
					if(!x2) return 0;

					// Get the indexes of x1 and x3 (the array indexes before and after given x2):
					i3 = binarySearch(this.x, x2);
					i1 = i3 - 1;

					// We have our indexes i1 & i3, so we can calculate already:
					// y2 := ((x2−x1) × (y3−y1)) ÷ (x3−x1) + y1
					return((x2 - this.x[i1]) * (this.y[i3] - this.y[i1])) / (this.x[i3] - this.x[i1]) + this.y[i1];
				};

				var binarySearch = (function() {
					var maxIndex, minIndex, guess;
					return function(array, val) {
						minIndex = -1;
						maxIndex = array.length;
						while(maxIndex - minIndex > 1)
							if(array[guess = maxIndex + minIndex >> 1] <= val) {
								minIndex = guess;
							} else {
								maxIndex = guess;
							}
						return maxIndex;
					};
				})();
			},
			//xxx: for now i will just save one spline function to to
			getInterpolateFunction: function(c) {
				if(!s.controller.spline) s.controller.spline = s.params.loop ?
					new s.controller.LinearSpline(s.slidesGrid, c.slidesGrid) :
					new s.controller.LinearSpline(s.snapGrid, c.snapGrid);
			},
			setTranslate: function(translate, byController) {
				var controlled = s.params.control;
				var multiplier, controlledTranslate;

				function setControlledTranslate(c) {
					// this will create an Interpolate function based on the snapGrids
					// x is the Grid of the scrolled scroller and y will be the controlled scroller
					// it makes sense to create this only once and recall it for the interpolation
					// the function does a lot of value caching for performance
					translate = c.rtl && c.params.direction === 'horizontal' ? -s.translate : s.translate;
					if(s.params.controlBy === 'slide') {
						s.controller.getInterpolateFunction(c);
						// i am not sure why the values have to be multiplicated this way, tried to invert the snapGrid
						// but it did not work out
						controlledTranslate = -s.controller.spline.interpolate(-translate);
					}

					if(!controlledTranslate || s.params.controlBy === 'container') {
						multiplier = (c.maxTranslate() - c.minTranslate()) / (s.maxTranslate() - s.minTranslate());
						controlledTranslate = (translate - s.minTranslate()) * multiplier + c.minTranslate();
					}

					if(s.params.controlInverse) {
						controlledTranslate = c.maxTranslate() - controlledTranslate;
					}
					c.updateProgress(controlledTranslate);
					c.setWrapperTranslate(controlledTranslate, false, s);
					c.updateActiveIndex();
				}

				if(s.isArray(controlled)) {
					for(var i = 0; i < controlled.length; i++) {
						if(controlled[i] !== byController && controlled[i] instanceof Swiper) {
							setControlledTranslate(controlled[i]);
						}
					}
				} else if(controlled instanceof Swiper && byController !== controlled) {

					setControlledTranslate(controlled);
				}
			},
			setTransition: function(duration, byController) {
				var controlled = s.params.control;
				var i;

				function setControlledTransition(c) {
					c.setWrapperTransition(duration, s);
					if(duration !== 0) {
						c.onTransitionStart();
						c.wrapper.transitionEnd(function() {
							if(!controlled) return;
							if(c.params.loop && s.params.controlBy === 'slide') {
								c.fixLoop();
							}
							c.onTransitionEnd();

						});
					}
				}

				if(s.isArray(controlled)) {
					for(i = 0; i < controlled.length; i++) {
						if(controlled[i] !== byController && controlled[i] instanceof Swiper) {
							setControlledTransition(controlled[i]);
						}
					}
				} else if(controlled instanceof Swiper && byController !== controlled) {
					setControlledTransition(controlled);
				}
			}
		};

		/*=========================
		 Hash Navigation
		 ===========================*/
		s.hashnav = {
			init: function() {
				if(!s.params.hashnav) return;
				s.hashnav.initialized = true;
				var hash = document.location.hash.replace('#', '');
				if(!hash) return;
				var speed = 0;
				for(var i = 0, length = s.slides.length; i < length; i++) {
					var slide = s.slides.eq(i);
					var slideHash = slide.attr('data-hash');
					if(slideHash === hash && !slide.hasClass(s.params.slideDuplicateClass)) {
						var index = slide.index();
						s.slideTo(index, speed, s.params.runCallbacksOnInit, true);
					}
				}
			},
			setHash: function() {
				if(!s.hashnav.initialized || !s.params.hashnav) return;
				document.location.hash = s.slides.eq(s.activeIndex).attr('data-hash') || '';
			}
		};

		/*=========================
		 Keyboard Control
		 ===========================*/
		function handleKeyboard(e) {
			if(e.originalEvent) e = e.originalEvent; //jquery fix
			var kc = e.keyCode || e.charCode;
			// Directions locks
			if(!s.params.allowSwipeToNext && (s.isHorizontal() && kc === 39 || !s.isHorizontal() && kc === 40)) {
				return false;
			}
			if(!s.params.allowSwipeToPrev && (s.isHorizontal() && kc === 37 || !s.isHorizontal() && kc === 38)) {
				return false;
			}
			if(e.shiftKey || e.altKey || e.ctrlKey || e.metaKey) {
				return;
			}
			if(document.activeElement && document.activeElement.nodeName && (document.activeElement.nodeName.toLowerCase() === 'input' || document.activeElement.nodeName.toLowerCase() === 'textarea')) {
				return;
			}
			if(kc === 37 || kc === 39 || kc === 38 || kc === 40) {
				var inView = false;
				//Check that swiper should be inside of visible area of window
				if(s.container.parents('.swiper-slide').length > 0 && s.container.parents('.swiper-slide-active').length === 0) {
					return;
				}
				var windowScroll = {
					left: window.pageXOffset,
					top: window.pageYOffset
				};
				var windowWidth = window.innerWidth;
				var windowHeight = window.innerHeight;
				var swiperOffset = s.container.offset();
				if(s.rtl) swiperOffset.left = swiperOffset.left - s.container[0].scrollLeft;
				var swiperCoord = [
					[swiperOffset.left, swiperOffset.top],
					[swiperOffset.left + s.width, swiperOffset.top],
					[swiperOffset.left, swiperOffset.top + s.height],
					[swiperOffset.left + s.width, swiperOffset.top + s.height]
				];
				for(var i = 0; i < swiperCoord.length; i++) {
					var point = swiperCoord[i];
					if(
						point[0] >= windowScroll.left && point[0] <= windowScroll.left + windowWidth &&
						point[1] >= windowScroll.top && point[1] <= windowScroll.top + windowHeight
					) {
						inView = true;
					}

				}
				if(!inView) return;
			}
			if(s.isHorizontal()) {
				if(kc === 37 || kc === 39) {
					if(e.preventDefault) e.preventDefault();
					else e.returnValue = false;
				}
				if((kc === 39 && !s.rtl) || (kc === 37 && s.rtl)) s.slideNext();
				if((kc === 37 && !s.rtl) || (kc === 39 && s.rtl)) s.slidePrev();
			} else {
				if(kc === 38 || kc === 40) {
					if(e.preventDefault) e.preventDefault();
					else e.returnValue = false;
				}
				if(kc === 40) s.slideNext();
				if(kc === 38) s.slidePrev();
			}
		}

		s.disableKeyboardControl = function() {
			s.params.keyboardControl = false;
			$(document).off('keydown', handleKeyboard);
		};
		s.enableKeyboardControl = function() {
			s.params.keyboardControl = true;
			$(document).on('keydown', handleKeyboard);
		};

		/*=========================
		 Mousewheel Control
		 ===========================*/
		s.mousewheel = {
			event: false,
			lastScrollTime: (new window.Date()).getTime()
		};
		if(s.params.mousewheelControl) {
			try {
				new window.WheelEvent('wheel');
				s.mousewheel.event = 'wheel';
			} catch(e) {
				if(window.WheelEvent || (s.container[0] && 'wheel' in s.container[0])) {
					s.mousewheel.event = 'wheel';
				}
			}
			if(!s.mousewheel.event && window.WheelEvent) {

			}
			if(!s.mousewheel.event && document.onmousewheel !== undefined) {
				s.mousewheel.event = 'mousewheel';
			}
			if(!s.mousewheel.event) {
				s.mousewheel.event = 'DOMMouseScroll';
			}
		}

		function handleMousewheel(e) {
			if(e.originalEvent) e = e.originalEvent; //jquery fix
			var we = s.mousewheel.event;
			var delta = 0;
			var rtlFactor = s.rtl ? -1 : 1;

			//WebKits
			if(we === 'mousewheel') {
				if(s.params.mousewheelForceToAxis) {
					if(s.isHorizontal()) {
						if(Math.abs(e.wheelDeltaX) > Math.abs(e.wheelDeltaY)) delta = e.wheelDeltaX * rtlFactor;
						else return;
					} else {
						if(Math.abs(e.wheelDeltaY) > Math.abs(e.wheelDeltaX)) delta = e.wheelDeltaY;
						else return;
					}
				} else {
					delta = Math.abs(e.wheelDeltaX) > Math.abs(e.wheelDeltaY) ? -e.wheelDeltaX * rtlFactor : -e.wheelDeltaY;
				}
			}
			//Old FireFox
			else if(we === 'DOMMouseScroll') delta = -e.detail;
			//New FireFox
			else if(we === 'wheel') {
				if(s.params.mousewheelForceToAxis) {
					if(s.isHorizontal()) {
						if(Math.abs(e.deltaX) > Math.abs(e.deltaY)) delta = -e.deltaX * rtlFactor;
						else return;
					} else {
						if(Math.abs(e.deltaY) > Math.abs(e.deltaX)) delta = -e.deltaY;
						else return;
					}
				} else {
					delta = Math.abs(e.deltaX) > Math.abs(e.deltaY) ? -e.deltaX * rtlFactor : -e.deltaY;
				}
			}
			if(delta === 0) return;

			if(s.params.mousewheelInvert) delta = -delta;

			if(!s.params.freeMode) {
				if((new window.Date()).getTime() - s.mousewheel.lastScrollTime > 60) {
					if(delta < 0) {
						if((!s.isEnd || s.params.loop) && !s.animating) s.slideNext();
						else if(s.params.mousewheelReleaseOnEdges) return true;
					} else {
						if((!s.isBeginning || s.params.loop) && !s.animating) s.slidePrev();
						else if(s.params.mousewheelReleaseOnEdges) return true;
					}
				}
				s.mousewheel.lastScrollTime = (new window.Date()).getTime();

			} else {
				//Freemode or scrollContainer:
				var position = s.getWrapperTranslate() + delta * s.params.mousewheelSensitivity;
				var wasBeginning = s.isBeginning,
					wasEnd = s.isEnd;

				if(position >= s.minTranslate()) position = s.minTranslate();
				if(position <= s.maxTranslate()) position = s.maxTranslate();

				s.setWrapperTransition(0);
				s.setWrapperTranslate(position);
				s.updateProgress();
				s.updateActiveIndex();

				if(!wasBeginning && s.isBeginning || !wasEnd && s.isEnd) {
					s.updateClasses();
				}

				if(s.params.freeModeSticky) {
					clearTimeout(s.mousewheel.timeout);
					s.mousewheel.timeout = setTimeout(function() {
						s.slideReset();
					}, 300);
				} else {
					if(s.params.lazyLoading && s.lazy) {
						s.lazy.load();
					}
				}

				// Return page scroll on edge positions
				if(position === 0 || position === s.maxTranslate()) return;
			}
			if(s.params.autoplay) s.stopAutoplay();

			if(e.preventDefault) e.preventDefault();
			else e.returnValue = false;
			return false;
		}

		s.disableMousewheelControl = function() {
			if(!s.mousewheel.event) return false;
			s.container.off(s.mousewheel.event, handleMousewheel);
			return true;
		};

		s.enableMousewheelControl = function() {
			if(!s.mousewheel.event) return false;
			s.container.on(s.mousewheel.event, handleMousewheel);
			return true;
		};

		/*=========================
		 Parallax
		 ===========================*/
		function setParallaxTransform(el, progress) {
			el = $(el);
			var p, pX, pY;
			var rtlFactor = s.rtl ? -1 : 1;

			p = el.attr('data-swiper-parallax') || '0';
			pX = el.attr('data-swiper-parallax-x');
			pY = el.attr('data-swiper-parallax-y');
			if(pX || pY) {
				pX = pX || '0';
				pY = pY || '0';
			} else {
				if(s.isHorizontal()) {
					pX = p;
					pY = '0';
				} else {
					pY = p;
					pX = '0';
				}
			}

			if((pX).indexOf('%') >= 0) {
				pX = parseInt(pX, 10) * progress * rtlFactor + '%';
			} else {
				pX = pX * progress * rtlFactor + 'px';
			}
			if((pY).indexOf('%') >= 0) {
				pY = parseInt(pY, 10) * progress + '%';
			} else {
				pY = pY * progress + 'px';
			}

			el.transform('translate3d(' + pX + ', ' + pY + ',0px)');
		}

		s.parallax = {
			setTranslate: function() {
				s.container.children('[data-swiper-parallax], [data-swiper-parallax-x], [data-swiper-parallax-y]').each(function() {
					setParallaxTransform(this, s.progress);

				});
				s.slides.each(function() {
					var slide = $(this);
					slide.find('[data-swiper-parallax], [data-swiper-parallax-x], [data-swiper-parallax-y]').each(function() {
						var progress = Math.min(Math.max(slide[0].progress, -1), 1);
						setParallaxTransform(this, progress);
					});
				});
			},
			setTransition: function(duration) {
				if(typeof duration === 'undefined') duration = s.params.speed;
				s.container.find('[data-swiper-parallax], [data-swiper-parallax-x], [data-swiper-parallax-y]').each(function() {
					var el = $(this);
					var parallaxDuration = parseInt(el.attr('data-swiper-parallax-duration'), 10) || duration;
					if(duration === 0) parallaxDuration = 0;
					el.transition(parallaxDuration);
				});
			}
		};

		/*=========================
		 Plugins API. Collect all and init all plugins
		 ===========================*/
		s._plugins = [];
		for(var plugin in s.plugins) {
			var p = s.plugins[plugin](s, s.params[plugin]);
			if(p) s._plugins.push(p);
		}
		// Method to call all plugins event/method
		s.callPlugins = function(eventName) {
			for(var i = 0; i < s._plugins.length; i++) {
				if(eventName in s._plugins[i]) {
					s._plugins[i][eventName](arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
				}
			}
		};

		/*=========================
		 Events/Callbacks/Plugins Emitter
		 ===========================*/
		function normalizeEventName(eventName) {
			if(eventName.indexOf('on') !== 0) {
				if(eventName[0] !== eventName[0].toUpperCase()) {
					eventName = 'on' + eventName[0].toUpperCase() + eventName.substring(1);
				} else {
					eventName = 'on' + eventName;
				}
			}
			return eventName;
		}

		s.emitterEventListeners = {};
		s.emit = function(eventName) {
			// Trigger callbacks
			if(s.params[eventName]) {
				s.params[eventName](arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
			}
			var i;
			// Trigger events
			if(s.emitterEventListeners[eventName]) {
				for(i = 0; i < s.emitterEventListeners[eventName].length; i++) {
					s.emitterEventListeners[eventName][i](arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
				}
			}
			// Trigger plugins
			if(s.callPlugins) s.callPlugins(eventName, arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
		};
		s.on = function(eventName, handler) {
			eventName = normalizeEventName(eventName);
			if(!s.emitterEventListeners[eventName]) s.emitterEventListeners[eventName] = [];
			s.emitterEventListeners[eventName].push(handler);
			return s;
		};
		s.off = function(eventName, handler) {
			var i;
			eventName = normalizeEventName(eventName);
			if(typeof handler === 'undefined') {
				// Remove all handlers for such event
				s.emitterEventListeners[eventName] = [];
				return s;
			}
			if(!s.emitterEventListeners[eventName] || s.emitterEventListeners[eventName].length === 0) return;
			for(i = 0; i < s.emitterEventListeners[eventName].length; i++) {
				if(s.emitterEventListeners[eventName][i] === handler) s.emitterEventListeners[eventName].splice(i, 1);
			}
			return s;
		};
		s.once = function(eventName, handler) {
			eventName = normalizeEventName(eventName);
			var _handler = function() {
				handler(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]);
				s.off(eventName, _handler);
			};
			s.on(eventName, _handler);
			return s;
		};

		// Accessibility tools
		s.a11y = {
			makeFocusable: function($el) {
				$el.attr('tabIndex', '0');
				return $el;
			},
			addRole: function($el, role) {
				$el.attr('role', role);
				return $el;
			},

			addLabel: function($el, label) {
				$el.attr('aria-label', label);
				return $el;
			},

			disable: function($el) {
				$el.attr('aria-disabled', true);
				return $el;
			},

			enable: function($el) {
				$el.attr('aria-disabled', false);
				return $el;
			},

			onEnterKey: function(event) {
				if(event.keyCode !== 13) return;
				if($(event.target).is(s.params.nextButton)) {
					s.onClickNext(event);
					if(s.isEnd) {
						s.a11y.notify(s.params.lastSlideMessage);
					} else {
						s.a11y.notify(s.params.nextSlideMessage);
					}
				} else if($(event.target).is(s.params.prevButton)) {
					s.onClickPrev(event);
					if(s.isBeginning) {
						s.a11y.notify(s.params.firstSlideMessage);
					} else {
						s.a11y.notify(s.params.prevSlideMessage);
					}
				}
				if($(event.target).is('.' + s.params.bulletClass)) {
					$(event.target)[0].click();
				}
			},

			liveRegion: $('<span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span>'),

			notify: function(message) {
				var notification = s.a11y.liveRegion;
				if(notification.length === 0) return;
				notification.html('');
				notification.html(message);
			},
			init: function() {
				// Setup accessibility
				if(s.params.nextButton && s.nextButton && s.nextButton.length > 0) {
					s.a11y.makeFocusable(s.nextButton);
					s.a11y.addRole(s.nextButton, 'button');
					s.a11y.addLabel(s.nextButton, s.params.nextSlideMessage);
				}
				if(s.params.prevButton && s.prevButton && s.prevButton.length > 0) {
					s.a11y.makeFocusable(s.prevButton);
					s.a11y.addRole(s.prevButton, 'button');
					s.a11y.addLabel(s.prevButton, s.params.prevSlideMessage);
				}

				$(s.container).append(s.a11y.liveRegion);
			},
			initPagination: function() {
				if(s.params.pagination && s.params.paginationClickable && s.bullets && s.bullets.length) {
					s.bullets.each(function() {
						var bullet = $(this);
						s.a11y.makeFocusable(bullet);
						s.a11y.addRole(bullet, 'button');
						s.a11y.addLabel(bullet, s.params.paginationBulletMessage.replace(/{{index}}/, bullet.index() + 1));
					});
				}
			},
			destroy: function() {
				if(s.a11y.liveRegion && s.a11y.liveRegion.length > 0) s.a11y.liveRegion.remove();
			}
		};

		/*=========================
		 Init/Destroy
		 ===========================*/
		s.init = function() {
			if(s.params.loop) s.createLoop();
			s.updateContainerSize();
			s.updateSlidesSize();
			s.updatePagination();
			if(s.params.scrollbar && s.scrollbar) {
				s.scrollbar.set();
				if(s.params.scrollbarDraggable) {
					s.scrollbar.enableDraggable();
				}
			}
			if(s.params.effect !== 'slide' && s.effects[s.params.effect]) {
				if(!s.params.loop) s.updateProgress();
				s.effects[s.params.effect].setTranslate();
			}
			if(s.params.loop) {
				s.slideTo(s.params.initialSlide + s.loopedSlides, 0, s.params.runCallbacksOnInit);
			} else {
				s.slideTo(s.params.initialSlide, 0, s.params.runCallbacksOnInit);
				if(s.params.initialSlide === 0) {
					if(s.parallax && s.params.parallax) s.parallax.setTranslate();
					if(s.lazy && s.params.lazyLoading) {
						s.lazy.load();
						s.lazy.initialImageLoaded = true;
					}
				}
			}
			s.attachEvents();
			if(s.params.observer && s.support.observer) {
				s.initObservers();
			}
			if(s.params.preloadImages && !s.params.lazyLoading) {
				s.preloadImages();
			}
			if(s.params.autoplay) {
				s.startAutoplay();
			}
			if(s.params.keyboardControl) {
				if(s.enableKeyboardControl) s.enableKeyboardControl();
			}
			if(s.params.mousewheelControl) {
				if(s.enableMousewheelControl) s.enableMousewheelControl();
			}
			if(s.params.hashnav) {
				if(s.hashnav) s.hashnav.init();
			}
			if(s.params.a11y && s.a11y) s.a11y.init();
			s.emit('onInit', s);
		};

		// Cleanup dynamic styles
		s.cleanupStyles = function() {
			// Container
			s.container.removeClass(s.classNames.join(' ')).removeAttr('style');

			// Wrapper
			s.wrapper.removeAttr('style');

			// Slides
			if(s.slides && s.slides.length) {
				s.slides
					.removeClass([
						s.params.slideVisibleClass,
						s.params.slideActiveClass,
						s.params.slideNextClass,
						s.params.slidePrevClass
					].join(' '))
					.removeAttr('style')
					.removeAttr('data-swiper-column')
					.removeAttr('data-swiper-row');
			}

			// Pagination/Bullets
			if(s.paginationContainer && s.paginationContainer.length) {
				s.paginationContainer.removeClass(s.params.paginationHiddenClass);
			}
			if(s.bullets && s.bullets.length) {
				s.bullets.removeClass(s.params.bulletActiveClass);
			}

			// Buttons
			if(s.params.prevButton) $(s.params.prevButton).removeClass(s.params.buttonDisabledClass);
			if(s.params.nextButton) $(s.params.nextButton).removeClass(s.params.buttonDisabledClass);

			// Scrollbar
			if(s.params.scrollbar && s.scrollbar) {
				if(s.scrollbar.track && s.scrollbar.track.length) s.scrollbar.track.removeAttr('style');
				if(s.scrollbar.drag && s.scrollbar.drag.length) s.scrollbar.drag.removeAttr('style');
			}
		};

		// Destroy
		s.destroy = function(deleteInstance, cleanupStyles) {
			// Detach evebts
			s.detachEvents();
			// Stop autoplay
			s.stopAutoplay();
			// Disable draggable
			if(s.params.scrollbar && s.scrollbar) {
				if(s.params.scrollbarDraggable) {
					s.scrollbar.disableDraggable();
				}
			}
			// Destroy loop
			if(s.params.loop) {
				s.destroyLoop();
			}
			// Cleanup styles
			if(cleanupStyles) {
				s.cleanupStyles();
			}
			// Disconnect observer
			s.disconnectObservers();
			// Disable keyboard/mousewheel
			if(s.params.keyboardControl) {
				if(s.disableKeyboardControl) s.disableKeyboardControl();
			}
			if(s.params.mousewheelControl) {
				if(s.disableMousewheelControl) s.disableMousewheelControl();
			}
			// Disable a11y
			if(s.params.a11y && s.a11y) s.a11y.destroy();
			// Destroy callback
			s.emit('onDestroy');
			// Delete instance
			if(deleteInstance !== false) s = null;
		};

		s.init();

		// Return swiper instance
		return s;
	};

	/*==================================================
	 Prototype
	 ====================================================*/
	Swiper.prototype = {
		isSafari: (function() {
			var ua = navigator.userAgent.toLowerCase();
			return(ua.indexOf('safari') >= 0 && ua.indexOf('chrome') < 0 && ua.indexOf('android') < 0);
		})(),
		isUiWebView: /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test(navigator.userAgent),
		isArray: function(arr) {
			return Object.prototype.toString.apply(arr) === '[object Array]';
		},
		/*==================================================
		 Browser
		 ====================================================*/
		browser: {
			ie: window.navigator.pointerEnabled || window.navigator.msPointerEnabled,
			ieTouch: (window.navigator.msPointerEnabled && window.navigator.msMaxTouchPoints > 1) || (window.navigator.pointerEnabled && window.navigator.maxTouchPoints > 1)
		},
		/*==================================================
		 Devices
		 ====================================================*/
		device: (function() {
			var ua = navigator.userAgent;
			var android = ua.match(/(Android);?[\s\/]+([\d.]+)?/);
			var ipad = ua.match(/(iPad).*OS\s([\d_]+)/);
			var ipod = ua.match(/(iPod)(.*OS\s([\d_]+))?/);
			var iphone = !ipad && ua.match(/(iPhone\sOS)\s([\d_]+)/);
			return {
				ios: ipad || iphone || ipod,
				android: android
			};
		})(),
		/*==================================================
		 Feature Detection
		 ====================================================*/
		support: {
			touch: (window.Modernizr && Modernizr.touch === true) || (function() {
				return !!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch);
			})(),

			transforms3d: (window.Modernizr && Modernizr.csstransforms3d === true) || (function() {
				var div = document.createElement('div').style;
				return('webkitPerspective' in div || 'MozPerspective' in div || 'OPerspective' in div || 'MsPerspective' in div || 'perspective' in div);
			})(),

			flexbox: (function() {
				var div = document.createElement('div').style;
				var styles = ('alignItems webkitAlignItems webkitBoxAlign msFlexAlign mozBoxAlign webkitFlexDirection msFlexDirection mozBoxDirection mozBoxOrient webkitBoxDirection webkitBoxOrient').split(' ');
				for(var i = 0; i < styles.length; i++) {
					if(styles[i] in div) return true;
				}
			})(),

			observer: (function() {
				return('MutationObserver' in window || 'WebkitMutationObserver' in window);
			})()
		},
		/*==================================================
		 Plugins
		 ====================================================*/
		plugins: {}
	};

	/*===========================
	 Dom7 Library
	 ===========================*/
	var Dom7 = (function() {
		var Dom7 = function(arr) {
			var _this = this,
				i = 0;
			// Create array-like object
			for(i = 0; i < arr.length; i++) {
				_this[i] = arr[i];
			}
			_this.length = arr.length;
			// Return collection with methods
			return this;
		};
		var $ = function(selector, context) {
			var arr = [],
				i = 0;
			if(selector && !context) {
				if(selector instanceof Dom7) {
					return selector;
				}
			}
			if(selector) {
				// String
				if(typeof selector === 'string') {
					var els, tempParent, html = selector.trim();
					if(html.indexOf('<') >= 0 && html.indexOf('>') >= 0) {
						var toCreate = 'div';
						if(html.indexOf('<li') === 0) toCreate = 'ul';
						if(html.indexOf('<tr') === 0) toCreate = 'tbody';
						if(html.indexOf('<td') === 0 || html.indexOf('<th') === 0) toCreate = 'tr';
						if(html.indexOf('<tbody') === 0) toCreate = 'table';
						if(html.indexOf('<option') === 0) toCreate = 'select';
						tempParent = document.createElement(toCreate);
						tempParent.innerHTML = selector;
						for(i = 0; i < tempParent.childNodes.length; i++) {
							arr.push(tempParent.childNodes[i]);
						}
					} else {
						if(!context && selector[0] === '#' && !selector.match(/[ .<>:~]/)) {
							// Pure ID selector
							els = [document.getElementById(selector.split('#')[1])];
						} else {
							// Other selectors
							els = (context || document).querySelectorAll(selector);
						}
						for(i = 0; i < els.length; i++) {
							if(els[i]) arr.push(els[i]);
						}
					}
				}
				// Node/element
				else if(selector.nodeType || selector === window || selector === document) {
					arr.push(selector);
				}
				//Array of elements or instance of Dom
				else if(selector.length > 0 && selector[0].nodeType) {
					for(i = 0; i < selector.length; i++) {
						arr.push(selector[i]);
					}
				}
			}
			return new Dom7(arr);
		};
		Dom7.prototype = {
			// Classes and attriutes
			addClass: function(className) {
				if(typeof className === 'undefined') {
					return this;
				}
				var classes = className.split(' ');
				for(var i = 0; i < classes.length; i++) {
					for(var j = 0; j < this.length; j++) {
						this[j].classList.add(classes[i]);
					}
				}
				return this;
			},
			removeClass: function(className) {
				var classes = className.split(' ');
				for(var i = 0; i < classes.length; i++) {
					for(var j = 0; j < this.length; j++) {
						this[j].classList.remove(classes[i]);
					}
				}
				return this;
			},
			hasClass: function(className) {
				if(!this[0]) return false;
				else return this[0].classList.contains(className);
			},
			toggleClass: function(className) {
				var classes = className.split(' ');
				for(var i = 0; i < classes.length; i++) {
					for(var j = 0; j < this.length; j++) {
						this[j].classList.toggle(classes[i]);
					}
				}
				return this;
			},
			attr: function(attrs, value) {
				if(arguments.length === 1 && typeof attrs === 'string') {
					// Get attr
					if(this[0]) return this[0].getAttribute(attrs);
					else return undefined;
				} else {
					// Set attrs
					for(var i = 0; i < this.length; i++) {
						if(arguments.length === 2) {
							// String
							this[i].setAttribute(attrs, value);
						} else {
							// Object
							for(var attrName in attrs) {
								this[i][attrName] = attrs[attrName];
								this[i].setAttribute(attrName, attrs[attrName]);
							}
						}
					}
					return this;
				}
			},
			removeAttr: function(attr) {
				for(var i = 0; i < this.length; i++) {
					this[i].removeAttribute(attr);
				}
				return this;
			},
			data: function(key, value) {
				if(typeof value === 'undefined') {
					// Get value
					if(this[0]) {
						var dataKey = this[0].getAttribute('data-' + key);
						if(dataKey) return dataKey;
						else if(this[0].dom7ElementDataStorage && (key in this[0].dom7ElementDataStorage)) return this[0].dom7ElementDataStorage[key];
						else return undefined;
					} else return undefined;
				} else {
					// Set value
					for(var i = 0; i < this.length; i++) {
						var el = this[i];
						if(!el.dom7ElementDataStorage) el.dom7ElementDataStorage = {};
						el.dom7ElementDataStorage[key] = value;
					}
					return this;
				}
			},
			// Transforms
			transform: function(transform) {
				for(var i = 0; i < this.length; i++) {
					var elStyle = this[i].style;
					elStyle.webkitTransform = elStyle.MsTransform = elStyle.msTransform = elStyle.MozTransform = elStyle.OTransform = elStyle.transform = transform;
				}
				return this;
			},
			transition: function(duration) {
				if(typeof duration !== 'string') {
					duration = duration + 'ms';
				}
				for(var i = 0; i < this.length; i++) {
					var elStyle = this[i].style;
					elStyle.webkitTransitionDuration = elStyle.MsTransitionDuration = elStyle.msTransitionDuration = elStyle.MozTransitionDuration = elStyle.OTransitionDuration = elStyle.transitionDuration = duration;
				}
				return this;
			},
			//Events
			on: function(eventName, targetSelector, listener, capture) {
				function handleLiveEvent(e) {
					var target = e.target;
					if($(target).is(targetSelector)) listener.call(target, e);
					else {
						var parents = $(target).parents();
						for(var k = 0; k < parents.length; k++) {
							if($(parents[k]).is(targetSelector)) listener.call(parents[k], e);
						}
					}
				}

				var events = eventName.split(' ');
				var i, j;
				for(i = 0; i < this.length; i++) {
					if(typeof targetSelector === 'function' || targetSelector === false) {
						// Usual events
						if(typeof targetSelector === 'function') {
							listener = arguments[1];
							capture = arguments[2] || false;
						}
						for(j = 0; j < events.length; j++) {
							this[i].addEventListener(events[j], listener, capture);
						}
					} else {
						//Live events
						for(j = 0; j < events.length; j++) {
							if(!this[i].dom7LiveListeners) this[i].dom7LiveListeners = [];
							this[i].dom7LiveListeners.push({ listener: listener, liveListener: handleLiveEvent });
							this[i].addEventListener(events[j], handleLiveEvent, capture);
						}
					}
				}

				return this;
			},
			off: function(eventName, targetSelector, listener, capture) {
				var events = eventName.split(' ');
				for(var i = 0; i < events.length; i++) {
					for(var j = 0; j < this.length; j++) {
						if(typeof targetSelector === 'function' || targetSelector === false) {
							// Usual events
							if(typeof targetSelector === 'function') {
								listener = arguments[1];
								capture = arguments[2] || false;
							}
							this[j].removeEventListener(events[i], listener, capture);
						} else {
							// Live event
							if(this[j].dom7LiveListeners) {
								for(var k = 0; k < this[j].dom7LiveListeners.length; k++) {
									if(this[j].dom7LiveListeners[k].listener === listener) {
										this[j].removeEventListener(events[i], this[j].dom7LiveListeners[k].liveListener, capture);
									}
								}
							}
						}
					}
				}
				return this;
			},
			once: function(eventName, targetSelector, listener, capture) {
				var dom = this;
				if(typeof targetSelector === 'function') {
					targetSelector = false;
					listener = arguments[1];
					capture = arguments[2];
				}

				function proxy(e) {
					listener(e);
					dom.off(eventName, targetSelector, proxy, capture);
				}

				dom.on(eventName, targetSelector, proxy, capture);
			},
			trigger: function(eventName, eventData) {
				for(var i = 0; i < this.length; i++) {
					var evt;
					try {
						evt = new window.CustomEvent(eventName, { detail: eventData, bubbles: true, cancelable: true });
					} catch(e) {
						evt = document.createEvent('Event');
						evt.initEvent(eventName, true, true);
						evt.detail = eventData;
					}
					this[i].dispatchEvent(evt);
				}
				return this;
			},
			transitionEnd: function(callback) {
				var events = ['webkitTransitionEnd', 'transitionend', 'oTransitionEnd', 'MSTransitionEnd', 'msTransitionEnd'],
					i, j, dom = this;

				function fireCallBack(e) {
					/*jshint validthis:true */
					if(e.target !== this) return;
					callback.call(this, e);
					for(i = 0; i < events.length; i++) {
						dom.off(events[i], fireCallBack);
					}
				}

				if(callback) {
					for(i = 0; i < events.length; i++) {
						dom.on(events[i], fireCallBack);
					}
				}
				return this;
			},
			// Sizing/Styles
			width: function() {
				if(this[0] === window) {
					return window.innerWidth;
				} else {
					if(this.length > 0) {
						return parseFloat(this.css('width'));
					} else {
						return null;
					}
				}
			},
			outerWidth: function(includeMargins) {
				if(this.length > 0) {
					if(includeMargins)
						return this[0].offsetWidth + parseFloat(this.css('margin-right')) + parseFloat(this.css('margin-left'));
					else
						return this[0].offsetWidth;
				} else return null;
			},
			height: function() {
				if(this[0] === window) {
					return window.innerHeight;
				} else {
					if(this.length > 0) {
						return parseFloat(this.css('height'));
					} else {
						return null;
					}
				}
			},
			outerHeight: function(includeMargins) {
				if(this.length > 0) {
					if(includeMargins)
						return this[0].offsetHeight + parseFloat(this.css('margin-top')) + parseFloat(this.css('margin-bottom'));
					else
						return this[0].offsetHeight;
				} else return null;
			},
			offset: function() {
				if(this.length > 0) {
					var el = this[0];
					var box = el.getBoundingClientRect();
					var body = document.body;
					var clientTop = el.clientTop || body.clientTop || 0;
					var clientLeft = el.clientLeft || body.clientLeft || 0;
					var scrollTop = window.pageYOffset || el.scrollTop;
					var scrollLeft = window.pageXOffset || el.scrollLeft;
					return {
						top: box.top + scrollTop - clientTop,
						left: box.left + scrollLeft - clientLeft
					};
				} else {
					return null;
				}
			},
			css: function(props, value) {
				var i;
				if(arguments.length === 1) {
					if(typeof props === 'string') {
						if(this[0]) return window.getComputedStyle(this[0], null).getPropertyValue(props);
					} else {
						for(i = 0; i < this.length; i++) {
							for(var prop in props) {
								this[i].style[prop] = props[prop];
							}
						}
						return this;
					}
				}
				if(arguments.length === 2 && typeof props === 'string') {
					for(i = 0; i < this.length; i++) {
						this[i].style[props] = value;
					}
					return this;
				}
				return this;
			},

			//Dom manipulation
			each: function(callback) {
				for(var i = 0; i < this.length; i++) {
					callback.call(this[i], i, this[i]);
				}
				return this;
			},
			html: function(html) {
				if(typeof html === 'undefined') {
					return this[0] ? this[0].innerHTML : undefined;
				} else {
					for(var i = 0; i < this.length; i++) {
						this[i].innerHTML = html;
					}
					return this;
				}
			},
			text: function(text) {
				if(typeof text === 'undefined') {
					if(this[0]) {
						return this[0].textContent.trim();
					} else return null;
				} else {
					for(var i = 0; i < this.length; i++) {
						this[i].textContent = text;
					}
					return this;
				}
			},
			is: function(selector) {
				if(!this[0]) return false;
				var compareWith, i;
				if(typeof selector === 'string') {
					var el = this[0];
					if(el === document) return selector === document;
					if(el === window) return selector === window;

					if(el.matches) return el.matches(selector);
					else if(el.webkitMatchesSelector) return el.webkitMatchesSelector(selector);
					else if(el.mozMatchesSelector) return el.mozMatchesSelector(selector);
					else if(el.msMatchesSelector) return el.msMatchesSelector(selector);
					else {
						compareWith = $(selector);
						for(i = 0; i < compareWith.length; i++) {
							if(compareWith[i] === this[0]) return true;
						}
						return false;
					}
				} else if(selector === document) return this[0] === document;
				else if(selector === window) return this[0] === window;
				else {
					if(selector.nodeType || selector instanceof Dom7) {
						compareWith = selector.nodeType ? [selector] : selector;
						for(i = 0; i < compareWith.length; i++) {
							if(compareWith[i] === this[0]) return true;
						}
						return false;
					}
					return false;
				}

			},
			index: function() {
				if(this[0]) {
					var child = this[0];
					var i = 0;
					while((child = child.previousSibling) !== null) {
						if(child.nodeType === 1) i++;
					}
					return i;
				} else return undefined;
			},
			eq: function(index) {
				if(typeof index === 'undefined') return this;
				var length = this.length;
				var returnIndex;
				if(index > length - 1) {
					return new Dom7([]);
				}
				if(index < 0) {
					returnIndex = length + index;
					if(returnIndex < 0) return new Dom7([]);
					else return new Dom7([this[returnIndex]]);
				}
				return new Dom7([this[index]]);
			},
			append: function(newChild) {
				var i, j;
				for(i = 0; i < this.length; i++) {
					if(typeof newChild === 'string') {
						var tempDiv = document.createElement('div');
						tempDiv.innerHTML = newChild;
						while(tempDiv.firstChild) {
							this[i].appendChild(tempDiv.firstChild);
						}
					} else if(newChild instanceof Dom7) {
						for(j = 0; j < newChild.length; j++) {
							this[i].appendChild(newChild[j]);
						}
					} else {
						this[i].appendChild(newChild);
					}
				}
				return this;
			},
			prepend: function(newChild) {
				var i, j;
				for(i = 0; i < this.length; i++) {
					if(typeof newChild === 'string') {
						var tempDiv = document.createElement('div');
						tempDiv.innerHTML = newChild;
						for(j = tempDiv.childNodes.length - 1; j >= 0; j--) {
							this[i].insertBefore(tempDiv.childNodes[j], this[i].childNodes[0]);
						}
						// this[i].insertAdjacentHTML('afterbegin', newChild);
					} else if(newChild instanceof Dom7) {
						for(j = 0; j < newChild.length; j++) {
							this[i].insertBefore(newChild[j], this[i].childNodes[0]);
						}
					} else {
						this[i].insertBefore(newChild, this[i].childNodes[0]);
					}
				}
				return this;
			},
			insertBefore: function(selector) {
				var before = $(selector);
				for(var i = 0; i < this.length; i++) {
					if(before.length === 1) {
						before[0].parentNode.insertBefore(this[i], before[0]);
					} else if(before.length > 1) {
						for(var j = 0; j < before.length; j++) {
							before[j].parentNode.insertBefore(this[i].cloneNode(true), before[j]);
						}
					}
				}
			},
			insertAfter: function(selector) {
				var after = $(selector);
				for(var i = 0; i < this.length; i++) {
					if(after.length === 1) {
						after[0].parentNode.insertBefore(this[i], after[0].nextSibling);
					} else if(after.length > 1) {
						for(var j = 0; j < after.length; j++) {
							after[j].parentNode.insertBefore(this[i].cloneNode(true), after[j].nextSibling);
						}
					}
				}
			},
			next: function(selector) {
				if(this.length > 0) {
					if(selector) {
						if(this[0].nextElementSibling && $(this[0].nextElementSibling).is(selector)) return new Dom7([this[0].nextElementSibling]);
						else return new Dom7([]);
					} else {
						if(this[0].nextElementSibling) return new Dom7([this[0].nextElementSibling]);
						else return new Dom7([]);
					}
				} else return new Dom7([]);
			},
			nextAll: function(selector) {
				var nextEls = [];
				var el = this[0];
				if(!el) return new Dom7([]);
				while(el.nextElementSibling) {
					var next = el.nextElementSibling;
					if(selector) {
						if($(next).is(selector)) nextEls.push(next);
					} else nextEls.push(next);
					el = next;
				}
				return new Dom7(nextEls);
			},
			prev: function(selector) {
				if(this.length > 0) {
					if(selector) {
						if(this[0].previousElementSibling && $(this[0].previousElementSibling).is(selector)) return new Dom7([this[0].previousElementSibling]);
						else return new Dom7([]);
					} else {
						if(this[0].previousElementSibling) return new Dom7([this[0].previousElementSibling]);
						else return new Dom7([]);
					}
				} else return new Dom7([]);
			},
			prevAll: function(selector) {
				var prevEls = [];
				var el = this[0];
				if(!el) return new Dom7([]);
				while(el.previousElementSibling) {
					var prev = el.previousElementSibling;
					if(selector) {
						if($(prev).is(selector)) prevEls.push(prev);
					} else prevEls.push(prev);
					el = prev;
				}
				return new Dom7(prevEls);
			},
			parent: function(selector) {
				var parents = [];
				for(var i = 0; i < this.length; i++) {
					if(selector) {
						if($(this[i].parentNode).is(selector)) parents.push(this[i].parentNode);
					} else {
						parents.push(this[i].parentNode);
					}
				}
				return $($.unique(parents));
			},
			parents: function(selector) {
				var parents = [];
				for(var i = 0; i < this.length; i++) {
					var parent = this[i].parentNode;
					while(parent) {
						if(selector) {
							if($(parent).is(selector)) parents.push(parent);
						} else {
							parents.push(parent);
						}
						parent = parent.parentNode;
					}
				}
				return $($.unique(parents));
			},
			find: function(selector) {
				var foundElements = [];
				for(var i = 0; i < this.length; i++) {
					var found = this[i].querySelectorAll(selector);
					for(var j = 0; j < found.length; j++) {
						foundElements.push(found[j]);
					}
				}
				return new Dom7(foundElements);
			},
			children: function(selector) {
				var children = [];
				for(var i = 0; i < this.length; i++) {
					var childNodes = this[i].childNodes;

					for(var j = 0; j < childNodes.length; j++) {
						if(!selector) {
							if(childNodes[j].nodeType === 1) children.push(childNodes[j]);
						} else {
							if(childNodes[j].nodeType === 1 && $(childNodes[j]).is(selector)) children.push(childNodes[j]);
						}
					}
				}
				return new Dom7($.unique(children));
			},
			remove: function() {
				for(var i = 0; i < this.length; i++) {
					if(this[i].parentNode) this[i].parentNode.removeChild(this[i]);
				}
				return this;
			},
			add: function() {
				var dom = this;
				var i, j;
				for(i = 0; i < arguments.length; i++) {
					var toAdd = $(arguments[i]);
					for(j = 0; j < toAdd.length; j++) {
						dom[dom.length] = toAdd[j];
						dom.length++;
					}
				}
				return dom;
			}
		};
		$.fn = Dom7.prototype;
		$.unique = function(arr) {
			var unique = [];
			for(var i = 0; i < arr.length; i++) {
				if(unique.indexOf(arr[i]) === -1) unique.push(arr[i]);
			}
			return unique;
		};

		return $;
	})();

	/*===========================
	 Get Dom libraries
	 ===========================*/
	var swiperDomPlugins = ['jQuery', 'Zepto', 'Dom7'];
	for(var i = 0; i < swiperDomPlugins.length; i++) {
		if(window[swiperDomPlugins[i]]) {
			addLibraryPlugin(window[swiperDomPlugins[i]]);
		}
	}
	// Required DOM Plugins
	var domLib;
	if(typeof Dom7 === 'undefined') {
		domLib = window.Dom7 || window.Zepto || window.jQuery;
	} else {
		domLib = Dom7;
	}

	/*===========================
	 Add .swiper plugin from Dom libraries
	 ===========================*/
	function addLibraryPlugin(lib) {
		lib.fn.swiper = function(params) {
			var firstInstance;
			lib(this).each(function() {
				var s = new Swiper(this, params);
				if(!firstInstance) firstInstance = s;
			});
			return firstInstance;
		};
	}

	if(domLib) {
		if(!('transitionEnd' in domLib.fn)) {
			domLib.fn.transitionEnd = function(callback) {
				var events = ['webkitTransitionEnd', 'transitionend', 'oTransitionEnd', 'MSTransitionEnd', 'msTransitionEnd'],
					i, j, dom = this;

				function fireCallBack(e) {
					/*jshint validthis:true */
					if(e.target !== this) return;
					callback.call(this, e);
					for(i = 0; i < events.length; i++) {
						dom.off(events[i], fireCallBack);
					}
				}

				if(callback) {
					for(i = 0; i < events.length; i++) {
						dom.on(events[i], fireCallBack);
					}
				}
				return this;
			};
		}
		if(!('transform' in domLib.fn)) {
			domLib.fn.transform = function(transform) {
				for(var i = 0; i < this.length; i++) {
					var elStyle = this[i].style;
					elStyle.webkitTransform = elStyle.MsTransform = elStyle.msTransform = elStyle.MozTransform = elStyle.OTransform = elStyle.transform = transform;
				}
				return this;
			};
		}
		if(!('transition' in domLib.fn)) {
			domLib.fn.transition = function(duration) {
				if(typeof duration !== 'string') {
					duration = duration + 'ms';
				}
				for(var i = 0; i < this.length; i++) {
					var elStyle = this[i].style;
					elStyle.webkitTransitionDuration = elStyle.MsTransitionDuration = elStyle.msTransitionDuration = elStyle.MozTransitionDuration = elStyle.OTransitionDuration = elStyle.transitionDuration = duration;
				}
				return this;
			};
		}
	}

	window.Swiper = Swiper;
})();

/**
 * mvalidate.js表单校验
 */
;
(function($) {
	var type = ['input:not([type]),input[type="color"],input[type="date"],input[type="datetime"],input[type="datetime-local"],input[type="email"],input[type="file"],input[type="hidden"],input[type="month"],input[type="number"],input[type="password"],input[type="range"],input[type="search"],input[type="tel"],input[type="text"],input[type="time"],input[type="url"],input[type="week"],textarea', 'select', 'input[type="checkbox"],input[type="radio"]'],
		allTypes = type.join(","),
		extend = {};
	var fieldValidTypeHand = function($field, status, options) {
		if($field.prop("type") == "radio" || $field.prop("type") == "checkbox") {
			var $fields = options.$form.find('[name="' + $field.prop('name') + '"]');

			if($fields.filter(":checked").length > 0) {
				$fields.removeClass('field-invalid')
			} else {
				$fields.addClass('field-invalid')
			}
		} else {
			if(status.required && status.pattern && status.conditional) {
				$field.removeClass('field-invalid');
			} else {
				$field.addClass('field-invalid');
			}
		}
	};
	var fieldTooltip = (function() {
		var instance = null;

		function show(text) {
			if(!instance) {
				var $container = $('<div class="field-tooltipWrap"><div class="field-tooltipInner"><div class="field-tooltip fieldTipBounceIn">' + text + '</div></div></div>');
				$container.appendTo($("body"));
				instance = true;
				setTimeout(function() {
					$container.remove();
					instance = false;
				}, 2000)
			}
		}

		return {
			show: show
		}
	})();
	var validateField = function(event, options) {
		var $field = $(this),
			status = {
				required: true,
				conditional: true,
				pattern: true
			},
			log, //验证提示信息存储变量

			errorTipFormat = $.fn.mvalidate.errorTipFormat, //错误信息输出的格式化

			fieldValue = $.trim($field.val()) || "",

			//*****获取当前字段的data-validate
			fieldValidate = $field.attr("data-validate"),
			validation = (fieldValidate != undefined) ? extend[fieldValidate] : {},
			//*****获取当前字段的data-required
			fieldRequired = $field.attr("data-required"),
			//*****获取当前字段的data-pattern
			fieldPattern = ($field.attr('data-pattern') || ($.type(validation.pattern) == 'regexp' ? validation.pattern : /(?:)/)),

			//*****获取当前字段的data-conditional
			fieldConditional = $field.attr("data-conditional") || validation.conditional,
			//*****获取当前字段的data-description
			fieldDescription = $field.attr("data-descriptions") || validation.descriptions,
			//*****获取当前字段的data-describedby
			fieldDescribedby = $field.attr("data-describedby") || validation.describedby;

		fieldDescription = $.isPlainObject(fieldDescription) ? fieldDescription : (options.descriptions[fieldDescription] || {});
		fieldRequired = fieldRequired != '' ? (fieldRequired || !!validation.required) : true;
		if($.type(fieldPattern) != 'regexp') {
			fieldPattern = RegExp(fieldPattern);
		}

		//如果是必填验证,那么就要判断是什么类型的表单
		if(fieldRequired) {
			//如果是那种可以通过val()来判断的
			if($field.is(type[0] + ',' + type[1])) {
				if(!fieldValue.length > 0) {
					status.required = false;
				}
				//如果是raido和checkbox,通过name和checked来判断
			} else if($field.is(type[2])) {
				if($field.is('[name]')) {
					if(options.$form.find('[name="' + $field.prop('name') + '"]:checked').length == 0) {
						status.required = false;
					}
				} else {
					status.required = field.is(':checked');
				}
			}
		}
		/**如果是正则验证
		 * 只有那些类似type=text的文本框我们才能通过正则表达式去验证pattern,
		 * 而对于select,radio,checkbox pattern显然是无效的
		 */
		if($field.is(type[0])) {
			//如果不匹配
			if(!fieldPattern.test(fieldValue)) {
				if(fieldRequired) {
					status.pattern = false;
				} else {
					if(fieldValue.length > 0) {
						status.pattern = false;
					}
				}
			}
		}

		//如果是data-conditional="name"函数验证,函数返回true或者是false
		if(fieldConditional != "undefined") {
			if($.isFunction(fieldConditional)) {
				status.conditional = !!fieldConditional.call($field, fieldValue, options);
			} else {
				if(options.conditional.hasOwnProperty(fieldConditional) && !options.conditional[fieldConditional].call($field, fieldValue, options)) {
					status.conditional = false;
				}
			}
		}

		//验证通过的信息所在对象

		log = errorTipFormat(fieldDescription.valid);
		if(!status.required) {
			log = errorTipFormat(fieldDescription.required);

		} else if(!status.pattern) {
			log = errorTipFormat(fieldDescription.pattern);

		} else if(!status.conditional) {
			log = errorTipFormat(fieldDescription.conditional);
		}

		var $describedShowElem = $('[id="' + fieldDescribedby + '"]');
		//如果找打提示的容器，是第二种类型的验证
		if($describedShowElem.length > 0 && options.type == 2) {
			//如果是change 或者是keyup 同时是第一次输入的时候就不要验证
			if((event.type == "keyup" || event.type == "change") && (!$describedShowElem.children().length || !$.trim($describedShowElem.text()))) {

			} else {
				$describedShowElem.html(log || '');
				fieldValidTypeHand($field, status, options)
			}
		}

		if(typeof(validation.each) == 'function') {
			validation.each.call($field, event, status, options);
		}
		options.eachField.call($field, event, status, options);

		if(status.required && status.pattern && status.conditional) {

			if(typeof(validation.valid) == 'function') { //二外拓展的
				validation.valid.call($field, event, status, options);
			}
			options.eachValidField.call($field, event, status, options);
		} else { //验证未通过
			if(!options.firstInvalid && options.firstInvalidFocus) {
				options.firstInvalid = true;
				$field.focus();
			}
			if(options.type == 1) {
				fieldTooltip.show(log)
			}
			if(typeof(validation.invalid) == 'function') {
				validation.invalid.call($field, event, status, options);
			}
			options.eachInvalidField.call($field, event, status, options);
		}

		/**
		 * 如果是data-describedby="elemId"验证信息要显示的地方，类型3的验证:
		 *        第一元素获取焦点，keyUp的时候要一直验证，如果正确那么错误信息就隐藏，如果不正确，那么错误
		 *        提示信息要根据状态而改变,对于与验证通过，那么可以通过eachInvalid来让用户自定义，而无需要
		 *        在插件中写它的操作方式
		 */
		return status;
	};
	$.extend($, {
		mvalidateExtend: function(options) {
			return $.extend(extend, options);
		}
	});

	$.fn.mvalidate = function(options) {
		var defaults = {
				type: 1,
				validateInSubmit: true,
				sendForm: true,
				onKeyup: false,
				onChange: true,
				firstInvalidFocus: true, //第一个未通过验证的表单是否获得交代呢
				conditional: {},
				descriptions: {},
				eachField: $.noop,
				eachValidField: $.noop,
				eachInvalidField: $.noop,
				valid: $.noop,
				invalid: $.noop,
				namespace: "mvalidate"
			},
			opts = $.extend(true, defaults, options),
			flag,
			namespace = opts.namespace;

		opts.type = Number(opts.type);
		opts.firstInvalid = false;
		flag = opts.type == 1 ? false : true;
		return this.mvalidateDestroy().each(function(event) {

			var $form = $(this),
				$fields; //存放当前表单下的所有元素;
			if(!$form.is("form")) return;
			opts.$form = $form;
			$form.data(name, { "options": opts });
			$fields = $form.find(allTypes);

			//
			if(flag && opts.onKeyup) {
				$fields.filter(type[0]).each(function() {

					$(this).on("keyup." + namespace, function(event) {
						validateField.call(this, event, opts)
					})
				});
			}

			if(flag && opts.onChange) {
				$fields.each(function() {
					var $this = $(this);
					if($this.is(type[1] + ',' + type[2])) {
						$(this).on('change.' + namespace, function(event) {
							validateField.call(this, event, opts);
						})
					}
				})
			}

			//如果需要验证的时候,在提交表单的时候对所有的字段进行验证
			if(opts.validateInSubmit) {
				$form.on("submit." + namespace, function(event) {
					var formValid = true;
					opts.firstInvalid = false;
					$fields.each(function() {
						var status = validateField.call(this, event, opts);
						if(!status.pattern || !status.conditional || !status.required) {
							formValid = false;
						}
					});

					if(formValid) {
						if(!opts.sendForm) {
							event.preventDefault();
						}
						if($.isFunction(opts.valid)) {
							opts.valid.call($form, event, opts);
						}
						//验证没有通过,禁用提交事件,以及绑定在这个elem上的其他事件
					} else {
						event.preventDefault();
						event.stopImmediatePropagation();
						if($.isFunction(opts.invalid)) {
							opts.invalid.call($form, event, opts)
						}
					}

				})
			}
		})
	};
	$.fn.mvalidateDestroy = function() {
		var $form = $(this),
			$fields;
		if(name != "") {
			var dataValidate = $form.data(name);
			if($form.is('form') && $.isPlainObject(dataValidate) && typeof(dataValidate.options.namespace) == 'string') {
				$fields = $form.removeData(name).find(allTypes);
				$fields.off('.' + dataValidate.options.namespace);
			}
		}
		return $form;
	};
	$.fn.mvalidate.errorTipFormat = function(text) {
		return '<div class="zvalid-resultformat"><div class="field-invalidmsg">' + text + '</div></div>';
	}
})(Zepto);

/**
 * touch.js
 */
;
(function($) {
	var touch = {},
		touchTimeout, longTapDelay = 750,
		supportTouch = 'ontouchend' in document;

	function parentIfText(node) {
		return 'tagName' in node ? node : node.parentNode;
	}

	function swipeDirection(x1, x2, y1, y2) {
		var xDelta = Math.abs(x1 - x2),
			yDelta = Math.abs(y1 - y2);
		return xDelta >= yDelta ? (x1 - x2 > 0 ? 'Left' : 'Right') : (y1 - y2 > 0 ? 'Up' : 'Down');
	}

	function longTap() {
		if(touch.last && Date.now() - touch.last >= longTapDelay) {
			touch.el.trigger('longTap');
			touch = {};
		}
	}

	$(document).ready(function() {
		var now, delta,
			touchStartEvent = supportTouch ? 'touchstart' : 'mousedown',
			touchMoveEvent = supportTouch ? 'touchmove' : 'mousemove',
			touchEndEvent = supportTouch ? 'touchend' : 'mouseup';

		document.body.addEventListener(touchStartEvent, function(e) {
			now = Date.now();
			delta = now - (touch.last || now);
			touch.el = $(parentIfText(supportTouch ? e.touches[0].target : e.target));
			touchTimeout && window.clearTimeout(touchTimeout);
			touch.x1 = supportTouch ? e.touches[0].pageX : e.pageX;
			touch.y1 = supportTouch ? e.touches[0].pageY : e.pageY;
			if(delta > 0 && delta <= 250) touch.isDoubleTap = true;
			touch.last = now;
			window.setTimeout(longTap, longTapDelay);
		}, false);

		document.body.addEventListener(touchMoveEvent, function(e) {
			touch.x2 = supportTouch ? e.touches[0].pageX : e.pageX;
			touch.y2 = supportTouch ? e.touches[0].pageY : e.pageY;
			if(Math.abs(touch.x1 - touch.x2) > 10) {
				e.preventDefault();
			}
		}, false);

		document.body.addEventListener(touchEndEvent, function(e) {
			if(touch.isDoubleTap) {
				touch.el.trigger('doubleTap');
				touch = {};
			} else if((touch.x2 && Math.abs(touch.x1 - touch.x2) > 30) || (touch.y2 && Math.abs(touch.y1 - touch.y2) > 30)) {
				touch.el.trigger('swipe');
				touch.el.trigger('swipe' + (swipeDirection(touch.x1, touch.x2, touch.y1, touch.y2)));
				touch = {};
			} else if('last' in touch) {
				touchTimeout = window.setTimeout(function() {
					touchTimeout = null;
					touch.el.trigger('tap');
					touch = {};
				}, 250);
			}
		}, false);

		document.body.addEventListener('touchcancel', function() {
			touch = {};
		}, false);
	});

	['swipe', 'swipeLeft', 'swipeRight', 'swipeUp', 'swipeDown', 'doubleTap', 'tap', 'longTap'].forEach(function(m) {
		$.fn[m] = function(callback) {
			return this.bind(m, callback);
		};
	});
})(Zepto);

/**
 * 拼音分组
 **/
;
(function($) {
	// 汉字拼音首字母列表 本列表包含了20902个汉字,用于配合
	//函数使用,本表收录的字符的Unicode编码范围为19968至40869
	var strChineseFirstPY = "YDYQSXMWZSSXJBYMGCCZQPSSQBYCDSCDQLDYLYBSSJGYZZJJFKCCLZDHWDWZJLJPFYYNWJJTMYHZWZHFLZPPQHGSCYYYNJQYXXGJHHSDSJNKKTMOMLCRXYPSNQSECCQZGGLLYJLMYZZSECYKYYHQWJSSGGYXYZYJWWKDJHYCHMYXJTLXJYQBYXZLDWRDJRWYSRLDZJPCBZJJBRCFTLECZSTZFXXZHTRQHYBDLYCZSSYMMRFMYQZPWWJJYFCRWFDFZQPYDDWYXKYJAWJFFXYPSFTZYHHYZYSWCJYXSCLCXXWZZXNBGNNXBXLZSZSBSGPYSYZDHMDZBQBZCWDZZYYTZHBTSYYBZGNTNXQYWQSKBPHHLXGYBFMJEBJHHGQTJCYSXSTKZHLYCKGLYSMZXYALMELDCCXGZYRJXSDLTYZCQKCNNJWHJTZZCQLJSTSTBNXBTYXCEQXGKWJYFLZQLYHYXSPSFXLMPBYSXXXYDJCZYLLLSJXFHJXPJBTFFYABYXBHZZBJYZLWLCZGGBTSSMDTJZXPTHYQTGLJSCQFZKJZJQNLZWLSLHDZBWJNCJZYZSQQYCQYRZCJJWYBRTWPYFTWEXCSKDZCTBZHYZZYYJXZCFFZZMJYXXSDZZOTTBZLQWFCKSZSXFYRLNYJMBDTHJXSQQCCSBXYYTSYFBXDZTGBCNSLCYZZPSAZYZZSCJCSHZQYDXLBPJLLMQXTYDZXSQJTZPXLCGLQTZWJBHCTSYJSFXYEJJTLBGXSXJMYJQQPFZASYJNTYDJXKJCDJSZCBARTDCLYJQMWNQNCLLLKBYBZZSYHQQLTWLCCXTXLLZNTYLNEWYZYXCZXXGRKRMTCNDNJTSYYSSDQDGHSDBJGHRWRQLYBGLXHLGTGXBQJDZPYJSJYJCTMRNYMGRZJCZGJMZMGXMPRYXKJNYMSGMZJYMKMFXMLDTGFBHCJHKYLPFMDXLQJJSMTQGZSJLQDLDGJYCALCMZCSDJLLNXDJFFFFJCZFMZFFPFKHKGDPSXKTACJDHHZDDCRRCFQYJKQCCWJDXHWJLYLLZGCFCQDSMLZPBJJPLSBCJGGDCKKDEZSQCCKJGCGKDJTJDLZYCXKLQSCGJCLTFPCQCZGWPJDQYZJJBYJHSJDZWGFSJGZKQCCZLLPSPKJGQJHZZLJPLGJGJJTHJJYJZCZMLZLYQBGJWMLJKXZDZNJQSYZMLJLLJKYWXMKJLHSKJGBMCLYYMKXJQLBMLLKMDXXKWYXYSLMLPSJQQJQXYXFJTJDXMXXLLCXQBSYJBGWYMBGGBCYXPJYGPEPFGDJGBHBNSQJYZJKJKHXQFGQZKFHYGKHDKLLSDJQXPQYKYBNQSXQNSZSWHBSXWHXWBZZXDMNSJBSBKBBZKLYLXGWXDRWYQZMYWSJQLCJXXJXKJEQXSCYETLZHLYYYSDZPAQYZCMTLSHTZCFYZYXYLJSDCJQAGYSLCQLYYYSHMRQQKLDXZSCSSSYDYCJYSFSJBFRSSZQSBXXPXJYSDRCKGJLGDKZJZBDKTCSYQPYHSTCLDJDHMXMCGXYZHJDDTMHLTXZXYLYMOHYJCLTYFBQQXPFBDFHHTKSQHZYYWCNXXCRWHOWGYJLEGWDQCWGFJYCSNTMYTOLBYGWQWESJPWNMLRYDZSZTXYQPZGCWXHNGPYXSHMYQJXZTDPPBFYHZHTJYFDZWKGKZBLDNTSXHQEEGZZYLZMMZYJZGXZXKHKSTXNXXWYLYAPSTHXDWHZYMPXAGKYDXBHNHXKDPJNMYHYLPMGOCSLNZHKXXLPZZLBMLSFBHHGYGYYGGBHSCYAQTYWLXTZQCEZYDQDQMMHTKLLSZHLSJZWFYHQSWSCWLQAZYNYTLSXTHAZNKZZSZZLAXXZWWCTGQQTDDYZTCCHYQZFLXPSLZYGPZSZNGLNDQTBDLXGTCTAJDKYWNSYZLJHHZZCWNYYZYWMHYCHHYXHJKZWSXHZYXLYSKQYSPSLYZWMYPPKBYGLKZHTYXAXQSYSHXASMCHKDSCRSWJPWXSGZJLWWSCHSJHSQNHCSEGNDAQTBAALZZMSSTDQJCJKTSCJAXPLGGXHHGXXZCXPDMMHLDGTYBYSJMXHMRCPXXJZCKZXSHMLQXXTTHXWZFKHCCZDYTCJYXQHLXDHYPJQXYLSYYDZOZJNYXQEZYSQYAYXWYPDGXDDXSPPYZNDLTWRHXYDXZZJHTCXMCZLHPYYYYMHZLLHNXMYLLLMDCPPXHMXDKYCYRDLTXJCHHZZXZLCCLYLNZSHZJZZLNNRLWHYQSNJHXYNTTTKYJPYCHHYEGKCTTWLGQRLGGTGTYGYHPYHYLQYQGCWYQKPYYYTTTTLHYHLLTYTTSPLKYZXGZWGPYDSSZZDQXSKCQNMJJZZBXYQMJRTFFBTKHZKBXLJJKDXJTLBWFZPPTKQTZTGPDGNTPJYFALQMKGXBDCLZFHZCLLLLADPMXDJHLCCLGYHDZFGYDDGCYYFGYDXKSSEBDHYKDKDKHNAXXYBPBYYHXZQGAFFQYJXDMLJCSQZLLPCHBSXGJYNDYBYQSPZWJLZKSDDTACTBXZDYZYPJZQSJNKKTKNJDJGYYPGTLFYQKASDNTCYHBLWDZHBBYDWJRYGKZYHEYYFJMSDTYFZJJHGCXPLXHLDWXXJKYTCYKSSSMTWCTTQZLPBSZDZWZXGZAGYKTYWXLHLSPBCLLOQMMZSSLCMBJCSZZKYDCZJGQQDSMCYTZQQLWZQZXSSFPTTFQMDDZDSHDTDWFHTDYZJYQJQKYPBDJYYXTLJHDRQXXXHAYDHRJLKLYTWHLLRLLRCXYLBWSRSZZSYMKZZHHKYHXKSMDSYDYCJPBZBSQLFCXXXNXKXWYWSDZYQOGGQMMYHCDZTTFJYYBGSTTTYBYKJDHKYXBELHTYPJQNFXFDYKZHQKZBYJTZBXHFDXKDASWTAWAJLDYJSFHBLDNNTNQJTJNCHXFJSRFWHZFMDRYJYJWZPDJKZYJYMPCYZNYNXFBYTFYFWYGDBNZZZDNYTXZEMMQBSQEHXFZMBMFLZZSRXYMJGSXWZJSPRYDJSJGXHJJGLJJYNZZJXHGXKYMLPYYYCXYTWQZSWHWLYRJLPXSLSXMFSWWKLCTNXNYNPSJSZHDZEPTXMYYWXYYSYWLXJQZQXZDCLEEELMCPJPCLWBXSQHFWWTFFJTNQJHJQDXHWLBYZNFJLALKYYJLDXHHYCSTYYWNRJYXYWTRMDRQHWQCMFJDYZMHMYYXJWMYZQZXTLMRSPWWCHAQBXYGZYPXYYRRCLMPYMGKSJSZYSRMYJSNXTPLNBAPPYPYLXYYZKYNLDZYJZCZNNLMZHHARQMPGWQTZMXXMLLHGDZXYHXKYXYCJMFFYYHJFSBSSQLXXNDYCANNMTCJCYPRRNYTYQNYYMBMSXNDLYLYSLJRLXYSXQMLLYZLZJJJKYZZCSFBZXXMSTBJGNXYZHLXNMCWSCYZYFZLXBRNNNYLBNRTGZQYSATSWRYHYJZMZDHZGZDWYBSSCSKXSYHYTXXGCQGXZZSHYXJSCRHMKKBXCZJYJYMKQHZJFNBHMQHYSNJNZYBKNQMCLGQHWLZNZSWXKHLJHYYBQLBFCDSXDLDSPFZPSKJYZWZXZDDXJSMMEGJSCSSMGCLXXKYYYLNYPWWWGYDKZJGGGZGGSYCKNJWNJPCXBJJTQTJWDSSPJXZXNZXUMELPXFSXTLLXCLJXJJLJZXCTPSWXLYDHLYQRWHSYCSQYYBYAYWJJJQFWQCQQCJQGXALDBZZYJGKGXPLTZYFXJLTPADKYQHPMATLCPDCKBMTXYBHKLENXDLEEGQDYMSAWHZMLJTWYGXLYQZLJEEYYBQQFFNLYXRDSCTGJGXYYNKLLYQKCCTLHJLQMKKZGCYYGLLLJDZGYDHZWXPYSJBZKDZGYZZHYWYFQYTYZSZYEZZLYMHJJHTSMQWYZLKYYWZCSRKQYTLTDXWCTYJKLWSQZWBDCQYNCJSRSZJLKCDCDTLZZZACQQZZDDXYPLXZBQJYLZLLLQDDZQJYJYJZYXNYYYNYJXKXDAZWYRDLJYYYRJLXLLDYXJCYWYWNQCCLDDNYYYNYCKCZHXXCCLGZQJGKWPPCQQJYSBZZXYJSQPXJPZBSBDSFNSFPZXHDWZTDWPPTFLZZBZDMYYPQJRSDZSQZSQXBDGCPZSWDWCSQZGMDHZXMWWFYBPDGPHTMJTHZSMMBGZMBZJCFZWFZBBZMQCFMBDMCJXLGPNJBBXGYHYYJGPTZGZMQBQTCGYXJXLWZKYDPDYMGCFTPFXYZTZXDZXTGKMTYBBCLBJASKYTSSQYYMSZXFJEWLXLLSZBQJJJAKLYLXLYCCTSXMCWFKKKBSXLLLLJYXTYLTJYYTDPJHNHNNKBYQNFQYYZBYYESSESSGDYHFHWTCJBSDZZTFDMXHCNJZYMQWSRYJDZJQPDQBBSTJGGFBKJBXTGQHNGWJXJGDLLTHZHHYYYYYYSXWTYYYCCBDBPYPZYCCZYJPZYWCBDLFWZCWJDXXHYHLHWZZXJTCZLCDPXUJCZZZLYXJJTXPHFXWPYWXZPTDZZBDZCYHJHMLXBQXSBYLRDTGJRRCTTTHYTCZWMXFYTWWZCWJWXJYWCSKYBZSCCTZQNHXNWXXKHKFHTSWOCCJYBCMPZZYKBNNZPBZHHZDLSYDDYTYFJPXYNGFXBYQXCBHXCPSXTYZDMKYSNXSXLHKMZXLYHDHKWHXXSSKQYHHCJYXGLHZXCSNHEKDTGZXQYPKDHEXTYKCNYMYYYPKQYYYKXZLTHJQTBYQHXBMYHSQCKWWYLLHCYYLNNEQXQWMCFBDCCMLJGGXDQKTLXKGNQCDGZJWYJJLYHHQTTTNWCHMXCXWHWSZJYDJCCDBQCDGDNYXZTHCQRXCBHZTQCBXWGQWYYBXHMBYMYQTYEXMQKYAQYRGYZSLFYKKQHYSSQYSHJGJCNXKZYCXSBXYXHYYLSTYCXQTHYSMGSCPMMGCCCCCMTZTASMGQZJHKLOSQYLSWTMXSYQKDZLJQQYPLSYCZTCQQPBBQJZCLPKHQZYYXXDTDDTSJCXFFLLCHQXMJLWCJCXTSPYCXNDTJSHJWXDQQJSKXYAMYLSJHMLALYKXCYYDMNMDQMXMCZNNCYBZKKYFLMCHCMLHXRCJJHSYLNMTJZGZGYWJXSRXCWJGJQHQZDQJDCJJZKJKGDZQGJJYJYLXZXXCDQHHHEYTMHLFSBDJSYYSHFYSTCZQLPBDRFRZTZYKYWHSZYQKWDQZRKMSYNBCRXQBJYFAZPZZEDZCJYWBCJWHYJBQSZYWRYSZPTDKZPFPBNZTKLQYHBBZPNPPTYZZYBQNYDCPJMMCYCQMCYFZZDCMNLFPBPLNGQJTBTTNJZPZBBZNJKLJQYLNBZQHKSJZNGGQSZZKYXSHPZSNBCGZKDDZQANZHJKDRTLZLSWJLJZLYWTJNDJZJHXYAYNCBGTZCSSQMNJPJYTYSWXZFKWJQTKHTZPLBHSNJZSYZBWZZZZLSYLSBJHDWWQPSLMMFBJDWAQYZTCJTBNNWZXQXCDSLQGDSDPDZHJTQQPSWLYYJZLGYXYZLCTCBJTKTYCZJTQKBSJLGMGZDMCSGPYNJZYQYYKNXRPWSZXMTNCSZZYXYBYHYZAXYWQCJTLLCKJJTJHGDXDXYQYZZBYWDLWQCGLZGJGQRQZCZSSBCRPCSKYDZNXJSQGXSSJMYDNSTZTPBDLTKZWXQWQTZEXNQCZGWEZKSSBYBRTSSSLCCGBPSZQSZLCCGLLLZXHZQTHCZMQGYZQZNMCOCSZJMMZSQPJYGQLJYJPPLDXRGZYXCCSXHSHGTZNLZWZKJCXTCFCJXLBMQBCZZWPQDNHXLJCTHYZLGYLNLSZZPCXDSCQQHJQKSXZPBAJYEMSMJTZDXLCJYRYYNWJBNGZZTMJXLTBSLYRZPYLSSCNXPHLLHYLLQQZQLXYMRSYCXZLMMCZLTZSDWTJJLLNZGGQXPFSKYGYGHBFZPDKMWGHCXMSGDXJMCJZDYCABXJDLNBCDQYGSKYDQTXDJJYXMSZQAZDZFSLQXYJSJZYLBTXXWXQQZBJZUFBBLYLWDSLJHXJYZJWTDJCZFQZQZZDZSXZZQLZCDZFJHYSPYMPQZMLPPLFFXJJNZZYLSJEYQZFPFZKSYWJJJHRDJZZXTXXGLGHYDXCSKYSWMMZCWYBAZBJKSHFHJCXMHFQHYXXYZFTSJYZFXYXPZLCHMZMBXHZZSXYFYMNCWDABAZLXKTCSHHXKXJJZJSTHYGXSXYYHHHJWXKZXSSBZZWHHHCWTZZZPJXSNXQQJGZYZYWLLCWXZFXXYXYHXMKYYSWSQMNLNAYCYSPMJKHWCQHYLAJJMZXHMMCNZHBHXCLXTJPLTXYJHDYYLTTXFSZHYXXSJBJYAYRSMXYPLCKDUYHLXRLNLLSTYZYYQYGYHHSCCSMZCTZQXKYQFPYYRPFFLKQUNTSZLLZMWWTCQQYZWTLLMLMPWMBZSSTZRBPDDTLQJJBXZCSRZQQYGWCSXFWZLXCCRSZDZMCYGGDZQSGTJSWLJMYMMZYHFBJDGYXCCPSHXNZCSBSJYJGJMPPWAFFYFNXHYZXZYLREMZGZCYZSSZDLLJCSQFNXZKPTXZGXJJGFMYYYSNBTYLBNLHPFZDCYFBMGQRRSSSZXYSGTZRNYDZZCDGPJAFJFZKNZBLCZSZPSGCYCJSZLMLRSZBZZLDLSLLYSXSQZQLYXZLSKKBRXBRBZCYCXZZZEEYFGKLZLYYHGZSGZLFJHGTGWKRAAJYZKZQTSSHJJXDCYZUYJLZYRZDQQHGJZXSSZBYKJPBFRTJXLLFQWJHYLQTYMBLPZDXTZYGBDHZZRBGXHWNJTJXLKSCFSMWLSDQYSJTXKZSCFWJLBXFTZLLJZLLQBLSQMQQCGCZFPBPHZCZJLPYYGGDTGWDCFCZQYYYQYSSCLXZSKLZZZGFFCQNWGLHQYZJJCZLQZZYJPJZZBPDCCMHJGXDQDGDLZQMFGPSYTSDYFWWDJZJYSXYYCZCYHZWPBYKXRYLYBHKJKSFXTZJMMCKHLLTNYYMSYXYZPYJQYCSYCWMTJJKQYRHLLQXPSGTLYYCLJSCPXJYZFNMLRGJJTYZBXYZMSJYJHHFZQMSYXRSZCWTLRTQZSSTKXGQKGSPTGCZNJSJCQCXHMXGGZTQYDJKZDLBZSXJLHYQGGGTHQSZPYHJHHGYYGKGGCWJZZYLCZLXQSFTGZSLLLMLJSKCTBLLZZSZMMNYTPZSXQHJCJYQXYZXZQZCPSHKZZYSXCDFGMWQRLLQXRFZTLYSTCTMJCXJJXHJNXTNRZTZFQYHQGLLGCXSZSJDJLJCYDSJTLNYXHSZXCGJZYQPYLFHDJSBPCCZHJJJQZJQDYBSSLLCMYTTMQTBHJQNNYGKYRQYQMZGCJKPDCGMYZHQLLSLLCLMHOLZGDYYFZSLJCQZLYLZQJESHNYLLJXGJXLYSYYYXNBZLJSSZCQQCJYLLZLTJYLLZLLBNYLGQCHXYYXOXCXQKYJXXXYKLXSXXYQXCYKQXQCSGYXXYQXYGYTQOHXHXPYXXXULCYEYCHZZCBWQBBWJQZSCSZSSLZYLKDESJZWMYMCYTSDSXXSCJPQQSQYLYYZYCMDJDZYWCBTJSYDJKCYDDJLBDJJSODZYSYXQQYXDHHGQQYQHDYXWGMMMAJDYBBBPPBCMUUPLJZSMTXERXJMHQNUTPJDCBSSMSSSTKJTSSMMTRCPLZSZMLQDSDMJMQPNQDXCFYNBFSDQXYXHYAYKQYDDLQYYYSSZBYDSLNTFQTZQPZMCHDHCZCWFDXTMYQSPHQYYXSRGJCWTJTZZQMGWJJTJHTQJBBHWZPXXHYQFXXQYWYYHYSCDYDHHQMNMTMWCPBSZPPZZGLMZFOLLCFWHMMSJZTTDHZZYFFYTZZGZYSKYJXQYJZQBHMBZZLYGHGFMSHPZFZSNCLPBQSNJXZSLXXFPMTYJYGBXLLDLXPZJYZJYHHZCYWHJYLSJEXFSZZYWXKZJLUYDTMLYMQJPWXYHXSKTQJEZRPXXZHHMHWQPWQLYJJQJJZSZCPHJLCHHNXJLQWZJHBMZYXBDHHYPZLHLHLGFWLCHYYTLHJXCJMSCPXSTKPNHQXSRTYXXTESYJCTLSSLSTDLLLWWYHDHRJZSFGXTSYCZYNYHTDHWJSLHTZDQDJZXXQHGYLTZPHCSQFCLNJTCLZPFSTPDYNYLGMJLLYCQHYSSHCHYLHQYQTMZYPBYWRFQYKQSYSLZDQJMPXYYSSRHZJNYWTQDFZBWWTWWRXCWHGYHXMKMYYYQMSMZHNGCEPMLQQMTCWCTMMPXJPJJHFXYYZSXZHTYBMSTSYJTTQQQYYLHYNPYQZLCYZHZWSMYLKFJXLWGXYPJYTYSYXYMZCKTTWLKSMZSYLMPWLZWXWQZSSAQSYXYRHSSNTSRAPXCPWCMGDXHXZDZYFJHGZTTSBJHGYZSZYSMYCLLLXBTYXHBBZJKSSDMALXHYCFYGMQYPJYCQXJLLLJGSLZGQLYCJCCZOTYXMTMTTLLWTGPXYMZMKLPSZZZXHKQYSXCTYJZYHXSHYXZKXLZWPSQPYHJWPJPWXQQYLXSDHMRSLZZYZWTTCYXYSZZSHBSCCSTPLWSSCJCHNLCGCHSSPHYLHFHHXJSXYLLNYLSZDHZXYLSXLWZYKCLDYAXZCMDDYSPJTQJZLNWQPSSSWCTSTSZLBLNXSMNYYMJQBQHRZWTYYDCHQLXKPZWBGQYBKFCMZWPZLLYYLSZYDWHXPSBCMLJBSCGBHXLQHYRLJXYSWXWXZSLDFHLSLYNJLZYFLYJYCDRJLFSYZFSLLCQYQFGJYHYXZLYLMSTDJCYHBZLLNWLXXYGYYHSMGDHXXHHLZZJZXCZZZCYQZFNGWPYLCPKPYYPMCLQKDGXZGGWQBDXZZKZFBXXLZXJTPJPTTBYTSZZDWSLCHZHSLTYXHQLHYXXXYYZYSWTXZKHLXZXZPYHGCHKCFSYHUTJRLXFJXPTZTWHPLYXFCRHXSHXKYXXYHZQDXQWULHYHMJTBFLKHTXCWHJFWJCFPQRYQXCYYYQYGRPYWSGSUNGWCHKZDXYFLXXHJJBYZWTSXXNCYJJYMSWZJQRMHXZWFQSYLZJZGBHYNSLBGTTCSYBYXXWXYHXYYXNSQYXMQYWRGYQLXBBZLJSYLPSYTJZYHYZAWLRORJMKSCZJXXXYXCHDYXRYXXJDTSQFXLYLTSFFYXLMTYJMJUYYYXLTZCSXQZQHZXLYYXZHDNBRXXXJCTYHLBRLMBRLLAXKYLLLJLYXXLYCRYLCJTGJCMTLZLLCYZZPZPCYAWHJJFYBDYYZSMPCKZDQYQPBPCJPDCYZMDPBCYYDYCNNPLMTMLRMFMMGWYZBSJGYGSMZQQQZTXMKQWGXLLPJGZBQCDJJJFPKJKCXBLJMSWMDTQJXLDLPPBXCWRCQFBFQJCZAHZGMYKPHYYHZYKNDKZMBPJYXPXYHLFPNYYGXJDBKXNXHJMZJXSTRSTLDXSKZYSYBZXJLXYSLBZYSLHXJPFXPQNBYLLJQKYGZMCYZZYMCCSLCLHZFWFWYXZMWSXTYNXJHPYYMCYSPMHYSMYDYSHQYZCHMJJMZCAAGCFJBBHPLYZYLXXSDJGXDHKXXTXXNBHRMLYJSLTXMRHNLXQJXYZLLYSWQGDLBJHDCGJYQYCMHWFMJYBMBYJYJWYMDPWHXQLDYGPDFXXBCGJSPCKRSSYZJMSLBZZJFLJJJLGXZGYXYXLSZQYXBEXYXHGCXBPLDYHWETTWWCJMBTXCHXYQXLLXFLYXLLJLSSFWDPZSMYJCLMWYTCZPCHQEKCQBWLCQYDPLQPPQZQFJQDJHYMMCXTXDRMJWRHXCJZYLQXDYYNHYYHRSLSRSYWWZJYMTLTLLGTQCJZYABTCKZCJYCCQLJZQXALMZYHYWLWDXZXQDLLQSHGPJFJLJHJABCQZDJGTKHSSTCYJLPSWZLXZXRWGLDLZRLZXTGSLLLLZLYXXWGDZYGBDPHZPBRLWSXQBPFDWOFMWHLYPCBJCCLDMBZPBZZLCYQXLDOMZBLZWPDWYYGDSTTHCSQSCCRSSSYSLFYBFNTYJSZDFNDPDHDZZMBBLSLCMYFFGTJJQWFTMTPJWFNLBZCMMJTGBDZLQLPYFHYYMJYLSDCHDZJWJCCTLJCLDTLJJCPDDSQDSSZYBNDBJLGGJZXSXNLYCYBJXQYCBYLZCFZPPGKCXZDZFZTJJFJSJXZBNZYJQTTYJYHTYCZHYMDJXTTMPXSPLZCDWSLSHXYPZGTFMLCJTYCBPMGDKWYCYZCDSZZYHFLYCTYGWHKJYYLSJCXGYWJCBLLCSNDDBTZBSCLYZCZZSSQDLLMQYYHFSLQLLXFTYHABXGWNYWYYPLLSDLDLLBJCYXJZMLHLJDXYYQYTDLLLBUGBFDFBBQJZZMDPJHGCLGMJJPGAEHHBWCQXAXHHHZCHXYPHJAXHLPHJPGPZJQCQZGJJZZUZDMQYYBZZPHYHYBWHAZYJHYKFGDPFQSDLZMLJXKXGALXZDAGLMDGXMWZQYXXDXXPFDMMSSYMPFMDMMKXKSYZYSHDZKXSYSMMZZZMSYDNZZCZXFPLSTMZDNMXCKJMZTYYMZMZZMSXHHDCZJEMXXKLJSTLWLSQLYJZLLZJSSDPPMHNLZJCZYHMXXHGZCJMDHXTKGRMXFWMCGMWKDTKSXQMMMFZZYDKMSCLCMPCGMHSPXQPZDSSLCXKYXTWLWJYAHZJGZQMCSNXYYMMPMLKJXMHLMLQMXCTKZMJQYSZJSYSZHSYJZJCDAJZYBSDQJZGWZQQXFKDMSDJLFWEHKZQKJPEYPZYSZCDWYJFFMZZYLTTDZZEFMZLBNPPLPLPEPSZALLTYLKCKQZKGENQLWAGYXYDPXLHSXQQWQCQXQCLHYXXMLYCCWLYMQYSKGCHLCJNSZKPYZKCQZQLJPDMDZHLASXLBYDWQLWDNBQCRYDDZTJYBKBWSZDXDTNPJDTCTQDFXQQMGNXECLTTBKPWSLCTYQLPWYZZKLPYGZCQQPLLKCCYLPQMZCZQCLJSLQZDJXLDDHPZQDLJJXZQDXYZQKZLJCYQDYJPPYPQYKJYRMPCBYMCXKLLZLLFQPYLLLMBSGLCYSSLRSYSQTMXYXZQZFDZUYSYZTFFMZZSMZQHZSSCCMLYXWTPZGXZJGZGSJSGKDDHTQGGZLLBJDZLCBCHYXYZHZFYWXYZYMSDBZZYJGTSMTFXQYXQSTDGSLNXDLRYZZLRYYLXQHTXSRTZNGZXBNQQZFMYKMZJBZYMKBPNLYZPBLMCNQYZZZSJZHJCTZKHYZZJRDYZHNPXGLFZTLKGJTCTSSYLLGZRZBBQZZKLPKLCZYSSUYXBJFPNJZZXCDWXZYJXZZDJJKGGRSRJKMSMZJLSJYWQSKYHQJSXPJZZZLSNSHRNYPZTWCHKLPSRZLZXYJQXQKYSJYCZTLQZYBBYBWZPQDWWYZCYTJCJXCKCWDKKZXSGKDZXWWYYJQYYTCYTDLLXWKCZKKLCCLZCQQDZLQLCSFQCHQHSFSMQZZLNBJJZBSJHTSZDYSJQJPDLZCDCWJKJZZLPYCGMZWDJJBSJQZSYZYHHXJPBJYDSSXDZNCGLQMBTSFSBPDZDLZNFGFJGFSMPXJQLMBLGQCYYXBQKDJJQYRFKZTJDHCZKLBSDZCFJTPLLJGXHYXZCSSZZXSTJYGKGCKGYOQXJPLZPBPGTGYJZGHZQZZLBJLSQFZGKQQJZGYCZBZQTLDXRJXBSXXPZXHYZYCLWDXJJHXMFDZPFZHQHQMQGKSLYHTYCGFRZGNQXCLPDLBZCSCZQLLJBLHBZCYPZZPPDYMZZSGYHCKCPZJGSLJLNSCDSLDLXBMSTLDDFJMKDJDHZLZXLSZQPQPGJLLYBDSZGQLBZLSLKYYHZTTNTJYQTZZPSZQZTLLJTYYLLQLLQYZQLBDZLSLYYZYMDFSZSNHLXZNCZQZPBWSKRFBSYZMTHBLGJPMCZZLSTLXSHTCSYZLZBLFEQHLXFLCJLYLJQCBZLZJHHSSTBRMHXZHJZCLXFNBGXGTQJCZTMSFZKJMSSNXLJKBHSJXNTNLZDNTLMSJXGZJYJCZXYJYJWRWWQNZTNFJSZPZSHZJFYRDJSFSZJZBJFZQZZHZLXFYSBZQLZSGYFTZDCSZXZJBQMSZKJRHYJZCKMJKHCHGTXKXQGLXPXFXTRTYLXJXHDTSJXHJZJXZWZLCQSBTXWXGXTXXHXFTSDKFJHZYJFJXRZSDLLLTQSQQZQWZXSYQTWGWBZCGZLLYZBCLMQQTZHZXZXLJFRMYZFLXYSQXXJKXRMQDZDMMYYBSQBHGZMWFWXGMXLZPYYTGZYCCDXYZXYWGSYJYZNBHPZJSQSYXSXRTFYZGRHZTXSZZTHCBFCLSYXZLZQMZLMPLMXZJXSFLBYZMYQHXJSXRXSQZZZSSLYFRCZJRCRXHHZXQYDYHXSJJHZCXZBTYNSYSXJBQLPXZQPYMLXZKYXLXCJLCYSXXZZLXDLLLJJYHZXGYJWKJRWYHCPSGNRZLFZWFZZNSXGXFLZSXZZZBFCSYJDBRJKRDHHGXJLJJTGXJXXSTJTJXLYXQFCSGSWMSBCTLQZZWLZZKXJMLTMJYHSDDBXGZHDLBMYJFRZFSGCLYJBPMLYSMSXLSZJQQHJZFXGFQFQBPXZGYYQXGZTCQWYLTLGWSGWHRLFSFGZJMGMGBGTJFSYZZGZYZAFLSSPMLPFLCWBJZCLJJMZLPJJLYMQDMYYYFBGYGYZMLYZDXQYXRQQQHSYYYQXYLJTYXFSFSLLGNQCYHYCWFHCCCFXPYLYPLLZYXXXXXKQHHXSHJZCFZSCZJXCPZWHHHHHAPYLQALPQAFYHXDYLUKMZQGGGDDESRNNZLTZGCHYPPYSQJJHCLLJTOLNJPZLJLHYMHEYDYDSQYCDDHGZUNDZCLZYZLLZNTNYZGSLHSLPJJBDGWXPCDUTJCKLKCLWKLLCASSTKZZDNQNTTLYYZSSYSSZZRYLJQKCQDHHCRXRZYDGRGCWCGZQFFFPPJFZYNAKRGYWYQPQXXFKJTSZZXSWZDDFBBXTBGTZKZNPZZPZXZPJSZBMQHKCYXYLDKLJNYPKYGHGDZJXXEAHPNZKZTZCMXCXMMJXNKSZQNMNLWBWWXJKYHCPSTMCSQTZJYXTPCTPDTNNPGLLLZSJLSPBLPLQHDTNJNLYYRSZFFJFQWDPHZDWMRZCCLODAXNSSNYZRESTYJWJYJDBCFXNMWTTBYLWSTSZGYBLJPXGLBOCLHPCBJLTMXZLJYLZXCLTPNCLCKXTPZJSWCYXSFYSZDKNTLBYJCYJLLSTGQCBXRYZXBXKLYLHZLQZLNZCXWJZLJZJNCJHXMNZZGJZZXTZJXYCYYCXXJYYXJJXSSSJSTSSTTPPGQTCSXWZDCSYFPTFBFHFBBLZJCLZZDBXGCXLQPXKFZFLSYLTUWBMQJHSZBMDDBCYSCCLDXYCDDQLYJJWMQLLCSGLJJSYFPYYCCYLTJANTJJPWYCMMGQYYSXDXQMZHSZXPFTWWZQSWQRFKJLZJQQYFBRXJHHFWJJZYQAZMYFRHCYYBYQWLPEXCCZSTYRLTTDMQLYKMBBGMYYJPRKZNPBSXYXBHYZDJDNGHPMFSGMWFZMFQMMBCMZZCJJLCNUXYQLMLRYGQZCYXZLWJGCJCGGMCJNFYZZJHYCPRRCMTZQZXHFQGTJXCCJEAQCRJYHPLQLSZDJRBCQHQDYRHYLYXJSYMHZYDWLDFRYHBPYDTSSCNWBXGLPZMLZZTQSSCPJMXXYCSJYTYCGHYCJWYRXXLFEMWJNMKLLSWTXHYYYNCMMCWJDQDJZGLLJWJRKHPZGGFLCCSCZMCBLTBHBQJXQDSPDJZZGKGLFQYWBZYZJLTSTDHQHCTCBCHFLQMPWDSHYYTQWCNZZJTLBYMBPDYYYXSQKXWYYFLXXNCWCXYPMAELYKKJMZZZBRXYYQJFLJPFHHHYTZZXSGQQMHSPGDZQWBWPJHZJDYSCQWZKTXXSQLZYYMYSDZGRXCKKUJLWPYSYSCSYZLRMLQSYLJXBCXTLWDQZPCYCYKPPPNSXFYZJJRCEMHSZMSXLXGLRWGCSTLRSXBZGBZGZTCPLUJLSLYLYMTXMTZPALZXPXJTJWTCYYZLBLXBZLQMYLXPGHDSLSSDMXMBDZZSXWHAMLCZCPJMCNHJYSNSYGCHSKQMZZQDLLKABLWJXSFMOCDXJRRLYQZKJMYBYQLYHETFJZFRFKSRYXFJTWDSXXSYSQJYSLYXWJHSNLXYYXHBHAWHHJZXWMYLJCSSLKYDZTXBZSYFDXGXZJKHSXXYBSSXDPYNZWRPTQZCZENYGCXQFJYKJBZMLJCMQQXUOXSLYXXLYLLJDZBTYMHPFSTTQQWLHOKYBLZZALZXQLHZWRRQHLSTMYPYXJJXMQSJFNBXYXYJXXYQYLTHYLQYFMLKLJTMLLHSZWKZHLJMLHLJKLJSTLQXYLMBHHLNLZXQJHXCFXXLHYHJJGBYZZKBXSCQDJQDSUJZYYHZHHMGSXCSYMXFEBCQWWRBPYYJQTYZCYQYQQZYHMWFFHGZFRJFCDPXNTQYZPDYKHJLFRZXPPXZDBBGZQSTLGDGYLCQMLCHHMFYWLZYXKJLYPQHSYWMQQGQZMLZJNSQXJQSYJYCBEHSXFSZPXZWFLLBCYYJDYTDTHWZSFJMQQYJLMQXXLLDTTKHHYBFPWTYYSQQWNQWLGWDEBZWCMYGCULKJXTMXMYJSXHYBRWFYMWFRXYQMXYSZTZZTFYKMLDHQDXWYYNLCRYJBLPSXCXYWLSPRRJWXHQYPHTYDNXHHMMYWYTZCSQMTSSCCDALWZTCPQPYJLLQZYJSWXMZZMMYLMXCLMXCZMXMZSQTZPPQQBLPGXQZHFLJJHYTJSRXWZXSCCDLXTYJDCQJXSLQYCLZXLZZXMXQRJMHRHZJBHMFLJLMLCLQNLDXZLLLPYPSYJYSXCQQDCMQJZZXHNPNXZMEKMXHYKYQLXSXTXJYYHWDCWDZHQYYBGYBCYSCFGPSJNZDYZZJZXRZRQJJYMCANYRJTLDPPYZBSTJKXXZYPFDWFGZZRPYMTNGXZQBYXNBUFNQKRJQZMJEGRZGYCLKXZDSKKNSXKCLJSPJYYZLQQJYBZSSQLLLKJXTBKTYLCCDDBLSPPFYLGYDTZJYQGGKQTTFZXBDKTYYHYBBFYTYYBCLPDYTGDHRYRNJSPTCSNYJQHKLLLZSLYDXXWBCJQSPXBPJZJCJDZFFXXBRMLAZHCSNDLBJDSZBLPRZTSWSBXBCLLXXLZDJZSJPYLYXXYFTFFFBHJJXGBYXJPMMMPSSJZJMTLYZJXSWXTYLEDQPJMYGQZJGDJLQJWJQLLSJGJGYGMSCLJJXDTYGJQJQJCJZCJGDZZSXQGSJGGCXHQXSNQLZZBXHSGZXCXYLJXYXYYDFQQJHJFXDHCTXJYRXYSQTJXYEFYYSSYYJXNCYZXFXMSYSZXYYSCHSHXZZZGZZZGFJDLTYLNPZGYJYZYYQZPBXQBDZTZCZYXXYHHSQXSHDHGQHJHGYWSZTMZMLHYXGEBTYLZKQWYTJZRCLEKYSTDBCYKQQSAYXCJXWWGSBHJYZYDHCSJKQCXSWXFLTYNYZPZCCZJQTZWJQDZZZQZLJJXLSBHPYXXPSXSHHEZTXFPTLQYZZXHYTXNCFZYYHXGNXMYWXTZSJPTHHGYMXMXQZXTSBCZYJYXXTYYZYPCQLMMSZMJZZLLZXGXZAAJZYXJMZXWDXZSXZDZXLEYJJZQBHZWZZZQTZPSXZTDSXJJJZNYAZPHXYYSRNQDTHZHYYKYJHDZXZLSWCLYBZYECWCYCRYLCXNHZYDZYDYJDFRJJHTRSQTXYXJRJHOJYNXELXSFSFJZGHPZSXZSZDZCQZBYYKLSGSJHCZSHDGQGXYZGXCHXZJWYQWGYHKSSEQZZNDZFKWYSSTCLZSTSYMCDHJXXYWEYXCZAYDMPXMDSXYBSQMJMZJMTZQLPJYQZCGQHXJHHLXXHLHDLDJQCLDWBSXFZZYYSCHTYTYYBHECXHYKGJPXHHYZJFXHWHBDZFYZBCAPNPGNYDMSXHMMMMAMYNBYJTMPXYYMCTHJBZYFCGTYHWPHFTWZZEZSBZEGPFMTSKFTYCMHFLLHGPZJXZJGZJYXZSBBQSCZZLZCCSTPGXMJSFTCCZJZDJXCYBZLFCJSYZFGSZLYBCWZZBYZDZYPSWYJZXZBDSYUXLZZBZFYGCZXBZHZFTPBGZGEJBSTGKDMFHYZZJHZLLZZGJQZLSFDJSSCBZGPDLFZFZSZYZYZSYGCXSNXXCHCZXTZZLJFZGQSQYXZJQDCCZTQCDXZJYQJQCHXZTDLGSCXZSYQJQTZWLQDQZTQCHQQJZYEZZZPBWKDJFCJPZTYPQYQTTYNLMBDKTJZPQZQZZFPZSBNJLGYJDXJDZZKZGQKXDLPZJTCJDQBXDJQJSTCKNXBXZMSLYJCQMTJQWWCJQNJNLLLHJCWQTBZQYDZCZPZZDZYDDCYZZZCCJTTJFZDPRRTZTJDCQTQZDTJNPLZBCLLCTZSXKJZQZPZLBZRBTJDCXFCZDBCCJJLTQQPLDCGZDBBZJCQDCJWYNLLZYZCCDWLLXWZLXRXNTQQCZXKQLSGDFQTDDGLRLAJJTKUYMKQLLTZYTDYYCZGJWYXDXFRSKSTQTENQMRKQZHHQKDLDAZFKYPBGGPZREBZZYKZZSPEGJXGYKQZZZSLYSYYYZWFQZYLZZLZHWCHKYPQGNPGBLPLRRJYXCCSYYHSFZFYBZYYTGZXYLXCZWXXZJZBLFFLGSKHYJZEYJHLPLLLLCZGXDRZELRHGKLZZYHZLYQSZZJZQLJZFLNBHGWLCZCFJYSPYXZLZLXGCCPZBLLCYBBBBUBBCBPCRNNZCZYRBFSRLDCGQYYQXYGMQZWTZYTYJXYFWTEHZZJYWLCCNTZYJJZDEDPZDZTSYQJHDYMBJNYJZLXTSSTPHNDJXXBYXQTZQDDTJTDYYTGWSCSZQFLSHLGLBCZPHDLYZJYCKWTYTYLBNYTSDSYCCTYSZYYEBHEXHQDTWNYGYCLXTSZYSTQMYGZAZCCSZZDSLZCLZRQXYYELJSBYMXSXZTEMBBLLYYLLYTDQYSHYMRQWKFKBFXNXSBYCHXBWJYHTQBPBSBWDZYLKGZSKYHXQZJXHXJXGNLJKZLYYCDXLFYFGHLJGJYBXQLYBXQPQGZTZPLNCYPXDJYQYDYMRBESJYYHKXXSTMXRCZZYWXYQYBMCLLYZHQYZWQXDBXBZWZMSLPDMYSKFMZKLZCYQYCZLQXFZZYDQZPZYGYJYZMZXDZFYFYTTQTZHGSPCZMLCCYTZXJCYTJMKSLPZHYSNZLLYTPZCTZZCKTXDHXXTQCYFKSMQCCYYAZHTJPCYLZLYJBJXTPNYLJYYNRXSYLMMNXJSMYBCSYSYLZYLXJJQYLDZLPQBFZZBLFNDXQKCZFYWHGQMRDSXYCYTXNQQJZYYPFZXDYZFPRXEJDGYQBXRCNFYYQPGHYJDYZXGRHTKYLNWDZNTSMPKLBTHBPYSZBZTJZSZZJTYYXZPHSSZZBZCZPTQFZMYFLYPYBBJQXZMXXDJMTSYSKKBJZXHJCKLPSMKYJZCXTMLJYXRZZQSLXXQPYZXMKYXXXJCLJPRMYYGADYSKQLSNDHYZKQXZYZTCGHZTLMLWZYBWSYCTBHJHJFCWZTXWYTKZLXQSHLYJZJXTMPLPYCGLTBZZTLZJCYJGDTCLKLPLLQPJMZPAPXYZLKKTKDZCZZBNZDYDYQZJYJGMCTXLTGXSZLMLHBGLKFWNWZHDXUHLFMKYSLGXDTWWFRJEJZTZHYDXYKSHWFZCQSHKTMQQHTZHYMJDJSKHXZJZBZZXYMPAGQMSTPXLSKLZYNWRTSQLSZBPSPSGZWYHTLKSSSWHZZLYYTNXJGMJSZSUFWNLSOZTXGXLSAMMLBWLDSZYLAKQCQCTMYCFJBSLXCLZZCLXXKSBZQCLHJPSQPLSXXCKSLNHPSFQQYTXYJZLQLDXZQJZDYYDJNZPTUZDSKJFSLJHYLZSQZLBTXYDGTQFDBYAZXDZHZJNHHQBYKNXJJQCZMLLJZKSPLDYCLBBLXKLELXJLBQYCXJXGCNLCQPLZLZYJTZLJGYZDZPLTQCSXFDMNYCXGBTJDCZNBGBQYQJWGKFHTNPYQZQGBKPBBYZMTJDYTBLSQMPSXTBNPDXKLEMYYCJYNZCTLDYKZZXDDXHQSHDGMZSJYCCTAYRZLPYLTLKXSLZCGGEXCLFXLKJRTLQJAQZNCMBYDKKCXGLCZJZXJHPTDJJMZQYKQSECQZDSHHADMLZFMMZBGNTJNNLGBYJBRBTMLBYJDZXLCJLPLDLPCQDHLXZLYCBLCXZZJADJLNZMMSSSMYBHBSQKBHRSXXJMXSDZNZPXLGBRHWGGFCXGMSKLLTSJYYCQLTSKYWYYHYWXBXQYWPYWYKQLSQPTNTKHQCWDQKTWPXXHCPTHTWUMSSYHBWCRWXHJMKMZNGWTMLKFGHKJYLSYYCXWHYECLQHKQHTTQKHFZLDXQWYZYYDESBPKYRZPJFYYZJCEQDZZDLATZBBFJLLCXDLMJSSXEGYGSJQXCWBXSSZPDYZCXDNYXPPZYDLYJCZPLTXLSXYZYRXCYYYDYLWWNZSAHJSYQYHGYWWAXTJZDAXYSRLTDPSSYYFNEJDXYZHLXLLLZQZSJNYQYQQXYJGHZGZCYJCHZLYCDSHWSHJZYJXCLLNXZJJYYXNFXMWFPYLCYLLABWDDHWDXJMCXZTZPMLQZHSFHZYNZTLLDYWLSLXHYMMYLMBWWKYXYADTXYLLDJPYBPWUXJMWMLLSAFDLLYFLBHHHBQQLTZJCQJLDJTFFKMMMBYTHYGDCQRDDWRQJXNBYSNWZDBYYTBJHPYBYTTJXAAHGQDQTMYSTQXKBTZPKJLZRBEQQSSMJJBDJOTGTBXPGBKTLHQXJJJCTHXQDWJLWRFWQGWSHCKRYSWGFTGYGBXSDWDWRFHWYTJJXXXJYZYSLPYYYPAYXHYDQKXSHXYXGSKQHYWFDDDPPLCJLQQEEWXKSYYKDYPLTJTHKJLTCYYHHJTTPLTZZCDLTHQKZXQYSTEEYWYYZYXXYYSTTJKLLPZMCYHQGXYHSRMBXPLLNQYDQHXSXXWGDQBSHYLLPJJJTHYJKYPPTHYYKTYEZYENMDSHLCRPQFDGFXZPSFTLJXXJBSWYYSKSFLXLPPLBBBLBSFXFYZBSJSSYLPBBFFFFSSCJDSTZSXZRYYSYFFSYZYZBJTBCTSBSDHRTJJBYTCXYJEYLXCBNEBJDSYXYKGSJZBXBYTFZWGENYHHTHZHHXFWGCSTBGXKLSXYWMTMBYXJSTZSCDYQRCYTWXZFHMYMCXLZNSDJTTTXRYCFYJSBSDYERXJLJXBBDEYNJGHXGCKGSCYMBLXJMSZNSKGXFBNBPTHFJAAFXYXFPXMYPQDTZCXZZPXRSYWZDLYBBKTYQPQJPZYPZJZNJPZJLZZFYSBTTSLMPTZRTDXQSJEHBZYLZDHLJSQMLHTXTJECXSLZZSPKTLZKQQYFSYGYWPCPQFHQHYTQXZKRSGTTSQCZLPTXCDYYZXSQZSLXLZMYCPCQBZYXHBSXLZDLTCDXTYLZJYYZPZYZLTXJSJXHLPMYTXCQRBLZSSFJZZTNJYTXMYJHLHPPLCYXQJQQKZZSCPZKSWALQSBLCCZJSXGWWWYGYKTJBBZTDKHXHKGTGPBKQYSLPXPJCKBMLLXDZSTBKLGGQKQLSBKKTFXRMDKBFTPZFRTBBRFERQGXYJPZSSTLBZTPSZQZSJDHLJQLZBPMSMMSXLQQNHKNBLRDDNXXDHDDJCYYGYLXGZLXSYGMQQGKHBPMXYXLYTQWLWGCPBMQXCYZYDRJBHTDJYHQSHTMJSBYPLWHLZFFNYPMHXXHPLTBQPFBJWQDBYGPNZTPFZJGSDDTQSHZEAWZZYLLTYYBWJKXXGHLFKXDJTMSZSQYNZGGSWQSPHTLSSKMCLZXYSZQZXNCJDQGZDLFNYKLJCJLLZLMZZNHYDSSHTHZZLZZBBHQZWWYCRZHLYQQJBEYFXXXWHSRXWQHWPSLMSSKZTTYGYQQWRSLALHMJTQJSMXQBJJZJXZYZKXBYQXBJXSHZTSFJLXMXZXFGHKZSZGGYLCLSARJYHSLLLMZXELGLXYDJYTLFBHBPNLYZFBBHPTGJKWETZHKJJXZXXGLLJLSTGSHJJYQLQZFKCGNNDJSSZFDBCTWWSEQFHQJBSAQTGYPQLBXBMMYWXGSLZHGLZGQYFLZBYFZJFRYSFMBYZHQGFWZSYFYJJPHZBYYZFFWODGRLMFTWLBZGYCQXCDJYGZYYYYTYTYDWEGAZYHXJLZYYHLRMGRXXZCLHNELJJTJTPWJYBJJBXJJTJTEEKHWSLJPLPSFYZPQQBDLQJJTYYQLYZKDKSQJYYQZLDQTGJQYZJSUCMRYQTHTEJMFCTYHYPKMHYZWJDQFHYYXWSHCTXRLJHQXHCCYYYJLTKTTYTMXGTCJTZAYYOCZLYLBSZYWJYTSJYHBYSHFJLYGJXXTMZYYLTXXYPZLXYJZYZYYPNHMYMDYYLBLHLSYYQQLLNJJYMSOYQBZGDLYXYLCQYXTSZEGXHZGLHWBLJHEYXTWQMAKBPQCGYSHHEGQCMWYYWLJYJHYYZLLJJYLHZYHMGSLJLJXCJJYCLYCJPCPZJZJMMYLCQLNQLJQJSXYJMLSZLJQLYCMMHCFMMFPQQMFYLQMCFFQMMMMHMZNFHHJGTTHHKHSLNCHHYQDXTMMQDCYZYXYQMYQYLTDCYYYZAZZCYMZYDLZFFFMMYCQZWZZMABTBYZTDMNZZGGDFTYPCGQYTTSSFFWFDTZQSSYSTWXJHXYTSXXYLBYQHWWKXHZXWZNNZZJZJJQJCCCHYYXBZXZCYZTLLCQXYNJYCYYCYNZZQYYYEWYCZDCJYCCHYJLBTZYYCQWMPWPYMLGKDLDLGKQQBGYCHJXY";
	//此处收录了375个多音字,
	var oMultiDiff = {
		"19969": "DZ",
		"19975": "WM",
		"19988": "QJ",
		"20048": "YL",
		"20056": "SC",
		"20060": "NM",
		"20094": "QG",
		"20127": "QJ",
		"20167": "QC",
		"20193": "YG",
		"20250": "KH",
		"20256": "ZC",
		"20282": "SC",
		"20285": "QJG",
		"20291": "TD",
		"20314": "YD",
		"20340": "NE",
		"20375": "TD",
		"20389": "YJ",
		"20391": "CZ",
		"20415": "PB",
		"20446": "YS",
		"20447": "SQ",
		"20504": "TC",
		"20608": "KG",
		"20854": "QJ",
		"20857": "ZC",
		"20911": "PF",
		"20504": "TC",
		"20608": "KG",
		"20854": "QJ",
		"20857": "ZC",
		"20911": "PF",
		"20985": "AW",
		"21032": "PB",
		"21048": "XQ",
		"21049": "SC",
		"21089": "YS",
		"21119": "JC",
		"21242": "SB",
		"21273": "SC",
		"21305": "YP",
		"21306": "QO",
		"21330": "ZC",
		"21333": "SDC",
		"21345": "QK",
		"21378": "CA",
		"21397": "SC",
		"21414": "XS",
		"21442": "SC",
		"21477": "JG",
		"21480": "TD",
		"21484": "ZS",
		"21494": "YX",
		"21505": "YX",
		"21512": "HG",
		"21523": "XH",
		"21537": "PB",
		"21542": "PF",
		"21549": "KH",
		"21571": "E",
		"21574": "DA",
		"21588": "TD",
		"21589": "O",
		"21618": "ZC",
		"21621": "KHA",
		"21632": "ZJ",
		"21654": "KG",
		"21679": "LKG",
		"21683": "KH",
		"21710": "A",
		"21719": "YH",
		"21734": "WOE",
		"21769": "A",
		"21780": "WN",
		"21804": "XH",
		"21834": "A",
		"21899": "ZD",
		"21903": "RN",
		"21908": "WO",
		"21939": "ZC",
		"21956": "SA",
		"21964": "YA",
		"21970": "TD",
		"22003": "A",
		"22031": "JG",
		"22040": "XS",
		"22060": "ZC",
		"22066": "ZC",
		"22079": "MH",
		"22129": "XJ",
		"22179": "XA",
		"22237": "NJ",
		"22244": "TD",
		"22280": "JQ",
		"22300": "YH",
		"22313": "XW",
		"22331": "YQ",
		"22343": "YJ",
		"22351": "PH",
		"22395": "DC",
		"22412": "TD",
		"22484": "PB",
		"22500": "PB",
		"22534": "ZD",
		"22549": "DH",
		"22561": "PB",
		"22612": "TD",
		"22771": "KQ",
		"22831": "HB",
		"22841": "JG",
		"22855": "QJ",
		"22865": "XQ",
		"23013": "ML",
		"23081": "WM",
		"23487": "SX",
		"23558": "QJ",
		"23561": "YW",
		"23586": "YW",
		"23614": "YW",
		"23615": "SN",
		"23631": "PB",
		"23646": "ZS",
		"23663": "ZT",
		"23673": "YG",
		"23762": "TD",
		"23769": "ZS",
		"23780": "QJ",
		"23884": "QK",
		"24055": "XH",
		"24113": "DC",
		"24162": "ZC",
		"24191": "GA",
		"24273": "QJ",
		"24324": "NL",
		"24377": "TD",
		"24378": "QJ",
		"24439": "PF",
		"24554": "ZS",
		"24683": "TD",
		"24694": "WE",
		"24733": "LK",
		"24925": "TN",
		"25094": "ZG",
		"25100": "XQ",
		"25103": "XH",
		"25153": "PB",
		"25170": "PB",
		"25179": "KG",
		"25203": "PB",
		"25240": "ZS",
		"25282": "FB",
		"25303": "NA",
		"25324": "KG",
		"25341": "ZY",
		"25373": "WZ",
		"25375": "XJ",
		"25384": "A",
		"25457": "A",
		"25528": "SD",
		"25530": "SC",
		"25552": "TD",
		"25774": "ZC",
		"25874": "ZC",
		"26044": "YW",
		"26080": "WM",
		"26292": "PB",
		"26333": "PB",
		"26355": "ZY",
		"26366": "CZ",
		"26397": "ZC",
		"26399": "QJ",
		"26415": "ZS",
		"26451": "SB",
		"26526": "ZC",
		"26552": "JG",
		"26561": "TD",
		"26588": "JG",
		"26597": "CZ",
		"26629": "ZS",
		"26638": "YL",
		"26646": "XQ",
		"26653": "KG",
		"26657": "XJ",
		"26727": "HG",
		"26894": "ZC",
		"26937": "ZS",
		"26946": "ZC",
		"26999": "KJ",
		"27099": "KJ",
		"27449": "YQ",
		"27481": "XS",
		"27542": "ZS",
		"27663": "ZS",
		"27748": "TS",
		"27784": "SC",
		"27788": "ZD",
		"27795": "TD",
		"27812": "O",
		"27850": "PB",
		"27852": "MB",
		"27895": "SL",
		"27898": "PL",
		"27973": "QJ",
		"27981": "KH",
		"27986": "HX",
		"27994": "XJ",
		"28044": "YC",
		"28065": "WG",
		"28177": "SM",
		"28267": "QJ",
		"28291": "KH",
		"28337": "ZQ",
		"28463": "TL",
		"28548": "DC",
		"28601": "TD",
		"28689": "PB",
		"28805": "JG",
		"28820": "QG",
		"28846": "PB",
		"28952": "TD",
		"28975": "ZC",
		"29100": "A",
		"29325": "QJ",
		"29575": "SL",
		"29602": "FB",
		"30010": "TD",
		"30044": "CX",
		"30058": "PF",
		"30091": "YSP",
		"30111": "YN",
		"30229": "XJ",
		"30427": "SC",
		"30465": "SX",
		"30631": "YQ",
		"30655": "QJ",
		"30684": "QJG",
		"30707": "SD",
		"30729": "XH",
		"30796": "LG",
		"30917": "PB",
		"31074": "NM",
		"31085": "JZ",
		"31109": "SC",
		"31181": "ZC",
		"31192": "MLB",
		"31293": "JQ",
		"31400": "YX",
		"31584": "YJ",
		"31896": "ZN",
		"31909": "ZY",
		"31995": "XJ",
		"32321": "PF",
		"32327": "ZY",
		"32418": "HG",
		"32420": "XQ",
		"32421": "HG",
		"32438": "LG",
		"32473": "GJ",
		"32488": "TD",
		"32521": "QJ",
		"32527": "PB",
		"32562": "ZSQ",
		"32564": "JZ",
		"32735": "ZD",
		"32793": "PB",
		"33071": "PF",
		"33098": "XL",
		"33100": "YA",
		"33152": "PB",
		"33261": "CX",
		"33324": "BP",
		"33333": "TD",
		"33406": "YA",
		"33426": "WM",
		"33432": "PB",
		"33445": "JG",
		"33486": "ZN",
		"33493": "TS",
		"33507": "QJ",
		"33540": "QJ",
		"33544": "ZC",
		"33564": "XQ",
		"33617": "YT",
		"33632": "QJ",
		"33636": "XH",
		"33637": "YX",
		"33694": "WG",
		"33705": "PF",
		"33728": "YW",
		"33882": "SR",
		"34067": "WM",
		"34074": "YW",
		"34121": "QJ",
		"34255": "ZC",
		"34259": "XL",
		"34425": "JH",
		"34430": "XH",
		"34485": "KH",
		"34503": "YS",
		"34532": "HG",
		"34552": "XS",
		"34558": "YE",
		"34593": "ZL",
		"34660": "YQ",
		"34892": "XH",
		"34928": "SC",
		"34999": "QJ",
		"35048": "PB",
		"35059": "SC",
		"35098": "ZC",
		"35203": "TQ",
		"35265": "JX",
		"35299": "JX",
		"35782": "SZ",
		"35828": "YS",
		"35830": "E",
		"35843": "TD",
		"35895": "YG",
		"35977": "MH",
		"36158": "JG",
		"36228": "QJ",
		"36426": "XQ",
		"36466": "DC",
		"36710": "JC",
		"36711": "ZYG",
		"36767": "PB",
		"36866": "SK",
		"36951": "YW",
		"37034": "YX",
		"37063": "XH",
		"37218": "ZC",
		"37325": "ZC",
		"38063": "PB",
		"38079": "TD",
		"38085": "QY",
		"38107": "DC",
		"38116": "TD",
		"38123": "YD",
		"38224": "HG",
		"38241": "XTC",
		"38271": "ZC",
		"38415": "YE",
		"38426": "KH",
		"38461": "YD",
		"38463": "AE",
		"38466": "PB",
		"38477": "XJ",
		"38518": "YT",
		"38551": "WK",
		"38585": "ZC",
		"38704": "XS",
		"38739": "LJ",
		"38761": "GJ",
		"38808": "SQ",
		"39048": "JG",
		"39049": "XJ",
		"39052": "HG",
		"39076": "CZ",
		"39271": "XT",
		"39534": "TD",
		"39552": "TD",
		"39584": "PB",
		"39647": "SB",
		"39730": "LG",
		"39748": "TPB",
		"40109": "ZQ",
		"40479": "ND",
		"40516": "HG",
		"40536": "HG",
		"40583": "QJ",
		"40765": "YQ",
		"40784": "QJ",
		"40840": "YK",
		"40863": "QJG"
	};
	//参数,中文字符串
	//返回值:拼音首字母串数组
	function makePy(str) {
		if(typeof(str) != "string")
			throw new Error(-1, "函数makePy需要字符串类型参数!");
		var arrResult = new Array(); //保存中间结果的数组
		for(var i = 0, len = str.length; i < len; i++) {
			//获得unicode码
			var ch = str.charAt(i);
			//检查该unicode码是否在处理范围之内,在则返回该码对映汉字的拼音首字母,不在则调用其它函数处理
			arrResult.push(checkCh(ch));
		}
		//处理arrResult,返回所有可能的拼音首字母串数组
		return mkRslt(arrResult);
	}

	function checkCh(ch) {
		var uni = ch.charCodeAt(0);
		//如果不在汉字处理范围之内,返回原字符,也可以调用自己的处理函数
		if(uni > 40869 || uni < 19968)
			return ch; //dealWithOthers(ch);
		//检查是否是多音字,是按多音字处理,不是就直接在strChineseFirstPY字符串中找对应的首字母
		return(oMultiDiff[uni] ? oMultiDiff[uni] : (strChineseFirstPY.charAt(uni - 19968)));
	}

	function mkRslt(arr) {
		var arrRslt = [""];
		for(var i = 0, len = arr.length; i < len; i++) {
			var str = arr[i];
			var strlen = str.length;
			if(strlen == 1) {
				for(var k = 0; k < arrRslt.length; k++) {
					arrRslt[k] += str;
				}
			} else {
				var tmpArr = arrRslt.slice(0);
				arrRslt = [];
				for(k = 0; k < strlen; k++) {
					//复制一个相同的arrRslt
					var tmp = tmpArr.slice(0);
					//把当前字符str[k]添加到每个元素末尾
					for(var j = 0; j < tmp.length; j++) {
						tmp[j] += str.charAt(k);
					}
					//把复制并修改后的数组连接到arrRslt上
					arrRslt = arrRslt.concat(tmp);
				}
			}
		}
		return arrRslt;
	}

	$.extend($, {
		getInitialsArrByStr: makePy
	});
})(Zepto);

/**
 * 评分组件
 *
 * @20170626 add by pangys
 *
 */
;
(function($) {
	//构造函数
	var Rater = function(ele, opt) {
		this.$ele = ele,
			this.defaults = { //默认参数
				value: 0, //当前选中个数
				color: '#4bf', //选中颜色
				bgcolor: '#ccc' //未选中颜色
			},
			this.options = $.extend({}, this.defaults, opt),
			this.obj = null;
	}
	//评分方法
	Rater.prototype = {
		init: function() { //初始化
			var _this = this;
			_this.setValue();
			return this.$ele.on('tap', 'li', function() {
				_this.options.value = $(this).index() + 1;
				_this.setValue();
			});
		},
		setValue: function() { //设置选中值
			var _this = this;
			this.$ele.find('li').each(function(index, el) {
				if(index <= _this.options.value - 1) {
					$(this).css('color', _this.options.color);

				} else {
					$(this).css('color', _this.options.bgcolor);
				}
			});
		},
		getValue: function() { //获取当前选中值
			return this.options.value;
		}
	}
	//添加到$
	$.fn.rater = function(options) {
		var rater = new Rater(this, options);
		this[0].obj = rater;
		return rater.init();
	}
	// $.fn.getValue = function () {
	//     return this[0].obj.getValue();
	// }

})(window.Zepto);

/**
 * 直线进度条
 *
 * @20170626 add by pangys
 *
 */
;
(function($) {
	//构造函数
	var Progress = function(ele, opt) {
		this.$ele = ele;
		this.bg = this.$ele.find('.progress-bar');
		this.bar = this.$ele.find('.progress-inner-bar');
		this.progress = this.$ele.find('.progress-precent');
		this.defaults = {
			color: '4bf',
			bgColor: '#ccc',
			fontColor: '#fff',
			n: 0
		};
		this.options = $.extend({}, this.defaults, opt);
		this.bar.css('background', this.options.color);
		this.bg.css('background', this.options.bgColor);
		this.progress.css('color', this.options.fontColor);
		if(this.options.n) {
			this.progressSet(this.options.n);
		}
	}
	//添加方法
	Progress.prototype = {
		progressSet: function(n) {
			var _this = this;
			if(n < 100) {
				_this.bar.css('width', n + '%');
				_this.progress.text(parseInt(n) + '%');
			} else {
				_this.bar.css('width', 100 + '%');
				_this.progress.text(100 + '%');
			}
		},
		setValue: function(n) {
			console.log(n);
			this.progressSet(n);
		}
	}
	//添加到$
	$.fn.progress = function(options) {
		var progress = new Progress(this, options);
		this[0].obj = progress;
	}
	// $.fn.setValue = function (n) {
	//     this[0].obj.progressSet(n)
	// }
})(window.Zepto);

/**
 * 圆形进度条
 *
 * @20170627 add by pangys
 *
 */
;
(function($) {
	//构造函数
	var ArcProgress = function(ele, opts) {
		this.$ele = ele; //当前元素
		this.obj = this.$ele.find("canvas")[0]; //获取canvas对象
		this.cObj = this.obj.getContext("2d"); //获取canvas上下文
		var objWidth = this.$ele.width();
		this.default = { //设置默认参数
			objWidth: objWidth, //对象宽度
			objCenter: objWidth / 2, //画布中心点 (不建议配置)
			color: '#4bf', //进度条颜色
			bgcolor: '#ccc', //背景颜色
			lineWidth: 10, //进度条宽度
			fontColor: '#4bf', //文字颜色
			fontSize: '40px', //文字大小
			radius: objWidth / 3, //圆形半半径 (不建议配置)
			rad: Math.PI * 2 / 100 //百分之一弧度(不建议配置)
		};
		this.options = $.extend({}, this.default, opts);
	}
	//添加方法
	ArcProgress.prototype = {
		init: function() { //初始化
			this.obj.width = this.options.objWidth;
			this.obj.height = this.options.objWidth;
			this.draw(0);
			//window.requestAnimationFrame(this.draw);
		},
		draw: function(n) { //绘制方法
			if(n > 100) {
				n = 100;
			}
			this.cObj.clearRect(0, 0, this.options.objWidth, this.options.objWidth);
			//背景圆
			this.cObj.beginPath();
			this.cObj.lineWidth = this.options.lineWidth;
			this.cObj.arc(this.options.objCenter, this.options.objCenter, this.options.radius, 0, Math.PI * 2, false);
			this.cObj.strokeStyle = this.options.bgcolor;
			this.cObj.stroke();
			//圆
			this.cObj.beginPath();
			this.cObj.lineWidth = this.options.lineWidth;
			this.cObj.lineCap = 'round';
			this.cObj.arc(this.options.objCenter, this.options.objCenter, this.options.radius, -Math.PI / 2, -Math.PI / 2 + n * this.options.rad, false);
			this.cObj.strokeStyle = this.options.color;
			this.cObj.stroke();
			//文字
			this.cObj.beginPath();
			this.cObj.font = this.options.fontSize + " Arial";
			this.cObj.fillStyle = this.options.fontColor;
			this.cObj.textBaseline = 'middle';
			this.cObj.textAlign = 'center';
			this.cObj.fillText(parseInt(n) + '%', this.options.objCenter, this.options.objCenter);
		},
		setValue: function(n) {
			this.draw(n);
		}
	}
	//绑定到$
	$.fn.arcProgress = function(options) {
		var arcProgress = new ArcProgress(this, options);
		this[0].obj = arcProgress;
		return arcProgress.init();
	}
	// $.fn.setValue = function (n) {
	//    this[0].obj.draw(n);
	// }

})(window.Zepto);

/**
 * 数量增减
 *
 * @20170627 add by pangys
 *
 */
;
(function($) {
	$('.xnumber-dec').on('tap', function() {
		var tem = parseInt($(this).siblings('.xnumber-int').val()) - 1;
		$(this).siblings('.xnumber-int').val(tem);
	})
	$('.xnumber-add').on('tap', function() {
		var tem = parseInt($(this).siblings('.xnumber-int').val()) + 1;
		$(this).siblings('.xnumber-int').val(tem);
	})
})(window.Zepto)
/**
 * 滚动公告
 *
 * @20170628 add by pangys
 *
 */
;
(function() {
	//构造函数
	var Marquee = function(ele, opts) {
		this.$ele = ele;
		this.contain = this.$ele.find('ul');
		this.eleHeight = this.$ele.height();
		this.containHeight = 2 * this.contain.height();
		this.timer = null;
		this.default = {
			speed: 1
		}
		this.options = $.extend({}, this.default, opts);
		var x = this.contain.html(); //将当前列表复制一遍
		this.contain.append(x);
	}
	//添加方法
	Marquee.prototype = {
		init: function() { //初始化
			var _this = this;
			var shifting = 0;
			this.timer = setInterval(function() {
				if(shifting < _this.containHeight / 2) {
					_this.contain[0].style.transition = "top .1s";
					shifting += _this.options.speed;
					_this.contain[0].style.top = -shifting + "px";
				} else {
					_this.contain[0].style.transition = "none"
					shifting = 0;
					_this.contain[0].style.top = shifting + "px";
				}

			}, 80)
		},
		stop: function() { //停止
			var _this = this;
			clearInterval(_this.timer)
		}
	}
	//绑定到$
	$.fn.marquee = function(options) {
		var marquee = new Marquee(this, options);
		this[0].obj = marquee;
		return marquee.init();
	}
	$.fn.marqueeStop = function() {
		this[0].obj.stop();
	}
})(window.Zepto)

/**
 * 支持左滑列表
 *
 * @20170629 add by pangys
 *
 */
;
(function() {
	//构造函数
	var SwipeItemContent = function(ele, opts) {
		this.$ele = ele;
		var supportTouch = 'ontouchend' in document,
			touchStartEvent = supportTouch ? 'touchstart' : 'mousedown', //触屏
			touchMoveEvent = supportTouch ? 'touchmove' : 'mousemove', //移动
			touchEndEvent = supportTouch ? 'touchend' : 'mouseup', //离屏
			startPosition, movePosition, endPosition, down, moveWidth; //开始位置、移动位置、结束位置、是否滑动、滑动距离
		//设置定位（修改默认列表定位）
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
			'transform': 'translate3d(' + moveWidth + 'px, 0px, 0px)',
			'position': 'absolute',
			'right': '0'
		})
		//获取开始位置
		this.$ele.on(touchStartEvent, 'ul', function(e) {
			startPosition = supportTouch ? e.touches[0].pageX : e.pageX;
			down = true;
		})
		//触屏滑动动
		this.$ele.on(touchMoveEvent, 'ul', function(e) {
			if(down) {
				movePosition = supportTouch ? e.touches[0].pageX : e.pageX;
				endPosition = movePosition;
				movePosition = movePosition - startPosition;
				$(this).find('.item-media')[0].style.transform = 'translate3d(' + movePosition + 'px, 0px, 0px)';
				$(this).find('.item-inner')[0].style.transform = 'translate3d(' + movePosition + 'px, 0px, 0px)';
			}
		})
		//结束位置
		this.$ele.on(touchEndEvent, 'ul', function(e) {
			down = false;
			if(endPosition - startPosition < -40) { //40滑动有效范围
				$(this).find('.item-media')[0].style.transform = 'translate3d(-' + moveWidth + 'px, 0px, 0px)';
				$(this).find('.item-inner')[0].style.transform = 'translate3d(-' + moveWidth + 'px, 0px, 0px)';
			} else {
				$(this).find('.item-media')[0].style.transform = 'translate3d(0px, 0px, 0px)';
				$(this).find('.item-inner')[0].style.transform = 'translate3d(0px, 0px, 0px)';
			}
			down = false;
		})
	}
	//绑定到$（无参数支持多元素选择）
	$.fn.swipeItemContent = function(opt) {
		$(this).each(function(index, el) {
			return new SwipeItemContent($(this), opt);
		});
	}
})(window.Zepto)

/**
 * 时间轴
 *
 * @20170628 add by dongfenghua
 *
 */
;
(function() {
	//构造时间轴节点
	var createNode = function(title, text, isFirstNode) {
		var nodeStr = '<li class="timeline-item" data-type="itemContent">';
		if(isFirstNode) {
			nodeStr += '<div class="timeline-item-color timeline-item-head-first" data-type="div">' +
				'<span class="icon icon-check timeline-item-checked" data-type="icon"></span>' +
				'</div>';
		} else {
			nodeStr += '<div class="timeline-item-color timeline-item-head" data-type="div"></div>';
		}
		nodeStr += '<div class="timeline-item-tail"></div>' +
			'<div class="timeline-item-content" data-type="div">' +
			'<h4 data-type="h4">' + title + '</h4>' +
			'<span data-type="span">' + text +
			'</span>' + '</div>' + '</li>';
		return nodeStr;
	}
	/*
	 * @brief   批量添加时间轴节点数
	 * @params  title：节点标题
	 * @params  text： 节点描述信息
	 */
	$.fn.addNode = function(title, text) {
		return this.each(function() {
			if(!this)
				return;
			var $this = $(this);
			if(title === undefined) {
				$.alert('请输入新增节点标题');
				return;
			}
			text = text || "这是描述信息";
			if($this.children('ul').length <= 0) return;
			$this.children('ul').append(createNode(title, text));
		});
	}
	/*
	 * @brief   批量添加时间轴节点数
	 * @params  参数是一个集合，格式如：[{"title":"","text":""},{"title":"","text":""}]
	 */
	$.fn.addNodeList = function(params) {
		return this.each(function() {
			if(!this)
				return;
			var $this = $(this);
			var defaults = {
				"title": "标题" + new Date().getTime(),
				"text": "这是描述信息"
			};
			params = params || {};

			var nodeListStr = "";
			for(var i = 0; i < params.length; i++) {
				var arrItem = params[i];
				for(var def in defaults) {
					if(typeof arrItem[def] === 'undefined') {
						arrItem[def] = defaults[def];
					}
				}
				nodeListStr += createNode(arrItem.title, arrItem.text);
			}
			if($this.children('ul').length <= 0) return;
			$this.children('ul').append(nodeListStr);
		});
	}
	/*
	 * @brief   动态设置时间轴节点个数
	 * @params  count   节点个数，必须是大于0的正整数
	 */
	$.fn.setNodeCount = function(count) {
		return this.each(function() {
			if(!this)
				return;
			var $this = $(this);
			if($this.children('ul').length <= 0) return;
			if(count > 0) {
				var nodeListStr = "";
				for(var i = 0; i < count; i++) {
					var flag = false;
					if(i == 0) {
						flag = true;
					}
					nodeListStr += createNode("标题" + (i + 1), "这是描述信息" + (i + 1), flag);
				}
				$this.children('ul').html(nodeListStr);
			}
		});
	}
})(window.Zepto)

/**
 * 弹出提示
 *
 * @20170629 add by pangys
 *
 */
;
(function() {
	$.popover = function(bt, el, typ) {
		var opts = {
			btn: bt,
			ele: el,
			type: typ
		};
		this.default = { //默认参数
			type: 'right', //-弹出位置
			marg: 10, //-间距
			arro: 5, //-三角大小
			align: 'center', //-对齐方式
			color: '#35495e', //-颜色
			px: 0, //-x偏移
			py: 0 //-y偏移
		};
		this.options = $.extend({}, this.default, opts); //获取参数
		var _this = this, //触发元素
			btn = opts.btn,
			ele = opts.ele, //弹窗元素
			tar = {}, //弹窗坐标
			arrow = {}, //三角偏移
			eleWidth, eleHeight, //弹窗宽高
			px, py, pw, ph; //触发元素坐标及宽高
		//@事件绑定->修改为默认执行 @20170718 modify by pangys
		//btn.on('click',function(e){
		var st = $('.content').scrollTop(); //获取滚动距离
		var sl = $('.content').scrollLeft();
		var headHeight = $("header").height(); //获取标题栏高度

		px = btn.offset().left + sl;
		py = btn.offset().top + st - headHeight;
		pw = btn[0].offsetWidth;
		ph = btn[0].offsetHeight;

		ele.show().css('opacity', 0);
		eleWidth = ele.width();
		eleHeight = ele.height();

		//@确定弹窗位置（默认对齐方式）
		if(_this.options.type == 'left') {
			tar.x = px - eleWidth - _this.options.marg;
			tar.y = py + ph / 2 - eleHeight / 2;
			arrow.x = eleWidth;
			arrow.y = eleHeight / 2 - _this.options.arro;
		} else if(_this.options.type == 'right') {
			tar.x = px + pw + _this.options.marg;
			tar.y = py + ph / 2 - eleHeight / 2;
			arrow.x = -_this.options.arro;
			arrow.y = eleHeight / 2 - _this.options.arro;
		} else if(_this.options.type == 'top') {
			tar.x = px + pw / 2 - eleWidth / 2;
			tar.y = py - eleHeight - _this.options.marg;
			arrow.x = eleWidth / 2 - _this.options.arro / 2;
			arrow.y = eleHeight;
		} else if(_this.options.type == 'bottom') {
			tar.x = px + pw / 2 - eleWidth / 2;
			tar.y = py + ph + _this.options.marg;
			arrow.x = eleWidth / 2 - _this.options.arro / 2;
			arrow.y = -5;
		} else {
			console.info("type参数配置错误");
			return false;
		}
		//@超出边界处理
		if(px < eleWidth / 2 - pw / 2 && (_this.options.type == 'top' || _this.options.type == 'bottom')) {
			tar.x = px;
			arrow.x = pw / 2 - _this.options.arro / 2;
		}
		if(py < eleHeight / 2 - ph / 2 && (_this.options.type == 'left' || _this.options.type == 'right')) {
			tar.y = py;
			arrow.y = ph / 2 - _this.options.arro / 2;
		}
		//@设置偏移量(后续添加)

		//@设置三角位置
		ele.find('.popover-arrow').css({
			top: arrow.y,
			left: arrow.x
		}).addClass('popover-arrow-' + _this.options.type);
		//@设置弹窗位置
		ele.css({
			position: 'absolute',
			top: tar.y,
			left: tar.x,
			opacity: 1
		});
		return false;
		//})

		//@隐藏弹窗->暂不添加
		// $('body').on('click',function(){
		//     ele.hide();
		// })
	}

})(window.Zepto)

/**
 * 圆形拖拽
 *
 * @20170629 add by pangys
 *
 */
;
(function() {
	//构造函数
	var ArcDragRange = function(ele, opts) {
		this.$ele = ele;
		this.default = { //默认参数
			insideArcColor: '#3af',
			insideArcWidth: 1,
			outsideArcColor: '#4bf',
			outsideArcWidth: 18,
			backArcColor: '#c0c0c0',
			backArcWidth: 18,
			sliderRadius: 15,
			sliderInsideColor: '#fff',
			sliderOutsideColor: '#4bf'
		}
		this.options = $.extend({}, this.default, opts); //参数拷贝
		this.supportTouch = 'ontouchend' in document; //事件处理
		this.touchStartEvent = this.supportTouch ? 'touchstart' : 'mousedown';
		this.touchMoveEvent = this.supportTouch ? 'touchmove' : 'mousemove';
		this.touchEndEvent = this.supportTouch ? 'touchend' : 'mouseup';
		this.obj = this.$ele.find("canvas")[0];
		this.cObj = this.obj.getContext("2d");
		var mobileWidth = this.$ele.width();
		this.objWidth = mobileWidth;
		this.objCenter = mobileWidth / 2;
		this.obj.width = mobileWidth;
		this.obj.height = mobileWidth;
		this.point = 0;
		this.pathr = 120;
		this.event();
		this.draw.prototype = this; //draw继承Draw方法
		this.p = new this.draw(); //创建实例
	}
	//添加方法
	ArcDragRange.prototype = {
		//@绘图
		draw: function(x, y, r, j) {
			this.cObj.clearRect(0, 0, this.objWidth, this.objWidth);
			var Starting = {};
			Starting.x = this.pathr * Math.cos(Math.PI * 1.25);
			Starting.y = this.pathr * Math.sin(Math.PI * 1.25);
			var o = this.respotchange(Starting);
			this.x = x || o.x;
			this.y = y || o.y;
			this.r = r || 20;
			this.j = j || 0.75 * Math.PI;
			// 绘制内层圆弧
			this.cObj.beginPath();
			this.cObj.lineWidth = this.options.insideArcWidth;
			this.cObj.arc(this.objCenter, this.objCenter, 100, Math.PI * 0.75, Math.PI * 2.25, false);
			this.cObj.strokeStyle = this.options.insideArcColor;
			this.cObj.stroke();
			// 绘制外侧圆弧
			this.cObj.beginPath();
			this.cObj.arc(this.objCenter, this.objCenter, this.pathr, Math.PI * 0.75, Math.PI * 2.25, false);
			this.cObj.strokeStyle = this.options.backArcColor;
			this.cObj.lineCap = "round";
			this.cObj.lineWidth = this.options.backArcWidth;
			this.cObj.stroke();
			// 可变圆弧
			this.cObj.beginPath();
			this.cObj.arc(this.objCenter, this.objCenter, this.pathr, Math.PI * 0.75, this.j, false);
			this.cObj.strokeStyle = this.options.outsideArcColor;
			this.cObj.lineCap = "round";
			this.cObj.lineWidth = this.options.outsideArcWidth;
			this.cObj.stroke();
			// 绘制滑块1
			this.cObj.beginPath();
			this.cObj.moveTo(this.objCenter, this.objCenter);
			this.cObj.arc(this.x, this.y, this.options.sliderRadius, 0, Math.PI * 2, false);
			this.cObj.fillStyle = this.options.sliderOutsideColor;
			this.cObj.fill();
			// 绘制滑块2
			this.cObj.beginPath();
			this.cObj.moveTo(200, 200);
			this.cObj.arc(this.x, this.y, 10, 0, Math.PI * 2, false);
			this.cObj.fillStyle = this.options.sliderInsideColor;
			this.cObj.fill();
		},
		//@移动
		OnMouseMove: function(evt) {
			if(this.p.isDown) {
				var a = {};
				a.x = this.getx(evt);
				a.y = this.gety(evt);
				var b = this.spotchange(a);
				var co = this.getmoveto(b.x, b.y);
				if(this.check(b.x, b.y)) {
					if(!this.p.isDown) {
						return false;
					}
					var co = this.getmoveto(b.x, b.y);
					var tar = this.respotchange(co)
					var o = co.z;
					this.p.draw(tar.x, tar.y, this.p.r, o);
					this.point = (o - 2.4) / 4.66;
				}
			}
		},
		OnMouseDown: function(evt) {
			var X = this.getx(evt);
			var Y = this.gety(evt);
			var minX = this.p.x - this.p.r * 2;
			var maxX = this.p.x + this.p.r * 2;
			var minY = this.p.y - this.p.r * 2;
			var maxY = this.p.y + this.p.r * 2;
			if(minX < X && X < maxX && minY < Y && Y < maxY) { //判断鼠标是否在滑块上
				this.p.isDown = true;
			} else {
				this.p.isDown = false;
			}
		},
		OnMouseUp: function() { //鼠标释放
			this.p.isDown = false
		},
		event: function() { //事件绑定
			var _this = this;
			this.obj.addEventListener(_this.touchStartEvent, this.OnMouseDown.bind(this), false);
			this.obj.addEventListener(_this.touchMoveEvent, this.OnMouseMove.bind(this), false);
			this.obj.addEventListener(_this.touchEndEvent, this.OnMouseUp.bind(this), false);
		},
		getmoveto: function(lx, ly) {
			var tem = {};
			tem.o = Math.atan(ly / lx);
			tem.x = this.pathr * Math.cos(tem.o);
			tem.y = this.pathr * Math.sin(tem.o);
			if(lx < 0) { //坐标点处理
				tem.x = -tem.x;
				tem.y = -tem.y;
			}
			if(lx > 0) { //弧度值处理
				tem.z = -Math.atan(tem.y / tem.x) + Math.PI * 2;
			} else {
				tem.z = -Math.atan(tem.y / tem.x) + Math.PI;
			}
			if(tem.z > 7.06) { //最大值
				tem.z = 7.06;
				tem.x = this.pathr * Math.cos(Math.PI * 2.25);
				tem.y = -this.pathr * Math.sin(Math.PI * 2.25);
			}
			if(tem.z < 2.4) { //最小值
				tem.z = 2.4;
				tem.x = this.pathr * Math.cos(Math.PI * 0.75);
				tem.y = -this.pathr * Math.sin(Math.PI * 0.75);
			}
			return tem;
		},
		spotchange: function(a) { //坐标转化
			var target = {};
			if(a.x < this.objCenter && a.y < this.objCenter) {
				target.x = -(this.objCenter - a.x);
				target.y = this.objCenter - a.y;
			} else if(a.x > this.objCenter && a.y < this.objCenter) {
				target.x = a.x - this.objCenter;
				target.y = this.objCenter - a.y;
			} else if(a.x > this.objCenter && a.y > this.objCenter) {
				target.x = a.x - this.objCenter;
				target.y = -(a.y - this.objCenter)
			} else if(a.x < this.objCenter && a.y > this.objCenter) {
				target.x = -(this.objCenter - a.x);
				target.y = -(a.y - this.objCenter);
			}
			return target;
		},
		respotchange: function(a) { //坐标转换
			var target = {};
			if(a.x > 0 && a.y > 0) {
				target.x = this.objCenter + a.x;
				target.y = (this.objCenter - a.y);
			} else if(a.x < 0 && a.y > 0) {
				target.x = this.objCenter + a.x;
				target.y = this.objCenter - a.y;
			} else if(a.x < 0 && a.y < 0) {
				target.x = this.objCenter + a.x;
				target.y = -(a.y - this.objCenter);
			} else if(a.x > 0 && a.y < 0) {
				target.x = this.objCenter + a.x;
				target.y = -(a.y - this.objCenter);
			}
			return target;
		},
		check: function(x, y) { //限制可拖动范围
			var xx = x * x;
			var yy = y * y;
			var rr = 114 * 114; //最小
			var rrr = 126 * 126; //最大
			if(xx + yy > rr && xx + yy < rrr) {
				return true;
			}
			return false;
		},
		getx: function(ev) { //获取鼠标在canvas内坐标x
			var tx = this.supportTouch ? ev.touches[0].clientX : ev.clientX;
			return tx - this.obj.getBoundingClientRect().left;
		},
		gety: function(ev) { //获取鼠标在canvas内坐标y
			var ty = this.supportTouch ? ev.touches[0].clientY : ev.clientY;
			return ty - this.obj.getBoundingClientRect().top;
		},
		getValue: function() {
			return this.point;
		}
	}
	//添加到$
	$.fn.arcDragRange = function(option) {
		var arcDragRange = new ArcDragRange(this, option);
		this[0].obj = arcDragRange;
		arcDragRange.draw();
	}
	// $.fn.getValue = function () {
	//     return this[0].obj.getReturn();
	// }

})(window.Zepto)

/**
 * 组件设置和获取值
 *
 * @20170719 add by pangys
 *
 */
;
(function() {
	$.fn.getValue = function() {
		return this[0].obj.getValue();
	};
	$.fn.setValue = function(n) {
		return this[0].obj.setValue(n);
	}
})()

/**
 * 倒计时和网页加水印方法扩展
 *
 */
;
(function($) {
	/*倒计时*/
	var sendVerifyCode = function($oHandler, seconds, overText) {
		var settings = {
			seconds: seconds || 60, //总秒数(s)默认60s
			overText: overText || '重新发送'
		}
		//倒计时秒数
		var timmer = setInterval(function() {
			seconds = seconds - 1;
			$oHandler.text(seconds + "s");
			$oHandler.off('click'); //$oHandler   触发事件的源对象
			if(seconds == 0) {
				window.clearInterval(timmer);
				$oHandler.text(overText || '重新发送'); //overText  倒计时完，重新显示的中文信息

				$oHandler.click(function() {
					$.sendVerifyCode($(this), settings.seconds, settings.overText);
				})
			}
		}, 1000);
	}
	/*网页加水印*/
	var addPageWatermark = function(image, text, color, fontsize, width, height, angle) {
		//默认设置
		var defaultSettings = {
			watermark_img: image || "", //水印内容(图片)
			watermark_txt: text, //水印内容
			watermark_x: 20, //水印起始位置x轴坐标
			watermark_y: 20, //水印起始位置Y轴坐标
			watermark_rows: 20, //水印行数
			watermark_cols: 20, //水印列数
			watermark_x_space: 100, //水印x轴间隔
			watermark_y_space: 50, //水印y轴间隔
			watermark_color: color || '#aaa', //水印字体颜色
			watermark_alpha: 0.4, //水印透明度
			watermark_fontsize: fontsize || '15px', //水印字体大小
			watermark_font: '微软雅黑', //水印字体
			watermark_width: width || 120, //水印宽度
			watermark_height: height || 50, //水印长度
			watermark_angle: angle || 15 //水印倾斜度数
		};
		var oTemp = document.createDocumentFragment();

		//获取页面最大宽度
		var page_width = Math.max(document.body.scrollWidth, document.body.clientWidth);
		var cutWidth = page_width * 0.0150;
		var page_width = page_width - cutWidth;
		//获取页面最大高度
		var page_height = Math.max(document.body.scrollHeight, document.body.clientHeight);
		// var page_height = document.body.scrollHeight+document.body.scrollTop;
		//如果将水印列数设置为0，或水印列数设置过大，超过页面最大宽度，则重新计算水印列数和水印x轴间隔
		if(defaultSettings.watermark_cols == 0 || (parseInt(defaultSettings.watermark_x + defaultSettings.watermark_width * defaultSettings.watermark_cols + defaultSettings.watermark_x_space * (defaultSettings.watermark_cols - 1)) > page_width)) {
			defaultSettings.watermark_cols = parseInt((page_width - defaultSettings.watermark_x + defaultSettings.watermark_x_space) / (defaultSettings.watermark_width + defaultSettings.watermark_x_space));
			defaultSettings.watermark_x_space = parseInt((page_width - defaultSettings.watermark_x - defaultSettings.watermark_width * defaultSettings.watermark_cols) / (defaultSettings.watermark_cols - 1));
		}
		//如果将水印行数设置为0，或水印行数设置过大，超过页面最大长度，则重新计算水印行数和水印y轴间隔
		if(defaultSettings.watermark_rows == 0 || (parseInt(defaultSettings.watermark_y + defaultSettings.watermark_height * defaultSettings.watermark_rows + defaultSettings.watermark_y_space * (defaultSettings.watermark_rows - 1)) > page_height)) {
			defaultSettings.watermark_rows = parseInt((defaultSettings.watermark_y_space + page_height - defaultSettings.watermark_y) / (defaultSettings.watermark_height + defaultSettings.watermark_y_space));
			defaultSettings.watermark_y_space = parseInt(((page_height - defaultSettings.watermark_y) - defaultSettings.watermark_height * defaultSettings.watermark_rows) / (defaultSettings.watermark_rows - 1));
		}
		var x;
		var y;
		for(var i = 0; i < defaultSettings.watermark_rows; i++) {
			y = defaultSettings.watermark_y + (defaultSettings.watermark_y_space + defaultSettings.watermark_height) * i;
			for(var j = 0; j < defaultSettings.watermark_cols; j++) {
				x = defaultSettings.watermark_x + (defaultSettings.watermark_width + defaultSettings.watermark_x_space) * j;

				var mask_div = document.createElement('div');
				mask_div.id = 'mask_div' + i + j;
				mask_div.className = 'mask_div';
				if(defaultSettings.watermark_img != '') {
					mask_div.style.background = "url(" + defaultSettings.watermark_img + ")";
					mask_div.style.backgroundPosition = 'center center';
					mask_div.style.backgroundSize = "auto 100%";
				} else {
					mask_div.appendChild(document.createTextNode(defaultSettings.watermark_txt));
				}
				//设置水印div倾斜显示
				mask_div.style.webkitTransform = "rotate(-" + defaultSettings.watermark_angle + "deg)";
				mask_div.style.MozTransform = "rotate(-" + defaultSettings.watermark_angle + "deg)";
				mask_div.style.msTransform = "rotate(-" + defaultSettings.watermark_angle + "deg)";
				mask_div.style.OTransform = "rotate(-" + defaultSettings.watermark_angle + "deg)";
				mask_div.style.transform = "rotate(-" + defaultSettings.watermark_angle + "deg)";
				mask_div.style.visibility = "";
				mask_div.style.position = "absolute";
				mask_div.style.left = x + 'px';
				mask_div.style.top = y + 'px';
				mask_div.style.overflow = "hidden";
				mask_div.style.zIndex = "9999";
				mask_div.style.pointerEvents = 'none'; //pointer-events:none  让水印不遮挡页面的点击事件
				//mask_div.style.border="solid #eee 1px";
				mask_div.style.opacity = defaultSettings.watermark_alpha;
				mask_div.style.fontSize = defaultSettings.watermark_fontsize;
				mask_div.style.fontFamily = defaultSettings.watermark_font;
				mask_div.style.color = defaultSettings.watermark_color;
				mask_div.style.textAlign = "center";
				mask_div.style.width = defaultSettings.watermark_width + 'px';
				mask_div.style.height = defaultSettings.watermark_height + 'px';
				mask_div.style.display = "block";
				oTemp.appendChild(mask_div);
			};
		};
		document.body.appendChild(oTemp);
	}

	$.extend($, {
		sendVerifyCode: sendVerifyCode,
		watermark: addPageWatermark
	});
})(Zepto);

$(function() {
		setTimeout(function() {
			$.init(); //框架初始化
		}, 500);
	})

	/**
	 * vue
	 *
	 */

	/*!
	 * Vue.js v1.0.28
	 * (c) 2016 Evan You
	 * Released under the MIT License.
	 */
	! function(t, e) { "object" == typeof exports && "undefined" != typeof module ? module.exports = e() : "function" == typeof define && define.amd ? define(e) : t.Vue = e() }(this, function() {
		"use strict";

		function t(e, n, r) { if(i(e, n)) return void(e[n] = r); if(e._isVue) return void t(e._data, n, r); var s = e.__ob__; if(!s) return void(e[n] = r); if(s.convert(n, r), s.dep.notify(), s.vms)
				for(var o = s.vms.length; o--;) { var a = s.vms[o];
					a._proxy(n), a._digest() }
			return r }

		function e(t, e) { if(i(t, e)) { delete t[e]; var n = t.__ob__; if(!n) return void(t._isVue && (delete t._data[e], t._digest())); if(n.dep.notify(), n.vms)
					for(var r = n.vms.length; r--;) { var s = n.vms[r];
						s._unproxy(e), s._digest() } } }

		function i(t, e) { return Mi.call(t, e) }

		function n(t) { return Wi.test(t) }

		function r(t) { var e = (t + "").charCodeAt(0); return 36 === e || 95 === e }

		function s(t) { return null == t ? "" : t.toString() }

		function o(t) { if("string" != typeof t) return t; var e = Number(t); return isNaN(e) ? t : e }

		function a(t) { return "true" === t || "false" !== t && t }

		function h(t) { var e = t.charCodeAt(0),
				i = t.charCodeAt(t.length - 1); return e !== i || 34 !== e && 39 !== e ? t : t.slice(1, -1) }

		function l(t) { return t.replace(Vi, c) }

		function c(t, e) { return e ? e.toUpperCase() : "" }

		function u(t) { return t.replace(Bi, "$1-$2").replace(Bi, "$1-$2").toLowerCase() }

		function f(t) { return t.replace(zi, c) }

		function p(t, e) { return function(i) { var n = arguments.length; return n ? n > 1 ? t.apply(e, arguments) : t.call(e, i) : t.call(e) } }

		function d(t, e) { e = e || 0; for(var i = t.length - e, n = new Array(i); i--;) n[i] = t[i + e]; return n }

		function v(t, e) { for(var i = Object.keys(e), n = i.length; n--;) t[i[n]] = e[i[n]]; return t }

		function m(t) { return null !== t && "object" == typeof t }

		function g(t) { return Ui.call(t) === Ji }

		function _(t, e, i, n) { Object.defineProperty(t, e, { value: i, enumerable: !!n, writable: !0, configurable: !0 }) }

		function y(t, e) { var i, n, r, s, o, a = function a() { var h = Date.now() - s;
				h < e && h >= 0 ? i = setTimeout(a, e - h) : (i = null, o = t.apply(r, n), i || (r = n = null)) }; return function() { return r = this, n = arguments, s = Date.now(), i || (i = setTimeout(a, e)), o } }

		function b(t, e) { for(var i = t.length; i--;)
				if(t[i] === e) return i; return -1 }

		function w(t) { var e = function e() { if(!e.cancelled) return t.apply(this, arguments) }; return e.cancel = function() { e.cancelled = !0 }, e }

		function C(t, e) { return t == e || !(!m(t) || !m(e)) && JSON.stringify(t) === JSON.stringify(e) }

		function $(t) { return /native code/.test(t.toString()) }

		function k(t) { this.size = 0, this.limit = t, this.head = this.tail = void 0, this._keymap = Object.create(null) }

		function x() { return fn.charCodeAt(vn + 1) }

		function A() { return fn.charCodeAt(++vn) }

		function O() { return vn >= dn }

		function T() { for(; x() === Tn;) A() }

		function N(t) { return t === kn || t === xn }

		function j(t) { return Nn[t] }

		function E(t, e) { return jn[t] === e }

		function S() { for(var t, e = A(); !O();)
				if(t = A(), t === On) A();
				else if(t === e) break }

		function F(t) { for(var e = 0, i = t; !O();)
				if(t = x(), N(t)) S();
				else if(i === t && e++, E(i, t) && e--, A(), 0 === e) break }

		function D() { for(var t = vn; !O();)
				if(mn = x(), N(mn)) S();
				else if(j(mn)) F(mn);
			else if(mn === An) { if(A(), mn = x(), mn !== An) { gn !== bn && gn !== $n || (gn = wn); break } A() } else { if(mn === Tn && (gn === Cn || gn === $n)) { T(); break } gn === wn && (gn = Cn), A() } return fn.slice(t + 1, vn) || null }

		function P() { for(var t = []; !O();) t.push(R()); return t }

		function R() { var t, e = {}; return gn = wn, e.name = D().trim(), gn = $n, t = L(), t.length && (e.args = t), e }

		function L() { for(var t = []; !O() && gn !== wn;) { var e = D(); if(!e) break;
				t.push(H(e)) } return t }

		function H(t) { if(yn.test(t)) return { value: o(t), dynamic: !1 }; var e = h(t),
				i = e === t; return { value: i ? t : e, dynamic: i } }

		function I(t) { var e = _n.get(t); if(e) return e;
			fn = t, pn = {}, dn = fn.length, vn = -1, mn = "", gn = bn; var i; return fn.indexOf("|") < 0 ? pn.expression = fn.trim() : (pn.expression = D().trim(), i = P(), i.length && (pn.filters = i)), _n.put(t, pn), pn }

		function M(t) { return t.replace(Sn, "\\$&") }

		function W() { var t = M(Mn.delimiters[0]),
				e = M(Mn.delimiters[1]),
				i = M(Mn.unsafeDelimiters[0]),
				n = M(Mn.unsafeDelimiters[1]);
			Dn = new RegExp(i + "((?:.|\\n)+?)" + n + "|" + t + "((?:.|\\n)+?)" + e, "g"), Pn = new RegExp("^" + i + "((?:.|\\n)+?)" + n + "$"), Fn = new k(1e3) }

		function V(t) { Fn || W(); var e = Fn.get(t); if(e) return e; if(!Dn.test(t)) return null; for(var i, n, r, s, o, a, h = [], l = Dn.lastIndex = 0; i = Dn.exec(t);) n = i.index, n > l && h.push({ value: t.slice(l, n) }), r = Pn.test(i[0]), s = r ? i[1] : i[2], o = s.charCodeAt(0), a = 42 === o, s = a ? s.slice(1) : s, h.push({ tag: !0, value: s.trim(), html: r, oneTime: a }), l = n + i[0].length; return l < t.length && h.push({ value: t.slice(l) }), Fn.put(t, h), h }

		function B(t, e) { return t.length > 1 ? t.map(function(t) { return z(t, e) }).join("+") : z(t[0], e, !0) }

		function z(t, e, i) { return t.tag ? t.oneTime && e ? '"' + e.$eval(t.value) + '"' : U(t.value, i) : '"' + t.value + '"' }

		function U(t, e) { if(Rn.test(t)) { var i = I(t); return i.filters ? "this._applyFilters(" + i.expression + ",null," + JSON.stringify(i.filters) + ",false)" : "(" + t + ")" } return e ? t : "(" + t + ")" }

		function J(t, e, i, n) { G(t, 1, function() { e.appendChild(t) }, i, n) }

		function q(t, e, i, n) { G(t, 1, function() { et(t, e) }, i, n) }

		function Q(t, e, i) { G(t, -1, function() { nt(t) }, e, i) }

		function G(t, e, i, n, r) { var s = t.__v_trans; if(!s || !s.hooks && !rn || !n._isCompiled || n.$parent && !n.$parent._isCompiled) return i(), void(r && r()); var o = e > 0 ? "enter" : "leave";
			s[o](i, r) }

		function Z(t) { if("string" == typeof t) { t = document.querySelector(t) } return t }

		function X(t) { if(!t) return !1; var e = t.ownerDocument.documentElement,
				i = t.parentNode; return e === t || e === i || !(!i || 1 !== i.nodeType || !e.contains(i)) }

		function Y(t, e) { var i = t.getAttribute(e); return null !== i && t.removeAttribute(e), i }

		function K(t, e) { var i = Y(t, ":" + e); return null === i && (i = Y(t, "v-bind:" + e)), i }

		function tt(t, e) { return t.hasAttribute(e) || t.hasAttribute(":" + e) || t.hasAttribute("v-bind:" + e) }

		function et(t, e) { e.parentNode.insertBefore(t, e) }

		function it(t, e) { e.nextSibling ? et(t, e.nextSibling) : e.parentNode.appendChild(t) }

		function nt(t) { t.parentNode.removeChild(t) }

		function rt(t, e) { e.firstChild ? et(t, e.firstChild) : e.appendChild(t) }

		function st(t, e) { var i = t.parentNode;
			i && i.replaceChild(e, t) }

		function ot(t, e, i, n) { t.addEventListener(e, i, n) }

		function at(t, e, i) { t.removeEventListener(e, i) }

		function ht(t) { var e = t.className; return "object" == typeof e && (e = e.baseVal || ""), e }

		function lt(t, e) { Ki && !/svg$/.test(t.namespaceURI) ? t.className = e : t.setAttribute("class", e) }

		function ct(t, e) { if(t.classList) t.classList.add(e);
			else { var i = " " + ht(t) + " ";
				i.indexOf(" " + e + " ") < 0 && lt(t, (i + e).trim()) } }

		function ut(t, e) { if(t.classList) t.classList.remove(e);
			else { for(var i = " " + ht(t) + " ", n = " " + e + " "; i.indexOf(n) >= 0;) i = i.replace(n, " ");
				lt(t, i.trim()) } t.className || t.removeAttribute("class") }

		function ft(t, e) { var i, n; if(vt(t) && bt(t.content) && (t = t.content), t.hasChildNodes())
				for(pt(t), n = e ? document.createDocumentFragment() : document.createElement("div"); i = t.firstChild;) n.appendChild(i); return n }

		function pt(t) { for(var e; e = t.firstChild, dt(e);) t.removeChild(e); for(; e = t.lastChild, dt(e);) t.removeChild(e) }

		function dt(t) { return t && (3 === t.nodeType && !t.data.trim() || 8 === t.nodeType) }

		function vt(t) { return t.tagName && "template" === t.tagName.toLowerCase() }

		function mt(t, e) { var i = Mn.debug ? document.createComment(t) : document.createTextNode(e ? " " : ""); return i.__v_anchor = !0, i }

		function gt(t) { if(t.hasAttributes())
				for(var e = t.attributes, i = 0, n = e.length; i < n; i++) { var r = e[i].name; if(Bn.test(r)) return l(r.replace(Bn, "")) } }

		function _t(t, e, i) { for(var n; t !== e;) n = t.nextSibling, i(t), t = n;
			i(e) }

		function yt(t, e, i, n, r) {
			function s() { if(a++, o && a >= h.length) { for(var t = 0; t < h.length; t++) n.appendChild(h[t]);
					r && r() } } var o = !1,
				a = 0,
				h = [];
			_t(t, e, function(t) { t === e && (o = !0), h.push(t), Q(t, i, s) }) }

		function bt(t) { return t && 11 === t.nodeType }

		function wt(t) { if(t.outerHTML) return t.outerHTML; var e = document.createElement("div"); return e.appendChild(t.cloneNode(!0)), e.innerHTML }

		function Ct(t, e) { var i = t.tagName.toLowerCase(),
				n = t.hasAttributes(); if(zn.test(i) || Un.test(i)) { if(n) return $t(t, e) } else { if(jt(e, "components", i)) return { id: i }; var r = n && $t(t, e); if(r) return r } }

		function $t(t, e) { var i = t.getAttribute("is"); if(null != i) { if(jt(e, "components", i)) return t.removeAttribute("is"), { id: i } } else if(i = K(t, "is"), null != i) return { id: i, dynamic: !0 } }

		function kt(e, n) { var r, s, o; for(r in n) s = e[r], o = n[r], i(e, r) ? m(s) && m(o) && kt(s, o) : t(e, r, o); return e }

		function xt(t, e) { var i = Object.create(t || null); return e ? v(i, Tt(e)) : i }

		function At(t) { if(t.components)
				for(var e, i = t.components = Tt(t.components), n = Object.keys(i), r = 0, s = n.length; r < s; r++) { var o = n[r];
					zn.test(o) || Un.test(o) || (e = i[o], g(e) && (i[o] = Di.extend(e))) } }

		function Ot(t) { var e, i, n = t.props; if(qi(n))
				for(t.props = {}, e = n.length; e--;) i = n[e], "string" == typeof i ? t.props[i] = null : i.name && (t.props[i.name] = i);
			else if(g(n)) { var r = Object.keys(n); for(e = r.length; e--;) i = n[r[e]], "function" == typeof i && (n[r[e]] = { type: i }) } }

		function Tt(t) { if(qi(t)) { for(var e, i = {}, n = t.length; n--;) { e = t[n]; var r = "function" == typeof e ? e.options && e.options.name || e.id : e.name || e.id;
					r && (i[r] = e) } return i } return t }

		function Nt(t, e, n) {
			function r(i) { var r = Jn[i] || qn;
				o[i] = r(t[i], e[i], n, i) } At(e), Ot(e); var s, o = {}; if(e.extends && (t = "function" == typeof e.extends ? Nt(t, e.extends.options, n) : Nt(t, e.extends, n)), e.mixins)
				for(var a = 0, h = e.mixins.length; a < h; a++) { var l = e.mixins[a],
						c = l.prototype instanceof Di ? l.options : l;
					t = Nt(t, c, n) }
			for(s in t) r(s); for(s in e) i(t, s) || r(s); return o }

		function jt(t, e, i, n) { if("string" == typeof i) { var r, s = t[e],
					o = s[i] || s[r = l(i)] || s[r.charAt(0).toUpperCase() + r.slice(1)]; return o } }

		function Et() { this.id = Qn++, this.subs = [] }

		function St(t) { Yn = !1, t(), Yn = !0 }

		function Ft(t) { if(this.value = t, this.dep = new Et, _(t, "__ob__", this), qi(t)) { var e = Qi ? Dt : Pt;
				e(t, Zn, Xn), this.observeArray(t) } else this.walk(t) }

		function Dt(t, e) { t.__proto__ = e }

		function Pt(t, e, i) { for(var n = 0, r = i.length; n < r; n++) { var s = i[n];
				_(t, s, e[s]) } }

		function Rt(t, e) { if(t && "object" == typeof t) { var n; return i(t, "__ob__") && t.__ob__ instanceof Ft ? n = t.__ob__ : Yn && (qi(t) || g(t)) && Object.isExtensible(t) && !t._isVue && (n = new Ft(t)), n && e && n.addVm(e), n } }

		function Lt(t, e, i) { var n = new Et,
				r = Object.getOwnPropertyDescriptor(t, e); if(!r || r.configurable !== !1) { var s = r && r.get,
					o = r && r.set,
					a = Rt(i);
				Object.defineProperty(t, e, { enumerable: !0, configurable: !0, get: function() { var e = s ? s.call(t) : i; if(Et.target && (n.depend(), a && a.dep.depend(), qi(e)))
							for(var r, o = 0, h = e.length; o < h; o++) r = e[o], r && r.__ob__ && r.__ob__.dep.depend(); return e }, set: function(e) { var r = s ? s.call(t) : i;
						e !== r && (o ? o.call(t, e) : i = e, a = Rt(e), n.notify()) } }) } }

		function Ht(t) { t.prototype._init = function(t) { t = t || {}, this.$el = null, this.$parent = t.parent, this.$root = this.$parent ? this.$parent.$root : this, this.$children = [], this.$refs = {}, this.$els = {}, this._watchers = [], this._directives = [], this._uid = tr++, this._isVue = !0, this._events = {}, this._eventsCount = {}, this._isFragment = !1, this._fragment = this._fragmentStart = this._fragmentEnd = null, this._isCompiled = this._isDestroyed = this._isReady = this._isAttached = this._isBeingDestroyed = this._vForRemoving = !1, this._unlinkFn = null, this._context = t._context || this.$parent, this._scope = t._scope, this._frag = t._frag, this._frag && this._frag.children.push(this), this.$parent && this.$parent.$children.push(this), t = this.$options = Nt(this.constructor.options, t, this), this._updateRef(), this._data = {}, this._callHook("init"), this._initState(), this._initEvents(), this._callHook("created"), t.el && this.$mount(t.el) } }

		function It(t) { if(void 0 === t) return "eof"; var e = t.charCodeAt(0); switch(e) {
				case 91:
				case 93:
				case 46:
				case 34:
				case 39:
				case 48:
					return t;
				case 95:
				case 36:
					return "ident";
				case 32:
				case 9:
				case 10:
				case 13:
				case 160:
				case 65279:
				case 8232:
				case 8233:
					return "ws" } return e >= 97 && e <= 122 || e >= 65 && e <= 90 ? "ident" : e >= 49 && e <= 57 ? "number" : "else" }

		function Mt(t) { var e = t.trim(); return("0" !== t.charAt(0) || !isNaN(t)) && (n(e) ? h(e) : "*" + e) }

		function Wt(t) {
			function e() { var e = t[c + 1]; if(u === ur && "'" === e || u === fr && '"' === e) return c++, n = "\\" + e, p[ir](), !0 } var i, n, r, s, o, a, h, l = [],
				c = -1,
				u = or,
				f = 0,
				p = []; for(p[nr] = function() { void 0 !== r && (l.push(r), r = void 0) }, p[ir] = function() { void 0 === r ? r = n : r += n }, p[rr] = function() { p[ir](), f++ }, p[sr] = function() { if(f > 0) f--, u = cr, p[ir]();
					else { if(f = 0, r = Mt(r), r === !1) return !1;
						p[nr]() } }; null != u;)
				if(c++, i = t[c], "\\" !== i || !e()) { if(s = It(i), h = vr[u], o = h[s] || h.else || dr, o === dr) return; if(u = o[0], a = p[o[1]], a && (n = o[2], n = void 0 === n ? i : n, a() === !1)) return; if(u === pr) return l.raw = t, l } }

		function Vt(t) { var e = er.get(t); return e || (e = Wt(t), e && er.put(t, e)), e }

		function Bt(t, e) { return Yt(e).get(t) }

		function zt(e, i, n) { var r = e; if("string" == typeof i && (i = Wt(i)), !i || !m(e)) return !1; for(var s, o, a = 0, h = i.length; a < h; a++) s = e, o = i[a], "*" === o.charAt(0) && (o = Yt(o.slice(1)).get.call(r, r)), a < h - 1 ? (e = e[o], m(e) || (e = {}, t(s, o, e))) : qi(e) ? e.$set(o, n) : o in e ? e[o] = n : t(e, o, n); return !0 }

		function Ut() {}

		function Jt(t, e) { var i = Nr.length; return Nr[i] = e ? t.replace($r, "\\n") : t, '"' + i + '"' }

		function qt(t) { var e = t.charAt(0),
				i = t.slice(1); return yr.test(i) ? t : (i = i.indexOf('"') > -1 ? i.replace(xr, Qt) : i, e + "scope." + i) }

		function Qt(t, e) { return Nr[e] }

		function Gt(t) { wr.test(t), Nr.length = 0; var e = t.replace(kr, Jt).replace(Cr, ""); return e = (" " + e).replace(Or, qt).replace(xr, Qt), Zt(e) }

		function Zt(t) { try { return new Function("scope", "return " + t + ";") } catch(t) { return Ut } }

		function Xt(t) { var e = Vt(t); if(e) return function(t, i) { zt(t, e, i) } }

		function Yt(t, e) { t = t.trim(); var i = gr.get(t); if(i) return e && !i.set && (i.set = Xt(i.exp)), i; var n = { exp: t }; return n.get = Kt(t) && t.indexOf("[") < 0 ? Zt("scope." + t) : Gt(t), e && (n.set = Xt(t)), gr.put(t, n), n }

		function Kt(t) { return Ar.test(t) && !Tr.test(t) && "Math." !== t.slice(0, 5) }

		function te() { Er.length = 0, Sr.length = 0, Fr = {}, Dr = {}, Pr = !1 }

		function ee() { for(var t = !0; t;) t = !1, ie(Er), ie(Sr), Er.length ? t = !0 : (Zi && Mn.devtools && Zi.emit("flush"), te()) }

		function ie(t) { for(var e = 0; e < t.length; e++) { var i = t[e],
					n = i.id;
				Fr[n] = null, i.run() } t.length = 0 }

		function ne(t) { var e = t.id; if(null == Fr[e]) { var i = t.user ? Sr : Er;
				Fr[e] = i.length, i.push(t), Pr || (Pr = !0, ln(ee)) } }

		function re(t, e, i, n) { n && v(this, n); var r = "function" == typeof e; if(this.vm = t, t._watchers.push(this), this.expression = e, this.cb = i, this.id = ++Rr, this.active = !0, this.dirty = this.lazy, this.deps = [], this.newDeps = [], this.depIds = new cn, this.newDepIds = new cn, this.prevError = null, r) this.getter = e, this.setter = void 0;
			else { var s = Yt(e, this.twoWay);
				this.getter = s.get, this.setter = s.set } this.value = this.lazy ? void 0 : this.get(), this.queued = this.shallow = !1 }

		function se(t, e) { var i = void 0,
				n = void 0;
			e || (e = Lr, e.clear()); var r = qi(t),
				s = m(t); if((r || s) && Object.isExtensible(t)) { if(t.__ob__) { var o = t.__ob__.dep.id; if(e.has(o)) return;
					e.add(o) } if(r)
					for(i = t.length; i--;) se(t[i], e);
				else if(s)
					for(n = Object.keys(t), i = n.length; i--;) se(t[n[i]], e) } }

		function oe(t) { return vt(t) && bt(t.content) }

		function ae(t, e) { var i = e ? t : t.trim(),
				n = Ir.get(i); if(n) return n; var r = document.createDocumentFragment(),
				s = t.match(Vr),
				o = Br.test(t),
				a = zr.test(t); if(s || o || a) { var h = s && s[1],
					l = Wr[h] || Wr.efault,
					c = l[0],
					u = l[1],
					f = l[2],
					p = document.createElement("div"); for(p.innerHTML = u + t + f; c--;) p = p.lastChild; for(var d; d = p.firstChild;) r.appendChild(d) } else r.appendChild(document.createTextNode(t)); return e || pt(r), Ir.put(i, r), r }

		function he(t) { if(oe(t)) return ae(t.innerHTML); if("SCRIPT" === t.tagName) return ae(t.textContent); for(var e, i = le(t), n = document.createDocumentFragment(); e = i.firstChild;) n.appendChild(e); return pt(n), n }

		function le(t) { if(!t.querySelectorAll) return t.cloneNode(); var e, i, n, r = t.cloneNode(!0); if(Ur) { var s = r; if(oe(t) && (t = t.content, s = r.content), i = t.querySelectorAll("template"), i.length)
					for(n = s.querySelectorAll("template"), e = n.length; e--;) n[e].parentNode.replaceChild(le(i[e]), n[e]) } if(Jr)
				if("TEXTAREA" === t.tagName) r.value = t.value;
				else if(i = t.querySelectorAll("textarea"), i.length)
				for(n = r.querySelectorAll("textarea"), e = n.length; e--;) n[e].value = i[e].value; return r }

		function ce(t, e, i) { var n, r; return bt(t) ? (pt(t), e ? le(t) : t) : ("string" == typeof t ? i || "#" !== t.charAt(0) ? r = ae(t, i) : (r = Mr.get(t), r || (n = document.getElementById(t.slice(1)), n && (r = he(n), Mr.put(t, r)))) : t.nodeType && (r = he(t)), r && e ? le(r) : r) }

		function ue(t, e, i, n, r, s) { this.children = [], this.childFrags = [], this.vm = e, this.scope = r, this.inserted = !1, this.parentFrag = s, s && s.childFrags.push(this), this.unlink = t(e, i, n, r, this); var o = this.single = 1 === i.childNodes.length && !i.childNodes[0].__v_anchor;
			o ? (this.node = i.childNodes[0], this.before = fe, this.remove = pe) : (this.node = mt("fragment-start"), this.end = mt("fragment-end"), this.frag = i, rt(this.node, i), i.appendChild(this.end), this.before = de, this.remove = ve), this.node.__v_frag = this }

		function fe(t, e) { this.inserted = !0; var i = e !== !1 ? q : et;
			i(this.node, t, this.vm), X(this.node) && this.callHook(me) }

		function pe() { this.inserted = !1; var t = X(this.node),
				e = this;
			this.beforeRemove(), Q(this.node, this.vm, function() { t && e.callHook(ge), e.destroy() }) }

		function de(t, e) { this.inserted = !0; var i = this.vm,
				n = e !== !1 ? q : et;
			_t(this.node, this.end, function(e) { n(e, t, i) }), X(this.node) && this.callHook(me) }

		function ve() { this.inserted = !1; var t = this,
				e = X(this.node);
			this.beforeRemove(), yt(this.node, this.end, this.vm, this.frag, function() { e && t.callHook(ge), t.destroy() }) }

		function me(t) {!t._isAttached && X(t.$el) && t._callHook("attached") }

		function ge(t) { t._isAttached && !X(t.$el) && t._callHook("detached") }

		function _e(t, e) { this.vm = t; var i, n = "string" == typeof e;
			n || vt(e) && !e.hasAttribute("v-if") ? i = ce(e, !0) : (i = document.createDocumentFragment(), i.appendChild(e)), this.template = i; var r, s = t.constructor.cid; if(s > 0) { var o = s + (n ? e : wt(e));
				r = Gr.get(o), r || (r = qe(i, t.$options, !0), Gr.put(o, r)) } else r = qe(i, t.$options, !0);
			this.linker = r }

		function ye(t, e, i) { var n = t.node.previousSibling; if(n) { for(t = n.__v_frag; !(t && t.forId === i && t.inserted || n === e);) { if(n = n.previousSibling, !n) return;
					t = n.__v_frag } return t } }

		function be(t) { for(var e = -1, i = new Array(Math.floor(t)); ++e < t;) i[e] = e; return i }

		function we(t, e, i, n) { return n ? "$index" === n ? t : n.charAt(0).match(/\w/) ? Bt(i, n) : i[n] : e || i }

		function Ce(t) { var e = t.node; if(t.end)
				for(; !e.__vue__ && e !== t.end && e.nextSibling;) e = e.nextSibling; return e.__vue__ }

		function $e(t, e, i) { for(var n, r, s, o = e ? [] : null, a = 0, h = t.options.length; a < h; a++)
				if(n = t.options[a], s = i ? n.hasAttribute("selected") : n.selected) { if(r = n.hasOwnProperty("_value") ? n._value : n.value, !e) return r;
					o.push(r) }
			return o }

		function ke(t, e) { for(var i = t.length; i--;)
				if(C(t[i], e)) return i; return -1 }

		function xe(t, e) { var i = e.map(function(t) { var e = t.charCodeAt(0); return e > 47 && e < 58 ? parseInt(t, 10) : 1 === t.length && (e = t.toUpperCase().charCodeAt(0), e > 64 && e < 91) ? e : ms[t] }); return i = [].concat.apply([], i),
				function(e) { if(i.indexOf(e.keyCode) > -1) return t.call(this, e) } }

		function Ae(t) { return function(e) { return e.stopPropagation(), t.call(this, e) } }

		function Oe(t) { return function(e) { return e.preventDefault(), t.call(this, e) } }

		function Te(t) { return function(e) { if(e.target === e.currentTarget) return t.call(this, e) } }

		function Ne(t) { if(ws[t]) return ws[t]; var e = je(t); return ws[t] = ws[e] = e, e }

		function je(t) { t = u(t); var e = l(t),
				i = e.charAt(0).toUpperCase() + e.slice(1);
			Cs || (Cs = document.createElement("div")); var n, r = _s.length; if("filter" !== e && e in Cs.style) return { kebab: t, camel: e }; for(; r--;)
				if(n = ys[r] + i, n in Cs.style) return { kebab: _s[r] + t, camel: n } }

		function Ee(t) { var e = []; if(qi(t))
				for(var i = 0, n = t.length; i < n; i++) { var r = t[i]; if(r)
						if("string" == typeof r) e.push(r);
						else
							for(var s in r) r[s] && e.push(s) } else if(m(t))
					for(var o in t) t[o] && e.push(o); return e }

		function Se(t, e, i) { if(e = e.trim(), e.indexOf(" ") === -1) return void i(t, e); for(var n = e.split(/\s+/), r = 0, s = n.length; r < s; r++) i(t, n[r]) }

		function Fe(t, e, i) {
			function n() {++s >= r ? i() : t[s].call(e, n) } var r = t.length,
				s = 0;
			t[0].call(e, n) }

		function De(t, e, i) { for(var r, s, o, a, h, c, f, p = [], d = i.$options.propsData, v = Object.keys(e), m = v.length; m--;) s = v[m], r = e[s] || Hs, h = l(s), Is.test(h) && (f = { name: s, path: h, options: r, mode: Ls.ONE_WAY, raw: null }, o = u(s), null === (a = K(t, o)) && (null !== (a = K(t, o + ".sync")) ? f.mode = Ls.TWO_WAY : null !== (a = K(t, o + ".once")) && (f.mode = Ls.ONE_TIME)), null !== a ? (f.raw = a, c = I(a), a = c.expression, f.filters = c.filters, n(a) && !c.filters ? f.optimizedLiteral = !0 : f.dynamic = !0, f.parentPath = a) : null !== (a = Y(t, o)) ? f.raw = a : d && null !== (a = d[s] || d[h]) && (f.raw = a), p.push(f)); return Pe(p) }

		function Pe(t) { return function(e, n) { e._props = {}; for(var r, s, l, c, f, p = e.$options.propsData, d = t.length; d--;)
					if(r = t[d], f = r.raw, s = r.path, l = r.options, e._props[s] = r, p && i(p, s) && Le(e, r, p[s]), null === f) Le(e, r, void 0);
					else if(r.dynamic) r.mode === Ls.ONE_TIME ? (c = (n || e._context || e).$get(r.parentPath), Le(e, r, c)) : e._context ? e._bindDir({ name: "prop", def: Ws, prop: r }, null, null, n) : Le(e, r, e.$get(r.parentPath));
				else if(r.optimizedLiteral) { var v = h(f);
					c = v === f ? a(o(f)) : v, Le(e, r, c) } else c = l.type === Boolean && ("" === f || f === u(r.name)) || f, Le(e, r, c) } }

		function Re(t, e, i, n) { var r = e.dynamic && Kt(e.parentPath),
				s = i;
			void 0 === s && (s = Ie(t, e)), s = We(e, s, t); var o = s !== i;
			Me(e, s, t) || (s = void 0), r && !o ? St(function() { n(s) }) : n(s) }

		function Le(t, e, i) { Re(t, e, i, function(i) { Lt(t, e.path, i) }) }

		function He(t, e, i) { Re(t, e, i, function(i) { t[e.path] = i }) }

		function Ie(t, e) { var n = e.options; if(!i(n, "default")) return n.type !== Boolean && void 0; var r = n.default; return m(r), "function" == typeof r && n.type !== Function ? r.call(t) : r }

		function Me(t, e, i) { if(!t.options.required && (null === t.raw || null == e)) return !0; var n = t.options,
				r = n.type,
				s = !r,
				o = []; if(r) { qi(r) || (r = [r]); for(var a = 0; a < r.length && !s; a++) { var h = Ve(e, r[a]);
					o.push(h.expectedType), s = h.valid } } if(!s) return !1; var l = n.validator; return !(l && !l(e)) }

		function We(t, e, i) { var n = t.options.coerce; return n && "function" == typeof n ? n(e) : e }

		function Ve(t, e) { var i, n; return e === String ? (n = "string", i = typeof t === n) : e === Number ? (n = "number", i = typeof t === n) : e === Boolean ? (n = "boolean", i = typeof t === n) : e === Function ? (n = "function", i = typeof t === n) : e === Object ? (n = "object", i = g(t)) : e === Array ? (n = "array", i = qi(t)) : i = t instanceof e, { valid: i, expectedType: n } }

		function Be(t) { Vs.push(t), Bs || (Bs = !0, ln(ze)) }

		function ze() { for(var t = document.documentElement.offsetHeight, e = 0; e < Vs.length; e++) Vs[e](); return Vs = [], Bs = !1, t }

		function Ue(t, e, i, n) { this.id = e, this.el = t, this.enterClass = i && i.enterClass || e + "-enter", this.leaveClass = i && i.leaveClass || e + "-leave", this.hooks = i, this.vm = n, this.pendingCssEvent = this.pendingCssCb = this.cancel = this.pendingJsCb = this.op = this.cb = null, this.justEntered = !1, this.entered = this.left = !1, this.typeCache = {}, this.type = i && i.type; var r = this;
			["enterNextTick", "enterDone", "leaveNextTick", "leaveDone"].forEach(function(t) { r[t] = p(r[t], r) }) }

		function Je(t) { if(/svg$/.test(t.namespaceURI)) { var e = t.getBoundingClientRect(); return !(e.width || e.height) } return !(t.offsetWidth || t.offsetHeight || t.getClientRects().length) }

		function qe(t, e, i) { var n = i || !e._asComponent ? ti(t, e) : null,
				r = n && n.terminal || gi(t) || !t.hasChildNodes() ? null : oi(t.childNodes, e); return function(t, e, i, s, o) { var a = d(e.childNodes),
					h = Qe(function() { n && n(t, e, i, s, o), r && r(t, a, i, s, o) }, t); return Ze(t, h) } }

		function Qe(t, e) { e._directives = []; var i = e._directives.length;
			t(); var n = e._directives.slice(i);
			Ge(n); for(var r = 0, s = n.length; r < s; r++) n[r]._bind(); return n }

		function Ge(t) { if(0 !== t.length) { var e, i, n, r, s = {},
					o = 0,
					a = []; for(e = 0, i = t.length; e < i; e++) { var h = t[e],
						l = h.descriptor.def.priority || ro,
						c = s[l];
					c || (c = s[l] = [], a.push(l)), c.push(h) } for(a.sort(function(t, e) { return t > e ? -1 : t === e ? 0 : 1 }), e = 0, i = a.length; e < i; e++) { var u = s[a[e]]; for(n = 0, r = u.length; n < r; n++) t[o++] = u[n] } } }

		function Ze(t, e, i, n) {
			function r(r) { Xe(t, e, r), i && n && Xe(i, n) } return r.dirs = e, r }

		function Xe(t, e, i) { for(var n = e.length; n--;) e[n]._teardown() }

		function Ye(t, e, i, n) { var r = De(e, i, t),
				s = Qe(function() { r(t, n) }, t); return Ze(t, s) }

		function Ke(t, e, i) { var n, r, s = e._containerAttrs,
				o = e._replacerAttrs; return 11 !== t.nodeType && (e._asComponent ? (s && i && (n = pi(s, i)), o && (r = pi(o, e))) : r = pi(t.attributes, e)), e._containerAttrs = e._replacerAttrs = null,
				function(t, e, i) { var s, o = t._context;
					o && n && (s = Qe(function() { n(o, e, null, i) }, o)); var a = Qe(function() { r && r(t, e) }, t); return Ze(t, a, o, s) } }

		function ti(t, e) { var i = t.nodeType; return 1 !== i || gi(t) ? 3 === i && t.data.trim() ? ii(t, e) : null : ei(t, e) }

		function ei(t, e) { if("TEXTAREA" === t.tagName) { if(null !== Y(t, "v-pre")) return ui; var i = V(t.value);
				i && (t.setAttribute(":value", B(i)), t.value = "") } var n, r = t.hasAttributes(),
				s = r && d(t.attributes); return r && (n = ci(t, s, e)), n || (n = hi(t, e)), n || (n = li(t, e)), !n && r && (n = pi(s, e)), n }

		function ii(t, e) { if(t._skip) return ni; var i = V(t.wholeText); if(!i) return null; for(var n = t.nextSibling; n && 3 === n.nodeType;) n._skip = !0, n = n.nextSibling; for(var r, s, o = document.createDocumentFragment(), a = 0, h = i.length; a < h; a++) s = i[a], r = s.tag ? ri(s, e) : document.createTextNode(s.value), o.appendChild(r); return si(i, o, e) }

		function ni(t, e) { nt(e) }

		function ri(t, e) {
			function i(e) { if(!t.descriptor) { var i = I(t.value);
					t.descriptor = { name: e, def: Ds[e], expression: i.expression, filters: i.filters } } } var n; return t.oneTime ? n = document.createTextNode(t.value) : t.html ? (n = document.createComment("v-html"), i("html")) : (n = document.createTextNode(" "), i("text")), n }

		function si(t, e) { return function(i, n, r, o) { for(var a, h, l, c = e.cloneNode(!0), u = d(c.childNodes), f = 0, p = t.length; f < p; f++) a = t[f], h = a.value, a.tag && (l = u[f], a.oneTime ? (h = (o || i).$eval(h), a.html ? st(l, ce(h, !0)) : l.data = s(h)) : i._bindDir(a.descriptor, l, r, o));
				st(n, c) } }

		function oi(t, e) { for(var i, n, r, s = [], o = 0, a = t.length; o < a; o++) r = t[o], i = ti(r, e), n = i && i.terminal || "SCRIPT" === r.tagName || !r.hasChildNodes() ? null : oi(r.childNodes, e), s.push(i, n); return s.length ? ai(s) : null }

		function ai(t) { return function(e, i, n, r, s) { for(var o, a, h, l = 0, c = 0, u = t.length; l < u; c++) { o = i[c], a = t[l++], h = t[l++]; var f = d(o.childNodes);
					a && a(e, o, n, r, s), h && h(e, f, n, r, s) } } }

		function hi(t, e) { var i = t.tagName.toLowerCase(); if(!zn.test(i)) { var n = jt(e, "elementDirectives", i); return n ? fi(t, i, "", e, n) : void 0 } }

		function li(t, e) { var i = Ct(t, e); if(i) { var n = gt(t),
					r = { name: "component", ref: n, expression: i.id, def: Ys.component, modifiers: { literal: !i.dynamic } },
					s = function(t, e, i, s, o) { n && Lt((s || t).$refs, n, null), t._bindDir(r, e, i, s, o) }; return s.terminal = !0, s } }

		function ci(t, e, i) { if(null !== Y(t, "v-pre")) return ui; if(t.hasAttribute("v-else")) { var n = t.previousElementSibling; if(n && n.hasAttribute("v-if")) return ui } for(var r, s, o, a, h, l, c, u, f, p, d = 0, v = e.length; d < v; d++) r = e[d], s = r.name.replace(io, ""), (h = s.match(eo)) && (f = jt(i, "directives", h[1]), f && f.terminal && (!p || (f.priority || so) > p.priority) && (p = f, c = r.name, a = di(r.name), o = r.value, l = h[1], u = h[2])); return p ? fi(t, l, o, i, p, c, u, a) : void 0 }

		function ui() {}

		function fi(t, e, i, n, r, s, o, a) { var h = I(i),
				l = { name: e, arg: o, expression: h.expression, filters: h.filters, raw: i, attr: s, modifiers: a, def: r }; "for" !== e && "router-view" !== e || (l.ref = gt(t)); var c = function(t, e, i, n, r) { l.ref && Lt((n || t).$refs, l.ref, null), t._bindDir(l, e, i, n, r) }; return c.terminal = !0, c }

		function pi(t, e) {
			function i(t, e, i) { var n = i && mi(i),
					r = !n && I(s);
				v.push({ name: t, attr: o, raw: a, def: e, arg: l, modifiers: c, expression: r && r.expression, filters: r && r.filters, interp: i, hasOneTime: n }) } for(var n, r, s, o, a, h, l, c, u, f, p, d = t.length, v = []; d--;)
				if(n = t[d], r = o = n.name, s = a = n.value, f = V(s), l = null, c = di(r), r = r.replace(io, ""), f) s = B(f), l = r, i("bind", Ds.bind, f);
				else if(no.test(r)) c.literal = !Ks.test(r), i("transition", Ys.transition);
			else if(to.test(r)) l = r.replace(to, ""), i("on", Ds.on);
			else if(Ks.test(r)) h = r.replace(Ks, ""), "style" === h || "class" === h ? i(h, Ys[h]) : (l = h, i("bind", Ds.bind));
			else if(p = r.match(eo)) { if(h = p[1], l = p[2], "else" === h) continue;
				u = jt(e, "directives", h, !0), u && i(h, u) } if(v.length) return vi(v) }

		function di(t) { var e = Object.create(null),
				i = t.match(io); if(i)
				for(var n = i.length; n--;) e[i[n].slice(1)] = !0; return e }

		function vi(t) { return function(e, i, n, r, s) { for(var o = t.length; o--;) e._bindDir(t[o], i, n, r, s) } }

		function mi(t) { for(var e = t.length; e--;)
				if(t[e].oneTime) return !0 }

		function gi(t) { return "SCRIPT" === t.tagName && (!t.hasAttribute("type") || "text/javascript" === t.getAttribute("type")) }

		function _i(t, e) { return e && (e._containerAttrs = bi(t)), vt(t) && (t = ce(t)), e && (e._asComponent && !e.template && (e.template = "<slot></slot>"), e.template && (e._content = ft(t), t = yi(t, e))), bt(t) && (rt(mt("v-start", !0), t), t.appendChild(mt("v-end", !0))), t }

		function yi(t, e) { var i = e.template,
				n = ce(i, !0); if(n) { var r = n.firstChild; if(!r) return n; var s = r.tagName && r.tagName.toLowerCase(); return e.replace ? (t === document.body, n.childNodes.length > 1 || 1 !== r.nodeType || "component" === s || jt(e, "components", s) || tt(r, "is") || jt(e, "elementDirectives", s) || r.hasAttribute("v-for") || r.hasAttribute("v-if") ? n : (e._replacerAttrs = bi(r), wi(t, r), r)) : (t.appendChild(n), t) } }

		function bi(t) { if(1 === t.nodeType && t.hasAttributes()) return d(t.attributes) }

		function wi(t, e) { for(var i, n, r = t.attributes, s = r.length; s--;) i = r[s].name, n = r[s].value, e.hasAttribute(i) || oo.test(i) ? "class" === i && !V(n) && (n = n.trim()) && n.split(/\s+/).forEach(function(t) { ct(e, t) }) : e.setAttribute(i, n) }

		function Ci(t, e) { if(e) { for(var i, n, r = t._slotContents = Object.create(null), s = 0, o = e.children.length; s < o; s++) i = e.children[s], (n = i.getAttribute("slot")) && (r[n] || (r[n] = [])).push(i); for(n in r) r[n] = $i(r[n], e); if(e.hasChildNodes()) { var a = e.childNodes; if(1 === a.length && 3 === a[0].nodeType && !a[0].data.trim()) return;
					r.default = $i(e.childNodes, e) } } }

		function $i(t, e) { var i = document.createDocumentFragment();
			t = d(t); for(var n = 0, r = t.length; n < r; n++) { var s = t[n];!vt(s) || s.hasAttribute("v-if") || s.hasAttribute("v-for") || (e.removeChild(s), s = ce(s, !0)), i.appendChild(s) } return i }

		function ki(t) {
			function e() {}

			function n(t, e) { var i = new re(e, t, null, { lazy: !0 }); return function() { return i.dirty && i.evaluate(), Et.target && i.depend(), i.value } } Object.defineProperty(t.prototype, "$data", { get: function() { return this._data }, set: function(t) { t !== this._data && this._setData(t) } }), t.prototype._initState = function() { this._initProps(), this._initMeta(), this._initMethods(), this._initData(), this._initComputed() }, t.prototype._initProps = function() { var t = this.$options,
					e = t.el,
					i = t.props;
				e = t.el = Z(e), this._propsUnlinkFn = e && 1 === e.nodeType && i ? Ye(this, e, i, this._scope) : null }, t.prototype._initData = function() { var t = this.$options.data,
					e = this._data = t ? t() : {};
				g(e) || (e = {}); var n, r, s = this._props,
					o = Object.keys(e); for(n = o.length; n--;) r = o[n], s && i(s, r) || this._proxy(r);
				Rt(e, this) }, t.prototype._setData = function(t) { t = t || {}; var e = this._data;
				this._data = t; var n, r, s; for(n = Object.keys(e), s = n.length; s--;) r = n[s], r in t || this._unproxy(r); for(n = Object.keys(t), s = n.length; s--;) r = n[s], i(this, r) || this._proxy(r);
				e.__ob__.removeVm(this), Rt(t, this), this._digest() }, t.prototype._proxy = function(t) { if(!r(t)) { var e = this;
					Object.defineProperty(e, t, { configurable: !0, enumerable: !0, get: function() { return e._data[t] }, set: function(i) { e._data[t] = i } }) } }, t.prototype._unproxy = function(t) { r(t) || delete this[t] }, t.prototype._digest = function() { for(var t = 0, e = this._watchers.length; t < e; t++) this._watchers[t].update(!0) }, t.prototype._initComputed = function() { var t = this.$options.computed; if(t)
					for(var i in t) { var r = t[i],
							s = { enumerable: !0, configurable: !0 }; "function" == typeof r ? (s.get = n(r, this), s.set = e) : (s.get = r.get ? r.cache !== !1 ? n(r.get, this) : p(r.get, this) : e, s.set = r.set ? p(r.set, this) : e), Object.defineProperty(this, i, s) } }, t.prototype._initMethods = function() { var t = this.$options.methods; if(t)
					for(var e in t) this[e] = p(t[e], this) }, t.prototype._initMeta = function() { var t = this.$options._meta; if(t)
					for(var e in t) Lt(this, e, t[e]) } }

		function xi(t) {
			function e(t, e) { for(var i, n, r, s = e.attributes, o = 0, a = s.length; o < a; o++) i = s[o].name, ho.test(i) && (i = i.replace(ho, ""), n = s[o].value, Kt(n) && (n += ".apply(this, $arguments)"), r = (t._scope || t._context).$eval(n, !0), r._fromParent = !0, t.$on(i.replace(ho), r)) }

			function i(t, e, i) { if(i) { var r, s, o, a; for(s in i)
						if(r = i[s], qi(r))
							for(o = 0, a = r.length; o < a; o++) n(t, e, s, r[o]);
						else n(t, e, s, r) } }

			function n(t, e, i, r, s) { var o = typeof r; if("function" === o) t[e](i, r, s);
				else if("string" === o) { var a = t.$options.methods,
						h = a && a[r];
					h && t[e](i, h, s) } else r && "object" === o && n(t, e, i, r.handler, r) }

			function r() { this._isAttached || (this._isAttached = !0, this.$children.forEach(s)) }

			function s(t) {!t._isAttached && X(t.$el) && t._callHook("attached") }

			function o() { this._isAttached && (this._isAttached = !1, this.$children.forEach(a)) }

			function a(t) { t._isAttached && !X(t.$el) && t._callHook("detached") } t.prototype._initEvents = function() { var t = this.$options;
				t._asComponent && e(this, t.el), i(this, "$on", t.events), i(this, "$watch", t.watch) }, t.prototype._initDOMHooks = function() { this.$on("hook:attached", r), this.$on("hook:detached", o) }, t.prototype._callHook = function(t) { this.$emit("pre-hook:" + t); var e = this.$options[t]; if(e)
					for(var i = 0, n = e.length; i < n; i++) e[i].call(this);
				this.$emit("hook:" + t) } }

		function Ai() {}

		function Oi(t, e, i, n, r, s) { this.vm = e, this.el = i, this.descriptor = t, this.name = t.name, this.expression = t.expression, this.arg = t.arg, this.modifiers = t.modifiers, this.filters = t.filters, this.literal = this.modifiers && this.modifiers.literal, this._locked = !1, this._bound = !1, this._listeners = null, this._host = n, this._scope = r, this._frag = s }

		function Ti(t) {
			t.prototype._updateRef = function(t) { var e = this.$options._ref; if(e) { var i = (this._scope || this._context).$refs;
					t ? i[e] === this && (i[e] = null) : i[e] = this } }, t.prototype._compile = function(t) {
				var e = this.$options,
					i = t;
				if(t = _i(t, e), this._initElement(t), 1 !== t.nodeType || null === Y(t, "v-pre")) {
					var n = this._context && this._context.$options,
						r = Ke(t, e, n);
					Ci(this, e._content);
					var s, o = this.constructor;
					e._linkerCachable && (s = o.linker, s || (s = o.linker = qe(t, e)));
					var a = r(this, t, this._scope),
						h = s ? s(this, t) : qe(t, e)(this, t);
					this._unlinkFn = function() { a(), h(!0) }, e.replace && st(i, t), this._isCompiled = !0, this._callHook("compiled")
				}
			}, t.prototype._initElement = function(t) { bt(t) ? (this._isFragment = !0, this.$el = this._fragmentStart = t.firstChild, this._fragmentEnd = t.lastChild, 3 === this._fragmentStart.nodeType && (this._fragmentStart.data = this._fragmentEnd.data = ""), this._fragment = t) : this.$el = t, this.$el.__vue__ = this, this._callHook("beforeCompile") }, t.prototype._bindDir = function(t, e, i, n, r) { this._directives.push(new Oi(t, this, e, i, n, r)) }, t.prototype._destroy = function(t, e) { if(this._isBeingDestroyed) return void(e || this._cleanup()); var i, n, r = this,
					s = function() {!i || n || e || r._cleanup() };
				t && this.$el && (n = !0, this.$remove(function() { n = !1, s() })), this._callHook("beforeDestroy"), this._isBeingDestroyed = !0; var o, a = this.$parent; for(a && !a._isBeingDestroyed && (a.$children.$remove(this), this._updateRef(!0)), o = this.$children.length; o--;) this.$children[o].$destroy(); for(this._propsUnlinkFn && this._propsUnlinkFn(), this._unlinkFn && this._unlinkFn(), o = this._watchers.length; o--;) this._watchers[o].teardown();
				this.$el && (this.$el.__vue__ = null), i = !0, s() }, t.prototype._cleanup = function() { this._isDestroyed || (this._frag && this._frag.children.$remove(this), this._data && this._data.__ob__ && this._data.__ob__.removeVm(this), this.$el = this.$parent = this.$root = this.$children = this._watchers = this._context = this._scope = this._directives = null, this._isDestroyed = !0, this._callHook("destroyed"), this.$off()) }
		}

		function Ni(t) { t.prototype._applyFilters = function(t, e, i, n) { var r, s, o, a, h, l, c, u, f; for(l = 0, c = i.length; l < c; l++)
					if(r = i[n ? c - l - 1 : l], s = jt(this.$options, "filters", r.name, !0), s && (s = n ? s.write : s.read || s, "function" == typeof s)) { if(o = n ? [t, e] : [t], h = n ? 2 : 1, r.args)
							for(u = 0, f = r.args.length; u < f; u++) a = r.args[u], o[u + h] = a.dynamic ? this.$get(a.value) : a.value;
						t = s.apply(this, o) }
				return t }, t.prototype._resolveComponent = function(e, i) { var n; if(n = "function" == typeof e ? e : jt(this.$options, "components", e, !0))
					if(n.options) i(n);
					else if(n.resolved) i(n.resolved);
				else if(n.requested) n.pendingCallbacks.push(i);
				else { n.requested = !0; var r = n.pendingCallbacks = [i];
					n.call(this, function(e) { g(e) && (e = t.extend(e)), n.resolved = e; for(var i = 0, s = r.length; i < s; i++) r[i](e) }, function(t) {}) } } }

		function ji(t) {
			function i(t) { return JSON.parse(JSON.stringify(t)) } t.prototype.$get = function(t, e) { var i = Yt(t); if(i) { if(e) { var n = this; return function() { n.$arguments = d(arguments); var t = i.get.call(n, n); return n.$arguments = null, t } } try { return i.get.call(this, this) } catch(t) {} } }, t.prototype.$set = function(t, e) { var i = Yt(t, !0);
				i && i.set && i.set.call(this, this, e) }, t.prototype.$delete = function(t) { e(this._data, t) }, t.prototype.$watch = function(t, e, i) { var n, r = this; "string" == typeof t && (n = I(t), t = n.expression); var s = new re(r, t, e, { deep: i && i.deep, sync: i && i.sync, filters: n && n.filters, user: !i || i.user !== !1 }); return i && i.immediate && e.call(r, s.value),
					function() { s.teardown() } }, t.prototype.$eval = function(t, e) { if(lo.test(t)) { var i = I(t),
						n = this.$get(i.expression, e); return i.filters ? this._applyFilters(n, null, i.filters) : n } return this.$get(t, e) }, t.prototype.$interpolate = function(t) { var e = V(t),
					i = this; return e ? 1 === e.length ? i.$eval(e[0].value) + "" : e.map(function(t) { return t.tag ? i.$eval(t.value) : t.value }).join("") : t }, t.prototype.$log = function(t) { var e = t ? Bt(this._data, t) : this._data; if(e && (e = i(e)), !t) { var n; for(n in this.$options.computed) e[n] = i(this[n]); if(this._props)
						for(n in this._props) e[n] = i(this[n]) } console.log(e) } }

		function Ei(t) {
			function e(t, e, n, r, s, o) { e = i(e); var a = !X(e),
					h = r === !1 || a ? s : o,
					l = !a && !t._isAttached && !X(t.$el); return t._isFragment ? (_t(t._fragmentStart, t._fragmentEnd, function(i) { h(i, e, t) }), n && n()) : h(t.$el, e, t, n), l && t._callHook("attached"), t }

			function i(t) { return "string" == typeof t ? document.querySelector(t) : t }

			function n(t, e, i, n) { e.appendChild(t), n && n() }

			function r(t, e, i, n) { et(t, e), n && n() }

			function s(t, e, i) { nt(t), i && i() } t.prototype.$nextTick = function(t) { ln(t, this) }, t.prototype.$appendTo = function(t, i, r) { return e(this, t, i, r, n, J) }, t.prototype.$prependTo = function(t, e, n) { return t = i(t), t.hasChildNodes() ? this.$before(t.firstChild, e, n) : this.$appendTo(t, e, n), this }, t.prototype.$before = function(t, i, n) { return e(this, t, i, n, r, q) }, t.prototype.$after = function(t, e, n) { return t = i(t), t.nextSibling ? this.$before(t.nextSibling, e, n) : this.$appendTo(t.parentNode, e, n), this }, t.prototype.$remove = function(t, e) { if(!this.$el.parentNode) return t && t(); var i = this._isAttached && X(this.$el);
				i || (e = !1); var n = this,
					r = function() { i && n._callHook("detached"), t && t() }; if(this._isFragment) yt(this._fragmentStart, this._fragmentEnd, this, this._fragment, r);
				else { var o = e === !1 ? s : Q;
					o(this.$el, this, r) } return this } }

		function Si(t) {
			function e(t, e, n) { var r = t.$parent; if(r && n && !i.test(e))
					for(; r;) r._eventsCount[e] = (r._eventsCount[e] || 0) + n, r = r.$parent } t.prototype.$on = function(t, i) { return(this._events[t] || (this._events[t] = [])).push(i), e(this, t, 1), this }, t.prototype.$once = function(t, e) {
				function i() { n.$off(t, i), e.apply(this, arguments) } var n = this; return i.fn = e, this.$on(t, i), this }, t.prototype.$off = function(t, i) { var n; if(!arguments.length) { if(this.$parent)
						for(t in this._events) n = this._events[t], n && e(this, t, -n.length); return this._events = {}, this } if(n = this._events[t], !n) return this; if(1 === arguments.length) return e(this, t, -n.length), this._events[t] = null, this; for(var r, s = n.length; s--;)
					if(r = n[s], r === i || r.fn === i) { e(this, t, -1), n.splice(s, 1); break }
				return this }, t.prototype.$emit = function(t) { var e = "string" == typeof t;
				t = e ? t : t.name; var i = this._events[t],
					n = e || !i; if(i) { i = i.length > 1 ? d(i) : i; var r = e && i.some(function(t) { return t._fromParent });
					r && (n = !1); for(var s = d(arguments, 1), o = 0, a = i.length; o < a; o++) { var h = i[o],
							l = h.apply(this, s);
						l !== !0 || r && !h._fromParent || (n = !0) } } return n }, t.prototype.$broadcast = function(t) { var e = "string" == typeof t; if(t = e ? t : t.name, this._eventsCount[t]) { var i = this.$children,
						n = d(arguments);
					e && (n[0] = { name: t, source: this }); for(var r = 0, s = i.length; r < s; r++) { var o = i[r],
							a = o.$emit.apply(o, n);
						a && o.$broadcast.apply(o, n) } return this } }, t.prototype.$dispatch = function(t) { var e = this.$emit.apply(this, arguments); if(e) { var i = this.$parent,
						n = d(arguments); for(n[0] = { name: t, source: this }; i;) e = i.$emit.apply(i, n), i = e ? i.$parent : null; return this } }; var i = /^hook:/ }

		function Fi(t) {
			function e() { this._isAttached = !0, this._isReady = !0, this._callHook("ready") } t.prototype.$mount = function(t) { if(!this._isCompiled) return t = Z(t), t || (t = document.createElement("div")), this._compile(t), this._initDOMHooks(), X(this.$el) ? (this._callHook("attached"), e.call(this)) : this.$once("hook:attached", e), this }, t.prototype.$destroy = function(t, e) { this._destroy(t, e) }, t.prototype.$compile = function(t, e, i, n) { return qe(t, this.$options, !0)(this, t, e, i, n) } }

		function Di(t) { this._init(t) }

		function Pi(t, e, i) { return i = i ? parseInt(i, 10) : 0, e = o(e), "number" == typeof e ? t.slice(i, i + e) : t }

		function Ri(t, e, i) { if(t = po(t), null == e) return t; if("function" == typeof e) return t.filter(e);
			e = ("" + e).toLowerCase(); for(var n, r, s, o, a = "in" === i ? 3 : 2, h = Array.prototype.concat.apply([], d(arguments, a)), l = [], c = 0, u = t.length; c < u; c++)
				if(n = t[c], s = n && n.$value || n, o = h.length) { for(; o--;)
						if(r = h[o], "$key" === r && Hi(n.$key, e) || Hi(Bt(s, r), e)) { l.push(n); break } } else Hi(n, e) && l.push(n); return l }

		function Li(t) {
			function e(t, e, i) { var r = n[i]; return r && ("$key" !== r && (m(t) && "$value" in t && (t = t.$value), m(e) && "$value" in e && (e = e.$value)), t = m(t) ? Bt(t, r) : t, e = m(e) ? Bt(e, r) : e), t === e ? 0 : t > e ? s : -s } var i = null,
				n = void 0;
			t = po(t); var r = d(arguments, 1),
				s = r[r.length - 1]; "number" == typeof s ? (s = s < 0 ? -1 : 1, r = r.length > 1 ? r.slice(0, -1) : r) : s = 1; var o = r[0]; return o ? ("function" == typeof o ? i = function(t, e) { return o(t, e) * s } : (n = Array.prototype.concat.apply([], r), i = function(t, r, s) { return s = s || 0, s >= n.length - 1 ? e(t, r, s) : e(t, r, s) || i(t, r, s + 1) }), t.slice().sort(i)) : t }

		function Hi(t, e) { var i; if(g(t)) { var n = Object.keys(t); for(i = n.length; i--;)
					if(Hi(t[n[i]], e)) return !0 } else if(qi(t)) { for(i = t.length; i--;)
					if(Hi(t[i], e)) return !0 } else if(null != t) return t.toString().toLowerCase().indexOf(e) > -1 }

		function Ii(i) {
			function n(t) { return new Function("return function " + f(t) + " (options) { this._init(options) }")() } i.options = { directives: Ds, elementDirectives: fo, filters: mo, transitions: {}, components: {}, partials: {}, replace: !0 }, i.util = Kn, i.config = Mn, i.set = t, i.delete = e, i.nextTick = ln, i.compiler = ao, i.FragmentFactory = _e, i.internalDirectives = Ys, i.parsers = { path: mr, text: Ln, template: qr, directive: En, expression: jr }, i.cid = 0; var r = 1;
			i.extend = function(t) { t = t || {}; var e = this,
					i = 0 === e.cid; if(i && t._Ctor) return t._Ctor; var s = t.name || e.options.name,
					o = n(s || "VueComponent"); return o.prototype = Object.create(e.prototype), o.prototype.constructor = o, o.cid = r++, o.options = Nt(e.options, t), o.super = e, o.extend = e.extend, Mn._assetTypes.forEach(function(t) { o[t] = e[t] }), s && (o.options.components[s] = o), i && (t._Ctor = o), o }, i.use = function(t) { if(!t.installed) { var e = d(arguments, 1); return e.unshift(this), "function" == typeof t.install ? t.install.apply(t, e) : t.apply(null, e), t.installed = !0, this } }, i.mixin = function(t) { i.options = Nt(i.options, t) }, Mn._assetTypes.forEach(function(t) { i[t] = function(e, n) { return n ? ("component" === t && g(n) && (n.name || (n.name = e), n = i.extend(n)), this.options[t + "s"][e] = n, n) : this.options[t + "s"][e] } }), v(i.transition, Vn) }
		var Mi = Object.prototype.hasOwnProperty,
			Wi = /^\s?(true|false|-?[\d\.]+|'[^']*'|"[^"]*")\s?$/,
			Vi = /-(\w)/g,
			Bi = /([^-])([A-Z])/g,
			zi = /(?:^|[-_\/])(\w)/g,
			Ui = Object.prototype.toString,
			Ji = "[object Object]",
			qi = Array.isArray,
			Qi = "__proto__" in {},
			Gi = "undefined" != typeof window && "[object Object]" !== Object.prototype.toString.call(window),
			Zi = Gi && window.__VUE_DEVTOOLS_GLOBAL_HOOK__,
			Xi = Gi && window.navigator.userAgent.toLowerCase(),
			Yi = Xi && Xi.indexOf("trident") > 0,
			Ki = Xi && Xi.indexOf("msie 9.0") > 0,
			tn = Xi && Xi.indexOf("android") > 0,
			en = Xi && /iphone|ipad|ipod|ios/.test(Xi),
			nn = void 0,
			rn = void 0,
			sn = void 0,
			on = void 0;
		if(Gi && !Ki) { var an = void 0 === window.ontransitionend && void 0 !== window.onwebkittransitionend,
				hn = void 0 === window.onanimationend && void 0 !== window.onwebkitanimationend;
			nn = an ? "WebkitTransition" : "transition", rn = an ? "webkitTransitionEnd" : "transitionend", sn = hn ? "WebkitAnimation" : "animation", on = hn ? "webkitAnimationEnd" : "animationend" }
		var ln = function() {
				function t() { i = !1; var t = e.slice(0);
					e.length = 0; for(var n = 0; n < t.length; n++) t[n]() } var e = [],
					i = !1,
					n = void 0; if("undefined" != typeof Promise && $(Promise)) { var r = Promise.resolve(),
						s = function() {};
					n = function() { r.then(t), en && setTimeout(s) } } else if("undefined" != typeof MutationObserver) { var o = 1,
						a = new MutationObserver(t),
						h = document.createTextNode(String(o));
					a.observe(h, { characterData: !0 }), n = function() { o = (o + 1) % 2, h.data = String(o) } } else n = setTimeout; return function(r, s) { var o = s ? function() { r.call(s) } : r;
					e.push(o), i || (i = !0, n(t, 0)) } }(),
			cn = void 0;
		"undefined" != typeof Set && $(Set) ? cn = Set : (cn = function() { this.set = Object.create(null) }, cn.prototype.has = function(t) { return void 0 !== this.set[t] }, cn.prototype.add = function(t) { this.set[t] = 1 }, cn.prototype.clear = function() { this.set = Object.create(null) });
		var un = k.prototype;
		un.put = function(t, e) { var i, n = this.get(t, !0); return n || (this.size === this.limit && (i = this.shift()), n = { key: t }, this._keymap[t] = n, this.tail ? (this.tail.newer = n, n.older = this.tail) : this.head = n, this.tail = n, this.size++), n.value = e, i }, un.shift = function() { var t = this.head; return t && (this.head = this.head.newer, this.head.older = void 0, t.newer = t.older = void 0, this._keymap[t.key] = void 0, this.size--), t }, un.get = function(t, e) { var i = this._keymap[t]; if(void 0 !== i) return i === this.tail ? e ? i : i.value : (i.newer && (i === this.head && (this.head = i.newer), i.newer.older = i.older), i.older && (i.older.newer = i.newer), i.newer = void 0, i.older = this.tail, this.tail && (this.tail.newer = i), this.tail = i, e ? i : i.value) };
		var fn, pn, dn, vn, mn, gn, _n = new k(1e3),
			yn = /^in$|^-?\d+/,
			bn = 0,
			wn = 1,
			Cn = 2,
			$n = 3,
			kn = 34,
			xn = 39,
			An = 124,
			On = 92,
			Tn = 32,
			Nn = { 91: 1, 123: 1, 40: 1 },
			jn = { 91: 93, 123: 125, 40: 41 },
			En = Object.freeze({ parseDirective: I }),
			Sn = /[-.*+?^${}()|[\]\/\\]/g,
			Fn = void 0,
			Dn = void 0,
			Pn = void 0,
			Rn = /[^|]\|[^|]/,
			Ln = Object.freeze({ compileRegex: W, parseText: V, tokensToExp: B }),
			Hn = ["{{", "}}"],
			In = ["{{{", "}}}"],
			Mn = Object.defineProperties({ debug: !1, silent: !1, async: !0, warnExpressionErrors: !0, devtools: !1, _delimitersChanged: !0, _assetTypes: ["component", "directive", "elementDirective", "filter", "transition", "partial"], _propBindingModes: { ONE_WAY: 0, TWO_WAY: 1, ONE_TIME: 2 }, _maxUpdateCount: 100 }, { delimiters: { get: function() { return Hn }, set: function(t) { Hn = t, W() }, configurable: !0, enumerable: !0 }, unsafeDelimiters: { get: function() { return In }, set: function(t) { In = t, W() }, configurable: !0, enumerable: !0 } }),
			Wn = void 0,
			Vn = Object.freeze({ appendWithTransition: J, beforeWithTransition: q, removeWithTransition: Q, applyTransition: G }),
			Bn = /^v-ref:/,
			zn = /^(div|p|span|img|a|b|i|br|ul|ol|li|h1|h2|h3|h4|h5|h6|code|pre|table|th|td|tr|form|label|input|select|option|nav|article|section|header|footer)$/i,
			Un = /^(slot|partial|component)$/i,
			Jn = Mn.optionMergeStrategies = Object.create(null);
		Jn.data = function(t, e, i) { return i ? t || e ? function() { var n = "function" == typeof e ? e.call(i) : e,
					r = "function" == typeof t ? t.call(i) : void 0; return n ? kt(n, r) : r } : void 0 : e ? "function" != typeof e ? t : t ? function() { return kt(e.call(this), t.call(this)) } : e : t }, Jn.el = function(t, e, i) { if(i || !e || "function" == typeof e) { var n = e || t; return i && "function" == typeof n ? n.call(i) : n } }, Jn.init = Jn.created = Jn.ready = Jn.attached = Jn.detached = Jn.beforeCompile = Jn.compiled = Jn.beforeDestroy = Jn.destroyed = Jn.activate = function(t, e) { return e ? t ? t.concat(e) : qi(e) ? e : [e] : t }, Mn._assetTypes.forEach(function(t) { Jn[t + "s"] = xt }), Jn.watch = Jn.events = function(t, e) { if(!e) return t; if(!t) return e; var i = {};
			v(i, t); for(var n in e) { var r = i[n],
					s = e[n];
				r && !qi(r) && (r = [r]), i[n] = r ? r.concat(s) : [s] } return i }, Jn.props = Jn.methods = Jn.computed = function(t, e) { if(!e) return t; if(!t) return e; var i = Object.create(null); return v(i, t), v(i, e), i };
		var qn = function(t, e) { return void 0 === e ? t : e },
			Qn = 0;
		Et.target = null, Et.prototype.addSub = function(t) { this.subs.push(t) }, Et.prototype.removeSub = function(t) { this.subs.$remove(t) }, Et.prototype.depend = function() { Et.target.addDep(this) }, Et.prototype.notify = function() { for(var t = d(this.subs), e = 0, i = t.length; e < i; e++) t[e].update() };
		var Gn = Array.prototype,
			Zn = Object.create(Gn);
		["push", "pop", "shift", "unshift", "splice", "sort", "reverse"].forEach(function(t) { var e = Gn[t];
			_(Zn, t, function() { for(var i = arguments.length, n = new Array(i); i--;) n[i] = arguments[i]; var r, s = e.apply(this, n),
					o = this.__ob__; switch(t) {
					case "push":
						r = n; break;
					case "unshift":
						r = n; break;
					case "splice":
						r = n.slice(2) } return r && o.observeArray(r), o.dep.notify(), s }) }), _(Gn, "$set", function(t, e) { return t >= this.length && (this.length = Number(t) + 1), this.splice(t, 1, e)[0] }), _(Gn, "$remove", function(t) { if(this.length) { var e = b(this, t); return e > -1 ? this.splice(e, 1) : void 0 } });
		var Xn = Object.getOwnPropertyNames(Zn),
			Yn = !0;
		Ft.prototype.walk = function(t) { for(var e = Object.keys(t), i = 0, n = e.length; i < n; i++) this.convert(e[i], t[e[i]]) }, Ft.prototype.observeArray = function(t) { for(var e = 0, i = t.length; e < i; e++) Rt(t[e]) }, Ft.prototype.convert = function(t, e) { Lt(this.value, t, e) }, Ft.prototype.addVm = function(t) {
			(this.vms || (this.vms = [])).push(t) }, Ft.prototype.removeVm = function(t) { this.vms.$remove(t) };
		var Kn = Object.freeze({ defineReactive: Lt, set: t, del: e, hasOwn: i, isLiteral: n, isReserved: r, _toString: s, toNumber: o, toBoolean: a, stripQuotes: h, camelize: l, hyphenate: u, classify: f, bind: p, toArray: d, extend: v, isObject: m, isPlainObject: g, def: _, debounce: y, indexOf: b, cancellable: w, looseEqual: C, isArray: qi, hasProto: Qi, inBrowser: Gi, devtools: Zi, isIE: Yi, isIE9: Ki, isAndroid: tn, isIOS: en, get transitionProp() { return nn }, get transitionEndEvent() { return rn }, get animationProp() { return sn }, get animationEndEvent() { return on }, nextTick: ln, get _Set() { return cn }, query: Z, inDoc: X, getAttr: Y, getBindAttr: K, hasBindAttr: tt, before: et, after: it, remove: nt, prepend: rt, replace: st, on: ot, off: at, setClass: lt, addClass: ct, removeClass: ut, extractContent: ft, trimNode: pt, isTemplate: vt, createAnchor: mt, findRef: gt, mapNodeRange: _t, removeNodeRange: yt, isFragment: bt, getOuterHTML: wt, mergeOptions: Nt, resolveAsset: jt, checkComponentAttr: Ct, commonTagRE: zn, reservedTagRE: Un, warn: Wn }),
			tr = 0,
			er = new k(1e3),
			ir = 0,
			nr = 1,
			rr = 2,
			sr = 3,
			or = 0,
			ar = 1,
			hr = 2,
			lr = 3,
			cr = 4,
			ur = 5,
			fr = 6,
			pr = 7,
			dr = 8,
			vr = [];
		vr[or] = { ws: [or], ident: [lr, ir], "[": [cr], eof: [pr] }, vr[ar] = { ws: [ar], ".": [hr], "[": [cr], eof: [pr] }, vr[hr] = { ws: [hr], ident: [lr, ir] }, vr[lr] = { ident: [lr, ir], 0: [lr, ir], number: [lr, ir], ws: [ar, nr], ".": [hr, nr], "[": [cr, nr], eof: [pr, nr] }, vr[cr] = { "'": [ur, ir], '"': [fr, ir], "[": [cr, rr], "]": [ar, sr], eof: dr, else: [cr, ir] }, vr[ur] = { "'": [cr, ir], eof: dr, else: [ur, ir] }, vr[fr] = { '"': [cr, ir], eof: dr, else: [fr, ir] };
		var mr = Object.freeze({ parsePath: Vt, getPath: Bt, setPath: zt }),
			gr = new k(1e3),
			_r = "Math,Date,this,true,false,null,undefined,Infinity,NaN,isNaN,isFinite,decodeURI,decodeURIComponent,encodeURI,encodeURIComponent,parseInt,parseFloat",
			yr = new RegExp("^(" + _r.replace(/,/g, "\\b|") + "\\b)"),
			br = "break,case,class,catch,const,continue,debugger,default,delete,do,else,export,extends,finally,for,function,if,import,in,instanceof,let,return,super,switch,throw,try,var,while,with,yield,enum,await,implements,package,protected,static,interface,private,public",
			wr = new RegExp("^(" + br.replace(/,/g, "\\b|") + "\\b)"),
			Cr = /\s/g,
			$r = /\n/g,
			kr = /[\{,]\s*[\w\$_]+\s*:|('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*"|`(?:[^`\\]|\\.)*\$\{|\}(?:[^`\\"']|\\.)*`|`(?:[^`\\]|\\.)*`)|new |typeof |void /g,
			xr = /"(\d+)"/g,
			Ar = /^[A-Za-z_$][\w$]*(?:\.[A-Za-z_$][\w$]*|\['.*?'\]|\[".*?"\]|\[\d+\]|\[[A-Za-z_$][\w$]*\])*$/,
			Or = /[^\w$\.](?:[A-Za-z_$][\w$]*)/g,
			Tr = /^(?:true|false|null|undefined|Infinity|NaN)$/,
			Nr = [],
			jr = Object.freeze({ parseExpression: Yt, isSimplePath: Kt }),
			Er = [],
			Sr = [],
			Fr = {},
			Dr = {},
			Pr = !1,
			Rr = 0;
		re.prototype.get = function() { this.beforeGet(); var t, e = this.scope || this.vm; try { t = this.getter.call(e, e) } catch(t) {} return this.deep && se(t), this.preProcess && (t = this.preProcess(t)), this.filters && (t = e._applyFilters(t, null, this.filters, !1)), this.postProcess && (t = this.postProcess(t)), this.afterGet(), t }, re.prototype.set = function(t) { var e = this.scope || this.vm;
			this.filters && (t = e._applyFilters(t, this.value, this.filters, !0)); try { this.setter.call(e, e, t) } catch(t) {} var i = e.$forContext; if(i && i.alias === this.expression) { if(i.filters) return;
				i._withLock(function() { e.$key ? i.rawValue[e.$key] = t : i.rawValue.$set(e.$index, t) }) } }, re.prototype.beforeGet = function() { Et.target = this }, re.prototype.addDep = function(t) { var e = t.id;
			this.newDepIds.has(e) || (this.newDepIds.add(e), this.newDeps.push(t), this.depIds.has(e) || t.addSub(this)) }, re.prototype.afterGet = function() { Et.target = null; for(var t = this.deps.length; t--;) { var e = this.deps[t];
				this.newDepIds.has(e.id) || e.removeSub(this) } var i = this.depIds;
			this.depIds = this.newDepIds, this.newDepIds = i, this.newDepIds.clear(), i = this.deps, this.deps = this.newDeps, this.newDeps = i, this.newDeps.length = 0 }, re.prototype.update = function(t) { this.lazy ? this.dirty = !0 : this.sync || !Mn.async ? this.run() : (this.shallow = this.queued ? !!t && this.shallow : !!t, this.queued = !0, ne(this)) }, re.prototype.run = function() { if(this.active) { var t = this.get(); if(t !== this.value || (m(t) || this.deep) && !this.shallow) { var e = this.value;
					this.value = t;
					this.prevError;
					this.cb.call(this.vm, t, e) } this.queued = this.shallow = !1 } }, re.prototype.evaluate = function() { var t = Et.target;
			this.value = this.get(), this.dirty = !1, Et.target = t }, re.prototype.depend = function() { for(var t = this.deps.length; t--;) this.deps[t].depend() }, re.prototype.teardown = function() { if(this.active) { this.vm._isBeingDestroyed || this.vm._vForRemoving || this.vm._watchers.$remove(this); for(var t = this.deps.length; t--;) this.deps[t].removeSub(this);
				this.active = !1, this.vm = this.cb = this.value = null } };
		var Lr = new cn,
			Hr = { bind: function() { this.attr = 3 === this.el.nodeType ? "data" : "textContent" }, update: function(t) { this.el[this.attr] = s(t) } },
			Ir = new k(1e3),
			Mr = new k(1e3),
			Wr = { efault: [0, "", ""], legend: [1, "<fieldset>", "</fieldset>"], tr: [2, "<table><tbody>", "</tbody></table>"], col: [2, "<table><tbody></tbody><colgroup>", "</colgroup></table>"] };
		Wr.td = Wr.th = [3, "<table><tbody><tr>", "</tr></tbody></table>"], Wr.option = Wr.optgroup = [1, '<select multiple="multiple">', "</select>"], Wr.thead = Wr.tbody = Wr.colgroup = Wr.caption = Wr.tfoot = [1, "<table>", "</table>"], Wr.g = Wr.defs = Wr.symbol = Wr.use = Wr.image = Wr.text = Wr.circle = Wr.ellipse = Wr.line = Wr.path = Wr.polygon = Wr.polyline = Wr.rect = [1, '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ev="http://www.w3.org/2001/xml-events"version="1.1">', "</svg>"];
		var Vr = /<([\w:-]+)/,
			Br = /&#?\w+?;/,
			zr = /<!--/,
			Ur = function() { if(Gi) { var t = document.createElement("div"); return t.innerHTML = "<template>1</template>", !t.cloneNode(!0).firstChild.innerHTML } return !1 }(),
			Jr = function() { if(Gi) { var t = document.createElement("textarea"); return t.placeholder = "t", "t" === t.cloneNode(!0).value } return !1 }(),
			qr = Object.freeze({ cloneNode: le, parseTemplate: ce }),
			Qr = { bind: function() { 8 === this.el.nodeType && (this.nodes = [], this.anchor = mt("v-html"), st(this.el, this.anchor)) }, update: function(t) { t = s(t), this.nodes ? this.swap(t) : this.el.innerHTML = t }, swap: function(t) { for(var e = this.nodes.length; e--;) nt(this.nodes[e]); var i = ce(t, !0, !0);
					this.nodes = d(i.childNodes), et(i, this.anchor) } };
		ue.prototype.callHook = function(t) { var e, i; for(e = 0, i = this.childFrags.length; e < i; e++) this.childFrags[e].callHook(t); for(e = 0, i = this.children.length; e < i; e++) t(this.children[e]) }, ue.prototype.beforeRemove = function() { var t, e; for(t = 0, e = this.childFrags.length; t < e; t++) this.childFrags[t].beforeRemove(!1); for(t = 0, e = this.children.length; t < e; t++) this.children[t].$destroy(!1, !0); var i = this.unlink.dirs; for(t = 0, e = i.length; t < e; t++) i[t]._watcher && i[t]._watcher.teardown() }, ue.prototype.destroy = function() { this.parentFrag && this.parentFrag.childFrags.$remove(this), this.node.__v_frag = null, this.unlink() };
		var Gr = new k(5e3);
		_e.prototype.create = function(t, e, i) { var n = le(this.template); return new ue(this.linker, this.vm, n, t, e, i) };
		var Zr = 700,
			Xr = 800,
			Yr = 850,
			Kr = 1100,
			ts = 1500,
			es = 1500,
			is = 1750,
			ns = 2100,
			rs = 2200,
			ss = 2300,
			os = 0,
			as = { priority: rs, terminal: !0, params: ["track-by", "stagger", "enter-stagger", "leave-stagger"], bind: function() { var t = this.expression.match(/(.*) (?:in|of) (.*)/); if(t) { var e = t[1].match(/\((.*),(.*)\)/);
						e ? (this.iterator = e[1].trim(), this.alias = e[2].trim()) : this.alias = t[1].trim(), this.expression = t[2] } if(this.alias) { this.id = "__v-for__" + ++os; var i = this.el.tagName;
						this.isOption = ("OPTION" === i || "OPTGROUP" === i) && "SELECT" === this.el.parentNode.tagName, this.start = mt("v-for-start"), this.end = mt("v-for-end"), st(this.el, this.end), et(this.start, this.end), this.cache = Object.create(null), this.factory = new _e(this.vm, this.el) } }, update: function(t) { this.diff(t), this.updateRef(), this.updateModel() }, diff: function(t) { var e, n, r, s, o, a, h = t[0],
						l = this.fromObject = m(h) && i(h, "$key") && i(h, "$value"),
						c = this.params.trackBy,
						u = this.frags,
						f = this.frags = new Array(t.length),
						p = this.alias,
						d = this.iterator,
						v = this.start,
						g = this.end,
						_ = X(v),
						y = !u; for(e = 0, n = t.length; e < n; e++) h = t[e], s = l ? h.$key : null, o = l ? h.$value : h, a = !m(o), r = !y && this.getCachedFrag(o, e, s), r ? (r.reused = !0, r.scope.$index = e, s && (r.scope.$key = s), d && (r.scope[d] = null !== s ? s : e), (c || l || a) && St(function() { r.scope[p] = o })) : (r = this.create(o, p, e, s), r.fresh = !y), f[e] = r, y && r.before(g); if(!y) { var b = 0,
							w = u.length - f.length; for(this.vm._vForRemoving = !0, e = 0, n = u.length; e < n; e++) r = u[e], r.reused || (this.deleteCachedFrag(r), this.remove(r, b++, w, _));
						this.vm._vForRemoving = !1, b && (this.vm._watchers = this.vm._watchers.filter(function(t) { return t.active })); var C, $, k, x = 0; for(e = 0, n = f.length; e < n; e++) r = f[e], C = f[e - 1], $ = C ? C.staggerCb ? C.staggerAnchor : C.end || C.node : v, r.reused && !r.staggerCb ? (k = ye(r, v, this.id), k === C || k && ye(k, v, this.id) === C || this.move(r, $)) : this.insert(r, x++, $, _), r.reused = r.fresh = !1 } }, create: function(t, e, i, n) { var r = this._host,
						s = this._scope || this.vm,
						o = Object.create(s);
					o.$refs = Object.create(s.$refs), o.$els = Object.create(s.$els), o.$parent = s, o.$forContext = this, St(function() { Lt(o, e, t) }), Lt(o, "$index", i), n ? Lt(o, "$key", n) : o.$key && _(o, "$key", null), this.iterator && Lt(o, this.iterator, null !== n ? n : i); var a = this.factory.create(r, o, this._frag); return a.forId = this.id, this.cacheFrag(t, a, i, n), a }, updateRef: function() { var t = this.descriptor.ref; if(t) { var e, i = (this._scope || this.vm).$refs;
						this.fromObject ? (e = {}, this.frags.forEach(function(t) { e[t.scope.$key] = Ce(t) })) : e = this.frags.map(Ce), i[t] = e } }, updateModel: function() { if(this.isOption) { var t = this.start.parentNode,
							e = t && t.__v_model;
						e && e.forceUpdate() } }, insert: function(t, e, i, n) { t.staggerCb && (t.staggerCb.cancel(), t.staggerCb = null); var r = this.getStagger(t, e, null, "enter"); if(n && r) { var s = t.staggerAnchor;
						s || (s = t.staggerAnchor = mt("stagger-anchor"), s.__v_frag = t), it(s, i); var o = t.staggerCb = w(function() { t.staggerCb = null, t.before(s), nt(s) });
						setTimeout(o, r) } else { var a = i.nextSibling;
						a || (it(this.end, i), a = this.end), t.before(a) } }, remove: function(t, e, i, n) { if(t.staggerCb) return t.staggerCb.cancel(), void(t.staggerCb = null); var r = this.getStagger(t, e, i, "leave"); if(n && r) { var s = t.staggerCb = w(function() { t.staggerCb = null, t.remove() });
						setTimeout(s, r) } else t.remove() }, move: function(t, e) { e.nextSibling || this.end.parentNode.appendChild(this.end), t.before(e.nextSibling, !1) }, cacheFrag: function(t, e, n, r) { var s, o = this.params.trackBy,
						a = this.cache,
						h = !m(t);
					r || o || h ? (s = we(n, r, t, o), a[s] || (a[s] = e)) : (s = this.id, i(t, s) ? null === t[s] && (t[s] = e) : Object.isExtensible(t) && _(t, s, e)), e.raw = t }, getCachedFrag: function(t, e, i) { var n, r = this.params.trackBy,
						s = !m(t); if(i || r || s) { var o = we(e, i, t, r);
						n = this.cache[o] } else n = t[this.id]; return n && (n.reused || n.fresh), n }, deleteCachedFrag: function(t) { var e = t.raw,
						n = this.params.trackBy,
						r = t.scope,
						s = r.$index,
						o = i(r, "$key") && r.$key,
						a = !m(e); if(n || o || a) { var h = we(s, o, e, n);
						this.cache[h] = null } else e[this.id] = null, t.raw = null }, getStagger: function(t, e, i, n) { n += "Stagger"; var r = t.node.__v_trans,
						s = r && r.hooks,
						o = s && (s[n] || s.stagger); return o ? o.call(t, e, i) : e * parseInt(this.params[n] || this.params.stagger, 10) }, _preProcess: function(t) { return this.rawValue = t, t }, _postProcess: function(t) { if(qi(t)) return t; if(g(t)) { for(var e, i = Object.keys(t), n = i.length, r = new Array(n); n--;) e = i[n], r[n] = { $key: e, $value: t[e] }; return r } return "number" != typeof t || isNaN(t) || (t = be(t)), t || [] }, unbind: function() { if(this.descriptor.ref && ((this._scope || this.vm).$refs[this.descriptor.ref] = null), this.frags)
						for(var t, e = this.frags.length; e--;) t = this.frags[e], this.deleteCachedFrag(t), t.destroy() } },
			hs = { priority: ns, terminal: !0, bind: function() { var t = this.el; if(t.__vue__) this.invalid = !0;
					else { var e = t.nextElementSibling;
						e && null !== Y(e, "v-else") && (nt(e), this.elseEl = e), this.anchor = mt("v-if"), st(t, this.anchor) } }, update: function(t) { this.invalid || (t ? this.frag || this.insert() : this.remove()) }, insert: function() { this.elseFrag && (this.elseFrag.remove(), this.elseFrag = null), this.factory || (this.factory = new _e(this.vm, this.el)), this.frag = this.factory.create(this._host, this._scope, this._frag), this.frag.before(this.anchor) }, remove: function() { this.frag && (this.frag.remove(), this.frag = null), this.elseEl && !this.elseFrag && (this.elseFactory || (this.elseFactory = new _e(this.elseEl._context || this.vm, this.elseEl)), this.elseFrag = this.elseFactory.create(this._host, this._scope, this._frag), this.elseFrag.before(this.anchor)) }, unbind: function() { this.frag && this.frag.destroy(), this.elseFrag && this.elseFrag.destroy() } },
			ls = { bind: function() { var t = this.el.nextElementSibling;
					t && null !== Y(t, "v-else") && (this.elseEl = t) }, update: function(t) { this.apply(this.el, t), this.elseEl && this.apply(this.elseEl, !t) }, apply: function(t, e) {
					function i() { t.style.display = e ? "" : "none" } X(t) ? G(t, e ? 1 : -1, i, this.vm) : i() } },
			cs = { bind: function() { var t = this,
						e = this.el,
						i = "range" === e.type,
						n = this.params.lazy,
						r = this.params.number,
						s = this.params.debounce,
						a = !1; if(tn || i || (this.on("compositionstart", function() { a = !0 }), this.on("compositionend", function() { a = !1, n || t.listener() })), this.focused = !1, i || n || (this.on("focus", function() { t.focused = !0 }), this.on("blur", function() { t.focused = !1, t._frag && !t._frag.inserted || t.rawListener() })), this.listener = this.rawListener = function() { if(!a && t._bound) { var n = r || i ? o(e.value) : e.value;
								t.set(n), ln(function() { t._bound && !t.focused && t.update(t._watcher.value) }) } }, s && (this.listener = y(this.listener, s)), this.hasjQuery = "function" == typeof jQuery, this.hasjQuery) { var h = jQuery.fn.on ? "on" : "bind";
						jQuery(e)[h]("change", this.rawListener), n || jQuery(e)[h]("input", this.listener) } else this.on("change", this.rawListener), n || this.on("input", this.listener);!n && Ki && (this.on("cut", function() { ln(t.listener) }), this.on("keyup", function(e) { 46 !== e.keyCode && 8 !== e.keyCode || t.listener() })), (e.hasAttribute("value") || "TEXTAREA" === e.tagName && e.value.trim()) && (this.afterBind = this.listener) }, update: function(t) { t = s(t), t !== this.el.value && (this.el.value = t) }, unbind: function() { var t = this.el; if(this.hasjQuery) { var e = jQuery.fn.off ? "off" : "unbind";
						jQuery(t)[e]("change", this.listener), jQuery(t)[e]("input", this.listener) } } },
			us = { bind: function() { var t = this,
						e = this.el;
					this.getValue = function() { if(e.hasOwnProperty("_value")) return e._value; var i = e.value; return t.params.number && (i = o(i)), i }, this.listener = function() { t.set(t.getValue()) }, this.on("change", this.listener), e.hasAttribute("checked") && (this.afterBind = this.listener) }, update: function(t) { this.el.checked = C(t, this.getValue()) } },
			fs = { bind: function() { var t = this,
						e = this,
						i = this.el;
					this.forceUpdate = function() { e._watcher && e.update(e._watcher.get()) }; var n = this.multiple = i.hasAttribute("multiple");
					this.listener = function() { var t = $e(i, n);
						t = e.params.number ? qi(t) ? t.map(o) : o(t) : t, e.set(t) }, this.on("change", this.listener); var r = $e(i, n, !0);
					(n && r.length || !n && null !== r) && (this.afterBind = this.listener), this.vm.$on("hook:attached", function() { ln(t.forceUpdate) }), X(i) || ln(this.forceUpdate) }, update: function(t) { var e = this.el;
					e.selectedIndex = -1; for(var i, n, r = this.multiple && qi(t), s = e.options, o = s.length; o--;) i = s[o], n = i.hasOwnProperty("_value") ? i._value : i.value, i.selected = r ? ke(t, n) > -1 : C(t, n) }, unbind: function() { this.vm.$off("hook:attached", this.forceUpdate) } },
			ps = { bind: function() {
					function t() { var t = i.checked; return t && i.hasOwnProperty("_trueValue") ? i._trueValue : !t && i.hasOwnProperty("_falseValue") ? i._falseValue : t } var e = this,
						i = this.el;
					this.getValue = function() { return i.hasOwnProperty("_value") ? i._value : e.params.number ? o(i.value) : i.value }, this.listener = function() { var n = e._watcher.get(); if(qi(n)) { var r = e.getValue(),
								s = b(n, r);
							i.checked ? s < 0 && e.set(n.concat(r)) : s > -1 && e.set(n.slice(0, s).concat(n.slice(s + 1))) } else e.set(t()) }, this.on("change", this.listener), i.hasAttribute("checked") && (this.afterBind = this.listener) }, update: function(t) { var e = this.el;
					qi(t) ? e.checked = b(t, this.getValue()) > -1 : e.hasOwnProperty("_trueValue") ? e.checked = C(t, e._trueValue) : e.checked = !!t } },
			ds = { text: cs, radio: us, select: fs, checkbox: ps },
			vs = { priority: Xr, twoWay: !0, handlers: ds, params: ["lazy", "number", "debounce"], bind: function() { this.checkFilters(), this.hasRead && !this.hasWrite; var t, e = this.el,
						i = e.tagName; if("INPUT" === i) t = ds[e.type] || ds.text;
					else if("SELECT" === i) t = ds.select;
					else { if("TEXTAREA" !== i) return;
						t = ds.text } e.__v_model = this, t.bind.call(this), this.update = t.update, this._unbind = t.unbind }, checkFilters: function() { var t = this.filters; if(t)
						for(var e = t.length; e--;) { var i = jt(this.vm.$options, "filters", t[e].name);
							("function" == typeof i || i.read) && (this.hasRead = !0), i.write && (this.hasWrite = !0) } }, unbind: function() { this.el.__v_model = null, this._unbind && this._unbind() } },
			ms = { esc: 27, tab: 9, enter: 13, space: 32, delete: [8, 46], up: 38, left: 37, right: 39, down: 40 },
			gs = { priority: Zr, acceptStatement: !0, keyCodes: ms, bind: function() { if("IFRAME" === this.el.tagName && "load" !== this.arg) { var t = this;
						this.iframeBind = function() { ot(t.el.contentWindow, t.arg, t.handler, t.modifiers.capture) }, this.on("load", this.iframeBind) } }, update: function(t) { if(this.descriptor.raw || (t = function() {}), "function" == typeof t) { this.modifiers.stop && (t = Ae(t)), this.modifiers.prevent && (t = Oe(t)), this.modifiers.self && (t = Te(t)); var e = Object.keys(this.modifiers).filter(function(t) { return "stop" !== t && "prevent" !== t && "self" !== t && "capture" !== t });
						e.length && (t = xe(t, e)), this.reset(), this.handler = t, this.iframeBind ? this.iframeBind() : ot(this.el, this.arg, this.handler, this.modifiers.capture) } }, reset: function() { var t = this.iframeBind ? this.el.contentWindow : this.el;
					this.handler && at(t, this.arg, this.handler) }, unbind: function() { this.reset() } },
			_s = ["-webkit-", "-moz-", "-ms-"],
			ys = ["Webkit", "Moz", "ms"],
			bs = /!important;?$/,
			ws = Object.create(null),
			Cs = null,
			$s = {
				deep: !0,
				update: function(t) { "string" == typeof t ? this.el.style.cssText = t : qi(t) ? this.handleObject(t.reduce(v, {})) : this.handleObject(t || {}) },
				handleObject: function(t) { var e, i, n = this.cache || (this.cache = {}); for(e in n) e in t || (this.handleSingle(e, null), delete n[e]); for(e in t) i = t[e], i !== n[e] && (n[e] = i, this.handleSingle(e, i)) },
				handleSingle: function(t, e) {
					if(t = Ne(t))
						if(null != e && (e += ""), e) {
							var i = bs.test(e) ? "important" : "";
							i ? (e = e.replace(bs, "").trim(), this.el.style.setProperty(t.kebab, e, i)) : this.el.style[t.camel] = e;
						} else this.el.style[t.camel] = ""
				}
			},
			ks = "http://www.w3.org/1999/xlink",
			xs = /^xlink:/,
			As = /^v-|^:|^@|^(?:is|transition|transition-mode|debounce|track-by|stagger|enter-stagger|leave-stagger)$/,
			Os = /^(?:value|checked|selected|muted)$/,
			Ts = /^(?:draggable|contenteditable|spellcheck)$/,
			Ns = { value: "_value", "true-value": "_trueValue", "false-value": "_falseValue" },
			js = { priority: Yr, bind: function() { var t = this.arg,
						e = this.el.tagName;
					t || (this.deep = !0); var i = this.descriptor,
						n = i.interp;
					n && (i.hasOneTime && (this.expression = B(n, this._scope || this.vm)), (As.test(t) || "name" === t && ("PARTIAL" === e || "SLOT" === e)) && (this.el.removeAttribute(t), this.invalid = !0)) }, update: function(t) { if(!this.invalid) { var e = this.arg;
						this.arg ? this.handleSingle(e, t) : this.handleObject(t || {}) } }, handleObject: $s.handleObject, handleSingle: function(t, e) { var i = this.el,
						n = this.descriptor.interp; if(this.modifiers.camel && (t = l(t)), !n && Os.test(t) && t in i) { var r = "value" === t && null == e ? "" : e;
						i[t] !== r && (i[t] = r) } var s = Ns[t]; if(!n && s) { i[s] = e; var o = i.__v_model;
						o && o.listener() } return "value" === t && "TEXTAREA" === i.tagName ? void i.removeAttribute(t) : void(Ts.test(t) ? i.setAttribute(t, e ? "true" : "false") : null != e && e !== !1 ? "class" === t ? (i.__v_trans && (e += " " + i.__v_trans.id + "-transition"), lt(i, e)) : xs.test(t) ? i.setAttributeNS(ks, t, e === !0 ? "" : e) : i.setAttribute(t, e === !0 ? "" : e) : i.removeAttribute(t)) } },
			Es = { priority: ts, bind: function() { if(this.arg) { var t = this.id = l(this.arg),
							e = (this._scope || this.vm).$els;
						i(e, t) ? e[t] = this.el : Lt(e, t, this.el) } }, unbind: function() { var t = (this._scope || this.vm).$els;
					t[this.id] === this.el && (t[this.id] = null) } },
			Ss = { bind: function() {} },
			Fs = { bind: function() { var t = this.el;
					this.vm.$once("pre-hook:compiled", function() { t.removeAttribute("v-cloak") }) } },
			Ds = { text: Hr, html: Qr, for: as, if: hs, show: ls, model: vs, on: gs, bind: js, el: Es, ref: Ss, cloak: Fs },
			Ps = { deep: !0, update: function(t) { t ? "string" == typeof t ? this.setClass(t.trim().split(/\s+/)) : this.setClass(Ee(t)) : this.cleanup() }, setClass: function(t) { this.cleanup(t); for(var e = 0, i = t.length; e < i; e++) { var n = t[e];
						n && Se(this.el, n, ct) } this.prevKeys = t }, cleanup: function(t) { var e = this.prevKeys; if(e)
						for(var i = e.length; i--;) { var n = e[i];
							(!t || t.indexOf(n) < 0) && Se(this.el, n, ut) } } },
			Rs = { priority: es, params: ["keep-alive", "transition-mode", "inline-template"], bind: function() { this.el.__vue__ || (this.keepAlive = this.params.keepAlive, this.keepAlive && (this.cache = {}), this.params.inlineTemplate && (this.inlineTemplate = ft(this.el, !0)), this.pendingComponentCb = this.Component = null, this.pendingRemovals = 0, this.pendingRemovalCb = null, this.anchor = mt("v-component"), st(this.el, this.anchor), this.el.removeAttribute("is"), this.el.removeAttribute(":is"), this.descriptor.ref && this.el.removeAttribute("v-ref:" + u(this.descriptor.ref)), this.literal && this.setComponent(this.expression)) }, update: function(t) { this.literal || this.setComponent(t) }, setComponent: function(t, e) { if(this.invalidatePending(), t) { var i = this;
						this.resolveComponent(t, function() { i.mountComponent(e) }) } else this.unbuild(!0), this.remove(this.childVM, e), this.childVM = null }, resolveComponent: function(t, e) { var i = this;
					this.pendingComponentCb = w(function(n) { i.ComponentName = n.options.name || ("string" == typeof t ? t : null), i.Component = n, e() }), this.vm._resolveComponent(t, this.pendingComponentCb) }, mountComponent: function(t) { this.unbuild(!0); var e = this,
						i = this.Component.options.activate,
						n = this.getCached(),
						r = this.build();
					i && !n ? (this.waitingFor = r, Fe(i, r, function() { e.waitingFor === r && (e.waitingFor = null, e.transition(r, t)) })) : (n && r._updateRef(), this.transition(r, t)) }, invalidatePending: function() { this.pendingComponentCb && (this.pendingComponentCb.cancel(), this.pendingComponentCb = null) }, build: function(t) { var e = this.getCached(); if(e) return e; if(this.Component) { var i = { name: this.ComponentName, el: le(this.el), template: this.inlineTemplate, parent: this._host || this.vm, _linkerCachable: !this.inlineTemplate, _ref: this.descriptor.ref, _asComponent: !0, _isRouterView: this._isRouterView, _context: this.vm, _scope: this._scope, _frag: this._frag };
						t && v(i, t); var n = new this.Component(i); return this.keepAlive && (this.cache[this.Component.cid] = n), n } }, getCached: function() { return this.keepAlive && this.cache[this.Component.cid] }, unbuild: function(t) { this.waitingFor && (this.keepAlive || this.waitingFor.$destroy(), this.waitingFor = null); var e = this.childVM; return !e || this.keepAlive ? void(e && (e._inactive = !0, e._updateRef(!0))) : void e.$destroy(!1, t) }, remove: function(t, e) { var i = this.keepAlive; if(t) { this.pendingRemovals++, this.pendingRemovalCb = e; var n = this;
						t.$remove(function() { n.pendingRemovals--, i || t._cleanup(), !n.pendingRemovals && n.pendingRemovalCb && (n.pendingRemovalCb(), n.pendingRemovalCb = null) }) } else e && e() }, transition: function(t, e) { var i = this,
						n = this.childVM; switch(n && (n._inactive = !0), t._inactive = !1, this.childVM = t, i.params.transitionMode) {
						case "in-out":
							t.$before(i.anchor, function() { i.remove(n, e) }); break;
						case "out-in":
							i.remove(n, function() { t.$before(i.anchor, e) }); break;
						default:
							i.remove(n), t.$before(i.anchor, e) } }, unbind: function() { if(this.invalidatePending(), this.unbuild(), this.cache) { for(var t in this.cache) this.cache[t].$destroy();
						this.cache = null } } },
			Ls = Mn._propBindingModes,
			Hs = {},
			Is = /^[$_a-zA-Z]+[\w$]*$/,
			Ms = Mn._propBindingModes,
			Ws = { bind: function() { var t = this.vm,
						e = t._context,
						i = this.descriptor.prop,
						n = i.path,
						r = i.parentPath,
						s = i.mode === Ms.TWO_WAY,
						o = this.parentWatcher = new re(e, r, function(e) { He(t, i, e) }, { twoWay: s, filters: i.filters, scope: this._scope }); if(Le(t, i, o.value), s) { var a = this;
						t.$once("pre-hook:created", function() { a.childWatcher = new re(t, n, function(t) { o.set(t) }, { sync: !0 }) }) } }, unbind: function() { this.parentWatcher.teardown(), this.childWatcher && this.childWatcher.teardown() } },
			Vs = [],
			Bs = !1,
			zs = "transition",
			Us = "animation",
			Js = nn + "Duration",
			qs = sn + "Duration",
			Qs = Gi && window.requestAnimationFrame,
			Gs = Qs ? function(t) { Qs(function() { Qs(t) }) } : function(t) { setTimeout(t, 50) },
			Zs = Ue.prototype;
		Zs.enter = function(t, e) { this.cancelPending(), this.callHook("beforeEnter"), this.cb = e, ct(this.el, this.enterClass), t(), this.entered = !1, this.callHookWithCb("enter"), this.entered || (this.cancel = this.hooks && this.hooks.enterCancelled, Be(this.enterNextTick)) }, Zs.enterNextTick = function() { var t = this;
			this.justEntered = !0, Gs(function() { t.justEntered = !1 }); var e = this.enterDone,
				i = this.getCssTransitionType(this.enterClass);
			this.pendingJsCb ? i === zs && ut(this.el, this.enterClass) : i === zs ? (ut(this.el, this.enterClass), this.setupCssCb(rn, e)) : i === Us ? this.setupCssCb(on, e) : e() }, Zs.enterDone = function() { this.entered = !0, this.cancel = this.pendingJsCb = null, ut(this.el, this.enterClass), this.callHook("afterEnter"), this.cb && this.cb() }, Zs.leave = function(t, e) { this.cancelPending(), this.callHook("beforeLeave"), this.op = t, this.cb = e, ct(this.el, this.leaveClass), this.left = !1, this.callHookWithCb("leave"), this.left || (this.cancel = this.hooks && this.hooks.leaveCancelled, this.op && !this.pendingJsCb && (this.justEntered ? this.leaveDone() : Be(this.leaveNextTick))) }, Zs.leaveNextTick = function() { var t = this.getCssTransitionType(this.leaveClass); if(t) { var e = t === zs ? rn : on;
				this.setupCssCb(e, this.leaveDone) } else this.leaveDone() }, Zs.leaveDone = function() { this.left = !0, this.cancel = this.pendingJsCb = null, this.op(), ut(this.el, this.leaveClass), this.callHook("afterLeave"), this.cb && this.cb(), this.op = null }, Zs.cancelPending = function() { this.op = this.cb = null; var t = !1;
			this.pendingCssCb && (t = !0, at(this.el, this.pendingCssEvent, this.pendingCssCb), this.pendingCssEvent = this.pendingCssCb = null), this.pendingJsCb && (t = !0, this.pendingJsCb.cancel(), this.pendingJsCb = null), t && (ut(this.el, this.enterClass), ut(this.el, this.leaveClass)), this.cancel && (this.cancel.call(this.vm, this.el), this.cancel = null) }, Zs.callHook = function(t) { this.hooks && this.hooks[t] && this.hooks[t].call(this.vm, this.el) }, Zs.callHookWithCb = function(t) { var e = this.hooks && this.hooks[t];
			e && (e.length > 1 && (this.pendingJsCb = w(this[t + "Done"])), e.call(this.vm, this.el, this.pendingJsCb)) }, Zs.getCssTransitionType = function(t) { if(!(!rn || document.hidden || this.hooks && this.hooks.css === !1 || Je(this.el))) { var e = this.type || this.typeCache[t]; if(e) return e; var i = this.el.style,
					n = window.getComputedStyle(this.el),
					r = i[Js] || n[Js]; if(r && "0s" !== r) e = zs;
				else { var s = i[qs] || n[qs];
					s && "0s" !== s && (e = Us) } return e && (this.typeCache[t] = e), e } }, Zs.setupCssCb = function(t, e) { this.pendingCssEvent = t; var i = this,
				n = this.el,
				r = this.pendingCssCb = function(s) { s.target === n && (at(n, t, r), i.pendingCssEvent = i.pendingCssCb = null, !i.pendingJsCb && e && e()) };
			ot(n, t, r) };
		var Xs = { priority: Kr, update: function(t, e) { var i = this.el,
						n = jt(this.vm.$options, "transitions", t);
					t = t || "v", e = e || "v", i.__v_trans = new Ue(i, t, n, this.vm), ut(i, e + "-transition"), ct(i, t + "-transition") } },
			Ys = { style: $s, class: Ps, component: Rs, prop: Ws, transition: Xs },
			Ks = /^v-bind:|^:/,
			to = /^v-on:|^@/,
			eo = /^v-([^:]+)(?:$|:(.*)$)/,
			io = /\.[^\.]+/g,
			no = /^(v-bind:|:)?transition$/,
			ro = 1e3,
			so = 2e3;
		ui.terminal = !0;
		var oo = /[^\w\-:\.]/,
			ao = Object.freeze({ compile: qe, compileAndLinkProps: Ye, compileRoot: Ke, transclude: _i, resolveSlots: Ci }),
			ho = /^v-on:|^@/;
		Oi.prototype._bind = function() { var t = this.name,
				e = this.descriptor; if(("cloak" !== t || this.vm._isCompiled) && this.el && this.el.removeAttribute) { var i = e.attr || "v-" + t;
				this.el.removeAttribute(i) } var n = e.def; if("function" == typeof n ? this.update = n : v(this, n), this._setupParams(), this.bind && this.bind(), this._bound = !0, this.literal) this.update && this.update(e.raw);
			else if((this.expression || this.modifiers) && (this.update || this.twoWay) && !this._checkStatement()) { var r = this;
				this.update ? this._update = function(t, e) { r._locked || r.update(t, e) } : this._update = Ai; var s = this._preProcess ? p(this._preProcess, this) : null,
					o = this._postProcess ? p(this._postProcess, this) : null,
					a = this._watcher = new re(this.vm, this.expression, this._update, { filters: this.filters, twoWay: this.twoWay, deep: this.deep, preProcess: s, postProcess: o, scope: this._scope });
				this.afterBind ? this.afterBind() : this.update && this.update(a.value) } }, Oi.prototype._setupParams = function() { if(this.params) { var t = this.params;
				this.params = Object.create(null); for(var e, i, n, r = t.length; r--;) e = u(t[r]), n = l(e), i = K(this.el, e), null != i ? this._setupParamWatcher(n, i) : (i = Y(this.el, e), null != i && (this.params[n] = "" === i || i)) } }, Oi.prototype._setupParamWatcher = function(t, e) { var i = this,
				n = !1,
				r = (this._scope || this.vm).$watch(e, function(e, r) { if(i.params[t] = e, n) { var s = i.paramWatchers && i.paramWatchers[t];
						s && s.call(i, e, r) } else n = !0 }, { immediate: !0, user: !1 });
			(this._paramUnwatchFns || (this._paramUnwatchFns = [])).push(r) }, Oi.prototype._checkStatement = function() { var t = this.expression; if(t && this.acceptStatement && !Kt(t)) { var e = Yt(t).get,
					i = this._scope || this.vm,
					n = function(t) { i.$event = t, e.call(i, i), i.$event = null }; return this.filters && (n = i._applyFilters(n, null, this.filters)), this.update(n), !0 } }, Oi.prototype.set = function(t) { this.twoWay && this._withLock(function() { this._watcher.set(t) }) }, Oi.prototype._withLock = function(t) { var e = this;
			e._locked = !0, t.call(e), ln(function() { e._locked = !1 }) }, Oi.prototype.on = function(t, e, i) { ot(this.el, t, e, i), (this._listeners || (this._listeners = [])).push([t, e]) }, Oi.prototype._teardown = function() { if(this._bound) { this._bound = !1, this.unbind && this.unbind(), this._watcher && this._watcher.teardown(); var t, e = this._listeners; if(e)
					for(t = e.length; t--;) at(this.el, e[t][0], e[t][1]); var i = this._paramUnwatchFns; if(i)
					for(t = i.length; t--;) i[t]();
				this.vm = this.el = this._watcher = this._listeners = null } };
		var lo = /[^|]\|[^|]/;
		Ht(Di), ki(Di), xi(Di), Ti(Di), Ni(Di), ji(Di), Ei(Di), Si(Di), Fi(Di);
		var co = { priority: ss, params: ["name"], bind: function() { var t = this.params.name || "default",
						e = this.vm._slotContents && this.vm._slotContents[t];
					e && e.hasChildNodes() ? this.compile(e.cloneNode(!0), this.vm._context, this.vm) : this.fallback() }, compile: function(t, e, i) { if(t && e) { if(this.el.hasChildNodes() && 1 === t.childNodes.length && 1 === t.childNodes[0].nodeType && t.childNodes[0].hasAttribute("v-if")) { var n = document.createElement("template");
							n.setAttribute("v-else", ""), n.innerHTML = this.el.innerHTML, n._context = this.vm, t.appendChild(n) } var r = i ? i._scope : this._scope;
						this.unlink = e.$compile(t, i, r, this._frag) } t ? st(this.el, t) : nt(this.el) }, fallback: function() { this.compile(ft(this.el, !0), this.vm) }, unbind: function() { this.unlink && this.unlink() } },
			uo = { priority: is, params: ["name"], paramWatchers: { name: function(t) { hs.remove.call(this), t && this.insert(t) } }, bind: function() { this.anchor = mt("v-partial"), st(this.el, this.anchor), this.insert(this.params.name) }, insert: function(t) { var e = jt(this.vm.$options, "partials", t, !0);
					e && (this.factory = new _e(this.vm, e), hs.insert.call(this)) }, unbind: function() { this.frag && this.frag.destroy() } },
			fo = { slot: co, partial: uo },
			po = as._postProcess,
			vo = /(\d{3})(?=\d)/g,
			mo = { orderBy: Li, filterBy: Ri, limitBy: Pi, json: { read: function(t, e) { return "string" == typeof t ? t : JSON.stringify(t, null, arguments.length > 1 ? e : 2) }, write: function(t) { try { return JSON.parse(t) } catch(e) { return t } } }, capitalize: function(t) { return t || 0 === t ? (t = t.toString(), t.charAt(0).toUpperCase() + t.slice(1)) : "" }, uppercase: function(t) { return t || 0 === t ? t.toString().toUpperCase() : "" }, lowercase: function(t) { return t || 0 === t ? t.toString().toLowerCase() : "" }, currency: function(t, e, i) { if(t = parseFloat(t), !isFinite(t) || !t && 0 !== t) return "";
					e = null != e ? e : "$", i = null != i ? i : 2; var n = Math.abs(t).toFixed(i),
						r = i ? n.slice(0, -1 - i) : n,
						s = r.length % 3,
						o = s > 0 ? r.slice(0, s) + (r.length > 3 ? "," : "") : "",
						a = i ? n.slice(-1 - i) : "",
						h = t < 0 ? "-" : ""; return h + e + o + r.slice(s).replace(vo, "$1,") + a }, pluralize: function(t) { var e = d(arguments, 1),
						i = e.length; if(i > 1) { var n = t % 10 - 1; return n in e ? e[n] : e[i - 1] } return e[0] + (1 === t ? "" : "s") }, debounce: function(t, e) { if(t) return e || (e = 300), y(t, e) } };
		return Ii(Di), Di.version = "1.0.28", setTimeout(function() { Mn.devtools && Zi && Zi.emit("init", Di) }, 0), Di
	});
//# sourceMappingURL=vue.min.js.map