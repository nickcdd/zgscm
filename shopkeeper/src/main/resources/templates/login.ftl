<!DOCTYPE html>
<html>
<head>
<#include "_head.ftl" />
    <title>正格集采平台商户端</title>
    <script>
        $(function () {
            $('a[data-toggle="tab"]').on('show.bs.tab', function () {
                var href = $(this).attr('href');
                $(href).find('img').attr('src', '/captcha?rnd=' + Math.random());
            });
        });
    </script>
    <style>
        .box-login {
            background: url('/assets/img/login/login-bg-new.png') no-repeat #F6922F left;
            background-size: contain;
            min-height: 486px;
        }
    </style>

</head>

<body>
<#include "_flash.ftl" />

<div class="container-fluid">

    <div class="row" style="margin-top: 5%;">
        <div class="pull-right col-xs-1">&nbsp;</div>
        <div class="pull-right">
            <h1 style="color: #ef822c; font-size: 50px;">正格集采平台商户端</h1>
        </div>
        <div class="pull-right">
            <img src="/assets/img/login/logo.png">　
        </div>
    </div>

    <div class="row box-login" style="padding: 100px;">
        <div class="pull-right" style="margin-right: 100px;">
            <div style="width: 450px; padding: 30px; background: #ffffff;">
                <form action="/login" method="post" class="form-signin form-bg-ljq">
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon">
                                 <span class="glyphicon glyphicon-user"></span>
                            </span>
                            <input type="text" id="name" name="username" class="form-control input-lg" placeholder="用户名" value="${cookieUsername!''}" required autofocus>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword" class="sr-only">密码</label>
                        <div class="input-group">
                            <span class="input-group-addon">
                                 <span class="glyphicon glyphicon-lock"></span>
                            </span>
                            <input type="password" name="password" id="password" class="form-control input-lg" placeholder="密码" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword" class="sr-only">验证码</label>
                        <div class="row">

                            <div class="col-xs-7">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                         <span class="glyphicon glyphicon-barcode"></span>
                                    </span>
                                    <input type="text" name="captcha" class="form-control input-lg" placeholder="验证码" required>
                                </div>

                            </div>
                            <div class="col-xs-5">
                                <img src="/captcha" class="img-responsive" title="图形验证码" onclick="this.src='/captcha?rnd=' + Math.random();" style="cursor: pointer;" />
                            </div>
                        </div>

                    </div>
                    <button class="btn btn-success btn-block btn-lg" type="submit">登录</button>

                </form>

            </div>
        </div>
    </div>

</div>

<script>
    $(function () {
        jQuery.validator.addMethod("isMobile", function (value, element) {
            var length = value.length;
            var mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
            return this.optional(element) || (length == 11 && mobile.test(value));
        }, "请正确填写您的手机号码");
    })
    function SMS() {
        var telephone = $("#telephone").val();
        var captcha = $("#captcha").val();
        if (telephone == '' || telephone == undefined) {
            showInfoFun('请输入电话号码。', 'warning');
            return false;
        }
        if (captcha == '' || captcha == undefined) {
            showInfoFun('请输入验证码。', 'warning');
            return false;
        }
        $.ajax({
            type: "Get",
            dateType: "JSON",
            url: "/validate",
            contentType: "application/json; charset=utf-8",
            data: {
                "captcha": captcha,
                "telephone": telephone
            },
            success: function (result) {
                if (result.errCode != "" && result.errCode != null && result.errCode == -1) {
                    showInfoFun(result.msg, 'warning');
                } else {
                    smsCodeButtonUpdate();
                }
                if (result.record == 'error') {
                    showInfoFun('发送失败', 'warning');
                }
            },
            error: function () {
                alert("服务器繁忙");
            }
        });
    }
    function smsCodeButtonUpdate() {
        $("#smsCodeButton").attr("disabled", true);
        $("#smsCodeButton").html("59秒后重新发送");
        var c = 59;

        var test = setInterval(function () {
            c--;
            $("#smsCodeButton").html(c + "秒后重新发送");
            if (c == -1) {
                $("#smsCodeButton").html("获取验证码");
                $("#smsCodeButton").attr("disabled", false);
                clearInterval(test);
            }
        }, 1000);
    }

</script>
</body>
</html>