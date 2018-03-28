<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
<#include "../_head_with_table.ftl" />
</head>
<body>

<div class="nav-tabs-custom">
    <ul class="nav nav-tabs">
        <li class=""><a href="/index">订单</a></li>
        <li class=""><a href="/order/index">采购记录</a></li>
        <li class=""><a href="/shopKeeperCard/index">银行卡管理</a></li>
        <li class=""><a href="/receivingAddress/index">收货地址管理</a></li>
        <li class="active"><a href="#cash_tab" data-toggle="tab" aria-expanded="true">提现记录</a></li>
        <li class=""><a href="/goods/index">商品列表</a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane active" id="cash_tab">
            <div class="row placeholders">
                <div class="col-xs-12 placeholder">
                    <form action="/withdrawApply/index" method="post" class="form-inline" role="form">
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
                            <label class="" for="name">状态</label>
                            <div class="input-group date">
                                <select class="form-control" name="status">
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
                            <button type="submit" class="btn btn-info btn-block ">查找</button>
                        </div>
                        <div class="table-responsive" style="margin-top: 2%">
                            <table class="table table-striped" data-toggle="table" data-page-info='${pageInfo}' data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                <thead>
                                <tr>
                                    <th style="text-align: left">时间</th>
                                    <th style="text-align: left">提现金额</th>
                                    <th style="text-align: left">银行名称</th>
                                    <th style="text-align: left">银行卡尾号</th>
                                    <th style="text-align: left">提现状态</th>
                                    <th style="text-align: left">审核原因</th>
                                </tr>
                                </thead>
                                <tbody id="orderContent">
                                <#if withdrawApplies ??>
                                    <#list withdrawApplies as withdrawApplie>
                                    <tr>
                                        <td class="text-left">${withdrawApplie.createTime}</td>
                                        <td class="text-left">${withdrawApplie.amount}</td>
                                        <td class="text-left">${withdrawApplie.bankName}</td>
                                        <td class="text-left">${withdrawApplie.cardNo}</td>
                                        <#if withdrawApplie.status == 1>
                                            <td class="text-left">待审核</td>
                                            <#elseif withdrawApplie.status == 2>
                                                <td class="text-left">通过</td>
                                            <#elseif withdrawApplie.status == 0>
                                                <td class="text-left">拒绝</td>
                                        </#if>

                                        <td class="text-left">
                                            <#if withdrawApplie.reason??>
                                                        ${withdrawApplie.reason}
                                                    </#if>
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