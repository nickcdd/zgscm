<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/shopKeeper/index">
    <script type="text/javascript">
        $(function () {

            intiSearchArea(true);
            var $form = $('#detailForm');
            $(document).on('click', '.btn-detail', function () {
                var $t = $(this), sid = $t.data('sid');
                $.getJSON('detail?sid=' + sid, function (result) {
//                    proviceBind();
                    if (result.success) {
                        $('#supplierList').hide();
                        $('#supplierDetail').show();
                        $('#updateTitle').show();
                        $('#addTitle').hide();
                        $('#newImg').show();
                        $('#oldImg').show();
                        $('#newPassword').hide();
                        $form.clearForm(true);
                        $form.formJSON('set', result.record);
                        setPageInfo();
                        var province = result.record.province;
                        var city = result.record.city;
                        var area = result.record.area;
                        var provinceStr = "<option value=" + province.split(",")[0] + " selected>" + province.split(",")[1] + "</option>";
                        var cityStr = "<option value=" + city.split(",")[0] + " selected>" + city.split(",")[1] + "</option>";
                        var areaStr = "<option value=" + area.split(",")[0] + " selected>" + area.split(",")[1] + "</option>";
                        var levelStr = ""
//                        if (result.record.level == 0) {
//                            levelStr = "<option value='0' selected> 基础商户</option><option value='1' > 标准商户</option>";
//                        } else {
//                            levelStr = "<option value='0' > 基础商户</option><option value='1' selected> 标准商户</option>";
//                        }
//                        $('#level').html(levelStr);
                        $("#province").html(provinceStr);
                        $("#city").html(cityStr);
                        $("#area").html(areaStr);
                        $("#newImg").attr("src", result.record.avatar);
                        intiArea(false);
                    } else {
                        showInfoFun(result.msg);
                    }
                });
            });

            $(document).on('click', '.btn-remove', function () {
                var $t = $(this), sid = $t.data('sid');
                $('#confirmModal').modal('show');
//                confirmFun('remove?sid=' + sid, '该操作将无法撤消，是否继续？');
                $('.btn-confirm').click(function () {

                    $.getJSON('remove?sid=' + sid, function (result) {
//
                        if (result.success) {
                            $('#infoForm').submit();
                        } else {
                            showInfoFun(result.msg);
                        }
                    });
                });
            });

            $('.btn-reset').click(function () {
                $form.clearForm(true);
            });
            $('.btn-cancel').click(function () {
//                $form.clearForm(true);
                $form.validate().resetForm();
                $('#supplierList').show();
                $('#supplierDetail').hide();
            });
            $('.btn-add').click(function () {
                $form.clearForm(true);
                $("#province").find("option").remove();
                $("#city").find("option").remove();
                $("#area").find("option").remove();
                $('#supplierList').hide();
                $('#supplierDetail').show();
                $('#addTitle').show();
                $('#updateTitle').hide();
                $('#newImg').show();
                $('#oldImg').hide();
                $('#newPassword').show();
//                var levelStr = "<option value='0' selected> 基础商户</option><option value='1' > 标准商户</option>";
//                $('#level').html(levelStr);
                setPageInfo();
                intiArea(true);

            });
            $('.btn_search').click(function () {
                $('#page').val("");
                $('#infoForm').submit();

            });
            $('.btn_disable').click(function () {
                var $t = $(this), sid = $t.data('sid');
                $.ajax({
                    type: "POST",
                    url: "/shopKeeper/disable",
                    data: {"sid": sid},
                    dataType: "JSON",
                    async: false,
                    success: function (result) {
                        if (result.success) {

                            $('#infoForm').submit();
                        } else {
                            showInfoFun(result.msg);
                        }

                    },
                    error: function () {

                    }
                });
//                alert("禁用"+sid);
//                $.getJSON('disable?sid=' + sid, function (result) {
////
//                    if (result.success) {
////                    $('#infoForm').submit();
//                    } else {
//                        showInfoFun(result.msg);
//                    }
//                });
            });
            $('.btn_enable').click(function () {
                var $t = $(this), sid = $t.data('sid');
                $.ajax({
                    type: "POST",
                    url: "/shopKeeper/enable",
                    data: {"sid": sid},
                    dataType: "JSON",
                    async: false,
                    success: function (result) {
                        if (result.success) {
                            $('#infoForm').submit();

                        } else {
                            showInfoFun(result.msg);
                        }

                    },
                    error: function () {

                    }
                });
//                alert("启用"+sid);
//                $.getJSON('enable?sid=' + sid, function (result) {
////
//                    if (result.success) {
////                        $('#infoForm').submit();
//                    } else {
//                        showInfoFun(result.msg);
//                    }
//                });
            });


            $form.submit(function () {

                if ($form.valid()) {
                    var data = $form.formJSON('get');
//                alert("校验通过");
                    $('#commitButton').attr("disabled", "disabled");
                } else {
//                    $('#commitButton').removeAttr("disabled");
//                   alert("校验不通过");
                }

                return true;
            });

            $form.clearForm(true);


        });
        function setPageInfo() {

            $('#redirectPage').val($('#infoTable').attr("data-page-number") - 1);
            $('#redirectSize').val($('#infoTable').attr("data-page-size"));

            if ($('#searchProvince').val() != undefined && $('#searchProvince').val() != "") {

                $('#redirectProvince').val($('#searchProvince').val());
            }
            if ($('#searchCity').val() != undefined && $('#searchCity').val() != "") {

                $('#redirectCity').val($('#searchCity').val());
            }
            if ($('#searchArea').val() != undefined && $('#searchArea').val() != "") {

                $('#redirectArea').val($('#searchArea').val());
            }
            if ($('#q').val() != undefined && $('#q').val() != "") {

                $('#redirectQ').val($('#q').val());
            }

        }
        function setResellerPageInfo() {

            $('#resellerPage').val($('#infoTable').attr("data-page-number") - 1);
            $('#resellerSize').val($('#infoTable').attr("data-page-size"));

            if ($('#searchProvince').val() != undefined && $('#searchProvince').val() != "") {

                $('#resellerProvince').val($('#searchProvince').val());
            }
            if ($('#searchCity').val() != undefined && $('#searchCity').val() != "") {

                $('#resellerCity').val($('#searchCity').val());
            }
            if ($('#searchArea').val() != undefined && $('#searchArea').val() != "") {

                $('#resellerArea').val($('#searchArea').val());
            }
            if ($('#q').val() != undefined && $('#q').val() != "") {

                $('#resellerQ').val($('#q').val());
            }

        }
        function searchReseller(obj){
//            alert($(obj).data('sid'));
            $('#shopKeeperSid').val($(obj).data('sid'));
            setResellerPageInfo();
            $('#resellerForm').submit();

        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">商户列表</h3>
            </div>


            <div class="box-body">

                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form action="/shopKeeper/index" method="post" class="form-inline" id="infoForm"
                              role="search-form">
                            <input type="hidden" name="page" id="page" value="${pageInfo.page-1}"/>
                            <input type="hidden" name="size"/>


                            <div class="form-group ">
                                <label class="" for="name">省</label>
                                <div class="input-group date">
                                    <select class="form-control" name="searchProvince" id="searchProvince"
                                            onchange="getSearchAllCity($('#searchProvince option:selected').val(),$('#searchCity option:selected').val())">

                                    <#if searchProvince!="">
                                        <option value="${searchProvince?split(",")[0]}"
                                                selected="selected">${searchProvince?split(",")[1]}</option>
                                    </#if>


                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">市</label>
                                <div class="input-group date">
                                    <select class="form-control" name="searchCity" id="searchCity"
                                            onchange="getSearchAllArea($('#searchCity option:selected').val(),$('#searchArea option:selected').val())">
                                    <#if searchCity!="">
                                        <option value="${searchCity?split(",")[0]}"
                                                selected="selected">${searchCity?split(",")[1]}</option>
                                    </#if>

                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">区</label>
                                <div class="input-group date">
                                    <select class="form-control" name="searchArea" id="searchArea">
                                    <#if searchArea!="">
                                        <option value="${searchArea?split(",")[0]}"
                                                selected="selected">${searchArea?split(",")[1]}</option>
                                    </#if>

                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 商户名称 </label>
                                <div class='input-group'>
                                    <input type='text' name="q" class="form-control" id="q" value="${q}"/>

                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn_search"><i
                                        class="fa  fa-search"></i>查找
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-add"><i class="fa  fa-plus"></i>新增
                                </button>
                            </div>
                            <div class="table-responsive" style="margin-top: 2%">
                                <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
                                       data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                    <thead>
                                    <tr>
                                        <th width="5%">
                                            <div class="th-inner">头像</div>
                                        </th>
                                        <th width="20%">
                                            <div class="th-inner">商户名称</div>
                                        </th>
                                        <th width="5%">
                                            <div class="th-inner">省、市、区</div>
                                        </th>
                                        <th width="25%">
                                            <div class="th-inner">地址</div>
                                        </th>
                                        <#--<th width="5%">-->
                                            <#--<div class="th-inner">现金金额</div>-->
                                        <#--</th>-->
                                        <#--<th width="5%">-->
                                            <#--<div class="th-inner">冻结金额</div>-->
                                        <#--</th>-->
                                        <#--<th width="5%">-->
                                            <#--<div class="th-inner">采购余额</div>-->
                                        <#--</th>-->
                                        <th width="5%">
                                            <div class="th-inner">状态</div>
                                        </th>
                                        <th width="20%">
                                            <div class="th-inner">操作</div>
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <#list shopKeepers as s>
                                    <tr>
                                        <td style="text-align: center;"><img class="img-circle" src="${s.avatar!''}"
                                                                             alt="头像" height="40" width="40"/></td>
                                        <td style="text-align: center;">${s.cname!''}</td>
                                        <td style="text-align: center;">${s.province!''}  ${s.city!''}  ${s.area!''}</td>
                                        <td style="text-align: center;">${s.address!''}</td>
                                        <#--<td style="text-align: center;">${s.balance!''}</td>-->
                                        <#--<td style="text-align: center;">${s.frozenBalance!''}</td>-->
                                        <#--<td style="text-align: center;">${s.credit!''}</td>-->
                                        <td style="text-align: center;"><#if s.status == 0>

                                            已禁用
                                        <#elseif s.status == 1>
                                            已启用
                                        <#else>
                                            已删除
                                        </#if></td>
                                        <td style="text-align: center;">
                                            <#if s.status != -1>
                                                <button type="button" class="btn btn-info btn-xs btn-detail"
                                                        data-sid="${s.sid?c}">
                                                    <i class="fa fa-edit fa-fw"></i> 详情
                                                </button>
                                                <@shiro.hasPermission name="shopKeeper:editReseller">
                                                <button type="button" class="btn btn-info btn-xs btn-reseller"
                                                        data-sid="${s.sid?c}" onclick="searchReseller(this)" >
                                                    <i class="fa fa-edit fa-fw"></i> 分销商
                                                </button>
                                                </@shiro.hasPermission>
                                            <#--<@shiro.hasPermission name="shopKeeper:save">-->
                                            <#--<#if s.status == 0>-->
                                            <#--<a class="btn btn-success btn-xs" href="enable?sid=${s.sid?c}">-->
                                            <#--<i class="fa fa-check fa-fw"></i> 启用-->
                                            <#--</a>-->
                                            <#--<#else>-->
                                            <#--<a class="btn btn-warning btn-xs" href="disable?sid=${s.sid?c}">-->
                                            <#--<i class="fa fa-ban fa-fw"></i> 禁用-->
                                            <#--</a>-->
                                            <#--</#if>-->
                                            <#--</@shiro.hasPermission>-->
                                                <@shiro.hasPermission name="shopKeeper:save">
                                                    <#if s.status == 0>
                                                        <button class="btn btn-success btn-xs btn_enable"
                                                                data-sid="${s.sid?c}">
                                                            <i class="fa fa-check fa-fw"></i> 启用
                                                        </button>
                                                    <#else>
                                                        <button class="btn btn-warning btn-xs btn_disable"
                                                                data-sid="${s.sid?c}">
                                                            <i class="fa fa-ban fa-fw"></i> 禁用
                                                        </button>
                                                    </#if>
                                                </@shiro.hasPermission>
                                                <@shiro.hasPermission name="shopKeeper:remove">
                                                    <button type="button" class="btn btn-danger btn-xs btn-remove"
                                                            data-sid="${s.sid?c}">
                                                        <i class="fa fa-edit fa-fw"></i> 删除
                                                    </button>
                                                </@shiro.hasPermission>
                                            </#if>
                                        </td>
                                    </tr>
                                    </#list>
                                    </tbody>
                                </table>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel"></h4>
                </div>
                <div class="modal-body">
                    是否确认删除？
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">否</button>
                    <button type="button" class="btn btn-primary btn-confirm">是</button>
                </div>
            </div>
        </div>
    </div>
    <form id="resellerForm" class="form-horizontal" method="post" action="resellerInfo"
          role="form">
        <input type="hidden" name="shopKeeperSid" id="shopKeeperSid"/>
        <input type="hidden" name="resellerSize" id="resellerSize"/>
        <input type="hidden" name="resellerPage" id="resellerPage"/>
        <input type="hidden" name="resellerQ" id="resellerQ"/>
        <input type="hidden" name="resellerProvince" id="resellerProvince"/>
        <input type="hidden" name="resellerCity" id="resellerCity"/>
        <input type="hidden" name="resellerArea" id="resellerArea"/>
    </form>
<#-- 显示供应商详情 -->
<#include "/shopKeeper/detail.ftl" />
</div>
</body>
</html>