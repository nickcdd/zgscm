<!DOCTYPE html>
<html>
<head>
<#include "_head.ftl" />
    <title>正格集采平台商户端</title>
    <style>
        body {
            background: #F6922F;
        }

        .box-login {
            background: url(/assets/img/login/login-bg-new.png) no-repeat bottom;
            background-size: contain;
            position: absolute;
            left: 15px;
            right: 15px;
            bottom: 0;
            top: 0;
        }
    </style>
    <script>
        $(function () {
            $('[name="captcha"]').focusin(function () {
//                var t = this;
//                setTimeout(function () {
//                    t.type = 'url';
//                }, 3000);
//                $(this).attr("type", "url");
//                $('#pTest').text(this.type);
            }).focusout(function () {
//                $(this).attr("type", "text");
//                $('#pTest').text(this.type);
            });
        });
    </script>
</head>

<body>
<#include "_flash.ftl" />

<div class="container-fluid">

    <div class="row box-login">
        <div class="col-xs-12" style="background: #FFFFFF; padding: 30px 30px 15px; margin-top: 50px;">
            <form action="/login" method="post" class="form-horizontal">

                <div class="form-group text-center" style="margin-top: -15px;">
                    <h3 style="color: #ef822c;">
                        <img width="48" style="margin-right: 20px; margin-top: -15px;" src="/assets/img/login/logo.png">正格集采平台商户端
                    </h3>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <span class="input-group-addon">
                             <span class="glyphicon glyphicon-user"></span>
                        </span>
                        <input type="tel" id="name" name="username" class="form-control input-lg" placeholder="用户名" value="${cookieUsername!''}" required>
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
                                <input type="text" name="captcha" class="form-control input-lg" placeholder="验证码" style="ime-mode: disabled;" maxlength="4" required>
                            </div>

                        </div>
                        <div class="col-xs-5">
                            <img src="/captcha" class="img-responsive" title="图形验证码" onclick="this.src='/captcha?rnd=' + Math.random();" style="cursor: pointer;" />
                            <p id="pTest"></p>
                        </div>
                    </div>

                </div>

                <div class="form-group">
                    <button class="btn btn-success btn-block btn-lg" type="submit">登录</button>
                </div>

            </form>
        </div>
    </div>

</div>
</body>
</html>
