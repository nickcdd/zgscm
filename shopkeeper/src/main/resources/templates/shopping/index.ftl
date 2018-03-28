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
        .nowrap {
            overflow: hidden;
            white-space: nowrap;
            width: 65%;
            -o-text-overflow: ellipsis;
            text-overflow: ellipsis;
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
                        　　姓　　名：
                        <span id="username" class="text-info">
                        <#if shopKeeper.realName??>
                            <span>${shopKeeper.realName}</span>
                        </#if>
                        </span>　　　
                        手机号码：
                        <span id="mobile" class="text-info">${shopKeeper.telephone}</span><br>
                        　　收货地址：<select class="form-control" id="addresses" name="addressSid">
                    <#if addresses??>
                        <#list addresses as address>
                            <option value="${address.sid?c}" ${(address.isDefault ?? && address.isDefault == 1)?string('selected="selected"', "")}>${address.address}</option>
                        </#list>
                    </#if>
                    </select>

                        <a href="/receivingAddress/add" class="form-control btn-block btn btn-info"><i
                                class="fa fa-plus-square fa-fw"></i>添加收货地址</a></div>
                    <table class="table" border="0">
                        <thead>
                            <tr>
                                <th class="" style="text-align: left">全部商品</th>
                                <th class="" style="text-align: left">单价（元）</th>
                                <th class="" style="text-align: left">数量</th>
                                <th class="" style="text-align: left">规格</th>
                                <th class="" style="text-align: left">金额</th>
                            </tr>
                        </thead>
                        <tbody>
                        <#if shoppingCarts ??>
                            <#list shoppingCarts as shoppingCart>
                                <tr>
                                    <td class="" style="text-align: left"></td>
                                    <td class="" style="text-align: left"></td>
                                    <td class="" style="text-align: left"></td>
                                    <td class="" style="text-align: left"></td>
                                    <td class="" style="text-align: left"></td>
                                </tr>
                                <tr style="border: 1px solid #c4e3f3;margin: 5% 0 0 0">
                                    <td style="width: 40%">
                                        <#if shoppingCart.sid ??>
                                            <input type="checkbox" name="shoppingCartSid" value="${shoppingCart.sid?c}"
                                                   checked="checked" style="display: none;">
                                        <#else >
                                            <input type="checkbox" name="shoppingCartSid" value=""
                                                   checked="checked" style="display: none;">
                                        </#if>
                                        <input type="checkbox" name="supplierSid" value="${shoppingCart.goods.supplier.sid?c}"
                                               checked="checked" style="display: none;">
                                        <#if shoppingCart.goods.goodsFiles ??>
                                            <#if shoppingCart.goods.goodsFiles?size == 0>
                                                <img width="15%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail"
                                                     style="float: left">
                                            </#if>
                                            <#list shoppingCart.goods.goodsFiles as goodsfile>
                                                <#if goodsfile_index == 0>
                                                    <img width="10%" src="${goodsfile.url}" onerror="checkImgFun(this)" class="img-thumbnail"
                                                         style="float: left">
                                                <#else>
                                                    <img width="10%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail"
                                                         style="float: left">
                                                </#if>
                                            </#list>
                                        <#else>
                                            <img width="10%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail"
                                                 style="float: left">
                                        </#if>
                                        <p class="nowrap" style="float: left;margin: 3% 1.5% 0 6%" title="${shoppingCart.goods.cname}">
                                             <#if shoppingCart.goods.supplier.sid == -1>
                                                <span style="color: #fff;font-size: 12px;padding: 2px;background: #ff0000;">自营</span>
                                            </#if>
                                            ${shoppingCart.goods.cname}
                                        </p>
                                    </td>
                                    <td style="width: 15%"><p style="">
                                        ￥<span data-price="${shoppingCart.goodsSpecification.price?c}"
                                               class="price">#{shoppingCart.goodsSpecification.price;m2M2}</span> 元</p>
                                    </td>
                                    <td style="width: 15%">
                                        <#if shoppingCart.goods.supplier.sid == -1>
                                            <p class="maxBuyCountError" style="color: red;display: none;"></p>
                                            <p class="text-red">
                                                <a href="javascript:void(0)" onclick="subtraction('<#if shoppingCart.sid??>${shoppingCart.sid?c}</#if>',this);"
                                                   title="减"
                                                   style="float: left;width: 30px;height:28px;background-color: #e0dfdf;text-align: center;border: 1px solid #bcbcbc;border-right: none;font-size: 28px;line-height: 24px;">-</a>
                                                <input type="number" name="goodsAmount"
                                                       title="请输入购买数量"
                                                       onblur="onblurInput('${shoppingCart.goodsSpecification.sid?c}','<#if shoppingCart.sid??>${shoppingCart.sid?c}</#if>',this)"
                                                       class="acount"
                                                       onkeyup="inputChange('${shoppingCart.goodsSpecification.sid?c}','<#if shoppingCart.sid??>${shoppingCart.sid?c}</#if>',this)"
                                                       style="float: left;width: 48px;height: 28px;text-align: center;border: 1px solid #bcbcbc;"
                                                       value="${shoppingCart.goodsAmount}">
                                                <a href="javascript:javascript:void(0)"
                                                   onclick="addition('${shoppingCart.goodsSpecification.sid?c}','<#if shoppingCart.sid??>${shoppingCart.sid?c}</#if>',this);" title="加"
                                                   style="float: left;width: 30px;height:28px;background-color: #e0dfdf;text-align: center;border: 1px solid #bcbcbc;border-left: none;font-size: 22px;line-height: 24px;">+</a>
                                            </p>
                                            <#else >
                                            <span>${shoppingCart.goodsAmount}</span>
                                        </#if>
                                    </td>
                                    <td style="width: 15%">${shoppingCart.goodsSpecification.cname}</td>
                                    <td style="width: 15%">
                                        ￥<span data-totalPrice="${((shoppingCart.goodsSpecification.price) * (shoppingCart.goodsAmount))?c}"
                                               class="totalPrice">#{((shoppingCart.goodsSpecification.price) * (shoppingCart.goodsAmount));m2M2}</span>
                                        元
                                    </td>
                                </tr>
                            </#list>
                        </#if>
                        </tbody>
                    </table>
                    <div style="margin-top: 1%;text-align: right;margin:2% 0 2% 0;">
                    <span style="padding: 1%;border: 1px solid red">
                        <input type="radio" name="payType" value="1" checked="checked" /><span class="text-red">&nbsp;&nbsp;微信支付&nbsp;&nbsp;&nbsp;&nbsp;</span>
                        <input type="radio" name="payType" value="2" /><span class="text-red">&nbsp;&nbsp;支付宝支付&nbsp;&nbsp;&nbsp;&nbsp;</span>
                        <input type="radio" name="payType" value="3" /><span class="text-red">&nbsp;&nbsp;网银支付</span>
                    </span>
                    </div>
                    <div style="margin-top: 1%;text-align: right">
                        <span><strong>合计金额：</strong><strong class="text-red">￥ <span id="ordersTotalPrice">#{ordersTotalPrice;m2M2}</span> 元</strong></span>
                        <button type="button" id="validateButton" onclick="fromValidate()" class="btn btn-lg btn-primary">
                            提交订单
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <div class="modal fade" id="orderSubmitValidate" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                            &times;
                        </button>
                        <h4 class="modal-title" id="myModalLabel">
                            <p id="orderSubmitValidateTitleModal"></p>
                            <p>是否购买余下商品？</p>
                        </h4>
                    </div>
                    <div class="modal-body">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                        </button>
                        <button id="afterSaleButton" onclick="orderSubmitValidate()" type="button" class="btn btn-primary">
                            确认
                        </button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal -->
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
    //input 失去焦点
    function onblurInput(specificationSid,strId, obj) {
        var amount = $(obj).val();
        if (amount == "") {
            $(obj).val(1);
            amount = 1;
        }
        var inventory = getInventory(specificationSid);
        inventory = parseInt(inventory, 10);
        if(inventory < amount){
            $(obj).parents('tr').find("p.maxBuyCountError").html("最大购买量："+inventory);
            $(obj).parents('tr').find("p.maxBuyCountError").show();
            setTimeout(function(){$(obj).parents('tr').find("p.maxBuyCountError").hide();},2000);
            $(obj).val(inventory);
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
    修改商品数量函数
    */
    function inputChange(specificationSid,strId, obj) {
        var amount = $(obj).val();
        if (amount != "") {
            amount = parseFloat(amount, 10);
            if (amount < 1) {
                $(obj).val(1);
                amount = 1;
            }
            var inventory = getInventory(specificationSid);
            inventory = parseInt(inventory, 10);
            if(inventory < amount){
                $(obj).parents('tr').find("p.maxBuyCountError").html("最大购买量："+inventory);
                $(obj).parents('tr').find("p.maxBuyCountError").show();
                setTimeout(function(){$(obj).parents('tr').find("p.maxBuyCountError").hide();},2000);
                $(obj).val(inventory);
            }
            if (strId == '') {
                changeSessionAcount(amount);
            } else {
                changeShoppingCarAcount(strId, amount);
            }
            chanageOrdersTotalPrice(obj);
            changeOrdersTotalPrice();
        }
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
    function addition(specificationSid,strId, obj) {
        var amount = $(obj).parent().children("input").val();
        amount = parseInt(amount, 10);
        amount = amount + 1;
        var inventory = getInventory(specificationSid);
        inventory = parseInt(inventory, 10);
        if(inventory < amount){
            $(obj).parents('tr').find("p.maxBuyCountError").html("最大购买量："+inventory);
            $(obj).parents('tr').find("p.maxBuyCountError").show();
            setTimeout(function(){$(obj).parents('tr').find("p.maxBuyCountError").hide();},2000);
            return false;
        }
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
        var username = $("#username").children().text();
        if ($form.valid()) {
            if (username == "" || username == null || username == undefined) {
                showInfoFun('请先完善个人信息。', 'warning');
                $("#validateButton").attr("disabled", false);
                $("#validateButton").css("background-image", "");
                return false;
            }

            if (addresses == "" || addresses == null || addresses == undefined) {
                showInfoFun('请先添加默认地址。', 'warning');
                $("#validateButton").attr("disabled", false);
                $("#validateButton").css("background-image", "");
                return false;
            }
        }
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
                if (result.code == 6) {
                    $("#validateButton").attr("disabled", true);
                    $("#shoppingConfirmOrder").submit();
                } else if (result.code == 0) {
                    showInfoFun('商品 ' + result.msg + ' 库存不足，请重新选择购买数量。', 'warning');
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                } else if (result.code == 1) {
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                    $("#orderSubmitValidateTitleModal").html("平台自营商品总购买金额必须大于${ordersTotalPirceEstimate}元。");
                    $('#orderSubmitValidate').modal('show');
                }else if (result.code == 2) {
                    showInfoFun('平台自营商品总购买金额必须大于${ordersTotalPirceEstimate}元。', 'warning');
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                } else if (result.code == 3) {
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                    $("#orderSubmitValidateTitleModal").html("主城九区以外平台自营商品总购买金额必须大于${ordersTotalPirceEstimateSpecial}元。");
                    $('#orderSubmitValidate').modal('show');
                }else if (result.code == 4) {
                    showInfoFun('主城九区以外平台自营商品总购买金额必须大于${ordersTotalPirceEstimateSpecial}元。', 'warning');
                    $("#validateButton").attr("disabled", false);
                    $("#validateButton").css("background-image", "");
                }
            }
        });
    }
    //平台商品金额不足的时候，购买余下商品函数
    function orderSubmitValidate() {
        $("[name=supplierSid]:checkbox").each(function () {
            if ($(this).is(':checked')) {
                var tempSid = $(this).val();
                if (tempSid == -1) {
                    $(this).parents('tr').find("[name=shoppingCartSid]:checkbox").attr("checked",false);
                }
            }
        });
        $("#validateButton").attr("disabled", true);
        $("#shoppingConfirmOrder").submit();
        $('#orderSubmitValidate').modal('hide');
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

    /*
    获得商品库存
     */
    var getInventory = function(specificationSid) {
        var inventory = 0;
        $.ajax({
            type: "GET",
            url: "/shopping/getInvertory",
            contentType: "application/json; charset=utf-8",
            async: false,
            dataType: "json",
            data:{'specificationSid':specificationSid},
            success: function (result) {
                inventory = result.record;
            },
            error: function (msg) {
                alert("系统繁忙");
            }
        });
        return inventory;
    }
</script>
</body>
</html>