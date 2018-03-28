<!DOCTYPE html>
<html>
<head>
<#include "_head_with_datepicker.ftl" />
<#include "_flash.ftl" />
    <meta name="nav-url" content="/baseInfo">
</head>
<body>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="min-width:600px;width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">编辑个人资料</h3>
        </div>
        <div class="tab-pane active" id="peopleData_tab">
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:30%">当前头像:</p>
                </div>
                <div class="col-xs-3">
                <#if shopKeeper.avatar ?? && shopKeeper.avatar != ''>
                    <form id="formUpAvatar" action="/upAvatar" method="post" enctype="multipart/form-data">
                        <div class="thumbnail" style="width: 70px;height: 70px;background: url(${shopKeeper.avatar!''}) no-repeat; background-size: cover;">
                            <input onchange="submitUpAcatar()" type="file" name="avatar" style="opacity: 0;width: 100%;height: 100%" />
                            <input type="hidden" name="sid" class="form-control" value="${shopKeeper.sid?c}" />
                        </div>
                    </form>
                <#else >
                    <form id="formUpAvatar" action="/upAvatar" method="post" enctype="multipart/form-data">
                        <div class="thumbnail" style="width: 70px;height: 70px;background: url('/assets/img/head/deficiency_head.jpg') no-repeat; background-size: cover;">
                            <input onchange="submitUpAcatar()" type="file" name="avatar" style="opacity: 0;width: 100%;height: 100%" />
                            <input type="hidden" name="sid" class="form-control" value="${shopKeeper.sid?c}" />
                        </div>
                    </form>
                </#if>
                </div>
            </div>
            <form id="editShopKeeper" action="/save" method="post" data-toggle="validator" role="form">
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="display: none;">商户sid:</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="hidden" name="sid" class="form-control" value="${shopKeeper.sid?c}" />
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">商户名称:</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="text" name="cname" class="form-control" value="${shopKeeper.cname}" required />
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">姓名:</p>
                    </div>
                    <div class="col-xs-9">
                    <#if shopKeeper.realName ??>
                        <input type="text" name="realName" class="form-control" value="${shopKeeper.realName}" required />
                    <#else >
                        <input type="text" name="realName" class="form-control" value="" required />
                    </#if>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">身份证号码:</p>
                    </div>
                    <div class="col-xs-9">
                    <#if shopKeeper.idCardNo ??>
                        <input type="text" name="idCardNo" class="form-control" value="${shopKeeper.idCardNo}" />
                    <#else >
                        <input type="text" name="idCardNo" class="form-control" value="" />
                    </#if>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">备注:</p>
                    </div>
                    <div class="col-xs-9">
                    <#if shopKeeper.note ??>
                        <input type="text" name="note" class="form-control" value="${shopKeeper.note}" />
                    <#else >
                        <input type="text" name="note" class="form-control" value="" />
                    </#if>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">联系电话:</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="text" name="telephone" class="form-control" value="${shopKeeper.telephone}" readonly />
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">居住地:</p>
                    </div>
                    <div class="col-xs-3">
                        <select name="province" class="form-control" id="province" onchange="loadCityContent($('#province option:selected').val(),$('#province option:selected').text())">
                            <option>${shopKeeper.province}</option>
                        <#if shopKeeper.province ??>
                            <option selected="selected">${shopKeeper.province}</option>
                        </#if>
                        </select>
                    </div>
                    <div class="col-xs-3">
                        <select name="city" class="form-control" id="city" onchange="loadAreaContent($('#city option:selected').val(),$('#city option:selected').text())">
                        <#if shopKeeper.province ??>
                            <option>${shopKeeper.city}</option>
                        </#if>
                        </select>
                    </div>
                    <div class="col-xs-3">
                        <select name="area" class="form-control" id="area">
                        <#if shopKeeper.area ??>
                            <option>${shopKeeper.area}</option>
                        </#if>
                        </select>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">详细地址:</p>
                    </div>
                    <div class="col-xs-9">
                    <#if shopKeeper.address ??>
                        <input type="text" name="address" class="form-control" value="${shopKeeper.address}" />
                    <#else >
                        <input type="text" name="address" class="form-control" value="" />
                    </#if>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-12">
                        <button id="validateButton" onclick="submitShopKeeper()" type="button" class="btn btn-primary">
                            确认
                        </button>
                        　　
                        <a href="/index" class="btn btn-default">返回</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    $(function () {
        var provinceText = $("#province option:selected").text();
        /**
         * 初始化加载省
         */
        if (provinceText == undefined || provinceText == '') {
            var provinceContent = getNextLevelArea(1, null);
            $("#province").html("<option>请选择</option>" + provinceContent);

        } else {
            $("#province").html(getNextLevelArea(1, provinceText));
        }
        /**
         * 初始化加载市
         */
        if (provinceText != undefined && provinceText != '') {
            var provinceVal = $("#province option:selected").val();
            if (provinceVal != undefined && provinceVal != '') {
                var cityContent = getNextLevelArea($("#province option:selected").val(), $("#city option:selected").text());
                $("#city").html("<option>请选择</option>" + cityContent);
            }

        }
        var cityText = $("#city option:selected").text();
        /**
         * 初始化加载区
         */
        if (cityText != undefined && cityText != '' && cityText != "请选择") {
            var provinceVal = $("#province option:selected").val();
            if (provinceVal != "请选择") {
                var areaContent = getNextLevelArea($("#city option:selected").val(), $("#area option:selected").text());
                $("#area").html("<option>请选择</option>" + areaContent);
            }
        }
    });

    /**
     * 加载市
     */
    function loadCityContent(sid, flag) {
        if (flag == "请选择") {
            return;
        }
        var cityContent = getNextLevelArea(sid, null);
        $("#city").html("<option selected='selected'>请选择</option>" + cityContent);
    }
    /**
     * 加载区域
     */
    function loadAreaContent(sid, flag) {
        if (flag == "请选择") {
            return;
        }
        var areaContent = getNextLevelArea(sid, null);
        $("#area").html("<option selected='selected'>请选择</option>" + areaContent);
    }
    /**
     * 根据父级Sid加载下一级地区列表
     * @param name
     * @param sid
     */
    var getNextLevelArea = function (sid, flag) {
        var str = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "/area",
            data: {'sid': sid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                $.each(result.record, function (index, value) {
                    if (flag == value.cname) {
                        str += "<option value=" + value.sid + " selected='selected'>" + value.cname + "</option>";
                    } else {
                        str += "<option value=" + value.sid + ">" + value.cname + "</option>";
                    }
                })
            },
            error: function (msg) {
                alert("系统繁忙");
                return;
            }
        });
        return str;
    }

    /**
     * 提交的时候将select中value的值改变成Text值
     */
    function submitShopKeeper() {
        $("#province option:selected").val($("#province option:selected").text());
        $("#city option:selected").val($("#city option:selected").text());
        $("#area option:selected").val($("#area option:selected").text());

        var $form = $('#editShopKeeper');

        $form.submit(function () {
            if ($form.valid()) {
                var data = $form.formJSON('get');

                if ($('#province option:selected').text() == "请选择") {
                    showInfoFun('请选择一个省。', 'warning');
                    return false;
                }
                if ($('#city option:selected').text() == "请选择") {
                    showInfoFun('请选择一个市。', 'warning');
                    return false;
                }
                if ($('#area option:selected').text() == "请选择") {
                    showInfoFun('请选择一个区。', 'warning');
                    return false;
                }
                $("#validateButton").attr("disabled", true);
            }

            return true;
        });
        $("#editShopKeeper").submit();
    }
    /**
     * 头像修改提交
     */
    function submitUpAcatar() {
        $("#formUpAvatar").submit();
    }

</script>
</body>
</html>