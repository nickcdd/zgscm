<!DOCTYPE html>
<html>
<head>
<#include "_head.ftl" />
    <title>正格集采平台</title>
</head>
<body class="hold-transition login-page">
<#include "_flash.ftl" />
<div class="login-box">
    <div class="login-logo">
        <b>正格集采平台<br />管理端</b>
    </div>
    <div class="login-box-body">
        <form action="/login" method="post" data-toggle="validator" role="form">
            <div class="form-group has-feedback">
                <input type="text" class="form-control" placeholder="用户名" name="username" required>
                <span class="glyphicon glyphicon-user form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input type="password" class="form-control" placeholder="密　码" name="password" required>
                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <div class="row">
                    <div class="col-xs-6">
                        <input type="text" class="form-control" placeholder="验证码" name="captcha" required>
                        <span class="form-control-feedback"></span>
                    </div>
                    <div class="col-xs-6">
                        <img src="/captcha" class="img-responsive" title="图形验证码" onclick="this.src='/captcha?rnd=' + Math.random();" style="cursor: pointer;" />
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <button type="submit" class="btn btn-primary btn-block btn-flat">登录</button>
                </div>
                <!-- /.col -->
            </div>
        </form>
    </div>
    <!-- /.login-box-body -->
</div>
<!-- /.login-box -->
</body>
</html>