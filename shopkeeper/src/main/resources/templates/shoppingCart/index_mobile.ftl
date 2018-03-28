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

        .flag-show {
            display: block
        }

        .flag-hide {
            display: none
        }

        .footer_fixed {
            position: fixed;
            z-index: 1000;
            bottom: 51px;
            left: 0;
            right: 0;
            height: 60px;
            background: #00a65a;
        }

        .container-right {
            position: absolute;
            right: 0;
            top: 0;
            bottom: 0;
            overflow: auto;
            padding: 10px;
        }

        .container-wrapper {
            position: absolute;
            left: 0;
            right: 0;
            top: 50px;
            bottom: 111px;
            overflow: hidden;
        }
    </style>
</head>
<body>
<div class="container-wrapper">
    <div class="container-right">
        <div class="box">
            <div class="box-header with-border">
                <div class="row">
                    <div class="col-xs-8  text-left">
                        <h3 class="box-title">我的购物车</h3>
                    </div>
                    <div class="col-xs-4  text-right">
                        <span class="flag-show" id="flagShow">编辑</span>
                        <span class="flag-hide" id="flagHide">完成</span>
                    </div>
                </div>
            </div>
            <div class="box-body">
                <form id="formValidate" action="/shopping/index" method="get">
                <#if shoppingCarts ??>
                    <#list shoppingCarts as shoppingCart>
                        <div class="parent" style="height: 100px;border: 1px solid #c4e3f3;margin-top: 2%">
                            <div style="width: 8%;float: left; line-height: 100px;margin-left: 2%">
                                <input style="" type="checkbox" checked="checked"
                                       onclick="changeShoppingCartTotalPrice()"
                                       value="${shoppingCart.sid?c}" name="goodsSids" />
                            </div>
                            <div style="width: 22%;float: left;padding: 2% 0 0 0">
                                <#if shoppingCart.goods.goodsFiles ??>
                                    <#if shoppingCart.goods.goodsFiles?size == 0>
                                        <img width="100%" src="/assets/img/goods/img-goods-default.png" />
                                    </#if>
                                    <#list shoppingCart.goods.goodsFiles as goodsfile>
                                        <#if goodsfile_index == 0>
                                            <img width="100%" src="${goodsfile.url}" onerror="checkImgFun(this)">
                                        <#else>
                                            <img width="100%" src="/assets/img/goods/img-goods-default.png" />
                                        </#if>
                                    </#list>
                                <#else>
                                    <img width="100%" src="/assets/img/goods/img-goods-default.png" />
                                </#if>
                            </div>
                            <div style="width: 53%; margin-left:3%;float: left;" class="flag-show">
                                <p style="font-size: 10px;">
                                    <#if shoppingCart.goods.cname?length gt 25>
                                    ${shoppingCart.goods.cname[0..25]}...
                                    <#else >
                                    ${shoppingCart.goods.cname}
                                    </#if>
                                </p>
                                <p style="font-size: 10px; color: #c3c3c3">
                                    规格：${shoppingCart.goodsSpecification.cname}</p>
                                <p style="font-size: 12px;color: red">
                                    <span class="singlePrice">#{shoppingCart.goodsSpecification.price ;m2M2}</span>
                                </p>
                            </div>
                            <div style="width: 8%;float: left;line-height: 100px;" class="flag-show">
                                ×<span class="goodsAmount">${shoppingCart.goodsAmount}</span>
                            </div>
                            <div style="width: 53%;float: left;" class="flag-hide">
                                <div style="padding: 20% 0 0 15% ">
                                    <a href="javascript:void(0)" onclick="subtraction('${shoppingCart.sid?c}',this);"
                                       title="减"
                                       style="float: left;width: 30px;height:28px;background-color: #e0dfdf;text-align: center;border: 1px solid #bcbcbc;border-right: none;font-size: 28px;line-height: 24px;">-</a>
                                    <input type="number" id="goodsAmount" name="goodsAmount"
                                           title="请输入购买数量"
                                           onblur="onblurInput('${shoppingCart.sid?c}',this)"
                                           class="acount"
                                           onkeyup="inputChange('${shoppingCart.sid?c}',this)"
                                           style="float: left;width: 48px;height: 28px;text-align: center;border: 1px solid #bcbcbc;"
                                           value="${shoppingCart.goodsAmount}">
                                    <a href="javascript:javascript:void(0)"
                                       onclick="addition('${shoppingCart.sid?c}',this);" title="加"
                                       style="float: left;width: 30px;height:28px;background-color: #e0dfdf;text-align: center;border: 1px solid #bcbcbc;border-left: none;font-size: 22px;line-height: 24px;">+</a>
                                </div>
                            </div>
                            <div style="width: 15%;float: left;height: 100%;background: red;" class="flag-hide">
                                <p class="btn-remove" data-sid="${shoppingCart.sid?c}" style="color: #FFFFFF;width: 100%;padding:100% 0 0 20%">
                                    删除</p>
                            </div>
                        </div>
                    </#list>
                </#if>
                <#if shoppingCarts?size == 0>
                    <div style="width: 100%;text-align: center">
                        暂无购买记录
                    </div>
                </#if>
                    <div class="footer_fixed">
                        <div style="float: left;width: 20%;text-align: left;padding: 0 0 0 5%;line-height: 50px;">
                            <input type="checkbox" checked="checked" style="margin: 10% 0 0 0" id="selectAll" />
                            <span style="font-size: 12px; color: #FFFFFF">全选</span>
                        </div>
                        <div style="width: 50%; float: left;line-height: 30px;padding: 0 0 0 5%">
                            <div>
                                <span style="font-size: 12px;color: #FFFFFF"> 合计金额</span>
                            </div>
                            <div>
                                <span style="font-size: 20px;color: #f1a417;">
                                <#if totalPrice ??>
                                    ￥<span id="shppingCarttotalPrice">#{totalPrice ;m2M2}</span>元
                                <#else >
                                    ￥<span id="shppingCarttotalPrice">0.00</span>元
                                </#if>
                                </span>
                            </div>
                        </div>
                        <div style="width: 25%; float: left;line-height: 60px;text-align: right">
                            <button id="payGoods" type="button" onclick="formValidate()" class="btn btn-default">立即结算
                            </button>
                        </div>
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
        $("#flagShow").on('click', function () {
            $(".flag-hide").toggle();
            $(".flag-show").toggle();
        })
        $("#flagHide").on('click', function () {
            $(".flag-hide").toggle();
            $(".flag-show").toggle();
        })
    });

    $(function () {
        $("#goodsAmount").blur(function () {
            if ($(this).val() == "") {
                $(this).val(1);
            }
        });


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
    function onblurInput(strId, obj) {
        var amount = $(obj).val();
        if (amount == "") {
            $(obj).val(1);
            amount = 1;
        }
        changeShoppingCarAcount(strId, amount);
        $(obj).parents('.parent').find("span.goodsAmount").text(amount);
        changeShoppingCartTotalPrice();
    }
    /*
    修改商品数量函数
    */
    function inputChange(strId, obj) {
        var amount = $(obj).val();
        amount = parseFloat(amount, 10);
        if (amount != '') {
            if (amount < 1) {
                $(obj).val(1);
                amount = 1;
            }
            changeShoppingCarAcount(strId, amount);
            $(obj).parents('.parent').find("span.goodsAmount").text(amount);
            changeShoppingCartTotalPrice();
        }
    }
    /*
    改变购物车选中价格总价
     */
    function changeShoppingCartTotalPrice() {
        var shppingCarttotalPrice = 0.00;
        $("[name=goodsSids]:checkbox").each(function () {
            if (this.checked) {
                var singlePrice = $(this).parents(".parent").find("span.singlePrice").text();
                var goodsAmount = $(this).parents(".parent").find("span.goodsAmount").text();
                singlePrice = parseFloat(singlePrice, 10);
                goodsAmount = parseFloat(goodsAmount, 10);
                var totalPrice = accMul(singlePrice, goodsAmount);
                shppingCarttotalPrice = parseFloat(shppingCarttotalPrice, 10);
                shppingCarttotalPrice = accAdd(shppingCarttotalPrice, totalPrice);
            }
        });
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

        $(obj).parents('.parent').find("span.goodsAmount").text(amount);
        changeShoppingCartTotalPrice();
    }
    /*
    点击“+”按钮
     */
    function addition(strId, obj) {
        var amount = $(obj).parent().children("input").val();
        amount = parseInt(amount, 10);
        amount = amount + 1;
        changeShoppingCarAcount(strId, amount);
        $(obj).parent().children("input").val(amount);
        $(obj).parents('.parent').find("span.goodsAmount").text(amount);
        changeShoppingCartTotalPrice();
    }

    /*
    改变后台购购物车数量
     */
    function changeShoppingCarAcount(sid, amount) {
        $.post("/shoppingCart/update?sid=" + sid + "&amount=" + amount, function (result) {
            console.log(result.record.goodsAmount);
        });
    }

</script>
</body>
</html>