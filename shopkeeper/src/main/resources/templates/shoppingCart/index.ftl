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
                        <h3 class="box-title">我的购物车</h3>
                    </div>
                    <div class="col-md-2 col-md-offset-8 text-right">
                        <a href="javascript:history.go(-1)" class="btn  btn-default text-right">返回</a>
                    </div>
                </div>
            </div>
            <div class="box-body">
                <form id="formValidate" action="/shopping/index" method="post">
                    <table class="table" border="0">
                        <thead>
                            <tr>
                                <td class="" style="text-align: left">
                                    <div class="row">
                                        <div class="col-md-2">
                                            <input type="checkbox" checked="checked" style="" id="selectAll" />
                                            <span class="">全选</span>
                                        </div>
                                        <div class="col-md-8">
                                            商品信息
                                        </div>
                                    </div>
                                </td>
                                <td class="" style="text-align: left">最小购买量</td>
                                <td class="" style="text-align: left">单价（元）</td>
                                <td class="" style="text-align: left">数量</td>
                                <td class="" style="text-align: left">规格</td>
                                <td class="" style="text-align: left">金额</td>
                                <td class="" style="text-align: left">操作</td>
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
                                    <td class="" style="text-align: left"></td>
                                    <td class="" style="text-align: left"></td>
                                </tr>
                                <tr style="border: 1px solid #c4e3f3;margin: 5% 0 0 0">
                                    <td class="col-md-5">
                                        <input style="float: left;margin: 3.5% 3% 0 3%" type="checkbox" checked="checked"
                                               onclick="changeShoppingCartTotalPrice()"
                                               value="${shoppingCart.sid?c}" name="goodsSids" />
                                        <#if shoppingCart.goods.goodsFiles ??>
                                            <#if shoppingCart.goods.goodsFiles?size == 0>
                                                <img width="10%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail" style="float: left" />
                                            </#if>
                                            <#list shoppingCart.goods.goodsFiles as goodsfile>
                                                <#if goodsfile_index == 0>
                                                    <img width="10%" src="${goodsfile.url}" onerror="checkImgFun(this)" class="img-thumbnail"
                                                         style="float: left">
                                                <#else>
                                                    <img width="10%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail" style="float: left" />
                                                </#if>
                                            </#list>
                                        <#else>
                                            <img width="10%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail" style="float: left" />
                                        </#if>
                                        <p style="float: left;margin: 4.5% 1.5% 0 6%" class="nowrap" title="${shoppingCart.goods.cname}">
                                            <#if shoppingCart.goods.supplier.sid == -1>
                                                <span style="color: #fff;font-size: 12px;padding: 2px;background: #ff0000;">自营</span>
                                            </#if>
                                            ${shoppingCart.goods.cname}
                                        </p>
                                    </td>
                                    <td class="col-md-1">
                                        <#if shoppingCart.goods.supplier.sid == -1>
                                            ≥ <span class="minBuyCount">1</span>
                                        <#else >
                                            ≥ <span class="minBuyCount">${shoppingCart.goodsSpecification.saleCount?c}</span>
                                        </#if>
                                    </td>
                                    <td class="col-md-1">￥
                                        <span class="price"
                                              data-price="${shoppingCart.goodsSpecification.price?c}">#{shoppingCart.goodsSpecification.price ;m2M2}</span>元
                                    </td>
                                    <td class="col-md-2">
                                        <p class="minBuyCountError" style="color: red;display: none;">最小购买量 ≥ ${shoppingCart.goodsSpecification.saleCount?c}</p>
                                        <p class="maxBuyCountError" style="color: red;display: none;"></p>
                                        <a href="javascript:void(0)" onclick="subtraction('${shoppingCart.sid?c}',this);"
                                           title="减"
                                           style="float: left;width: 30px;height:28px;background-color: #e0dfdf;text-align: center;border: 1px solid #bcbcbc;border-right: none;font-size: 28px;line-height: 24px;">-</a>
                                        <input type="number" id="goodsAmount" name="goodsAmount"
                                               title="请输入购买数量"
                                               class="goodsAmount"
                                               onblur="onblurInput('${shoppingCart.goodsSpecification.sid?c}','${shoppingCart.sid?c}',this)"
                                               onkeyup="inputChange('${shoppingCart.goodsSpecification.sid?c}','${shoppingCart.sid?c}',this)"
                                               style="float: left;width: 48px;height: 28px;text-align: center;border: 1px solid #bcbcbc;"
                                               value="${shoppingCart.goodsAmount}">
                                        <a href="javascript:javascript:void(0)"
                                           onclick="addition('${shoppingCart.goodsSpecification.sid?c}','${shoppingCart.sid?c}',this);" title="加"
                                           style="float: left;width: 30px;height:28px;background-color: #e0dfdf;text-align: center;border: 1px solid #bcbcbc;border-left: none;font-size: 22px;line-height: 24px;">+</a>
                                    </td>
                                    <td class="col-md-1">${shoppingCart.goodsSpecification.cname}</td>
                                    <td class="col-md-1">
                                        ￥<span data-totalPrice="#{((shoppingCart.goodsSpecification.price) * (shoppingCart.goodsAmount)) ;m2M2}"
                                               class="totalPrice">#{((shoppingCart.goodsSpecification.price) * (shoppingCart.goodsAmount)) ;m2M2}</span>元
                                    </td>
                                    <td class="col-md-1">
                                        <button type="button" class="btn btn-danger btn-xs btn-remove"
                                                data-sid="${shoppingCart.sid?c}">
                                            <i class="fa fa-remove fa-fw"></i> 删除
                                        </button>
                                    </td>
                                </tr>
                            </#list>
                        </#if>
                        <#if shoppingCarts?size == 0>
                            <tr>
                                <td colspan="6" style="text-align: center">暂时没有购物记录</td>
                            </tr>
                        </#if>
                        </tbody>
                    </table>
                    <div style="margin-top: 1%;text-align: right;margin:2% 0 2% 0;">
                    </div>
                    <div style="margin-top: 1%;text-align: right">
                        <span><strong>合计金额：</strong><strong class="text-red">￥
                        <#if totalPrice ??>
                            <span id="shppingCarttotalPrice">#{totalPrice ;m2M2}</span>
                        <#else >
                            <span id="shppingCarttotalPrice">0.00</span>
                        </#if>
                                元</strong></span>
                        <button id="payGoods" type="button" onclick="formValidate()" class="btn btn-lg btn-primary">立即结算
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
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
    $(function () {
        $(document).on('click', '.btn-remove', function () {
            var $t = $(this), sid = $t.data('sid');
            confirmFun('/shoppingCart/remove?sid=' + sid, '确认删除？');
        });

        $("#selectAll").click(function () {
            $("[name=goodsSids]:checkbox").prop("checked", this.checked);
            changeShoppingCartTotalPrice();
        });
        $("[name=goodsSids]:checkbox").click(function () {
            var flag = true;
            $("[name=goodsSids]:checkbox").each(function () {
                if (!this.checked) {
                    flag = false;
                }
            });
            $("#selectAll").prop("checked", flag);
        });
        var shppingCarttotalPrice = $("#shppingCarttotalPrice").html();
        shppingCarttotalPrice = parseFloat(shppingCarttotalPrice, 10);
        if (shppingCarttotalPrice == 0) {
            $("#payGoods").prop("disabled", true);
        }

        $("input[type=number]").each(function () {
            minBuyCountValidate(this);
            changeShoppingCartTotalPrice();

        });

    });

    function formValidate() {
        var $form = $('#formValidate');
        $form.submit(function () {
            if ($form.valid()) {
                $("#payGoods").attr("disabled", true);
            }
            return true;
        });
        $("#formValidate").submit();
    }

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
        changeShoppingCarAcount(strId, amount);
        chanageGoodsTotalPrice(obj);
        minBuyCountValidate(obj);
        changeShoppingCartTotalPrice();
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
            changeShoppingCarAcount(strId, amount);
            chanageGoodsTotalPrice(obj);
            minBuyCountValidate(obj);
            changeShoppingCartTotalPrice();
        }
    }

    /*
    改变单个商品总价
     */
    function chanageGoodsTotalPrice(obj) {
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
    改变购物车选中价格总价
     */
    function changeShoppingCartTotalPrice() {
        var shppingCarttotalPrice = 0.00;
        var flag = true;
        $("[name=goodsSids]:checkbox").each(function () {
            if (!this.checked) {
                flag = false;
            }
            if (this.checked) {
                var totalPrice = $(this).parents("tr").find("span.totalPrice").text();
                totalPrice = parseFloat(totalPrice, 10);
                shppingCarttotalPrice = parseFloat(shppingCarttotalPrice, 10);
                shppingCarttotalPrice = accAdd(shppingCarttotalPrice, totalPrice);
            }
        });
        $("#selectAll").prop("checked", flag);
        var m;
        try {
            m = shppingCarttotalPrice.toString().split(".")[1].length
        } catch (e) {
            m = 0
        }
        if (m == 0) {
            shppingCarttotalPrice = shppingCarttotalPrice.toString() + ".00";
        } else if (m == 1) {
            shppingCarttotalPrice = shppingCarttotalPrice.toString() + "0";
        }
        $("#shppingCarttotalPrice").text(shppingCarttotalPrice);
        if (shppingCarttotalPrice == 0) {
            $("#payGoods").prop("disabled", true);
        } else {
            $("#payGoods").prop("disabled", false);
        }
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
        m = Math.pow(10, Math.max(r1, r2));
        return (accMul(arg1, m) + accMul(arg2, m)) / m;
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
        return Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m);
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
        changeShoppingCarAcount(strId, amount);
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
        $(obj).parents('tr').find("span.totalPrice").data("totalPrice", tempPrice)
        minBuyCountValidate($(obj).parent().children("input"));
        changeShoppingCartTotalPrice();
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
        changeShoppingCarAcount(strId, amount);
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
        $(obj).parents('tr').find("span.totalPrice").data("totalPrice", tempPrice)
        minBuyCountValidate($(obj).parent().children("input"));
        changeShoppingCartTotalPrice();
    }
    function minBuyCountValidate(inputVal) {
        var amount = $(inputVal).val();
        var minBuyCount = $(inputVal).parents('tr').find("span.minBuyCount").html();
        minBuyCount = parseInt(minBuyCount, 10);
        if(minBuyCount > amount){
            $(inputVal).parents('tr').find("p.minBuyCountError").show();
            $(inputVal).parents('tr').find("[name=goodsSids]:checkbox").attr("checked",false);
            $(inputVal).parents('tr').find("[name=goodsSids]:checkbox").attr("disabled",true);
        }else {
            $(inputVal).parents('tr').find("p.minBuyCountError").hide();
            $(inputVal).parents('tr').find("[name=goodsSids]:checkbox").attr("disabled",false);
            $(inputVal).parents('tr').find("[name=goodsSids]:checkbox").attr("checked",true);
        }
    }
    /*
    改变后台购购物车数量
     */
    function changeShoppingCarAcount(sid, amount) {
        $.post("/shoppingCart/update?sid=" + sid + "&amount=" + amount, function (result) {
            console.log(result.record.goodsAmount);
        });
    }
    /*
    获得商品库存
     */
    var getInventory = function(specificationSid) {
        var inventory = 0;
        $.ajax({
            type: "GET",
            url: "/shoppingCart/getInvertory",
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