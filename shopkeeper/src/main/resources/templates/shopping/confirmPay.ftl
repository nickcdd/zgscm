<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_table.ftl" />
<#include "../_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/orders/index">

</head>
<style>
    .scroll {
        overflow-x: scroll;
        height: 400px;
        width: 1700px;
    }
</style>
<body style=" overflow-y:auto; overflow-x:auto;width:1024px;">
<div class="row scroll" style="min-width: 724px;">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <div class="row">
                    <div class="col-md-2 text-left">
                        <h3 class="box-title">确认支付</h3>
                    </div>
                </div>
            </div>
            <div class="box-body">
                <div align="center" class="scroll"
                     style="min-height: 520px;min-width: 700px;background: #fff;margin-top: 30px;font-size: 18px;">
                    <div style="margin:30px;">
                        <div class=""
                             style="height:30px;min-width: 650px;text-align: left;line-height: 30px;padding-top: 30px;">
                            <div style="float: left;">
                                <div style="height: 30px;width: 30px;border-radius: 15px;background: #eeeeee;text-align: center;color: #8d8d8d;float: left;">
                                    1
                                </div>
                                填写充值订单
                            </div>
                            <div style="margin-left: 30%;float: left;">
                                <div style="height: 30px;width: 30px;border-radius: 15px;background: #2eac49;text-align: center;color: #fff;float: left;">
                                    2
                                </div>
                                确认并支付
                            </div>
                            <div style="float: right;">
                                <div style="height: 30px;width: 30px;border-radius: 15px;background: #eeeeee;text-align: center;color: #8d8d8d;float: left;">
                                    3
                                </div>
                                完成
                            </div>
                        </div>
                        <br><br>
                        <div class="progress progress-striped active" style="width: 100%">
                            <div class="progress-bar progress-bar-success" role="progressbar"
                                 aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"
                                 style="width: 66%;">
                                <span class="sr-only">66% 完成</span>
                            </div>
                        </div>
                        <br>
                        <p style="text-align:left;margin-left: 170px;" class="text-warning">订单将会在
                        <#if ordersNoPaymentCancelTime??>
                        ${ordersNoPaymentCancelTime}
                        <#else >
                            30
                        </#if>分钟以后失效，请尽快支付</p>
                        <br><br><br><br>
                        <!--<img src="/Home/Tpl/Public/Img/UserCenter/bpay.gif"/>-->
                        <div style="text-align:left; padding:10px; line-height:25px;margin-left: 170px;">
                            <span class="text-info">你的订单于</span><span
                                class="text-red">${(orders.createTime?string("yyyy-MM-dd HH:mm:ss"))}</span><span
                                class="text-info">提交成功!</span><br>
                            <span class="text-info">订单号:${orders.sid?c}<br>
    					 	<span class="text-info">支付金额:</span><span
                                        class="text-red">￥#{orders.totalAmount;m2M2}元</span><br><br>
                            <#if payType ??>
                                <#if payType == 1>
                                    <#if urlPay??>
                                        <img src="${urlPay}"><br>
                                    </#if>
                                    <span>使用微信扫描二维码进行支付</span>
                                <#elseif payType == 2 || payType == 3>
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
                                <#elseif payType == 4>
                                    <span class="text-info">当前剩余采购余额：<strong class="text-red">${shopKeeper.credit}</strong></span>
                                    <#if shopKeeper.credit gte orders.payAmount>
                                        　<a href="/shopping/creditPay?orderSid=${orders.sid?c}" class="btn btn-success">确认支付</a>
                                    <#else>
                                        <br /><span class="text-warning">您的采购余额不足,请重新选择支付方式</span>
                                    </#if>
                                </#if>
                            </#if>
                            <br><br>
                        </div>
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