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
                <div align="center"
                     style="min-height: 520px;width: 1200px;background: #fff;margin-top: 30px;font-size: 18px;">
                    <div style="margin:30px;">
                        <div class=""
                             style="height:30px;width: 800px;text-align: left;line-height: 30px;padding-top: 30px;">
                            <div style="float: left;">
                                <div style="height: 30px;width: 30px;border-radius: 15px;background: #eeeeee;text-align: center;color: #8d8d8d;float: left;">
                                    1
                                </div>
                                填写充值订单
                            </div>
                            <div style="margin-left: 30%;float: left;">
                                <div style="height: 30px;width: 30px;border-radius: 15px;background: #eeeeee;text-align: center;color: #8d8d8d;float: left;">
                                    2
                                </div>
                                确认并支付
                            </div>
                            <div style="float: right;">
                                <div style="height: 30px;width: 30px;border-radius: 15px;background: #2eac49;text-align: center;color: #fff;float: left;">
                                    3
                                </div>
                                完成
                            </div>
                        </div>
                        <br><br>
                        <div class="progress progress-striped active" style="width: 70%">
                            <div class="progress-bar progress-bar-success" role="progressbar"
                                 aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"
                                 style="width: 100%;">
                                <span class="sr-only">100% 完成</span>
                            </div>
                        </div>
                        <br><br><br><br><br>
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
</div>
</body>
</html>