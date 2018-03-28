<link rel="stylesheet" href="/assets/plugins/select2/select2.css">
<script src="/assets/plugins/select2/select2.full.js"></script>
<script type="text/javascript" src="/assets/plugins/select2/i18n/zh-CN.js"></script></span>
<script type="text/javascript">
    $(function () {
    });

    function save(){
        $('#commitButton').attr("disabled","disabled");
        $("#addForm").ajaxSubmit({
            type: "POST",
            url: "/inventory/save",
            dataType: "json",
            success: function (data) {
                if (data.flag) {
                    confirmInfoFun("cancel()", data.msg, "修改成功", false);
//                    cancel();
                }
                else {
                    confirmInfoFun("", data.msg, "修改失败", false);
                }

            },
            complete: function () {
                $('#commitButton').attr("disabled","");
            }
        });
    }
    function setPageInfo() {
        var str = "";
        str += "page=" + $('#redirectPage').val();
        str += "&size=" + $('#redirectSize').val();

        if ($('#redirectGoodsName').val() != undefined && $('#redirectGoodsName').val() != "") {
            str += "&goodsName=" + $('#redirectGoodsName').val();
//                $('#redirectStartDate').val($('#startDate').val());
        }
        if ($('#redirectStorageSid').val() != undefined && $('#redirectStorageSid').val() != "") {

//                $('#redirectEndDate').val($('#endDate').val());
            str += "&storageSid=" + $('#redirectStorageSid').val();
        }



        return str;
    }
    function cancel(){
        var str=setPageInfo();
        location.href="/inventory/index?"+str;
    }
</script>
<div class="col-md-12" id="">
    <div class="box box-info">
        <div class="box-header with-border">

            <h3 class="box-title" id="addTitle">修改库存信息</h3>
        </div>
        <form id="addForm" class="form-horizontal" method="post" action=""
              data-toggle="validator" role="form" >
            <input type="hidden" name="sid" id="sid" value="${inventory.sid?c}" />
            <input type="hidden" name="goodsSid" id="goodsSid" value="${inventory.goods.sid?c}" />
            <input type="hidden" name="specificationSid" id="specificationSid" value="${inventory.goodsSpecification.sid?c}" />
            <input type="hidden" name="storageSid" id="storageSid" value="${inventory.storage.sid?c}" />
            <input type="hidden" name="redirectGoodsName" id="redirectGoodsName" value="${redirectGoodsName!''}" />
            <input type="hidden" name="redirectStorageSid" id="redirectStorageSid" value="${redirectStorageSid!''}" />
            <input type="hidden" name="redirectPage" id="redirectPage" value="${redirectPage!''}" />
            <input type="hidden" name="redirectSize" id="redirectSize" value="${redirectSize!''}" />
            <div class="box-body">
                <div class="form-group">
                    <label for="goodsSid" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品名称</label>
                    <div class="col-sm-4">
                        <input type="text" class="form-control"  placeholder="商品名称" value="${inventory.goods.cname}" readonly />
                    </div>

                </div>
                <div class="form-group">
                    <label for="specificationSid" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品规格</label>
                    <div class="col-sm-4">
                        <input type="text" class="form-control"  placeholder="商品规格" value="${inventory.goodsSpecification.cname}" readonly />
                    </div>

                </div>
                <div class="form-group">
                    <label for="storageSid" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;仓储</label>
                    <div class="col-sm-4">
                        <input type="text" class="form-control"  placeholder="仓储名称" value="${inventory.storage.cname}" readonly />
                    </div>

                </div>

                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品数量</label>
                    <div class="col-sm-3">
                        <input type="number" min='0' class="form-control" id="amount" name="amount" value="${inventory.amount}" placeholder=""
                               value="" maxlength="12" autocomplete="false" />
                        <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                        <div class="help-block with-errors"></div>
                    </div>
                </div>


            </div>

            <div class="box-footer">
                <button type="button" class="btn btn-danger pull-right btn-cancel" onclick="cancel()">
                    <i class="fa fa-close"></i> 取消
                </button>
                <button type="button" class="btn btn-primary pull-right" id="commitButton" onclick="save()">
                    <i class="fa fa-save"></i> 保存
                </button>
                <#--<button type="button" class="btn btn-info pull-right btn-reset">-->
                    <#--<i class="fa fa-eraser"></i> 重置-->
                <#--</button>-->
            </div>

        </form>
    </div>
</div>

