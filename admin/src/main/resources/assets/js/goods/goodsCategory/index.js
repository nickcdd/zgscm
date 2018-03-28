/**
 * Created by Administrator on 2017/5/9 0009.
 */
var $form;
var resultStr;
// var statusStr="<option value='1'>有效</option><option value='0'>无效</option>";
$(function () {

    $form = $('#detailForm');
    var strHtml = showGoodsCategory(-1);
//            alert(strHtml);
    $('#myTree').append(strHtml);
    $('#rootTree').click();
    $('.btn-add').click(function () {
        $form.clearForm(true);
        $form.validate().resetForm();

        $('#detailGoodsCategory').show();
        $('#addTitle').show();
        $('#updateTitle').hide();
        $('#goodsCatecoryParent').show();
        var str = "<option value='1' selected></option>";
        $.each(resultStr, function (i, item) {


            str += "<option value=" + item.sid + ">" + item.cname + "</option>";


        })
        $('#parentSid').html(str);
        $('#status').html("<option value='1'>有效</option><option value='0'>无效</option>");

    });
    $form.submit(function () {
        if ($form.valid()) {
            var data = $form.formJSON('get');
            $('#commitButton').attr("disabled","disabled");

        }

        return true;
    });
    findBigGoodsCategory(1);
});
/**
 * 得到商品类别详情
 * @param sid
 */
function getGooodsCategory(sid) {
    $form.validate().resetForm();

    $.getJSON('/goods/goodsCategory/detail?sid=' + sid, function (result) {
        if (result.success) {
            $form.clearForm(true);
            if (result.record.parentSid == 1 || result.record.parentSid == -1) {

                $('#goodsCatecoryParent').hide();


            } else {
                $('#goodsCatecoryParent').show();

            }
            $('#detailGoodsCategory').show();
            $('#addTitle').hide();
            $('#updateTitle').show();
            $form.formJSON('set', result.record);
            var str;
            $.each(resultStr, function (i, item) {
                if (result.record.parentSid == item.sid) {
                    str += "<option value=" + item.sid + " selected>" + item.cname + "</option>";
                } else {
                    str += "<option value=" + item.sid + ">" + item.cname + "</option>";
                }

            })
            $('#parentSid').html(str);
            // $('#status').html(statusStr);
            if (result.record.status == 1) {
                $('#status').html("<option value='1' selected>有效</option><option value='0' >无效</option>");
            } else {
                $('#status').html("<option value='1' >有效</option><option value='0' selected>无效</option>");
            }


        } else {
            showInfoFun(result.msg);
        }
    });
}

/**
 * 左边树的onclick响应方法  查询子类
 * @param obj
 */
function findGoodsCategory(obj) {
//            $('#detailGoodsCategory').show();
    $(obj).next('ul').toggle(200);
    if ($(obj).attr("data-flag") == 1) {
        $(obj).attr("data-flag", "0");
        var sid = $(obj).attr("data-info");


        var strHtml = showGoodsCategory(sid);
        $(obj).after(strHtml);
    }
    var sid = $(obj).attr("data-info");
    if (sid != 1) {
        getGooodsCategory(sid);

    } else {
        $form.clearForm(true);
        $('#detailGoodsCategory').hide();
    }
}
/**
 * ajax查询子类
 * @param sid
 * @param flag
 * @returns {*}
 */
function showGoodsCategory(sid) {
//            alert(sid);

    var str = "<ul  >";
    $.ajax({
        type: "POST",
        url: "/goods/showGoodsCategory",
        data: {"sid": sid},
        dataType: "JSON",
        async: false,
        success: function (data) {
            //从服务器获取数据进行绑定
            if(sid==-1){
                $.each(data.record, function (i, item) {
                    str += "<li ><a href='#' id='rootTree' data-info=" + item.sid + " data-flag='1' onclick='findGoodsCategory(this)'><i class='fa fa-folder'></i> <span>" + item.cname + "</span></a></li>";

                })
                str += " </ul>";
            }else {


                $.each(data.record, function (i, item) {
                    str += "<li ><a href='#' data-info=" + item.sid + " data-flag='1' onclick='findGoodsCategory(this)'><i class='fa fa-folder'></i> <span>" + item.cname + "</span></a></li>";

                })
                str += " </ul>";
            }
//                    $('#tree').append(str);
//                return str;
        },
        error: function () {

        }
    });
    return str;

}
/**
 * 查询大类
 * @param sid
 */
function findBigGoodsCategory(sid) {
    $.ajax({
        type: "POST",
        url: "/goods/getBigGoodsCategory",
        data: {"sid": sid},
        dataType: "JSON",
        async: false,
        success: function (data) {
            //从服务器获取数据进行绑定
            resultStr = data.record;

        },
        error: function () {

        }
    });
}