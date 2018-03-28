/**
 * Created by Administrator on 2017/5/12 0012.
 */
// $(function () {
//
//     jQuery.validator.addMethod("checkGoodsBm", function(value, element) {
//         if(value.trim()!="" && value!=undefined && value!=null) {
//             var flag = false;
//             // var sid=$('#sid').val();
//             // alert(element.getAttribute('data-sid'));
//
//             $.ajax({
//                 type: "POST",
//                 url: '/goods/checkGoodsBm',
//                 async: false,
//                 data: {'goodsBm': value, 'specificationSid': element.getAttribute('data-sid')},
//                 success: function (result) {
//                     if (result.success) {
//                         flag = true;
//                     } else {
//                         flag = false;
//                     }
//                 }
//             });
//
//             if (!flag) {
//                 return false;
//             } else {
//                 return true;
//             }
//         }else{
//             return true;
//         }
//     }, "商品编码已存在");
// });
//商品类别联动
function intiGoodsCategory() {

    var bigCatecoryId = $("#bigCatecory option:selected").val();
    var smallCatecoryId = $("#smallCatecory option:selected").val();
    /**
     * 加载大类
     */
    var bigCatecoryStr = getGoodsCatecory(1, bigCatecoryId);

    $("#bigCatecory").html("<option selected='selected'></option>" + bigCatecoryStr)
    /**
     * 加载小类
     */
    if (bigCatecoryId != undefined && bigCatecoryId != '') {
        var smallCatecoryStr = getGoodsCatecory($("#bigCatecory option:selected").val(), $("#smallCatecory option:selected").val());
        $("#smallCatecory").html("<option selected='selected'></option>" + smallCatecoryStr);


    }

}
function getAllBigCatecory(sid, areaName) {
    var smallCatecoryStr = getGoodsCatecory(sid, areaName);
    $("#smallCatecory").html("<option selected='selected'></option>" + smallCatecoryStr);

}

function getGoodsCatecory(parentSid, areaName) {

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

// function getAllSuppliers() {
//
//     var str;
//     $.ajax({
//         type: "POST",
//         url: "/supplier/getAllSuppliers",
//
//         dataType: "JSON",
//         async: false,
//         success: function (data) {
//             //从服务器获取数据进行绑定
//             $.each(data.record, function (i, item) {
//
//
//                 str += "<option value=" + item.sid + ">" + item.cname + "</option>";
//
//
//             })
//
//             return str;
//         },
//         error: function () {
//
//         }
//     });
//     return str;
//
// }




