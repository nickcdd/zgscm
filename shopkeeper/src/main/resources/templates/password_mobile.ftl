<!DOCTYPE html>
<html>
<head>
<#include "_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/password">
</head>
<body>

<div class="row">
    <div class="col-xs-12">
        <div class="box box-primary">
            <div class="box-header with-border">
                <div>
                    <div style="width: 85%;float: left;"><span>修改密码</span></div>
                    <div style="width: 15%;float: left;"><a href="javascript:history.go(-1)">返回</a></div>
                </div>
            </div>
            <div class="box-body">
                <div>
                    <form id="editPassword" action="/updatePassword" method="post" data-toggle="validator" role="form">
                        <div style="height: 50px;">
                            <div style="width: 32%;float: left;">
                                <p class="" style="margin-top:10%">输入原密码：</p>
                            </div>
                            <div style="width: 68%;float: left;">
                                <input type="password" id="oldPassword" name="oldPassword" class="form-control" />
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 32%;float: left;">
                                <p class="" style="margin-top:10%">输入新密码：</p>
                            </div>
                            <div style="width: 68%;float: left;">
                                <input type="password" id="newPassword1" name="newPassword1" class="form-control" />
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 32%;float: left;">
                                <p class="" style="margin-top:10%">确认新密码：</p>
                            </div>
                            <div style="width: 68%;float: left;">
                                <input type="password" id="newPassword2" name="newPassword2" class="form-control" />
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div>
                                <button id="validateButton" onclick="submitEditPassword()" type="button" class="btn btn-primary btn-block">
                                    确认
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>

    /**
     * 验证两次密码相同与否
     */
    function submitEditPassword() {
        var $form = $('#editPassword');
        $form.submit(function () {
            if ($form.valid()) {
                var data = $form.formJSON('get');

                if ($("#oldPassword").val() == '') {
                    showInfoFun('请输入原密码。', 'warning');
                    return false;
                }
                if ($("#newPassword1").val() == '') {
                    showInfoFun('请输入新密码。', 'warning');
                    return false;
                }
                if ($("#newPassword2").val() == '') {
                    showInfoFun('请输入确认密码。', 'warning');
                    return false;
                }
                if ($("#newPassword1").val() != $("#newPassword2").val()) {
                    showInfoFun('确认密码和新密码不一致。', 'warning');
                    $("#newPassword1").val("");
                    $("#newPassword2").val("");
                    return false;
                }
                $("#validateButton").attr("disabled", true);
            }
            return true;
        });
        $("#editPassword").submit();
    }
</script>
</body>
</html>