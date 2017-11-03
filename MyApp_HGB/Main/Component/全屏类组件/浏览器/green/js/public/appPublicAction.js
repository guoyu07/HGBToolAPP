$(function () {
    /**
     * 根据os类型，动态加载相应的cordova版本
     */
    if ($.device.ios) {
        //$.alert('ios');
        $.getScript('js/libs/cordova_ios.js');
    } else if ($.device.android) {
        //$.alert('android');
        $.getScript('js/libs/cordova_android.js');
    }

    /**
     * 存放公用的表单验证字段判断条件
     */
    $.mvalidateExtend({
        name: {   //姓名
            required: true,      //是否必输项
            pattern: /^[\u4e00-\u9fa5]{2,}$/,		//校验规则 ：中文-2个以上汉字
            descriptions: {      //不满足校验条件的描述信息
                required: '请输入姓名',
                pattern: '姓名需两个以上汉字'
            }
        },
        username: {   //用户注册名或昵称校验
            required: true,      //是否必输项
            pattern: /^[a-zA-Z0-9_]{3,16}$/,	//校验规则 ：3个或以上字符
            descriptions: {      //不满足校验条件的描述信息
                required: '请输入用户名',
                pattern: '请输入3-16位的英文字符'
            }
        },
         number: {   //用户注册名或昵称校验
            required: true,      //是否必输项
            pattern: /^\d{6}$/,    //校验规则 ：3个或以上字符
            descriptions: {      //不满足校验条件的描述信息
                required: '请输入6位数字',
                pattern: '请输入6位数字'
            }
        },
        sex: {   //性别
            required: true,      //是否必输项
            descriptions: {      //不满足校验条件的描述信息
                required: '请选择性别'
            }
        },
        password: {
            required: true, //是否必输项
            pattern: /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$/, //校验规则 ：8到16位数字与字母组合
            descriptions: {//不满足校验条件的描述信息
                required: '请输入密码',
                pattern: '密码由8到16位数字与字母组合'
            }
        },
        confirmpassword: {//确认密码
            required: true, //是否必输项
            descriptions: {//不满足校验条件的描述信息
                required: '请再次输入密码',
                conditional: '两次密码不一样'
            }
        },
        mobile: {//手机
            required: true, //是否必输项
            pattern: /^0?1[3|4|5|8][0-9]\d{8}$/, //校验规则
            descriptions: {//不满足校验条件的描述信息
                required: '请输入手机号码',
                pattern: '您输入的手机号码格式不正确'
            }
        },
        phone: {//固定电话
            required: true, //是否必输项
            pattern: /^0?1[3|4|5|8][0-9]\d{8}$/, //校验规则
            descriptions: {//不满足校验条件的描述信息
                required: '请输入手机号码',
                pattern: '您输入的固定电话格式不正确'
            }
        },
        age: {//年龄
            required: true,
            pattern: /^(1[0-2]\d|[1-9]{1,2})$/,
            descriptions: {
                required: '请输入年龄',
                pattern: '请输入有效的年龄格式'
            }
        },
        email: {//邮箱
            required: true,
            pattern: /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/,
            descriptions: {
                required: '请输入Email地址',
                pattern: '您输入的邮箱格式不正确'
            }
        },
        idcard: {//身份证
            required: true,
            pattern: /^\d{15}|\d{18}$/,
            descriptions: {
                required: '请输入身份证信息',
                pattern: '您输入的身份证格式不正确'
            }
        },
        zipcode: {//邮编
            required: true,
            pattern: /^[\\d]{6}/,
            descriptions: {
                required: '请输入邮政编号',
                pattern: '您输入的邮编格式不正确'
            }
        },
        date: {//日期
            required: true,
            pattern: /^\d{4}-\d{2}-\d{2}$/,
            descriptions: {
                required: '请输入日期',
                pattern: '请输入有效的日期格式'
            }
        },
        currency: {//货币
            required: true,
            pattern: /^\d+(\.\d+)?$/,
            descriptions: {
                required: '请输入货币信息',
                pattern: '您输入的货币格式不正确'
            }
        },
        bankcard: { //银行卡号
            required: true, //是否必输项
            pattern: /^([1-9]{1})(\d{15}|\d{18})$/, //校验规则
            descriptions: {//不满足校验条件的描述信息
                required: '请输入银行卡号',
                pattern: '请输入16或19位的银行卡号'
            }
        },
        address: {//住址
            required: true, //是否必输项
            pattern: /([^\x00-\xff]|[A-Za-z0-9_])+/, //校验规则([^\x00-\xff]|[A-Za-z0-9_])+
            descriptions: {//不满足校验条件的描述信息
                required: '请输入居住地址',
                pattern: '请输入有效居住地址'
            }
        }
    })
});
