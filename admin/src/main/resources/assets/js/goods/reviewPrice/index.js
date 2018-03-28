/**
 * Created by lipengcheng on 2017/5/19 0019.
 */
$(function () {
    initSearchGoodsCategory();
    var $form = $('#detailForm');
    $(document).on('click', '.btn-detail', function () {
        var $t = $(this), sid = $t.data('sid');
        $.getJSON('/goods/detail?sid=' + sid, function (result) {
            if (result.success) {
                $('.wrapper').animate({scrollTop:0}, 'fast');
                $form.clearForm(true);

                $form.formJSON('set', result.record);
                setPageInfo();
//

                if (result.record.supplierList.length > 0) {
//                            var arr=new Array();
                    //初始化供应商
                    var strResult = "";
                    for (var i = 0; i < result.record.supplierList.length; i++) {
//                                arr[i]=result.record.supplierList[i].sid;
                        strResult += result.record.supplierList[i].cname + ";";
                    }
//                           alert(strResult);
                    $('#supplierName').val(strResult.substring(0, strResult.length - 1))
                }
                if (result.record.goodsSpecifications.length > 0) {
                    for (var i = 0; i < result.record.goodsSpecifications.length; i++) {
                        var statusStr = "";
                        if (result.record.goodsSpecifications[i].status == 1) {

                            statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control' readonly ><option selected='selected' value='1'>有效</option></select></div> ";
                        } else if (result.record.goodsSpecifications[i].status == 0) {

                            statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control' readonly ><option selected='selected' value='0'>无效</option></select></div> ";
                        }
                        // var str = "<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;规格名称</label><div class='col-sm-2'><input type='text' data-sid='" + result.record.goodsSpecifications[i].sid + "' class='form-control'  value='" + result.record.goodsSpecifications[i].cname + "' placeholder='规格名称' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;进价</label><div class='col-sm-2'><input type='text' class='form-control'  placeholder='进价'value='" + result.record.goodsSpecifications[i].cost + "' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;售价</label><div class='col-sm-2'><input type='text' class='form-control'  value='" + result.record.goodsSpecifications[i].price + "' placeholder='售价' readonly/></div>" + statusStr + "</div>";
                        var str = "<div  class='list-group-item removeFlag' style='background:#f9f9f9 '><div class='form-group '><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品编码</label><div class='col-sm-3'><input type='text' data-sid='" + result.record.goodsSpecifications[i].sid + "' class='form-control'  value='" + result.record.goodsSpecifications[i].goodsBm + "' placeholder='商品编码' readonly/></div><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;规格名称</label><div class='col-sm-3'><input type='text' data-sid='" + result.record.goodsSpecifications[i].sid + "' class='form-control'  value='" + result.record.goodsSpecifications[i].cname + "' placeholder='规格名称' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;进价</label><div class='col-sm-3'><input type='text' class='form-control'  placeholder='进价' value='" + result.record.goodsSpecifications[i].cost + "' readonly/></div></div><div class='form-group '><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;售价</label><div class='col-sm-3'><input type='text' class='form-control' value='" + result.record.goodsSpecifications[i].price + "' placeholder='售价' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;建议售价</label><div class='col-sm-3'><input type='text' class='form-control' value='" + result.record.goodsSpecifications[i].suggestPrice + "' placeholder='建议售价' readonly/></div>" + statusStr + "</div></div>";
                        $('#goodsSpecification').append(str);

                    }

                }
                var reasonStr=" <div class='modal-body'><div class='form-group has-feedback'>"
                    +"<label for='' class='col-sm-3 control-label'>&nbsp;&nbsp;<span style='color: red;'>审核意见</span></label>"
                +"<div class='col-sm-6'>"
                    +"<input type='text' class='form-control' id='reason' name='reason' placeholder='不通过时审核意见不能为空'"
                +"maxlength='50' autocomplete='false' />"
                    +"</div> </div></div>";
                $('#goodsSpecification').append(reasonStr);
                var goodsCategoryOneStr = "<option value=" + result.record.goodsCategoryOne.sid + " selected>" + result.record.goodsCategoryOne.cname + "</option>";
                var goodsCategoryTwoStr = "<option value=" + result.record.goodsCategoryTwo.sid + " selected>" + result.record.goodsCategoryTwo.cname + "</option>";
                var freeGoodsStr="";
                if(result.record.freeGoods ==0) {
                    freeGoodsStr = "<option value='0' selected>否</option>";
                }else{
                    freeGoodsStr = "<option value='1' selected>是</option>";
                }
                if (result.record.goodsFiles.length > 0) {
                    $("#oldImgUrl").attr("src", result.record.goodsFiles[0].url);
                }
                //商品操作日志
                var logsStr="";
                if(result.record.goodsLogs.length > 0){
                    for(var i=0;i<result.record.goodsLogs.length;i++) {

//                                logsStr += "<a href='javascript:void (0)' class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>"+  new Date(parseInt(result.record.goodsLogs[i].createTime))      + "         "+      result.record.goodsLogs[i].note+"</span></div></div></a>";
                        logsStr += "<div  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>"+  (new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleDateString()+""+(new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleTimeString()      + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+      result.record.goodsLogs[i].note+"</span></div></div></div>";
                    }
                }else{
                    logsStr = "<div  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>暂无操作记录</span></div></div></div>";
                }
                $('#logsList').html(logsStr);
                $('#freeGoods').html(freeGoodsStr);
                $("#bigCatecory").html(goodsCategoryOneStr);
                $("#smallCatecory").html(goodsCategoryTwoStr);

                $('#reviewPriceList').hide();
                $('#reviewPriceDetail').show();


            } else {
                showInfoFun(result.msg);
            }
        });
    });


    $('.btn-cancel').click(function () {
        $form.clearForm(true);
        $('#reviewPriceList').show();
        $('#reviewPriceDetail').hide();
//                for(var i=0;i<priceId;i++){
//                    $('#cname'+i).remove();
//                    $('#price'+i).remove();
//                    $('#cost'+i).remove();
//                }
        $('.removeFlag').remove();


    });


    $form.submit(function () {

        if ($form.valid()) {
            var data = $form.formJSON('get');


        }

        return true;
    });
    $("#selectAll").click(function () {
        $("[name=goodsSids]:checkbox").prop("checked", this.checked);

    });
    $("[name=goodsSids]:checkbox").click(function () {
        var flag = true;
        $("[name=goodsSids]:checkbox").each(function () {
            if (!this.checked) {
                flag = false;
            }
        });
        $("#selectAll").prop("checked", flag);
    });
    $form.clearForm(true);

});

function setPageInfo() {

    $('#redirectPage').val($('#infoTable').attr("data-page-number") - 1);
    $('#redirectSize').val($('#infoTable').attr("data-page-size"));

    if ($('#searchBigCatecory').val() != undefined && $('#searchBigCatecory').val() != "") {

        $('#redirectBigCategory').val($('#searchBigCatecory').val());
    }
    if ($('#searchSmallCatecory').val() != undefined && $('#searchSmallCatecory').val() != "") {

        $('#redirectSmallCategory').val($('#searchSmallCatecory').val());
    }
    if ($('#q').val() != undefined && $('#q').val() != "") {

        $('#redirectQ').val($('#q').val());
    }

}
//信息通过
function reviewSuccess() {
    $('#reviewStatus').val(7);
    $('#detailForm').submit();
}
//信息不通过
function reviewFail() {
    $('#reviewStatus').val(6);
    if($('#reason').val()=="" || $('#reason').val()==undefined || $('#reason').val()==null){
        showInfoFun("请填写审核意见","danger");
    }else {
        $('#detailForm').submit();
    }
    // $('#detailForm').submit();
}
//查询商品类别联动
function initSearchGoodsCategory() {

    var bigCatecoryId = $("#searchBigCatecory option:selected").val();
    var smallCatecoryId = $("#searchSmallCatecory option:selected").val();
    /**
     * 加载大类
     */
    var bigCatecoryStr = getSearchGoodsCatecory(1, bigCatecoryId);

    $("#searchBigCatecory").html("<option selected='selected'></option>" + bigCatecoryStr)
    /**
     * 加载小类
     */
    if (bigCatecoryId != undefined && bigCatecoryId != '') {
        var smallCatecoryStr = getSearchGoodsCatecory($("#searchBigCatecory option:selected").val(), $("#searchSmallCatecory option:selected").val());
        // $("#searchSmallCatecory").html(smallCatecoryStr);
        if (smallCatecoryId != undefined && smallCatecoryId != '') {
            $("#searchSmallCatecory").html("<option ></option>" + smallCatecoryStr);
        } else {
            $("#searchSmallCatecory").html("<option selected='selected'></option>" + smallCatecoryStr);
        }

    }

}
function getSearchAllSmallCatecory(sid, areaName) {
    var smallCatecoryStr = getSearchGoodsCatecory(sid, areaName);
    $("#searchSmallCatecory").html("<option selected='selected'></option>" + smallCatecoryStr);

}

function getSearchGoodsCatecory(parentSid, areaName) {

    var str;
    $.ajax({
        type: "POST",
        url: "/goods/getGoodsCategorys",
        data: {"parentSid": parentSid, "status": 1},
        dataType: "JSON",
        async: false,
        success: function (data) {
            //从服务器获取数据进行绑定
            $.each(data.record, function (i, item) {

                if (areaName == item.sid) {
                    str += "<option value=" + item.sid + " selected>" + item.cname + "</option>";
                } else {
                    str += "<option value=" + item.sid + ">" + item.cname + "</option>";
                }

            })

            return str;
        },
        error: function () {

        }
    });
    return str;

}

//响应批量提交按钮
function batchBtns(status){
    $('#modelReason').val("");
    var array = [];
    $("[name=goodsSids]:checkbox").each(function () {
        if (this.checked) {
//                    alert($(this).val());
            array.push($(this).val());
        }
    });
//            alert(array.length);
    if(array.length==0){
        showInfoFun("请选择至少一条数据","danger");
    }else{
        if(status==6){
            $('#confirmModal').modal('show');
            $('.btn-confirm').click(function () {

                if($('#modelReason').val()=="" || $('#modelReason').val()==undefined || $('#modelReason').val()==null){
                    showInfoFun("审核意见不能为空","danger");
                }else{
                    $('.btn-confirm').attr("disabled","disabled");
                    $('#confirmModal').modal('hide');
                    batchSummit(array,status,$('#modelReason').val());
                }
            });
        }else if(status==7){
            batchSummit(array,status,"");
        }

    }
}

function batchSummit(array,status,reason){
    $('.btn-sign').attr("disabled","disabled");
    $.ajax({
        type: "POST",
        url: "/goods/batchCommitReview",
        data: {"goodsSids": array, "status": status,"reason":reason},
        dataType: "JSON",
        traditional: true,
        async: false,
        success: function (result) {
            if (result.success) {
                showInfoFun(result.msg);
                $('#infoForm').submit();



            } else {
                $('.btn-sign').removeAttr("disabled");
                showInfoFun(result.msg);
            }

        },
        error: function () {
            $('.btn-sign').removeAttr("disabled");
        }
    });

}
function singleBtn(obj,status){
    if(status==6){
        $('#confirmModal').modal('show');
        $('.btn-confirm').click(function () {

            if($('#modelReason').val()=="" || $('#modelReason').val()==undefined || $('#modelReason').val()==null){
                showInfoFun("审核意见不能为空","danger");
            }else{
                $('.btn-confirm').attr("disabled","disabled");
                $('#confirmModal').modal('hide');
                singleSummit(obj,status,$('#modelReason').val());
            }
        });
    }else if(status==7){
        singleSummit(obj,status,"");
    }
}
function singleSummit(obj,status,reason){
//            alert($(obj).val());
    $(obj).attr("disabled","disabled");
    $.ajax({
        type: "POST",
        url: "/goods/commitReview",
        data: {"sid": $(obj).val(), "status": status,"reason":reason},
        dataType: "JSON",
        async: false,
        success: function (result) {
            if (result.success) {
                showInfoFun(result.msg);
                $('#infoForm').submit();
            } else {
                $(obj).removeAttr("disabled");
                showInfoFun(result.msg);
            }

        },
        error: function () {
            $(obj).removeAttr("disabled");
        }
    });
}