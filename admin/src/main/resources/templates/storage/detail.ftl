<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
<#include "../_flash.ftl" />
    <meta name="nav-url" content="/storage/detail">
</head>
<body>
<div class="row">
    <div class="col-md-12">
        <div class="box box-primary" style="padding:0% 10% 10% 10%">
            <div class="box-header with-border" style="margin:0 0 2% 0">
                <h3 class="box-title">仓储详情</h3>
            </div>
            <div class="box-body">
                <div>
                    <form id="updateStorage" action="/storage/save" method="post" data-toggle="validator" role="form">
                        <input type="hidden" class="form-control" id="sid" name="sid" value="${storage.sid}" />
                        <div class="form-group has-feedback row">
                            <label for="password" class="col-sm-3 control-label text-right">仓储名称</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="cname" name="cname" value="${storage.cname}" required />
                            </div>
                        </div>
                        <div class="form-group has-feedback row">
                            <label for="password" class="col-sm-3 control-label text-right">仓储编码</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="code" name="code" readonly value="${storage.code}" />
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="Province" class="col-sm-3 control-label text-right"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;省</label>
                            <div class="col-sm-2">
                                <select class="form-control" name="province" id="searchProvince"
                                        onchange="getSearchAllCity($('#searchProvince option:selected').val())"
                                        required="required">
                                    <#if storage.province ??>
                                        <option selected="selected">${storage.province}</option>
                                    </#if>
                                </select>
                            </div>
                            <label for="City" class="col-sm-1 control-label text-right"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;市</label>
                            <div class="col-sm-2">
                                <select class="form-control" name="city" id="searchCity"
                                        onchange="getSearchAllArea($('#searchCity option:selected').val())"
                                        required="required">
                                    <#if storage.province ??>
                                        <option selected="city">${storage.city}</option>
                                    </#if>
                                </select>
                            </div>
                            <label for="Village" class="col-sm-2 control-label text-right"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;区/县</label>
                            <div class="col-sm-2">
                                <select class="form-control" name="area" id="searchArea" required="required">
                                    <#if storage.area ??>
                                        <option selected="city">${storage.area}</option>
                                    </#if>
                                </select>
                            </div>
                        </div>
                        <div class="form-group has-feedback row">
                            <label for="password" class="col-sm-3 control-label text-right">详细地址</label>
                            <div class="col-sm-9">
                                <#if storage.address ??>
                                    <input type="text" class="form-control" id="address" name="address" value="${storage.address}" />
                                <#else >
                                    <input type="text" class="form-control" id="address" name="address"  />
                                </#if>
                            </div>
                        </div>
                        <div class="form-group has-feedback row">
                            <label for="password" class="col-sm-3 control-label text-right">联系人</label>
                            <div class="col-sm-9">
                                <#if storage.realName ??>
                                    <input type="text" class="form-control" id="realName" name="realName" value="${storage.realName}" />
                                <#else >
                                    <input type="text" class="form-control" id="realName" name="realName" />
                                </#if>
                            </div>
                        </div>
                        <div class="form-group has-feedback row">
                            <label for="password" class="col-sm-3 control-label text-right">联系电话</label>
                            <div class="col-sm-9">
                                <#if storage.telephone ??>
                                    <input type="text" class="form-control" id="telephone" name="telephone" value="${storage.telephone}" />
                                <#else >
                                    <input type="text" class="form-control" id="telephone" name="telephone" />
                                </#if>
                            </div>
                        </div>
                    <@shiro.hasPermission name="shopKeeper:save">
                        <div class="box-footer">
                            <a href="javascript:history.go(-1)" class="btn btn-danger pull-right btn-cancel">
                                <i class="fa fa-close"></i> 取消
                            </a>
                            <button type="button" onclick="submitForm()" class="btn btn-primary pull-right" id="submitButton" >
                                <i class="fa fa-save"></i> 保存
                            </button>
                            <button type="reset" class="btn btn-info pull-right btn-reset">
                                <i class="fa fa-eraser"></i> 重置
                            </button>
                        </div>
                    </@shiro.hasPermission>
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
        if(searchProvinceText == undefined || searchProvinceText == ''){
            areaContent = findAreaByPraentSid(1,null);
            $("#searchProvince").html("<option selected='selected'></option>"+areaContent);
        }else {
            areaContent = findAreaByPraentSid(1,searchProvinceText);
            $("#searchProvince").html("<option></option>"+areaContent);
        }
        var searchProvinceVal = $("#searchProvince option:selected").val();
        var searchCityText = $("#searchCity option:selected").text();
        if(searchProvinceVal != undefined && searchProvinceVal != ''){
            var areaContent = '';
            if(searchCityText == undefined || searchCityText == ''){
                areaContent = findAreaByPraentSid(searchProvinceVal,null);
                $("#searchCity").html("<option selected='selected'></option>"+areaContent);
            }else {
                areaContent = findAreaByPraentSid(searchProvinceVal,searchCityText);
                $("#searchCity").html("<option></option>"+areaContent);
            }
        }
        var searchCityVal = $("#searchCity option:selected").val();
        if(searchCityVal != undefined && searchCityVal != ''){
            var searchAreaText = $("#searchArea option:selected").text();
            var areaContent = '';
            if(searchAreaText == undefined || searchAreaText == ''){
                areaContent = findAreaByPraentSid(searchCityVal,null);
                $("#searchArea").html("<option selected='selected'></option>"+areaContent);
            }else {
                areaContent = findAreaByPraentSid(searchCityVal,searchAreaText);
                $("#searchArea").html("<option></option>"+areaContent);
            }
        }
    });
    function getSearchAllCity(searchProvinceVal){
        if(searchProvinceVal == undefined || searchProvinceVal == ''){
            $("#searchCity").find('option').remove();
            $("#searchArea").find('option').remove();
            return false;
        }
        var areaContent = findAreaByPraentSid(searchProvinceVal,null);
        $("#searchCity").html("<option selected='selected'></option>"+areaContent);
    }
    function getSearchAllArea(searchCityVal){
        if(searchCityVal == undefined || searchCityVal == ''){
            $("#searchArea").find('option').remove();
            return false;
        }
        var areaContent = findAreaByPraentSid(searchCityVal,null);
        $("#searchArea").html("<option selected='selected'></option>"+areaContent);
    }
    var findAreaByPraentSid = function (parentSid,tag) {
        var str = '';
        $.ajax({
            type: "GET",
            async: false,
            url : "/storage/findAreaByPraentSid",
            data: {'parentSid' : parentSid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                $.each(result.record, function (index, value) {
                    if(tag == value.cname){
                        str +="<option value='"+value.sid+"' selected = 'selected'>"+value.cname+"</option>";
                    }else {
                        str +="<option value='"+value.sid+"'>"+value.cname+"</option>";
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
        var $form = $('#updateStorage');
        if ($form.valid()) {
            var data = $form.formJSON('get');
            if ($('#searchProvince option:selected').text() == "") {
                showInfoFun('请选择一个省。', 'warning');
                return false;
            }
            if ($('#searchCity option:selected').text() == "") {
                showInfoFun('请选择一个市。', 'warning');
                return false;
            }
            if ($('#searchArea option:selected').text() == "") {
                showInfoFun('请选择一个区/县。', 'warning');
                return false;
            }
            $("#submitButton").attr("disabled",true);
        }
        $("#updateStorage").submit();
    }
</script>
</body>
</html>