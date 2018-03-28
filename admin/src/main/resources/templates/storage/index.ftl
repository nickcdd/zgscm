<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_table.ftl" />

    <meta name="nav-url" content="/storage/index">

</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">仓储列表</h3>
            </div>
            <div class="box-body">
                <div>
                    <form class="form-inline" id="storageIndexForm" action="/storage/index">
                        <input type="hidden" name="page" />
                        <input type="hidden" name="size" />
                        <div class="form-group" style="margin: 0 0 2% 0">
                            <label class="" for="name">省</label>
                            <div class="input-group date">
                                <select class="form-control" name="searchProvince" id="searchProvince"
                                        onchange="getSearchAllCity($('#searchProvince option:selected').val())">
                                    <#if searchProvince !="">
                                        <option selected="selected">${searchProvince}</option>
                                    </#if>
                                </select>
                            </div>
                        </div>
                        <div class="form-group " style="margin: 0 0 2% 0">
                            <label class="" for="name">市</label>
                            <div class="input-group date">
                                <select class="form-control" name="searchCity" id="searchCity"
                                        onchange="getSearchAllArea($('#searchCity option:selected').val())">
                                    <#if searchCity!="">
                                        <option selected="selected">${searchCity}</option>
                                    </#if>
                                </select>
                            </div>
                        </div>
                        <div class="form-group " style="margin: 0 0 2% 0">
                            <label class="" for="name">区</label>
                            <div class="input-group date">
                                <select class="form-control" name="searchArea" id="searchArea">
                                    <#if searchArea!="">
                                        <option selected="selected">${searchArea}</option>
                                    </#if>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" style="margin: 0 0 2% 0">
                            <label class="" for="name"> 仓储名称 </label>
                            <div class='input-group'>
                                <input type='text' name="cname" class="form-control" value="${cname}" />
                            </div>
                        </div>
                        <div class="form-group " style="margin: 0 0 2% 0">
                            <label class="" for="name"> 仓储编码 </label>
                            <div class='input-group'>
                                <input type='text' name="code" class="form-control" value="${code}" />
                            </div>
                        </div>
                        <div class="form-group" style="margin: 0 0 2% 0">
                            <button type="button" onclick="submitForm()" class="btn btn-info btn-block btn_search"><i
                                    class="fa  fa-search"></i>查找
                            </button>
                        </div>
                        <div class="form-group " style="margin: 0 0 2% 0">
                            <a href="/storage/add" class="btn btn-info btn-block btn-add"><i class="fa  fa-plus"></i>新增
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
                                   data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                <thead>
                                    <th>
                                        <div class="th-inner">仓储名称</div>
                                    </th>
                                    <th>
                                        <div class="th-inner">仓储编码</div>
                                    </th>
                                    <th>
                                        <div class="th-inner">省、市、区</div>
                                    </th>
                                    <th>
                                        <div class="th-inner">地址</div>
                                    </th>
                                    <th>
                                        <div class="th-inner">联系人</div>
                                    </th>
                                    <th>
                                        <div class="th-inner">联系电话</div>
                                    </th>
                                    <th>
                                        <div class="th-inner">操作</div>
                                    </th>
                                </thead>
                                <tbody>
                                <#if storagePage ??>
                                    <#list storagePage as storage>
                                        <tr>
                                            <td>
                                                <#if storage.cname??>
                                                        ${storage.cname!''}
                                                    </#if>
                                            </td>
                                            <td>
                                                <#if storage.code??>
                                                        ${storage.code!''}
                                                    </#if>
                                            </td>
                                            <td>
                                                <#if storage.province?? && storage.city?? && storage.area??>
                                                        ${storage.province!''} ${storage.city!''} ${storage.area!''}
                                                    </#if>
                                            </td>
                                            <td>
                                                <#if storage.address??>
                                                        ${storage.address!''}
                                                    </#if>
                                            </td>
                                            <td>
                                                <#if storage.realName??>
                                                        ${storage.realName!''}
                                                    </#if>
                                            </td>
                                            <td>
                                                <#if storage.telephone??>
                                                        ${storage.telephone!''}
                                                    </#if>
                                            </td>
                                            <td>
                                                <@shiro.hasPermission name="storage:save">
                                                    <a href="/storage/detail?sid=${storage.sid?c}" class="btn btn-info btn-xs">
                                                        <i class="fa fa-edit fa-fw"></i> 详情
                                                    </a>
                                                </@shiro.hasPermission>
                                                <@shiro.hasPermission name="storage:remove">
                                                    <button type="button" class="btn btn-danger btn-xs btn-remove"
                                                            data-sid="${storage.sid?c}">
                                                        <i class="fa fa-remove fa-fw"></i> 删除
                                                    </button>
                                                </@shiro.hasPermission>
                                            </td>
                                        </tr>
                                    </#list>
                                </#if>
                                </tbody>
                            </table>
                        </div>
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
        $(document).on('click','.btn-remove',function () {
            var $t = $(this), sid = $t.data('sid');
            confirmFun('/storage/remove?sid=' + sid, '确认删除？');
        });
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
        $("#storageIndexForm").submit();
    }
</script>
</body>
</html>