<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
</head>
<body>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">修改银行卡</h3>
        </div>
        <form id="shopKeeperCardUpdateForm" action="/shopKeeperCard/update" method="post" role="form" data-toggle="validator" onsubmit="return dosubmit()">
            <div >
                <input type="hidden" name="sid" class="form-control" value="${shopKeeperCard.sid?c}" />
            </div>
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:10%">开户银行:</p>
                </div>
                <div class="col-xs-3">
                    <a data-toggle="modal" data-target="#addBank_Modal"><img id="hedaImg" src="/assets/img/bankImg/${shopKeeperCard.bankName}.png" class="img-thumbnail" ></a>
                </div>
                <input type="hidden" id="bankName" name="bankName" value="${shopKeeperCard.bankName}" class="form-control"  />
            </div>
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:10%">储蓄卡卡号:</p>
                </div>
                <div class="col-xs-9">
                    <input onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')" type="text" name="cardNo" class="form-control" value="${shopKeeperCard.cardNo}" required />
                </div>
            </div>
            <div class="row form-group">
                <div class="col-xs-12">
                    <button type="button" id="submitButton" class="btn btn-primary">确认</button>　　
                    <a href="javascript:history.go(-1)" class="btn btn-default">返回</a>
                </div>
            </div>
        </form>
    </div>
</div>
<!--添加银行卡模态框-->
<div class="modal fade" id="addBank_Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="myModalLabel">
                    添加银行卡
                </h4>
            </div>
            <div class="modal-body">
                <p>为了您的安全，即日起只能添加快捷卡才能进行提现。</p>
                <div class="row form-group">
                    <div class="col-xs-3" >
                        <img src="/assets/img/bankImg/ABC.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/BJBANK.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/BOC.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/CCB.png" class="img-thumbnail editImgSrc">
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3" >
                        <img src="/assets/img/bankImg/CCQTGB.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/CDCB.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/CIB.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/CITIC.png" class="img-thumbnail editImgSrc">
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3" >
                        <img src="/assets/img/bankImg/CMB.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/CMBC.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/COMM.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/CQBANK.png" class="img-thumbnail editImgSrc">
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3" >
                        <img src="/assets/img/bankImg/CRCBANK.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/GDB.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/HXBANK.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/ICBC.png" class="img-thumbnail editImgSrc">
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3" >
                        <img src="/assets/img/bankImg/PINGAN.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/PSBC.png" class="img-thumbnail editImgSrc">
                    </div>
                    <div class="col-xs-3">
                        <img src="/assets/img/bankImg/SPDB.png" class="img-thumbnail editImgSrc">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).on('click', '.editImgSrc', function () {
        $("#hedaImg").attr('src',$(this).attr("src"));
        $('#addBank_Modal').modal('hide');
        $("#bankName").val($(this).attr("src").substring(20,$(this).attr("src").length-4))
    });
</script>
<script type="text/javascript">
    function submitValidate() {
        var $form = $('#shopKeeperCardUpdateForm');
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