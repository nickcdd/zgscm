<!DOCTYPE html>
<html>
<head>
<#include "_head_with_datepicker.ftl" />
</head>
<body>

<div class="nav-tabs-custom">
    <ul class="nav nav-tabs">
        <li class="active"><a href="#order_tab" data-toggle="tab" aria-expanded="true">订单</a></li>
        <li class=""><a href="/order/index">采购记录</a></li>
        <li class=""><a href="/shopKeeperCard/index">银行卡管理</a></li>
        <li class=""><a href="/receivingAddress/index">收货地址管理</a></li>
        <li class=""><a href="/withdrawApply/index  ">提现记录</a></li>
        <li class=""><a href="/goods/index">商品列表</a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane active" id="order_tab">
            <div class="row placeholders">
                <div class="col-xs-12 placeholder">
                    <form class="form-inline" role="form">
                        <div class="form-group">
                            <label class="" for="name">日期</label>
                            <div class="input-group date">
                                <div class="input-group-addon">
                                    <i class="fa fa-calendar"></i>
                                </div>
                                <input type="text" id="startTime" class="form-control pull-right" id="datepicker_start">
                            </div>
                        </div>
                        <div class="form-group ">
                            <label class="" for="name"> 至 </label>
                            <div class="input-group date">
                                <div class="input-group-addon">
                                    <i class="fa fa-calendar"></i>
                                </div>
                                <input type="text" id="endTime" class="form-control pull-right form_datetime"
                                       id="datepicker_end">
                            </div>
                        </div>
                        <div class="form-group ">
                            <input type="text" onkeyup="this.value=this.value.replace(/\D/g,'')"
                                   onafterpaste="this.value=this.value.replace(/\D/g,'')" class="form-control"
                                   id="logisticsNo" placeholder="订单号">
                        </div>
                        <div class="form-group ">
                            <button type="button" class="btn btn-info btn-block" onclick="submitShowOrder()">
                                查找
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="table-responsive" style="margin-top: 2%">
                <table class="table table-striped table-hover table-bordered">
                    <thead>
                    <tr>
                        <th style="text-align: left">时间</th>
                        <th style="text-align: left">订单编号</th>
                        <th style="text-align: left">订单状态</th>
                        <th style="text-align: left">订单金额</th>
                    </tr>
                    </thead>
                    <tbody id="orderContent">
                    </tbody>
                </table>

                <div id="pageInfo" style="">
                </div>
            </div>
        </div>
        <!-- /.tab-pane -->
        <div class="tab-pane" id="tab_2">
            <div class="box-header with-border">
                <div class="row">
                    <div class="col-xs-2">
                        <button type="submit" class="btn btn-primary btn-block" data-toggle="modal"
                                data-target="#onlyAddBank_modal">添加银行卡
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <!-- 收获地址管理 -->
        <div class="tab-pane" id="tab_3">

        </div>
        <!-- /.tab-pane -->
    </div>
    <!-- /.tab-content -->
</div>

<script>
    $(function () {
        var picker1 = $('#startTime').datetimepicker();
        var picker2 = $("#endTime").datetimepicker();

        //动态设置最小值
        picker1.on('changeDate', function (e) {
            picker2.datetimepicker('setStartDate', e.date);
        });
        //动态设置最大值
        picker2.on('changeDate', function (e) {
            picker1.datetimepicker('setEndDate', e.date);
        });
    });

    function submitShowOrder() {
        showOrders(0);
    }
    $(function () {
        showOrders(0);
    });
    function showOrders(page) {
        // alert($("#startTime").val());
        $.ajax({
            type: "Get",
            dateType: "JSON",
            url: "/order/gatheringOrders",
            contentType: "application/json; charset=utf-8",
            data: {
                "page": page,
                "startTime": $("#startTime").val(),
                "endTime": $("#endTime").val(),
                "logisticsNo": $("#logisticsNo").val()
            },
            success: function (result) {
                var pageStr = "", str = "";
                var pageNumber = parseInt(result.record.number);
                pageStr += "<span class='pagination-info'> 第" + (pageNumber + 1) + "页&nbsp&nbsp&nbsp";
                if (pageNumber > 0) {
                    pageStr += "<button class='btn btn-info'  onclick='showOrders(" + (pageNumber - 1) + ")'>上一页</button>";
                }

                if (result.record.totalPages > (result.record.number + 1)) {
                    $("#testDateStr").html(startTime);
                    pageStr += "　<button class='btn btn-info'  onclick='showOrders(" + (pageNumber + 1) + ")'>下一页</button>";
                }
                pageStr += "&nbsp&nbsp 共 &nbsp " + result.record.totalPages + " &nbsp页</span>";

                if (result.record.totalPages == 0) {
                    $("#pageInfo").html("未查询到订单数据");
                } else {
                    $("#pageInfo").html(pageStr);
                }


                $.each(result.record.content, function (index, value) {
                    str += "<tr><td class='text-left'>" + dateConversionResult(value.updateTime) + "</td>";
                    str += "<td class='text-left'>" + value.sid + "</td>";
                    if (value.status == 1) {
                        str += "<td class='text-left'>待付款</td>"
                    } else if (value.status == 2) {
                        str += "<td class='text-left'>已收款</td>"
                    } else if (value.status == 3) {
                        str += "<td class='text-left'>已发货</td>"
                    } else if (value.status == 4) {
                        str += "<td class='text-left'>已收货</td>"
                    } else if (value.status == 5) {
                        str += "<td class='text-left'>待退款</td>"
                    } else if (value.status == 6) {
                        str += "<td class='text-left'>已退款</td>"
                    }
                    str += "<td class='text-left'>" + value.payAmount + "</td>"
                })

                $("#orderContent").html(str);
            },
            error: function () {
                alert("系统繁忙123！");
            }
        });
    }

    var dateConversionResult = function (d) {

        //将时间戳转为int类型，构造Date类型
        var date = new Date(parseInt(d, 10));

        //月份得+1，且只有个位数时在前面+0
        var month = date.getMonth() + 1 < 10 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;

        //日期为个位数时在前面+0
        var currentDate = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
        var hours = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
        var minutes = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
        var seconds = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();


        return date.getFullYear() + "-" + month + "-" + currentDate + " " + hours + ":" + minutes + ":" + seconds;

    }
</script>
</body>
</html>