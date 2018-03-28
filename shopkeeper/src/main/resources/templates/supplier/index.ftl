<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
<#include "../_head_with_table.ftl" />
    <meta name="nav-url" content="/goods/index">
</head>
<body>
<div class="nav-tabs-custom">
    <ul class="nav nav-tabs">
        <li><a href="/goods/index">产品列表</a></li>
        <li class="active"><a href="#supplier_tab" data-toggle="tab" aria-expanded="true">供应商列表</a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane active" id="supplier_tab">
            <div class="row placeholders">
                <div class="col-md-12 placeholder">
                    <form id="storageIndexForm" action="/supplier/index" method="get" class="form-inline" role="form">
                        <input type="hidden" name="page" />
                        <input type="hidden" name="size" />
                        <div class="form-group" style="margin: 0 0 2% 0">
                            <label class="" for="name">省</label>
                            <div class="input-group date">
                                <select class="form-control" name="province" id="searchProvince"
                                        onchange="getSearchAllCity($('#searchProvince option:selected').val())">
                                <#if province !="">
                                    <option selected="selected">${province}</option>
                                </#if>
                                </select>
                            </div>
                        </div>
                        <div class="form-group " style="margin: 0 0 2% 0">
                            <label class="" for="name">市</label>
                            <div class="input-group date">
                                <select class="form-control" name="city" id="searchCity"
                                        onchange="getSearchAllArea($('#searchCity option:selected').val())">
                                <#if city!="">
                                    <option selected="selected">${city}</option>
                                </#if>
                                </select>
                            </div>
                        </div>
                        <div class="form-group " style="margin: 0 0 2% 0">
                            <label class="" for="name">区</label>
                            <div class="input-group date">
                                <select class="form-control" name="area" id="searchArea">
                                <#if area!="">
                                    <option selected="selected">${area}</option>
                                </#if>
                                </select>
                            </div>
                        </div>
                        <div class="form-group " style="margin: 0 0 2% 0">
                            <div class="input-group ">
                            <#if cname ??>
                                <input type="text" name="cname" id="cname" class="form-control" placeholder="请输入搜索的关键词"
                                       value="${cname}" />
                            <#else >
                                <input type="text" name="cname" id="cname" class="form-control"
                                       placeholder="请输入搜索的关键词" />
                            </#if>
                            </div>
                        </div>
                        <div class="form-group " style="margin: 0 0 2% 0">
                            <button type="button" onclick="submitForm()" class="btn btn-info btn-block ">搜索</button>
                        </div>
                        <div>
                            <table class="table" border="0">
                                <tbody>
                                <#if suppliers ??>
                                    <#list suppliers as supplier>
                                        <tr>
                                            <td class="" style="text-align: left"></td>
                                            <td class="" style="text-align: left"></td>
                                            <td class="" style="text-align: left"></td>
                                        </tr>

                                        <tr class="" style="border: 1px solid #c4e3f3;margin: 5% 0 0 0">
                                            <td class="col-md-4">
                                                <a href="/goods/shopIndex?supplierSid=${supplier.sid?c}" >
                                                    <#if supplier.avatar ??>
                                                        <img width="10%" src="${supplier.avatar}" onerror="checkImgFun(this)" class="img-thumbnail"
                                                             style="float: left">
                                                    <#else>
                                                        <img width="10%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail" style="float: left" />
                                                    </#if>
                                                    <span style="float: left;margin: 4.5% 1.5% 0 6%">${supplier.cname}</span>
                                                </a>
                                            </td>
                                            <td class="col-md-2"><span>${supplier.province}
                                                、${supplier.city}、${supplier.area}</span></td>
                                            <td class="col-md-6 col-md-offset-4">
                                                <#if supplier.address ??>
                                                    <span>${supplier.address}</span>
                                                </#if>
                                            </td>
                                        </tr>


                                    </#list>
                                </#if>
                                <#if suppliers?size == 0>
                                    <tr>
                                        <td colspan="6" style="text-align: center">没有相应的供应商记录</td>
                                    </tr>
                                </#if>
                                </tbody>
                            </table>
                        </div>
                        <table data-toggle="table" data-page-info='${pageInfo}'
                               data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}" data-page-list="6,12,24,48">
                            <thead>
                                <tr style="display: none">
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody style="display: none">
                                <tr>
                                    <td>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </form>
                </div>

            </div>
        </div>
    </div>
