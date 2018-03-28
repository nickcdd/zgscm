<!DOCTYPE html>
<html>
<head>
<#include "_head_with_datepicker.ftl" />
<#include "_head_with_table.ftl" />
</head>
<body>

<div class="nav-tabs-custom">
    <ul class="nav nav-tabs">
        <li class="active"><a href="#rebate_tab" data-toggle="tab" aria-expanded="true">返利记录</a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane active" id="rebate_tab" style="width: 50%">
            <div class="row placeholders">
                <div class="col-xs-12 placeholder">
                    <form action="/rebate/index" method="post" class="form-inline" role="form">
                        <input type="hidden" name="page" />
                        <input type="hidden" name="size" />
                        <div class="form-group">
                            <label class="" for="name">日期</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-calendar"></i>
                                </div>
                                <input type="text" id="startTime" name="startTime" class="form-control pull-right" id="datepicker_start" value="${startTime}">
                            </div>
                        </div>
                        <div class="form-group ">
                            <label class="" for="name"> 至 </label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-calendar"></i>
                                </div>
                                <input type="text" id="endTime" name="endTime" class="form-control pull-right" id="datepicker_end" value="${endTime}">
                            </div>
                        </div>
                        <div class="form-group ">
                            <button type="submit" class="btn btn-info btn-block ">查找</button>
                        </div>
                        <div class="table-responsive" style="margin-top: 2%">
                            <table class="table table-striped" data-toggle="table" data-page-info='${pageInfo}' data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                <thead>
                                <tr>
                                    <th class="text-left">时间</th>
                                    <th class="text-left">返利金额</th>
                                </tr>
                                </thead>
                                <tbody id="orderContent">
                                <#if resellerRebates ??>
                                    <#list resellerRebates as resellerRebate>
                                    <tr>
                                        <td class="text-left">${resellerRebate.createTime}</td>
                                        <td class="text-left">${resellerRebate.amount}</td>
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

        var picker1 = $('#startTime').datetimepicker();
        var picker2 = $("#endTime").datetimepicker();

        //动态设置最小值(后面一个日期不能小于前面一个)
        picker1.on('changeDate', function (e) {
            picker2.datetimepicker('setStartDate', e.date);
        });
        //动态设置最大值
        picker2.on('changeDate', function (e) {
            picker1.datetimepicker('setEndDate', e.date);
        });

    });

</script>
</body>
</html>