<!DOCTYPE html>
<html>
<head>
<#include "_head.ftl" />
    <style>
        body {
            min-height: 430px;
        }

        .input-amount {
            width: 100%;
            height: 2.5em;
            border: 1px solid #efefef;
            border-radius: 5px;
        }

        .input-amount label {
            padding: 0.5em;
            margin: 0;
            color: #cccccc;
            font-weight: normal;
        }

        .input-amount p {
            padding: 0.5em;
            margin: 0;
        }

        .pad-wrapper {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
        }

        .pad-wrapper table {
            width: 100%;
            height: 300px;
            background: #cccccc;
            table-layout: fixed;
            border-collapse: collapse;
            border: none;
        }

        .pad-wrapper table td {
            background: #ffffff;
            text-align: center;
            vertical-align: middle;
            border-right: 1px solid #cfcfcf;
            border-bottom: 1px solid #cfcfcf;
            font-size: 2em;
        }

        .pad-wrapper table tr:last-child td {
            border-bottom: none;
        }

        .pad-wrapper table tr td:last-child {
            border-right: none;
        }

        .pad-wrapper table td.disabled {
            background: #cfcfcf;
            color: #ffffff;
        }
    </style>

    <script>
        $(function () {
            var $amount = $('.input-amount');
            $('.pad-wrapper td').click(function () {
                var $t = $(this), key = $t.data('key') || '0', fn = $t.data('fn') || '';
                var amount = $amount.data('amount') || '';

                if ((parseFloat(amount) >= 99999.99 || (amount.indexOf('.') > -1 && amount.substring(amount.indexOf('.')).length > 2)) && fn != 1) {
                    return;
                }

                if (fn) {
                    switch (fn) {
                        case 1:
                            amount = amount.substr(0, amount.length - 1);
                            if (parseFloat(amount) == 0) {
                                amount = '';
                            }

                            $amount.data('amount', amount);
                            $amount.find('p').text('￥' + amount);
                            return;
                        case 2:
                            return;
                        case 3:
                            if (amount.indexOf('.') == -1) {
                                if (parseInt(amount, 10) > 0) {
                                    amount += '.';
                                } else {
                                    amount = '0.';
                                }
                                $amount.data('amount', amount);
                                $amount.find('p').text('￥' + amount);
                            }
                            return;
                        case 4:
                            $amount.data('amount', '');
                            $amount.find('p').text('￥');
                            return;
                        default:
                            return;
                    }
                }

                amount += key;
                $amount.data('amount', amount);
                $amount.find('p').text('￥' + amount);
            });
        });
    </script>
</head>
<body class="skin-blue-light">
<#include "../_flash.ftl" />
<#if shopKeeper?? >
<div class="wrapper">
    <section class="content-wrapper">
        <section class="content">

            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">重庆正格二维码收银台</h3>
                </div>

                <div class="box-body">
                    <p>${shopKeeper.cname!''}</p>
                    <div class="input-amount">
                        <label>金额</label>
                        <p class="pull-right" id="total_fee_p">￥</p>
                    </div>
                </div>
            </div>

        </section>
    </section>
</div>

<div class="pad-wrapper">
    <table>
        <tr>
            <td width="25%" data-key="1">1</td>
            <td width="25%" data-key="2">2</td>
            <td width="25%" data-key="3">3</td>
            <td width="25%" data-fn="1"><i class="ion-backspace-outline"></i></td>
        </tr>
        <tr>
            <td data-key="4">4</td>
            <td data-key="5">5</td>
            <td data-key="6">6</td>
            <td rowspan="3" data-fn="2" class="" onclick="pay()">确认<br />支付</td>
        </tr>
        <tr>
            <td data-key="7">7</td>
            <td data-key="8">8</td>
            <td data-key="9">9</td>
        </tr>
        <tr>
            <td data-fn="4">C</td>
            <td data-key="0">0</td>
            <td data-fn="3">.</td>
        </tr>
    </table>
</div>
</#if>
<form id="payFrom" action="http://www.zgsh315.com/pay.php/Pay/startPay" method="get">
    <input type="hidden" name="key" id="key" />
    <input type="hidden" name="addtime" id="addtime" />
    <input type="hidden" name="pay_type" id="pay_type" />
    <input type="hidden" name="orderid" id="orderid" />
    <input type="hidden" name="total_fee" id="total_fee" />
    <input type="hidden" name="subject" id="subject" />
    <input type="hidden" name="body" id="body" />
    <input type="hidden" name="notify_url" id="notify_url" />
    <input type="hidden" name="return_url" id="return_url" />
    <input type="hidden" name="show_url" id="show_url" />
    <input type="hidden" name="close_window" id="close_window" />
</form>
<script>
    function pay() {
        var total_fee= $("#total_fee_p").text();
        var pay_type = ${payWay};
        var sid = ${shopKeeper.sid};
        if(total_fee == "￥"){
            showInfoFun('请输入金额。', 'info');
            return;
        }
        $.post('/cashier/pay?total_fee='+total_fee+'&sid='+sid+'&pay_type='+pay_type, function (result) {
            var data = result.record;
            $("#key").val(data.sign);
            $("#pay_type").val(data.pay_type);
            $("#addtime").val(data.addtime);
            $("#orderid").val(data.orderid);
            $("#total_fee").val(data.total_fee);
            $("#subject").val(data.subject);
            $("#body").val(data.body);
            $("#notify_url").val(data.notify_url);
            $("#return_url").val(data.return_url);
            $("#show_url").val(data.show_url);
            $("#close_window").val(data.close_window);
            $("#payFrom").submit();
        });
    }


</script>
</body>
</html>