/**
 * Created by Administrator on 2017/5/15 0015.
 */
var priceId = 1;
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

                //显示供应商
                if (result.record.supplierList.length > 0) {

                    var strResult = "";
                    for (var i = 0; i < result.record.supplierList.length; i++) {

                        strResult += result.record.supplierList[i].cname + ";";
                    }

                    $('#supplierName').val(strResult.substring(0, strResult.length - 1))
                }
                if (result.record.goodsSpecifications.length > 0) {
                    for (var i = 0; i < result.record.goodsSpecifications.length; i++) {
                        var statusStr = "";
                        if (result.record.goodsSpecifications[i].status == 1) {

                            statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control'  id='priceStatus" + priceId + "'><option selected='selected' value='1'>有效</option><option value='0'>无效</option></select></div> ";
                        } else if (result.record.goodsSpecifications[i].status == 0) {

                            statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control'  id='priceStatus" + priceId + "'><option  value='1'>有效</option><option selected='selected' value='0'>无效</option></select></div> ";
                        }
                        var str = "<div  class='list-group-item removeFlag' style='background:#f9f9f9 '><div class='form-group '><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品编码</label><div class='col-sm-3'><input type='text' data-sid='" + result.record.goodsSpecifications[i].goodsBm + "' class='form-control' id='goodsBm" + priceId + "' value='" + result.record.goodsSpecifications[i].goodsBm + "' placeholder='商品编码' /></div><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;规格名称</label><div class='col-sm-3'><input type='text' data-sid='" + result.record.goodsSpecifications[i].sid + "' class='form-control' id='cname" + priceId + "' value='" + result.record.goodsSpecifications[i].cname + "' placeholder='规格名称' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;进价</label><div class='col-sm-3'><input type='number' class='form-control' id='cost" + priceId + "' placeholder='进价' value='" + result.record.goodsSpecifications[i].cost + "' required='required'/></div></div><div class='form-group '><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;售价</label><div class='col-sm-3'><input type='number' class='form-control' id='price" + priceId + "'value='" + result.record.goodsSpecifications[i].price + "' placeholder='售价' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;建议售价</label><div class='col-sm-3'><input type='number' class='form-control'id='suggestPrice" + priceId + "' value='" + result.record.goodsSpecifications[i].suggestPrice + "' placeholder='建议售价' required='required'/></div>" + statusStr + "</div></div>";

                        $('#goodsSpecification').append(str);
                        priceId += 1;
                    }
                    $('#reviewBtn').show();
                } else {
                    $('#reviewBtn').hide();
                    // var statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control'  id='priceStatus" + priceId + "'><option selected='selected' value='1'>有效</option><option value='0'>无效</option></select></div> ";
                    // var str = "<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;名称</label><div class='col-sm-2'><input type='text' data-sid='' class='form-control' id='cname" + priceId + "'  placeholder='价格名称' required='required'/></div><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品进价</label><div class='col-sm-2'><input type='number' class='form-control' id='cost"+ priceId + "' placeholder='商品进价' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品售价</label><div class='col-sm-2'><input type='number' class='form-control' id='price" + priceId + "'  placeholder='商品售价' required='required'/></div>" + statusStr +"</div>";
                    // $('#goodsSpecification').append(str);
                    // priceId += 1;
                }
                var goodsCategoryOneStr = "<option value=" + result.record.goodsCategoryOne.sid + " selected>" + result.record.goodsCategoryOne.cname + "</option>";
                var goodsCategoryTwoStr = "<option value=" + result.record.goodsCategoryTwo.sid + " selected>" + result.record.goodsCategoryTwo.cname + "</option>";
                var freeGoodsStr = "";
                if (result.record.freeGoods == 0) {
                    freeGoodsStr = "<option value='0' selected>否</option>";
                } else {
                    freeGoodsStr = "<option value='1' selected>是</option>";
                }
                //商品操作日志
                var logsStr = "";
                if (result.record.goodsLogs.length > 0) {
                    for (var i = 0; i < result.record.goodsLogs.length; i++) {

//                                logsStr += "<a href='javascript:void (0)' class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>"+  new Date(parseInt(result.record.goodsLogs[i].createTime))      + "         "+      result.record.goodsLogs[i].note+"</span></div></div></a>";
                        logsStr += "<div  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><spanclass='text-info'>" + (new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleDateString() + "" + (new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleTimeString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + result.record.goodsLogs[i].note + "</span></div></div></div>";
                    }
                } else {
                    logsStr = "<div  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>暂无操作记录</span></div></div></div>";
                }
                $('#logsList').html(logsStr);
                $('#freeGoods').html(freeGoodsStr);
                $("#bigCatecory").html(goodsCategoryOneStr);
                $("#smallCatecory").html(goodsCategoryTwoStr);
                if (result.record.goodsFiles.length > 0) {
                    $("#oldImgUrl").attr("src", result.record.goodsFiles[0].url);
                }
                $('#goodsPriceList').hide();
                $('#goodsPriceDetail').show();


            } else {
                showInfoFun(result.msg);
            }
        });
    });


    $('.btn-cancel').click(function () {
        $form.clearForm(true);
        $('#goodsPriceList').show();
        $('#goodsPriceDetail').hide();

        $('.removeFlag').remove();
        priceId = 1;

    });
