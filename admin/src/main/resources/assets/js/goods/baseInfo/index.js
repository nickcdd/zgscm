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

                $form.clearForm(true);
                $form.formJSON('set', result.record);
                setPageInfo();
                var goodsCategoryOneStr = "<option value=" + result.record.goodsCategoryOne.sid + " selected>" + result.record.goodsCategoryOne.cname + "</option>";
                var goodsCategoryTwoStr = "<option value=" + result.record.goodsCategoryTwo.sid + " selected>" + result.record.goodsCategoryTwo.cname + "</option>";
                var freeGoodsStr="";
                if(result.record.freeGoods==0){
                    freeGoodsStr="<option value='0' selected> 否</option><option value='1' > 是</option>";
                }else{
                    freeGoodsStr="<option value='0' > 否</option><option value='1' selected > 是</option>";
                }
                $('#freeGoods').html(freeGoodsStr);
                $("#bigCatecory").html(goodsCategoryOneStr);
                $("#smallCatecory").html(goodsCategoryTwoStr);
                $('#goodsBaseInfoList').hide();
                $('#goodsBaseInfoDetail').show();
                $('#updateTitle').show();
                $('#reviewBtn').show();
                $('#addTitle').hide();
                $('#oldImg').show();
                if (result.record.goodsFiles.length > 0) {
                    $("#oldImgUrl").attr("src", result.record.goodsFiles[0].url);
                }
                intiGoodsCategory();

            } else {
                showInfoFun(result.msg);
            }
        });
    });
    $('.btn-add').click(function () {
        $form.clearForm(true);
        var freeGoodsStr="<option value='0' selected> 否</option><option value='1' > 是</option>";
        $('#freeGoods').html(freeGoodsStr);
        $("#bigCatecory").find("option").remove();
        $("#smallCatecory").find("option").remove();
        $('#goodsBaseInfoList').hide();
        $('#goodsBaseInfoDetail').show();
        $('#updateTitle').hide();
        $('#addTitle').show();
        $('#oldImg').hide();
        $('#reviewBtn').hide();
        setPageInfo();
        intiGoodsCategory();
    });

    $('.btn-cancel').click(function () {
        $form.clearForm(true);
        $('#goodsBaseInfoList').show();
        $('#goodsBaseInfoDetail').hide();
        $('#updateTitle').show();
        $('#addTitle').hide();
    });
    $('#reviewBtn').click(function () {
//               alert($('#sid').val());
        $.ajax({
            type: "POST",
            url: "/goods/commitReview",
            data: {"sid": $('#sid').val(), "status": 2,},
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
                    // location.href = "index?q=" + $('#q').val() + "&searchBigCatecory=" + $('#searchBigCatecory').val() + "&searchSmallCatecory=" + $('#searchSmallCatecory').val() + "&status=" + $('#status').val()+"&page="+($('#infoTable').attr("data-page-number") - 1)+"&size="+$('#infoTable').attr("data-page-size");
                    location.href = "index?" + str;
                    showInfoFun(result.msg);

                } else {
                    showInfoFun(result.msg);
                }

            },
            error: function () {

            }
        });
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