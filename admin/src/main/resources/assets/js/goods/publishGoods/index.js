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

                if (result.record.status == 0) {
                    $('#publishUp').show();
                    $('#publishDown').hide();
                } else if (result.record.status == 1) {
                    $('#publishUp').hide();
                    $('#publishDown').show();
                } else if (result.record.status == 7) {
                    $('#publishUp').show();
                    $('#publishDown').show();

                }

                if (result.record.supplierList.length > 0) {
//

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
                        // var statusStr = "";
                        // if (result.record.goodsSpecifications[i].status == 1) {
                        //
                        //     statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control' readonly ><option selected='selected' value='1'>有效</option></select></div> ";
                        // } else if (result.record.goodsSpecifications[i].status == 0) {
                        //
                        //     statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control' readonly ><option selected='selected' value='0'>无效</option></select></div> ";
                        // }
                        // var str = "<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;规格名称</label><div class='col-sm-2'><input type='text' data-sid='" + result.record.goodsSpecifications[i].sid + "' class='form-control'  value='" + result.record.goodsSpecifications[i].cname + "' placeholder='规格名称' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;进价</label><div class='col-sm-2'><input type='text' class='form-control'  placeholder='进价'value='" + result.record.goodsSpecifications[i].cost + "' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;售价</label><div class='col-sm-2'><input type='text' class='form-control'  value='" + result.record.goodsSpecifications[i].price + "' placeholder='售价' readonly/></div>" + statusStr + "</div>";
                        // $('#goodsSpecification').append(str);
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

                $('#publishGoodsList').hide();
                $('#publishGoodsDetail').show();


            } else {
                showInfoFun(result.msg);
            }
        });
    });


    $('.btn-cancel').click(function () {

        $form.clearForm(true);
        $('#publishGoodsList').show();
        $('#publishGoodsDetail').hide();

        $('.removeFlag').remove();


    });


    $form.submit(function () {

        if ($form.valid()) {
            var data = $form.formJSON('get');


        }

        return true;
    });

    $form.clearForm(true);

});
function setPageInfo() {

    $('#redirectPage').val($('#infoTable').attr("data-page-number") - 1);
    $('#redirectSize').val($('#infoTable').attr("data-page-size"));
    $('#redirectStatus').val($('#status').val());

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
function publishSuccess() {
    $('#reviewStatus').val(1);
    $('#detailForm').submit();
}
//信息不通过
function publishFail() {
    $('#reviewStatus').val(0);
    $('#detailForm').submit();
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