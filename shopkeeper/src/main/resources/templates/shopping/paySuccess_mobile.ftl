<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_table.ftl" />
<#include "../_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/orders/index">
</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <div class="row">
                    <div class="col-md-2 text-left">
                        <h3 class="box-title">支付成功</h3>
                    </div>
                </div>
            </div>
            <div class="box-body">
                <div>
                <#if status ??>
                    <#if status == 1>
                        <div style="text-align:left; padding:10px; line-height:25px;color:#0cc;margin-left: 170px;">
                            你的订单于<span
                                style="color:#f00; font-weight:bold;font-size: 24px;">${(orders.createTime?string("yyyy-MM-dd HH:mm:ss"))}</span>支付成功!<br><br>
                            <span style="color:#999">订单号:${orders.sid?c}<br>
                                    支付金额:<span style="color:#f00; font-weight:bold;">￥#{orders.payAmount;m2M2}元</span><br>
                                <span><strong id="target" style="color:#f00;">10</strong>秒后返回采购记录</span></span>
                            <br><br>
                        </div>
                        <script>
                            $(function () {
                                var c = 10
                                var timer = setInterval(function () {
                                    c--;
                                    $("#target").html(c);
                                    if (c == 1) {
                                        window.location.href = "/order/index";
                                        window.clearInterval(timer);
                                    }
                                }, 1000);
                            });
                        </script>
                    <#else >
                        <span>支付失败 请<a href="/shopping/pay?ordersSid=${orders.sid?c}&payType=${orders.channel}">重新支付</a></span>
                    </#if>
                </#if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>