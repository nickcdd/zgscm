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
                initSelect();

                $form.formJSON('set', result.record);
                setPageInfo();
                if (result.record.supplierList.length > 0) {
                    var arr = new Array();
                    for (var i = 0; i < result.record.supplierList.length; i++) {
                        arr[i] = result.record.supplierList[i].sid;
                    }
                    $(".select2").val(arr).trigger("change");
                }
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
                        logsStr += "<a  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>"+  (new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleDateString()+""+(new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleTimeString()      + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+      result.record.goodsLogs[i].note+"</span></div></div></a>";
                    }
                }else{
                    logsStr = "<a  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>暂无操作记录</span></div></div></a>";
                }
                $('#logsList').html(logsStr);
                $('#freeGoods').html(freeGoodsStr);
                $("#bigCatecory").html(goodsCategoryOneStr);
                $("#smallCatecory").html(goodsCategoryTwoStr);

                $('#goodsSupplierList').hide();
                $('#goodsSupplierDetail').show();
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
        $('#goodsSupplierList').hide();
        $('#goodsSupplierDetail').show();


    });

    $('.btn-cancel').click(function () {
        $form.clearForm(true);
        $('#goodsSupplierList').show();
        $('#goodsSupplierDetail').hide();

    });

    $form.submit(function () {

        if ($form.valid()) {
            var data = $form.formJSON('get');

            $('#commitButton').attr("disabled","disabled");
        }

        return true;
    });

    $form.clearForm(true);

});
function setPageInfo() {

    $('#redirectPage').val($('#infoTable').attr("data-page-number").trim() - 1);
    $('#redirectSize').val($('#infoTable').attr("data-page-size").trim());

    $('#redirectStatus').val($('#status').val().trim());
    if ($('#searchBigCatecory').val() != undefined && $('#searchBigCatecory').val() != "") {

        $('#redirectBigCategory').val($('#searchBigCatecory').val().trim());
    }
    if ($('#searchSmallCatecory').val() != undefined && $('#searchSmallCatecory').val() != "") {

        $('#redirectSmallCategory').val($('#searchSmallCatecory').val().trim());
    }
    if ($('#q').val() != undefined && $('#q').val() != "") {

        $('#redirectQ').val($('#q').val());
    }

}
function initSelect() {
    $(".select2").select2();


    var supplierStr = getAllSuppliers();
    $('#allSuppliers').html(supplierStr);

//            arr[0]=1;
//            arr[1]=26;
//            $(".select2").val(arr).trigger("change")
}
function getAllSuppliers() {

    var str="<option value=''>请选择</option>";
    $.ajax({
        type: "POST",
        url: "/supplier/getAllSuppliers",

        dataType: "JSON",
        async: false,
        success: function (data) {
            //从服务器获取数据进行绑定
            $.each(data.record, function (i, item) {

                // str="<option value=''>请选择</option>";
                str += "<option value=" + item.sid + ">" + item.cname + "</option>";


            })

            return str;
        },
        error: function () {

        }
    });
    return str;

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