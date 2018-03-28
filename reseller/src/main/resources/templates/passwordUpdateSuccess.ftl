<!DOCTYPE html>
<html>
<meta http-equiv="refresh" content="3;url=/index"/>
<head>
<#include "_head_with_datepicker.ftl" />
</head>
<body>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">跳转提示</h3>
        </div>
        <div class="tab-pane active" id="peopleData_tab">
            <h4 class="text-success"><span class="glyphicon glyphicon-ok"></span>　
                密码修改成功，<span id="target">3</span>秒后跳转到登录页面</h4>
        </div>
    </div>
</div>
<script>

    $(function () {

        var c = 3;
        setInterval(function () {
            c--;
            $("#target").html(c);
            if (c == 0) {
                window.location.href = "/logout";
            }
        }, 1000);

    });
</script>
</body>
</html>