<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
</head>
<body>
<div class="box box-primary" style="padding:0% 10% 10% 10%;">
    <div style="width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">添加银行卡</h3>
        </div>
        <form id="shopKeeperCardAddForm" action="/shopKeeperCard/save" method="post" role="form" data-toggle="validator">
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:10%">开户银行:</p>
                </div>
                <div class="col-xs-3">
                    <img src="/assets/img/bankImg/${bankCardName}.png" class="img-thumbnail" >
                </div>
                <input type="hidden" name="bankName" class="form-control" value="${bankCardName}"  />
            </div>
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:10%">储蓄卡卡号:</p>
                </div>
                <div class="col-xs-9">
                    <input onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')" type="text" name="cardNo" class="form-control"  required />
                </div>
            </div>
            <div class="row form-group">
                <div class="col-xs-12">
                    <button onclick="submitValidate()" type="button" class="btn btn-primary">确认</button>　　
                    <a href="javascript:history.go(-1)" class="btn btn-default">返回</a>
                </div>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
    function submitValidate() {
        var $form = $('#shopKeeperCardAddForm');
        $form.submit(function () {
            if ($form.valid()) {
                var data = $form.formJSON('get');
                if ($('#province option:selected').text() == "请选择") {
                    showInfoFun('请选择一个省。', 'warning');
                    return false;
                }
                if ($('#city option:selected').text() == "请选择") {
                    showInfoFun('请选择一个市。', 'warning');
                    return false;
                }
                if ($('#area option:selected').text() == "请选择") {
                    showInfoFun('请选择一个区。', 'warning');
                    return false;
                }
                $("#submitButton").attr("disabled",true);
            }
            return true;
        });
        $form.submit();
    }
</script>
</body>
</html>