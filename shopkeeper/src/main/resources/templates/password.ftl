<!DOCTYPE html>
<html>
<head>
<#include "_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/password">
</head>
<body>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="min-width:600px;width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">修改密码</h3>
        </div>
        <div class="tab-pane active" id="peopleData_tab">
            <form id="editPassword" action="/updatePassword" method="post" data-toggle="validator" role="form">
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">输入原密码</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="password" id="oldPassword" name="oldPassword" class="form-control" required />
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">输入新密码</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="password" id="newPassword1" name="newPassword1" class="form-control" required />
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">确认新密码</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="password" id="newPassword2" name="newPassword2" class="form-control" required />
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-12">
                        <button id="validateButton" onclick="submitEditPassword()" type="button" class="btn btn-primary">
                            确认
                        </button>
                        　　
                        <a href="javascript:history.go(-1)" class="btn btn-default">返回</a>
                    </div>
                </div>
            </form>
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