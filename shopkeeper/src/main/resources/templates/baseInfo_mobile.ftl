<!DOCTYPE html>
<html>
<head>
<#include "_head_with_datepicker.ftl" />
<#include "_flash.ftl" />
    <meta name="nav-url" content="/baseInfo">
</head>
<body>
<div class="row">
    <div class="col-xs-12">
        <div class="box box-primary">
            <div class="box-header with-border">
                <div>
                    <div style="width: 85%;float: left;"><span>编辑个人资料</span></div>
                    <div style="width: 15%;float: left;"><a href="javascript:history.go(-1)">返回</a></div>
                </div>
            </div>
            <div class="box-body">
                <div style="height: 70px;padding: 8% 0 0 0">
                    <div style="width: 25%;float: left;">
                        <p class="" style="margin-top:30%">当前头像:</p>
                    </div>
                    <div style="width: 75%;float: left;">
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
                <div>
                    <form id="editShopKeeper" action="/save" method="post" data-toggle="validator" role="form">
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="display: none;">商户sid:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                                <input type="hidden" name="sid" class="form-control" value="${shopKeeper.sid?c}" />
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="margin-top:10%">商户名称:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                                <input id="cname" type="text" name="cname" class="form-control" value="${shopKeeper.cname}" />
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="margin-top:10%">姓　　名:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                            <#if shopKeeper.realName ??>
                                <input type="text" name="realName" class="form-control" value="${shopKeeper.realName}" />
                            <#else >
                                <input type="text" name="realName" class="form-control" value="" />
                            </#if>
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="margin-top:10%">身份证号:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                            <#if shopKeeper.idCardNo ??>
                                <input type="text" name="idCardNo" class="form-control" value="${shopKeeper.idCardNo}" />
                            <#else >
                                <input type="text" name="idCardNo" class="form-control" value="" />
                            </#if>
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="margin-top:10%">备　　注:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                            <#if shopKeeper.note ??>
                                <input type="text" name="note" class="form-control" value="${shopKeeper.note}" />
                            <#else >
                                <input type="text" name="note" class="form-control" value="" />
                            </#if>
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="margin-top:10%">联系电话:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                                <input id="telephone" type="text" name="telephone" class="form-control" value="${shopKeeper.telephone}" readonly />
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="margin-top:10%">省　　份:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                                <select name="province" class="form-control" id="province" onchange="loadCityContent($('#province option:selected').val(),$('#province option:selected').text())">
                                    <option>${shopKeeper.province}</option>
                                <#if shopKeeper.province ??>
                                    <option selected="selected">${shopKeeper.province}</option>
                                </#if>
                                </select>
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="margin-top:10%">市　　区:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                                <select name="city" class="form-control" id="city" onchange="loadAreaContent($('#city option:selected').val(),$('#city option:selected').text())">
                                <#if shopKeeper.province ??>
                                    <option>${shopKeeper.city}</option>
                                </#if>
                                </select>
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="margin-top:10%">区　　县:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                                <select name="area" class="form-control" id="area">
                                <#if shopKeeper.area ??>
                                    <option>${shopKeeper.area}</option>
                                </#if>
                                </select>
                            </div>
                        </div>
                        <div style="height: 50px;">
                            <div style="width: 25%;float: left;">
                                <p class="" style="margin-top:10%">详细地址:</p>
                            </div>
                            <div style="width: 75%;float: left;">
                            <#if shopKeeper.address ??>
                                <input type="text" name="address" class="form-control" value="${shopKeeper.address}" />
                            <#else >
                                <input type="text" name="address" class="form-control" value="" />
                            </#if>
                            </div>
                        </div>
                        <div>
                            <div>
                                <button id="validateButton" onclick="submitShopKeeper()" type="button" class="btn btn-primary btn-block">
                                    提 交
                                </button>
                                　　
                            </div>
                        </div>
                    </form>
                </div>
            </div>
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
                if ($('#cname').val() == "") {
                    showInfoFun('商户名称为必填字段。', 'warning');
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