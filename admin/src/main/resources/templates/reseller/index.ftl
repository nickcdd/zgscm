<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/reseller/index">
    <script type="text/javascript">
        $(function () {


            var $form = $('#detailForm');
            $(document).on('click', '.btn-detail', function () {
                var $t = $(this), sid = $t.data('sid');
                $.getJSON('detail?sid=' + sid, function (result) {
//                    proviceBind();
                    if (result.success) {
                        $('#resellerList').hide();
                        $('#resellerDetail').show();
                        $('#updateTitle').show();
                        $('#addTitle').hide();
                        $('#newPassword').hide();
                        $form.clearForm(true);
                        $form.formJSON('set', result.record);
                        $("#newImg").attr("src", result.record.avatar);
                        setPageInfo();

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
//            $('.btn-confirm').click(function () {
//
//                $.getJSON('remove?sid=' + sid, function (result) {
////
//                    if (result.success) {
//                        $('#infoForm').submit();
//                    } else {
//                        showInfoFun(result.msg);
//                    }
//                });
//            });

            $('.btn-reset').click(function () {
                $form.clearForm(true);
            });
            $('.btn-cancel').click(function () {
//                $form.clearForm(true);
                $form.validate().resetForm();
                $('#resellerList').show();
                $('#resellerDetail').hide();
            });
            $('.btn-add').click(function () {
                $form.clearForm(true);

                $('#resellerList').hide();
                $('#resellerDetail').show();
                $('#addTitle').show();
                $('#updateTitle').hide();
                $('#newPassword').show();
                $('#oldImg').hide();
                setPageInfo();


            });
            $('.btn-search').click(function () {
                $('#page').val("");
                $('#infoForm').submit();

            });
            $('.btn_disable').click(function () {
                var $t = $(this), sid = $t.data('sid');
                $.ajax({
                    type: "POST",
                    url: "/reseller/disable",
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
                    url: "/reseller/enable",
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


            if ($('#q').val() != undefined && $('#q').val() != "") {

                $('#redirectQ').val($('#q').val());
            }

        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="resellerList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">分销商列表</h3>
            </div>


            <div class="box-body">

                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form action="/reseller/index" method="post" class="form-inline" id="infoForm"
                              role="search-form">
                            <input type="hidden" name="page" id="page" value="${pageInfo.page-1}"/>
                            <input type="hidden" name="size"/>


                            <div class="form-group ">
                                <label class="" for="name"> 分销商名称 </label>
                                <div class='input-group'>
                                    <input type='text' name="q" class="form-control" id="q" value="${q}"/>

                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-search"><i
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

                                        <th width="20%">
                                            <div class="th-inner">分销商名称</div>
                                        </th>

                                        <th width="10%">
                                            <div class="th-inner">关联商户数量</div>
                                        </th>
                                        <th width="5%">
                                            <div class="th-inner">状态</div>
                                        </th>
                                        <th width="20%">
                                            <div class="th-inner">操作</div>
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <#list resellers as r>
                                    <tr>

                                        <td style="text-align: center;">${r.cname!''}</td>
                                        <td style="text-align: center;"> <#if r.shopKeeperList?size gt 0>
                                            ${r.shopKeeperList?size}
                                            <#else>
                                            0
                                        </#if></td>
                                        <td style="text-align: center;"><#if r.status == 0>

                                            已禁用
                                        <#elseif r.status == 1>
                                            已启用
                                        <#else>
                                            已删除
                                        </#if></td>
                                        <td style="text-align: center;">
                                            <#if r.status !=-1>
                                                <button type="button" class="btn btn-info btn-xs btn-detail"
                                                        data-sid="${r.sid?c}">
                                                    <i class="fa fa-edit fa-fw"></i> 详情
                                                </button>
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

                                                <@shiro.hasPermission name="reseller:save">
                                                    <#if r.status == 0>
                                                        <button class="btn btn-success btn-xs btn_enable"
                                                                data-sid="${r.sid?c}">
                                                            <i class="fa fa-check fa-fw"></i> 启用
                                                        </button>
                                                    <#else>
                                                        <button class="btn btn-warning btn-xs btn_disable"
                                                                data-sid="${r.sid?c}">
                                                            <i class="fa fa-ban fa-fw"></i> 禁用
                                                        </button>
                                                    </#if>
                                                </@shiro.hasPermission>
                                                <@shiro.hasPermission name="reseller:remove">
                                                    <button type="button" class="btn btn-danger btn-xs btn-remove"
                                                            data-sid="${r.sid?c}">
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
<#-- 显示供应商详情 -->
<#include "/reseller/detail.ftl" />
</div>
</body>
</html>