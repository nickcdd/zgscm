<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_table.ftl" />
<#include "../_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/orders/index">

</head>
<body>
<div class="row">
    <div class="col-md-12">
        <div class="box box-info">
            <div class="box-header with-border">
                <div class="row">
                    <div class="col-md-2 text-left">
                        <h3 class="box-title">确认支付</h3>
                    </div>
                </div>
            </div>
            <div class="box-body">
                <div>
                    <p style="text-align:left;" class="text-warning">订单将会在
                    <#if ordersNoPaymentCancelTime??>
                    ${ordersNoPaymentCancelTime}
                    <#else >
                        30
                    </#if>分钟以后失效，请尽快支付
                    </p>
                    <div>
                        <span class="text-info">你的订单于</span>
                        <span class="text-red">${(orders.createTime?string("yyyy-MM-dd HH:mm:ss"))}</span>
                        <span class="text-info">提交成功!</span><br>
                        <span class="text-info">订单号:${orders.sid?c}<br>
                        <span class="text-info">支付金额:</span>
                        <span class="text-red">￥#{orders.totalAmount;m2M2}元</span><br><br>
                    </div>
                    <div>
                    <#if payType ??>
                        <#if payType == 1>
                            <#if urlPay??>
                                <img src="${urlPay}"><br>
                            </#if>
                            <span>使用微信扫描二维码进行支付</span>
                        <#elseif payType == 2 >
                            <#if multiValueMap ??>
                                <form id="alipayForm" action="${orderPayUrl}" method="post">
                                    <#list multiValueMap?keys as key>
                                        <input name="${key}" type="hidden" value="${multiValueMap[key][0]!}">
                                    </#list>
                                </form>
                            </#if>
                            <script>
                                $(function () {
                                    $("#alipayForm").submit();
                                });
                            </script>
                        <#elseif payType == 3>
                            <span class="text-info">当前剩余采购余额：<strong class="text-red">${shopKeeper.credit}</strong></span>
                            <#if shopKeeper.credit gte orders.payAmount>
                                　<a href="/shopping/creditPay?orderSid=${orders.sid?c}" class="btn btn-success">确认支付</a>
                            <#else>
                                <br /><span class="text-warning">您的采购余额不足,请重新选择支付方式</span>
                            </#if>
                        </#if>
                    </#if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(function () {
        var c = 5;
        setInterval(function () {
            c--;
            if (c == 0) {
                $.post('/shopping/wechatPayResultVerification?orderid=${orders.sid?c}', function (result) {
                    if (result.msg == 'paySuccess') {
                        window.location.href = "/shopping/paySuccess?orderid=${orders.sid?c}&status=1";
                    }
                });
                c = 5;
            }
        }, 1000);
    });
</script>
</body>
</html>