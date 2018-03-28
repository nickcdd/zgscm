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
                var goodsCategoryOneStr = "<option value=" + result.record.goodsCategoryOne.sid + " selected>" + result.record.goodsCategoryOne.cname + "</option>";
                var goodsCategoryTwoStr = "<option value=" + result.record.goodsCategoryTwo.sid + " selected>" + result.record.goodsCategoryTwo.cname + "</option>";
                var freeGoodsStr="";
                if(result.record.freeGoods ==0) {
                    freeGoodsStr = "<option value='0' selected>否</option>";
                }else{
                    freeGoodsStr = "<option value='1' selected>是</option>";
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
                $('#goodsBaseInfoList').hide();
                $('#goodsBaseInfoDetail').show();
                if (result.record.goodsFiles.length > 0) {
                    $("#oldImgUrl").attr("src", result.record.goodsFiles[0].url);
                }


            } else {
                showInfoFun(result.msg);
            }
        });
    });
    $('.btn-add').click(function () {
        $form.clearForm(true);
        $('#goodsBaseInfoList').hide();
        $('#goodsBaseInfoDetail').show();


    });

    $('.btn-cancel').click(function () {
        $form.clearForm(true);
        $('#goodsBaseInfoList').show();
        $('#goodsBaseInfoDetail').hide();

    });
    $('.btn-reset').click(function () {
        $form.clearForm(true);
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
    $('#reviewStatus').val(4);
    $('#detailForm').submit();
}
//信息不通过
function reviewFail() {
    $('#reviewStatus').val(3);
    if($('#reason').val()=="" || $('#reason').val()==undefined || $('#reason').val()==null){
        showInfoFun("请填写审核意见","danger");
    }else {
        $('#detailForm').submit();
    }
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
        if(status==3){
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
        }else if(status==4){
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
    if(status==3){
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
    }else if(status==4){
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