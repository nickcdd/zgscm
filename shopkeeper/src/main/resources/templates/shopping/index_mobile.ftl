<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_table.ftl" />
<#include "../_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/orders/index">
    <style>
        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none !important;
            margin: 0;
        }

        input[type="number"] {
            -moz-appearance: textfield;
        }
    </style>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <div class="row">
                    <div class="col-md-2 text-left">
                        <h3 class="box-title">结算</h3>
                    </div>
                </div>
            </div>
            <div class="box-body">
                <form id="shoppingConfirmOrder" action="/shopping/confirmOrder" method="post" class="form-inline">
                    <div style="border:1px solid #ccc;margin-top:25px; padding:10px; line-height:40px;background-color:#f5f5f5;">
                        <b style="color:#f00;">商家发货时与您取得联系，使您能够正常收到商品，请认真核对！</b>
                        <hr style="border:0px; border-top:1px dotted #ccc;">
                    <#if shopKeeper.realName??>
                        姓　　名：<span class="text-info" id="username">${shopKeeper.realName}</span>　　
                    </#if>
                        <span id="mobile" class="text-info">${shopKeeper.telephone}</span><br>
                        <select class="form-control" id="addresses" name="addressSid">
                        <#if addresses??>
                            <#list addresses as address>
                                <option value="${address.sid?c}" ${(address.isDefault ?? && address.isDefault == 1)?string('selected="selected"', "")}>${address.address}</option>
                            </#list>
                        </#if>
                        </select>
                        <div style="height: 5px;"></div>
                        <a href="/receivingAddress/add" class="form-control btn-block btn btn-info"><i class="fa fa-plus-square fa-fw"></i>添加收货地址</a>
                    </div>
                <#list shoppingCarts as shoppingCart>
                    <div class="parent" style="height: 100px;border: 1px solid #c4e3f3;margin-top: 2%;">
                        <div style="width: 8%;float: left; line-height: 100px;margin-left: 2%;display: none;">
                            <#if shoppingCart.sid ??>
                                <input type="checkbox" name="shoppingCartSid" value="${shoppingCart.sid?c}" checked="checked" style="display: none;" />
                            <#else >
                                <input type="checkbox" name="shoppingCartSid" value="" checked="checked" style="display: none;" />
                            </#if>
                        </div>
                        <div style="width: 22%;float: left;padding: 3% 0 0 3%;">
                            <#if shoppingCart.goods.goodsFiles ??>
                                <#if shoppingCart.goods.goodsFiles?size == 0>
                                    <img style="max-height: 70px;" src="/assets/img/goods/img-goods-default.png" />
                                </#if>
                                <#list shoppingCart.goods.goodsFiles as goodsfile>
                                    <#if goodsfile_index == 0>
                                        <img style="max-height: 70px;max-width: 100%;" src="${goodsfile.url}" onerror="checkImgFun(this)" />
                                    <#else>
                                        <img style="max-height: 70px;" src="/assets/img/goods/img-goods-default.png" />
                                    </#if>
                                </#list>
                            <#else>
                                <img style="max-height: 70px;" src="/assets/img/goods/img-goods-default.png" />
                            </#if>
                        </div>
                        <div style="width: 53%;float: left;height: 100px;margin: 2% 0 0 5%" class="flag-show">
                            <p style="font-size: 10px;">
                                <#if shoppingCart.goods.cname?length gt 25>
                                ${shoppingCart.goods.cname[0..25]}...
                                <#else >
                                ${shoppingCart.goods.cname}
                                </#if>
                            </p>
                            <p style="font-size: 10px; color: #c3c3c3">规格：${shoppingCart.goodsSpecification.cname}</p>
                            <p style="font-size: 12px;color: red">
                                <span class="singlePrice">#{shoppingCart.goodsSpecification.price ;m2M2}</span>
                            </p>
                        </div>
                        <div style="width: 8%;float: left;line-height: 100px;" class="flag-show">
                            ×<span class="goodsAmount">${shoppingCart.goodsAmount}</span>
                        </div>
                    </div>
                </#list>
                    <div style="margin-top: 1%;text-align: right;margin:2% 0 2% 0;height: 50px;">
                        <div style="padding: 1%;border: 1px solid red;display: inline-block">
                        <#--<input type="radio" name="payType" value="1" checked="checked"/><span class="text-red">&nbsp;&nbsp;微信支付&nbsp;&nbsp;&nbsp;&nbsp;</span>-->
                            <input type="radio" name="payType" checked="checked" value="2" /><span class="text-red">&nbsp;&nbsp;支付宝支付&nbsp;&nbsp;&nbsp;&nbsp;</span>
                        </div>
                    </div>
                    <div style="margin-top: 1%;text-align: right">
                        <p><strong>合计金额：</strong><strong class="text-red">￥
                            <span id="ordersTotalPrice">#{ordersTotalPrice;m2M2}</span> 元</strong></p>
                        <a href="/shoppingCart/index" class="btn btn-lg btn-default">返回购物车</a>
                        <button type="button" id="validateButton" onclick="fromValidate()" class="btn btn-lg btn-primary">
                            提交订单
                        </button>
                    </div>
                </form>
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

    /*
    修改商品数量函数
    */
    function inputChange(strId, obj) {
        var amount = $(obj).val();
        if (amount == "") {
            $(obj).val(1);
            amount = 1;
        }
        amount = parseFloat(amount, 10);
        if (amount < 1) {
            $(obj).val(1);
            amount = 1;
        }
        if (strId == '') {
            changeSessionAcount(amount);
        } else {
            changeShoppingCarAcount(strId, amount);
        }
        chanageOrdersTotalPrice(obj);
        changeOrdersTotalPrice();
    }

    /*
    改变单个商品总价
     */
    function chanageOrdersTotalPrice(obj) {
        var amount = $(obj).val();
        var price = $(obj).parents('tr').find("span.price").data('price');
        var tempPrice = accMul(price, amount);
        var m;
        try {
            m = tempPrice.toString().split(".")[1].length
        } catch (e) {
            m = 0
        }
        if (m == 0) {
            tempPrice = tempPrice.toString() + ".00";
        } else if (m == 1) {
            tempPrice = tempPrice.toString() + "0";
        }
        $(obj).parents('tr').find("span.totalPrice").text(tempPrice);
        $(obj).parents('tr').find("span.totalPrice").data("totalPrice", tempPrice)
    }

    /*
   点击“-”按钮
    */
    function subtraction(strId, obj) {
        var amount = $(obj).parent().children("input").val();
        amount = parseInt(amount, 10);
        if (amount == 1) {
            return false;
        }
        amount = amount - 1;
        if (strId == '') {
            changeSessionAcount(amount);
        } else {
            changeShoppingCarAcount(strId, amount);
        }
        $(obj).parent().children("input").val(amount);

        var price = $(obj).parents('tr').find("span.price").data('price');
        var tempPrice = accMul(price, amount);
        var m;
        try {
            m = tempPrice.toString().split(".")[1].length
        } catch (e) {
            m = 0
        }
        if (m == 0) {
            tempPrice = tempPrice.toString() + ".00";
        } else if (m == 1) {
            tempPrice = tempPrice.toString() + "0";
        }
        $(obj).parents('tr').find("span.totalPrice").text(tempPrice);
        changeOrdersTotalPrice();
    }

    /*
    点击“+”按钮
     */
    function addition(strId, obj) {
        var amount = $(obj).parent().children("input").val();
        amount = parseInt(amount, 10);
        amount = amount + 1;
        if (strId == '') {
            changeSessionAcount(amount);
        } else {
            changeShoppingCarAcount(strId, amount);
        }
        $(obj).parent().children("input").val(amount);

        var price = $(obj).parents('tr').find("span.price").data('price');
        var tempPrice = accMul(price, amount);
        var m;
        try {
            m = tempPrice.toString().split(".")[1].length
        } catch (e) {
            m = 0
        }
        if (m == 0) {
            tempPrice = tempPrice.toString() + ".00";
        } else if (m == 1) {
            tempPrice = tempPrice.toString() + "0";
        }
        $(obj).parents('tr').find("span.totalPrice").text(tempPrice);
        changeOrdersTotalPrice();
    }

    /*
  改变后台购购物车数量
   */
    var changeShoppingCarAcount = function (sid, amount) {
        $.post("/shoppingCart/update?sid=" + sid + "&amount=" + amount, function (result) {
            console.log(result.record.goodsAmount);
        });
    }

    function changeSessionAcount(amount) {
        $.post("/shoppingCart/updateSession?amount=" + amount, function (result) {
            console.log(result.record.goodsAmount);
        });
    }

    /*
    浮点小数相加方法
     */
    function accAdd(arg1, arg2) {
        var r1, r2, m;
        try {
            r1 = arg1.toString().split(".")[1].length
        } catch (e) {
            r1 = 0
        }
        try {
            r2 = arg2.toString().split(".")[1].length
        } catch (e) {
            r2 = 0
        }
        m = Math.pow(10, Math.max(r1, r2))
        return (accMul(arg1, m) + accMul(arg2, m)) / m
    }

    /*
    浮点小数相乘方法
     */
    function accMul(arg1, arg2) {
        var m = 0, s1 = arg1.toString(), s2 = arg2.toString();
        try {
            m += s1.split(".")[1].length
        } catch (e) {
        }
        try {
            m += s2.split(".")[1].length
        } catch (e) {
        }
        return Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m)
    }

    /*
   改变结算选中价格总价
    */
    function changeOrdersTotalPrice() {
        var ordersTotalPrice = 0.00;
        $("[name=shoppingCartSid]:checkbox").each(function () {
            if ($(this).is(':checked')) {
                var totalPrice = $(this).parents("tr").find("span.totalPrice").text();
                totalPrice = parseFloat(totalPrice, 10);
                ordersTotalPrice = parseFloat(ordersTotalPrice, 10);
                ordersTotalPrice = accAdd(ordersTotalPrice, totalPrice);
            }
        });
        var m;
        try {
            m = ordersTotalPrice.toString().split(".")[1].length
        } catch (e) {
            m = 0
        }
        if (m == 0) {
            ordersTotalPrice = ordersTotalPrice.toString() + ".00";
        } else if (m == 1) {
            ordersTotalPrice = ordersTotalPrice.toString() + "0";
        }
        $("#ordersTotalPrice").text(ordersTotalPrice);
    }

    function fromValidate() {
        $("#validateButton").css("background-image", "url(/assets/img/await.jpg)");
        $("#validateButton").css("background-size", "40px 40px");
        $("#validateButton").css("background-position", "center top");
        $("#validateButton").css("background-repeat", "no-repeat");
        $("#validateButton").attr("disabled", true);
        var $form = $('#shoppingConfirmOrder');
        var addresses = $("#addresses option:selected").val();
        var username = $("#username").text();
        $form.submit(function () {
            if ($form.valid()) {
                if (username == "" || username == null || username == undefined) {
                    showInfoFun('请先完善个人信息。', 'warning');
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                    return false;
                }
                if (addresses == "" || addresses == null || addresses == undefined) {
                    showInfoFun('请先添加收货地址。', 'warning');
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                    return false;
                }
            }
            return true;
        });
        orderSubmitVerification();
    }

    function orderSubmitVerification() {
        var shoppingCartSid = new Array();
        var i = 0;
        $("[name=shoppingCartSid]:checkbox").each(function () {
            if ($(this).is(':checked')) {
                var tempSid = $(this).val();
                if (tempSid != '') {
                    shoppingCartSid[i] = $(this).val();
                }
                i++;
            }
        });
        var addressSid = $("#addresses option:selected").val();
        $.post("/shopping/orderSubmitVerification?shoppingCartSid=" + shoppingCartSid + "&addressSid=" + addressSid, function (result) {
            if (result != null && result != undefined) {
                if (result.code == 3) {
                    $("#validateButton").attr("disabled", true);
                    $("#shoppingConfirmOrder").submit();
                } else if (result.code == 0) {
                    showInfoFun('商品 ' + result.msg + ' 库存不足。', 'warning');
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                } else if (result.code == 1) {
                    showInfoFun('购买金额必须大于${ordersTotalPirceEstimate}元才能提交订单。', 'warning');
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                } else if (result.code == 2) {
                    showInfoFun('主城九区以外购买金额必须大于${ordersTotalPirceEstimateSpecial}元才能提交订单。', 'warning');
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                }
            }
        });
    }

    var checkImgFun = function (img) {
        var checkImg = function (img) {
            if (img.naturalHeight <= 1 && img.naturalWidth <= 1) {
                img.src = '/assets/img/goods/img-goods-default.png';
            }
        };

        try {
            if (img.complete) {
                checkImg(img);
            } else {
                $(img).load(function () {
                    checkImg(this);
                }).error(function () {
                    this.src = '/assets/img/goods/img-goods-default.png';
                });
            }
        } catch (e) {
        }
    };
</script>
</body>
</html>