//提交审核
    $('#reviewBtn').click(function () {
        $('#reviewStatus').val("5");
        commitFrom();

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
function addNewGoodsSpecification() {

    var flag = true;
    if (priceId == 1) {
        flag = true;
    } else {
        for (var i = 1; i < priceId; i++) {
            if ($('#cname' + i).length > 0) {
                if ($('#cname' + i).val().trim() == "" || $('#cost' + i).val().trim() == "" || $('#price' + i).val().trim() == "" || $('#suggestPrice' + i).val().trim() == "" ) {

                    flag = false
                    break;
                }
            }
        }
    }
    if (flag) {
        var str = "<div class='list-group-item removeFlag' style='background:#f9f9f9 '><div class='form-group '><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品编码</label><div class='col-sm-3'><input type='text' data-sid='' class='form-control' id='goodsBm" + priceId + "' placeholder='商品编码' /></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;规格名称</label><div class='col-sm-3'><input type='text' data-sid='' class='form-control' id='cname" + priceId + "' placeholder='规格名称' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;进价 </label><div class='col-sm-3'><input type='number' class='form-control' id='cost" + priceId + "' placeholder='进价' required='required'/></div></div><div class='form-group '><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;售价</label><div class='col-sm-3'><input type='number' class='form-control' id='price" + priceId + "'placeholder='售价' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color:red;'>&nbsp;*</span>&nbsp;&nbsp;建议售价</label><div class='col-sm-3'><input type='number' class='form-control' id='suggestPrice" + priceId + "' placeholder='建议售价'required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control'  id='priceStatus" + priceId + "'><option selected='selected' value='1'>有效</option><option value='0'>无效</option></select></div><div class='col-sm-1'><button type='button' class='btn btn-danger btn-xs 'onclick='removeDiv(this)' id='' >移除</button></div></div></div>";
        $('#goodsSpecification').append(str);
        priceId += 1;
    } else {
        showInfoFun("请完善价格信息再添加", "danger");
    }
}
function commitFrom() {
    var goodsSpecificationStr = "";

    if (priceId == 1) {
        if ($('#cname1').length > 0) {
            // if ($.trim($('#cname' + priceId).val()) != "" && $.trim($('#cost' + priceId).val()) != "" && $.trim($('#price' + priceId).val()) != "" && $.trim($('#suggestPrice' + priceId).val()) != "" && $.trim($('#goodsBm' + priceId).val()) != "") {
            if ($.trim($('#cname' + priceId).val()) != "" && $.trim($('#cost' + priceId).val()) != "" && $.trim($('#price' + priceId).val()) != "" && $.trim($('#suggestPrice' + priceId).val()) != "" ) {
            goodsSpecificationStr = $('#cname' + priceId).attr('data-sid') + "," + $('#cname' + priceId).val() + "," + $('#cost' + priceId).val() + "," + $('#price' +
                        priceId).val() + "," + $('#suggestPrice' + priceId).val() + "," + $('#priceStatus' + priceId).val() +  "," + $('#goodsBm' + priceId).val()+";";
                $('#goodsSpecificationStr').val(goodsSpecificationStr.substring(0, goodsSpecificationStr.length - 1));
                $('#commitButton').attr("disabled", "disabled");
                $('#reviewBtn').attr("disabled", "disabled");
                $('#detailForm').submit();
            } else {
                showInfoFun("请完善价格信息", "danger");
            }
        } else {
            showInfoFun("当前商品没有添加价格信息，无需保存");
        }

    } else {
        var flag = true;

        for (var i = 1; i < priceId; i++) {
            if ($('#cname' + i).length > 0) {

                // if ($.trim($('#cname' + i).val()) != "" && $.trim($('#cost' + i).val()) != "" && $.trim($('#price' + i).val()) != "" && $.trim($('#suggestPrice' + i).val()) != "" && $.trim($('#goodsBm' + i).val()) != "" ) {
                if ($.trim($('#cname' + i).val()) != "" && $.trim($('#cost' + i).val()) != "" && $.trim($('#price' + i).val()) != "" && $.trim($('#suggestPrice' + i).val()) != ""  ) {
                    // alert($('#goodsBm' + i).val());
                    goodsSpecificationStr += $('#cname' + i).attr('data-sid') + "," + $('#cname' + i).val() + "," + $('#cost' + i).val() + "," + $('#price' + i).val() + "," + $('#suggestPrice' + i).val() + "," + $('#priceStatus' + i).val() +"," + $('#goodsBm' + i).val()+ ";";

                } else {
                    flag = false;

                    showInfoFun("请完善价格信息再保存", "danger");
                    break;
                }
            }
        }
        if(flag) {
            if (goodsSpecificationStr == "") {
                showInfoFun("当前商品没有添加价格信息，无需保存");
                flag = false;
            }
        }
        if (flag) {
            $('#goodsSpecificationStr').val(goodsSpecificationStr.substring(0, goodsSpecificationStr.length - 1));
            if ($('#detailForm').valid()) {
                $('#commitButton').attr("disabled", "disabled");
                $('#reviewBtn').attr("disabled", "disabled");
                $('#detailForm').submit();
            }
            // $('#commitButton').attr("disabled","disabled");
            // $('#detailForm').submit();
        }


    }
}
function removeDiv(obj) {

    $(obj).parent().parent().parent().remove();
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

function batchSummit(obj) {
    $(obj).attr("disabled", "disabled");
    var array = [];
    $("[name=goodsSids]:checkbox").each(function () {
        if (this.checked) {
//                    alert($(this).val());
            array.push($(this).val());
        }
    });
//            alert(array.length);
    if (array.length == 0) {
        $(obj).removeAttr("disabled");
        showInfoFun("请选择至少一条数据", "danger");
    } else {

        $.ajax({
            type: "POST",
            url: "/goods/batchCommitReview",
            data: {"goodsSids": array, "status": 5},
            dataType: "JSON",
            traditional: true,
            async: false,
            success: function (result) {
                if (result.success) {
                    var str = "status=" + $('#status').val() + "&page=" + ($('#infoTable').attr("data-page-number") - 1) + "&size=" + $('#infoTable').attr("data-page-size");
                    if ($('#searchBigCatecory').val() != undefined && $('#searchBigCatecory').val() != "") {

                        str += "&searchBigCatecory=" + $('#searchBigCatecory').val();
                    }
                    if ($('#searchSmallCatecory').val() != undefined && $('#searchSmallCatecory').val() != "") {

                        str += "&searchSmallCatecory=" + $('#searchSmallCatecory').val();
                    }
                    if ($('#q').val() != undefined && $('#q').val() != "") {

                        str += "&q=" + $('#q').val()
                    }
                    // location.href = "index?q=" + $('#q').val() + "&searchBigCatecory=" + $('#searchBigCatecory').val() + "&searchSmallCatecory=" +
                    $('#searchSmallCatecory').val() + "&status=" + $('#status').val() + "&page=" + ($('#infoTable').attr("data-page-number") - 1) + "&size=" + $('#infoTable').attr("data-page-size");
                    location.href = "index?" + str;

                    showInfoFun(result.msg);

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
}
function singleSummit(obj) {
//            alert($(obj).val());
    $(obj).attr("disabled", "disabled");
    $.ajax({
        type: "POST",
        url: "/goods/commitReview",
        data: {"sid": $(obj).val(), "status": 5},
        dataType: "JSON",
        async: false,
        success: function (result) {
            if (result.success) {
                var str = "status=" + $('#status').val() + "&page=" + ($('#infoTable').attr("data-page-number") - 1) + "&size=" + $('#infoTable').attr("data-page-size");
                if ($('#searchBigCatecory').val() != undefined && $('#searchBigCatecory').val() != "") {

                    str += "&searchBigCatecory=" + $('#searchBigCatecory').val();
                }
                if ($('#searchSmallCatecory').val() != undefined && $('#searchSmallCatecory').val() != "") {

                    str += "&searchSmallCatecory=" + $('#searchSmallCatecory').val();
                }
                if ($('#q').val() != undefined && $('#q').val() != "") {

                    str += "&q=" + $('#q').val()
                }
                // location.href = "index?q=" + $('#q').val() + "&searchBigCatecory=" + $('#searchBigCatecory').val() + "&searchSmallCatecory=" +
                $('#searchSmallCatecory').val() + "&status=" + $('#status').val() + "&page=" + ($('#infoTable').attr("data-page-number") - 1) + "&size=" + $('#infoTable').attr("data-page-size");
                location.href = "index?" + str;

                showInfoFun(result.msg);

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