</div>
<script>
    $(function () {
        var searchProvinceText = $("#searchProvince option:selected").text();
        var areaContent = '';
        if (searchProvinceText == undefined || searchProvinceText == '') {
            areaContent = findAreaByPraentSid(1, null);
            $("#searchProvince").html("<option selected='selected'></option>" + areaContent);
        } else {
            areaContent = findAreaByPraentSid(1, searchProvinceText);
            $("#searchProvince").html("<option></option>" + areaContent);
        }
        var searchProvinceVal = $("#searchProvince option:selected").val();
        var searchCityText = $("#searchCity option:selected").text();
        if (searchProvinceVal != undefined && searchProvinceVal != '') {
            var areaContent = '';
            if (searchCityText == undefined || searchCityText == '') {
                areaContent = findAreaByPraentSid(searchProvinceVal, null);
                $("#searchCity").html("<option selected='selected'></option>" + areaContent);
            } else {
                areaContent = findAreaByPraentSid(searchProvinceVal, searchCityText);
                $("#searchCity").html("<option></option>" + areaContent);
            }
        }
        var searchCityVal = $("#searchCity option:selected").val();
        if (searchCityVal != undefined && searchCityVal != '') {
            var searchAreaText = $("#searchArea option:selected").text();
            var areaContent = '';
            if (searchAreaText == undefined || searchAreaText == '') {
                areaContent = findAreaByPraentSid(searchCityVal, null);
                $("#searchArea").html("<option selected='selected'></option>" + areaContent);
            } else {
                areaContent = findAreaByPraentSid(searchCityVal, searchAreaText);
                $("#searchArea").html("<option></option>" + areaContent);
            }
        }
    });
    function getSearchAllCity(searchProvinceVal) {
        if (searchProvinceVal == undefined || searchProvinceVal == '') {
            $("#searchCity").find('option').remove();
            $("#searchArea").find('option').remove();
            return false;
        }
        var areaContent = findAreaByPraentSid(searchProvinceVal, null);
        $("#searchCity").html("<option selected='selected'></option>" + areaContent);
    }
    function getSearchAllArea(searchCityVal) {
        if (searchCityVal == undefined || searchCityVal == '') {
            $("#searchArea").find('option').remove();
            return false;
        }
        var areaContent = findAreaByPraentSid(searchCityVal, null);
        $("#searchArea").html("<option selected='selected'></option>" + areaContent);
    }
    var findAreaByPraentSid = function (parentSid, tag) {
        var str = '';
        $.ajax({
            type: "GET",
            async: false,
            url: "/supplier/findAreaByPraentSid",
            data: {'parentSid': parentSid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                $.each(result.record, function (index, value) {
                    if (tag == value.cname) {
                        str += "<option value='" + value.sid + "' selected = 'selected'>" + value.cname + "</option>";
                    } else {
                        str += "<option value='" + value.sid + "'>" + value.cname + "</option>";
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
    function submitForm() {
        $("#searchProvince option:selected").val($("#searchProvince option:selected").text());
        $("#searchCity option:selected").val($("#searchCity option:selected").text());
        $("#searchArea option:selected").val($("#searchArea option:selected").text());
        $("#storageIndexForm").submit();
    }

    var checkImgFun = function (img) {
        var checkImg = function (img) {
            if (img.naturalHeight <= 1 && img.naturalWidth <= 1) {
                img.src = '/assets/img/goods/img-goods-default.png';
            }
        };

        try {
            if (img.complete) {
                checkImg(img);
            } else {
                $(img).load(function () {
                    checkImg(this);
                }).error(function () {
                    this.src = '/assets/img/goods/img-goods-default.png';
                });
            }
        } catch (e) {
        }
    };
</script>
</body>
</html>