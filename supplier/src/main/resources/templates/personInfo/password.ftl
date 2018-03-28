<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
<#include "/_head_with_datepicker.ftl" />
    <script type="text/javascript">
        $(function () {
            jQuery.validator.addMethod("checkPassword", function(value, element) {
                var flag = 1;
                var sid=$('#sid').val();

                $.ajax({
                    type:"POST",
                    url:'/personInfo/checkPassword',
                    async:false,
                    data:{'oldPassword':value},
                    success: function(result){
                        if(result.success){
                            flag = 1;
                        }else{
                            flag = 0;
                        }
                    }
                });

                if(flag == 0){
                    return false;
                }else{
                    return true;
                }

            }, "原密码不正确");


            var $form = $('#detailForm');


            $form.submit(function () {
                if ($form.valid()) {


                }

                return true;
            });


//
//            $form.submit(function () {
//                alert($("#detailForm").formToArray());
////                if ($form.valid()) {
////                    var data = $form.formJSON('get');
////
////                    if (!data.sid && !data.password) {
////                        showInfoFun('创建管理员时密码不能为空。', 'warning');
////                        return false;
////                    }
////
////                    if ($('#tbody-roles :checkbox:checked').length === 0) {
////                        showInfoFun('请至少选择一个角色。', 'warning');
////                        return false;
////                    }
////
////                }
//
////                return true;
//
//            });

//            $form.clearForm(true);
        });
    </script>
</head>
<body>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">修改密码</h3>
        </div>
        <div class="tab-pane active" id="peopleData_tab">
            <form id="editPassword" action="updatePassword" method="post" data-toggle="validator" role="form">
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">输入原密码</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="password" id="oldPassword" name="oldPassword" checkPassword="true" placeholder="请输入6-16位密码" rangelength="[6,16]" class="form-control" required/>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">输入新密码</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="password" id="newPassword1" name="newPassword1" placeholder="请输入6-16位新密码" rangelength="[6,16]" class="form-control" required/>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">确认新密码</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="password" id="newPassword2" name="newPassword2" placeholder="确认新密码" rangelength="[6,16]" equalTo="#newPassword1" class="form-control" required/>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-12">
                        <button  type="submit" class="btn btn-primary">确认</button>
                        　　
                        <a href="javascript:history.go(-1)" class="btn btn-default">返回</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>