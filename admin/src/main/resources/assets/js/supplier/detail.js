/**
 * Created by think on 2017/4/28.
 */
$(function () {
    jQuery.validator.addMethod("isMobile", function(value, element) {
        var length = value.length;
        var mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
        return this.optional(element) || (length == 11 && mobile.test(value));
    }, "请正确填写您的手机号码");
    jQuery.validator.addMethod("phonesame", function(value, element) {
        var flag = 1;
        var sid=$('#sid').val();

        $.ajax({
            type:"POST",
            url:'/supplier/checkTelephone',
            async:false,
            data:{'telephone':value,'sid':sid},
            success: function(result){
                if(result.success){
                    flag = 1;
                }else{
                    flag = 0;
                }
            }
        });

        if(flag == 0){
            return false;
        }else{
            return true;
        }

    }, "该手机号已经注册");
});
function intiArea(flag) {
    if (flag) {
        var provinceId = $("#province option:selected").val();
        var cityId = $("#city option:selected").val();
        var areaId = $("#area option:selected").val();
        /**
         * 加载省
         */
        var prvoinceStr = getInitAreas(1, provinceId);

        $("#province").html("<option selected='selected'></option>" + prvoinceStr)
        /**
         * 加载市
         */
        if (provinceId != undefined && provinceId != '') {
            var cityStr = getInitAreas($("#province option:selected").val(), $("#city option:selected").val());
            // $("#city").html(cityStr);
            if (cityId != undefined && cityId != '') {
                $("#city").html("<option ></option>" + cityStr);
            } else {
                $("#city").html("<option selected='selected'></option>" + cityStr);
            }

        }
        /**
         * 加载区/县
         */
        if (cityId != undefined && cityId != '') {
            var areaStr = getInitAreas($("#city option:selected").val(), $("#area option:selected").val());
            // $("#area").html(areaStr);
            if (areaId != undefined && areaId != '') {
                $("#area").html("<option ></option>" + areaStr);
            } else {
                $("#area").html("<option selected='selected'></option>" + areaStr);
            }
        }
    } else {
        var provinceId = $("#province option:selected").val();
        var cityId = $("#city option:selected").val();
        var areaId = $("#area option:selected").val();
        /**
         * 加载省
         */
        var prvoinceStr = getAreas(1, provinceId);

        $("#province").html("<option selected='selected'></option>" + prvoinceStr)
        /**
         * 加载市
         */
        if (provinceId != undefined && provinceId != '') {
            var cityStr = getAreas($("#province option:selected").val(), $("#city option:selected").val());
            // $("#city").html(cityStr);
            if (cityId != undefined && cityId != '') {
                $("#city").html("<option ></option>" + cityStr);
            } else {
                $("#city").html("<option selected='selected'></option>" + cityStr);
            }

        }
        /**
         * 加载区/县
         */
        if (cityId != undefined && cityId != '') {
            var areaStr = getAreas($("#city option:selected").val(), $("#area option:selected").val());
            // $("#area").html(areaStr);
            if (areaId != undefined && areaId != '') {
                $("#area").html("<option ></option>" + areaStr);
            } else {
                $("#area").html("<option selected='selected'></option>" + areaStr);
            }
        }
    }
}
function getAllCity(sid, areaName) {
    var cityStr = getAreas(sid, areaName);
    $("#city").html("<option selected='selected'></option>" + cityStr);
    $("#area").html("<option ></option>")
}
/**
 * 加载区域
 */
function getAllArea(sid, areaName) {

    var areaStr = getAreas(sid, areaName);
    $("#area").html("<option selected='selected'></option>" + areaStr);
}
function getInitAreas(parentSid, areaName) {
    var str;

    $.ajax({
        type: "POST",
        url: "/supplier/getArea",
        data: {"parentSid": parentSid},
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
            //将数据添加到省份这个下拉框里面
            // $("#area").append(str);
            return str;
        },
        error: function () {

        }
    });

    return str;
}
function getAreas(parentSid, areaName) {

    var str;
    if (parentSid != undefined) {
        $.ajax({
            type: "POST",
            url: "/supplier/getArea",
            data: {"parentSid": parentSid},
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
                //将数据添加到省份这个下拉框里面
                // $("#area").append(str);
                return str;
            },
            error: function () {

            }
        });
    }
    return str;

}
//下面是搜索界面的省市区三级联动

function intiSearchArea(flag) {
    if (flag) {
        var provinceId = $("#searchProvince option:selected").val();
        var cityId = $("#searchCity option:selected").val();
        var areaId = $("#searchArea option:selected").val();
        /**
         * 加载省
         */
        var prvoinceStr = getInitAreas(1, provinceId);

        $("#searchProvince").html("<option selected='selected'></option>" + prvoinceStr);
        /**
         * 加载市
         */
        if (provinceId != undefined && provinceId != '') {
            var cityStr = getInitAreas($("#searchProvince option:selected").val(), $("#searchCity option:selected").val());
            if (cityId != undefined && cityId != '') {
                $("#searchCity").html("<option ></option>" + cityStr);
            } else {
                $("#searchCity").html("<option selected='selected'></option>" + cityStr);
            }


        }
        /**
         * 加载区/县
         */
        if (cityId != undefined && cityId != '') {
            var areaStr = getInitAreas($("#searchCity option:selected").val(), $("#searchArea option:selected").val());
            if (areaId != undefined && areaId != '') {
                $("#searchArea").html("<option ></option>" + areaStr);
            } else {
                $("#searchArea").html("<option selected='selected'></option>" + areaStr);
            }

        }
    } else {
        var provinceId = $("#searchProvince option:selected").val();
        var cityId = $("#searchCity option:selected").val();
        var areaId = $("#searchArea option:selected").val();
        /**
         * 加载省
         */
        var prvoinceStr = getAreas(1, provinceId);

        $("#searchProvince").html("<option selected='selected'></option>" + prvoinceStr);
        /**
         * 加载市
         */
        if (provinceId != undefined && provinceId != '') {
            var cityStr = getAreas($("#searchProvince option:selected").val(), $("#searchCity option:selected").val());
            if (cityId != undefined && cityId != '') {
                $("#searchCity").html("<option ></option>" + cityStr);
            } else {
                $("#searchCity").html("<option selected='selected'></option>" + cityStr);
            }


        }
        /**
         * 加载区/县
         */
        if (cityId != undefined && cityId != '') {
            var areaStr = getAreas($("#searchCity option:selected").val(), $("#searchArea option:selected").val());
            if (areaId != undefined && areaId != '') {
                $("#searchArea").html("<option ></option>" + areaStr);
            } else {
                $("#searchArea").html("<option selected='selected'></option>" + areaStr);
            }

        }
    }
}
function getSearchAllCity(sid, areaName) {
    var cityStr = getAreas(sid, areaName);
    $("#searchCity").html("<option selected='selected'></option>" + cityStr);
    $("#searchArea").html("<option ></option>")
}
/**
 * 加载区域
 */
function getSearchAllArea(sid, areaName) {

    var areaStr = getAreas(sid, areaName);
    $("#searchArea").html("<option selected='selected'></option>" + areaStr);
}