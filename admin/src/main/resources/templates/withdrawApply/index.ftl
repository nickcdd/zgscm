<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
<#include "/_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/withdrawApply/index">
    <script type="text/javascript">
        $(function () {
            var picker1 = $('#datetimepicker1').datetimepicker({
                format: "yyyy-mm-dd hh:ii",
                language: 'zh-CN',
                autoclose: true,
                pickerPosition: "bottom-left"
                //minDate: '2016-7-1'
            });
            var picker2 = $('#datetimepicker2').datetimepicker({
                format: "yyyy-mm-dd hh:ii",
                language: 'zh-CN',
                autoclose: true,
                pickerPosition: "bottom-left"
            });
            //动态设置最小值
            picker1.on('changeDate', function (e) {
//                alert(e.date);
//                picker2.data('DateTimePicker').minDate(e.date);
                picker2.datetimepicker('setStartDate', e.date);
            });
            //动态设置最大值
            picker2.on('changeDate', function (e) {
//                picker1.data('DateTimePicker').maxDate(e.date);
                picker1.datetimepicker('setEndDate', e.date);
//                alert(e.date);
            });
            var $form = $('#detailForm');
            $(document).on('click', '.btn-detail', function () {
                var $t = $(this), sid = $t.data('sid');
                $.getJSON('detail?sid=' + sid, function (result) {
                    if (result.success) {
                        $('#supplierList').hide();
                        $('#supplierDetail').show();
                        $form.clearForm(true);
                        $form.formJSON('set', result.record);
                        var statusStr = "";
                        if (result.record.status == 1) {
                            statusStr = "<option value='2' >通过</option><option value='0'>不通过</option>";
                            $('#detailStatus').removeAttr("readonly");
                            $('#reason').removeAttr("readonly");
                            $('#saveBtn').show();
                        } else if (result.record.status == 0) {
                            statusStr = "<option value='0' selected='selected'>不通过</option>";
                            $('#detailStatus').attr("readonly", "readonly");
                            $('#reason').attr("readonly", "readonly");
                            $('#saveBtn').hide();
                        } else if (result.record.status == 2) {
                            statusStr = "<option value='2' selected='selected'>通过</option>";
                            $('#detailStatus').attr("readonly", "readonly");
                            $('#reason').attr("readonly", "readonly");
                            $('#saveBtn').hide();
                        }
                        $('#detailStatus').html(statusStr);
                        setPageInfo();

                    } else {
                        showInfoFun(result.msg);
                    }
                });
            });
            //导出
            $('.btn-export').click(function () {
                exportExecl();
            });
            //取消
            $('.btn-cancel').click(function () {
                $form.clearForm(true);
                $('#supplierList').show();
                $('#supplierDetail').hide();
            });

            $form.submit(function () {
                if ($form.valid()) {
                    var data = $form.formJSON('get');


                }

                return true;
            });

            $form.clearForm(true);
        });

        function exportExecl() {
//            alert($('#startDate').val());
            $('#exportQ').val($('#q').val());
            $('#exportStartDate').val($('#startDate').val());
            $('#exportEndDate').val($('#endDate').val());
            $('#exportState').val($('#status').val());
            $('#exportForm').submit();
        }
        function setPageInfo() {

            $('#redirectPage').val($('#infoTable').attr("data-page-number") - 1);
            $('#redirectSize').val($('#infoTable').attr("data-page-size"));
            $('#redirectStatus').val($('#status').val())
            if ($('#startDate').val() != undefined && $('#startDate').val() != "") {

                $('#redirectStartDate').val($('#startDate').val());
            }
            if ($('#endDate').val() != undefined && $('#endDate').val() != "") {

                $('#redirectEndDate').val($('#endDate').val());
            }

            if ($('#q').val() != undefined && $('#q').val() != "") {

                $('#redirectQ').val($('#q').val());
            }

        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">提现申请</h3>
            </div>
            <div class="box-body">
                <form id="exportForm" action="/withdrawApply/export" method="post">
                    <input type="hidden" name="exportQ" id="exportQ"/>
                    <input type="hidden" name="exportStartDate" id="exportStartDate"/>
                    <input type="hidden" name="exportEndDate" id="exportEndDate"/>
                    <input type="hidden" name="exportState" id="exportState"/>
                </form>

                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form action="/withdrawApply/index" method="post" class="form-inline" role="search-form">
                            <input type="hidden" name="page"/>
                            <input type="hidden" name="size"/>

                            <div class="form-group">
                                <label class="" for="name">日期</label>
                                <div class='input-group date' id='datetimepicker1'>
                                    <input type='text' name="startDate" class="form-control" id="startDate"
                                           value="${startDate}" readonly/>
                                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
                                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-remove"></span>
                </span>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 至 </label>
                                <div class='input-group date' id='datetimepicker2'>
                                    <input type='text' name="endDate" class="form-control" id="endDate"
                                           value="${endDate}" readonly/>

                                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
                                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-remove"></span>
                </span>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 商户名称 </label>
                                <div class='input-group'>
                                    <input type='text' name="q" class="form-control" id="q" value="${q}"/>

                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">状态</label>
                                <div class="input-group date">
                                    <select class="form-control" name="status" id="status">
                                    <#if status == 1>
                                        <option selected="selected" value="1">待审核</option>
                                        <option value="0">拒绝</option>
                                        <option value="2">通过</option>
                                    <#elseif status == 0>
                                        <option selected="selected" value="0">拒绝</option>
                                        <option value="1">待审核</option>
                                        <option value="2">通过</option>
                                    <#else>
                                        <option selected="selected" value="2">通过</option>
                                        <option value="0">拒绝</option>
                                        <option value="1">待审核</option>
                                    </#if>


                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="submit" class="btn btn-info btn-block "><i class="fa  fa-search"></i>查找
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-export"><i
                                        class="fa  fa-file-excel-o"></i>导出excel
                                </button>
                            </div>

                            <div class="table-responsive" style="margin-top: 2%">
                                <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
                                       data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                    <thead>
                                    <tr>
                                        <th width="20%">
                                            <div class="th-inner">商户名称</div>
                                        </th>
                                        <th width="20%">
                                            <div class="th-inner">提现金额</div>
                                        </th>
                                        <th width="20%">
                                            <div class="th-inner">申请时间</div>
                                        </th>
                                        <th width="20%">
                                            <div class="th-inner">申请状态</div>
                                        </th>

                                        <th width="20%">
                                            <div class="th-inner">操作</div>
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <#list withdrawApplys as w>
                                    <tr>
                                        <td style="text-align: center;">${w.shopKeeperCname!''}</td>
                                        <td style="text-align: center;">${w.amount!''}</td>
                                        <td style="text-align: left;">${w.createTime?string("yyyy-MM-dd HH:mm:ss")!''}</td>

                                        <td style="text-align: center;"><#if w.status==1>
                                            待审核
                                        <#elseif w.status==0>
                                            审核未通过
                                        <#elseif w.status==2>
                                            审核通过
                                        <#else>
                                            删除
                                        </#if></td>
                                        <td style="text-align: center;">
                                            <button type="button" class="btn btn-info btn-xs btn-detail"
                                                    data-sid="${w.sid?c}">
                                                <i class="fa fa-edit fa-fw"></i><#if w.status==1>
                                                审核
                                            <#else>
                                                详情
                                            </#if>
                                            </button>

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

<#-- 显示提现申请详情 -->
<#include "/withdrawApply/detail.ftl" />
</div>
</body>
</html>