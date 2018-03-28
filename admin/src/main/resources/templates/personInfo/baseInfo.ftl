<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
<#include "/_head_with_datepicker.ftl" />
    <script src="/assets/js/jquery.form.js"></script>
    <script type="text/javascript">
        $(function () {
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
            <h3 class="box-title">编辑个人资料</h3>
        </div>
        <div class="tab-pane active" id="peopleData_tab">

            <form id="detailForm" action="save" method="post" data-toggle="validator" role="form">
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="display: none;">管理员sid:</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="hidden" name="sid" class="form-control" value="${manager.sid?c}" />
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">用户名:</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="text" name="username" class="form-control" value="${manager.username!''}" required readonly/>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">姓名:</p>
                    </div>
                    <div class="col-xs-9">

                            <input type="text" name="cname" class="form-control" value="${manager.cname!''}" required />

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