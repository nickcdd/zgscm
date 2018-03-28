<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
    <style>
        .pecificationsDefault {
            background: #fc5b01;
            color: #fff
        }

        .pecifications {
            padding: 0.5%;
            border: 1px solid #fc5b01;
        }

        .pecificationsDefault:link {
            color: #FFF;
            text-decoration: none;
        }

        pecifications:visited {
            color: #FFF;
            text-decoration: none;
        }

        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none !important;
            margin: 0;
        }

        input[type="number"] {
            -moz-appearance: textfield;
        }
        .shopName{
            color: #666;
        }
        .shopName:hover{
            color: #ff0000;
        }
    </style>
</head>
<body>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="width: 100%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <div class="row">
                <div class="col-md-2 col-xs-5 text-left">
                    <h3 class="box-title">商品详情</h3>
                </div>
                <div class="col-md-2 col-md-offset-8 col-xs-4 col-xs-offset-3 text-right">
                    <a href="javascript:history.go(-1)" class="btn  btn-default text-right">返回</a>
                </div>
            </div>
        </div>
        <div class="box-body">
            <form id="goodsDetailForm" action="/shoppingCart/add" method="post" onsubmit="return dosubmit()">
                <input type="hidden" name="goodsSid" value="${goods.sid?c}">
                <div class="row">
                    <div class="col-md-4 col-xs-12">
                    <#if goods.goodsFiles ??>
                        <#if goods.goodsFiles?size == 0>
                            <img width="100%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail" />
                        </#if>
                        <#list goods.goodsFiles as goodsfile>
                            <#if goodsfile_index == 0>
                                <img width="100%" src="${goodsfile.url}" class="img-thumbnail" onerror="checkImgFun(this);" />
                            <#else>
                                <img width="100%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail" />
                            </#if>
                        </#list>
                    <#else>
                        <img width="100%" src="/assets/img/goods/img-goods-default.png" class="img-thumbnail" />
                    </#if>
                    </div>
                    <div class="col-md-8 col-xs-12">
                        <div style="margin: 0 0 1% 0">
                            <a class="shopName" href="/goods/shopIndex?supplierSid=${goods.supplier.sid?c}">${goods.supplier.cname}</a>
                            <#if goods.supplier.sid == -1>
                                <span style="color: #fff;font-size: 12px;padding: 2px;background: #ff0000;margin: 0 0 0 1%">平台自营</span>
                            </#if>
                        </div>
                        <p class="text-bold" style="font-size: 20px;"><strong>${goods.cname}</strong></p>
                    <#if goods.goodsSpecificationDtos ??>
                        <#list goods.goodsSpecificationDtos as pecifications>
                            <#if pecifications_index==0>
                                <p class="text-info" 　 style="margin-top: 2%">
                                    <span>价　格：</span>
                                    <strong id="price" class="text-bold text-red">#{pecifications.price;m2M2} 元</strong>
                                </p>
                            </#if>
                        </#list>
                    </#if>
                    <p class="text-info" style="margin-top: 2%"><span>规　格：</span>
                    <#if goods.goodsSpecificationDtos ??>
                        <#list goods.goodsSpecificationDtos as pecifications>
                            <#if pecifications_index == 0>
                                <input type="hidden" id="pecificationsSid" name="specificationSid"
                                       value="${pecifications.sid?c}">
                                <a href="javascript:void(0)" class="pecificationsDefault pecifications"
                                   onclick="updateprice('${pecifications.sid?c}')">${pecifications.cname}
                                    &nbsp;&nbsp;</a>
                            <#else >
                                <a href="javascript:void(0)" class="pecifications"
                                   onclick="updateprice('${pecifications.sid?c}')">${pecifications.cname}
                                    &nbsp;&nbsp;</a>
                            </#if>
                        </#list>
                        <#list goods.goodsSpecificationDtos as pecifications>
                            <#if pecifications_index == 0>
                                <p class="text-info" 　 style="margin-top: 2%">
                                    <span>库 存：</span>
                                    <span id="inventory">${pecifications.inventory?c}</span> 件
                                </p>
                            <#if goods.supplier.sid != -1>
                                <p class="text-info"  style="margin-top: 2%">
                                    <span>最小购买量：≥ </span>
                                    <span id="saleCount" class="minBuyCount">${pecifications.saleCount?c}</span>
                                </p>
                            </#if>
                            </#if>
                        </#list>
                    </#if>
                        </p>
                        <span style="display: inline-block;height: 30px;line-height: 30px;margin-top: 2%">
                        <span class="text-info" style="float: left;margin-left: 0px;">数　量：</span>
                            <a href="javascript:subtraction();" title="减"
                               style="float: left;width: 30px;height:28px;background-color: #e0dfdf;text-align: center;border: 1px solid #bcbcbc;border-right: none;font-size: 28px;line-height: 24px;">-</a>
                            <input id="amount" type="number" onkeyup="inputChange(this)" value="1" name="goodsAmount"
                                   title="请输入购买数量"
                                   maxlength="6"
                                   style="float: left;width: 48px;height: 28px;text-align: center;border: 1px solid #bcbcbc;">
                            <a href="javascript:addition();" title="加"
                               style="float: left;width: 30px;height:28px;background-color: #e0dfdf;text-align: center;border: 1px solid #bcbcbc;border-left: none;font-size: 22px;line-height: 24px;">+</a>
                        <span class="text-info" style="float: left;margin-left: 10px;">件</span>
                    </span>
                        <div style="margin-top: 10%">
                            <button type="button" id="nowBuyButton" onclick="immediatelyPay('${goods.supplier.sid}')" class="btn btn-lg btn-buyNow btn-primary">
                                立即购买
                            </button>
                            <button type="button" id="addShoppingCartButton" onclick="addShoppingCart('${goods.supplier.sid}')" class="btn btn-lg btn-addShopingCart btn-default">
                                加入购物车
                            </button>
                        </div>
                        <div>
                        <#if goods.supplier.sid != -1>
                            <#if goods.goodsSpecificationDtos ??>
                                <#list goods.goodsSpecificationDtos as pecifications>
                                    <#if pecifications_index==0>
                                        <p class="minBuyCountError" style="color: red;display: none;">最小购买量 ≥ <span class="minBuyCount">${pecifications.saleCount}</span> </p>
                                    </#if>
                                </#list>
                            </#if>
                        </#if>
                        </div>
                    </div>
                </div>
            </form>
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
        $("#amount").blur(function () {
            if ($(this).val() == "") {
                $(this).val(1);
            }
        });
    });

    function subtraction() {
        var temp = $("#amount").val();
        temp = parseInt(temp);
        if (temp == 1) {
            return false;
        }
        $("#amount").val(temp - 1)
    }

    function addition() {
        var temp = $("#amount").val();
        var inventory = inventoryAmount();
        temp = parseInt(temp);
        if (temp >= inventory) {
            alert("库存不足！");
            return false;
        }
        $("#amount").val(temp + 1)
    }

    function inputChange(obj) {
        var amount = $(obj).val();
        var inventory = inventoryAmount();
        if (amount > inventory) {
            alert("库存不足，请重新输入。");
            $(obj).val(1);
            return false;
        }
        amount = parseFloat(amount, 10);
        if (amount < 1) {
            $(obj).val(1);
            amount = 1;
        }
    }

    /**
     * 不同规格的商品改变价格 和库存
     * @param cname
     */
    function updateprice(pecificationsSid) {
        $("#amount").val(1);
        $.ajax({
            type: "GET",
            url: "/goods/updatePrice",
            data: {'pecificationsSid': pecificationsSid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {

                var tempPrice = result.record.price;
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
                $("#price").html(tempPrice + " 元");
                $("#inventory").html(result.record.inventory);
                $("#pecificationsSid").val(result.record.sid);
                $(".minBuyCount").html(result.record.saleCount);
            },
            error: function (msg) {
                alert("系统繁忙");
            }
        });
        changeButtonType();
    }

    /**
     * 得到当前库存量
     */
    var inventoryAmount = function () {
        var inventory = $("#inventory").html();
        inventory = parseInt(inventory, 10);
        return inventory;
    }

    /**
     * 库存判断 改变按钮状态 禁止买库存以上商品
     */
    function changeButtonType() {
        var inventory = inventoryAmount();
        if (inventory > 0) {
            $(".btn-buyNow").attr("disabled", false);
            $(".btn-addShopingCart").attr("disabled", false);
        } else {
            $(".btn-buyNow").attr("disabled", true);
            $(".btn-addShopingCart").attr("disabled", true);
        }
    }

    $(function () {
        $(".pecifications").click(function () {
            $(".pecificationsDefault").removeClass("pecificationsDefault");
            $(this).addClass("pecificationsDefault");
        });
        changeButtonType();
    })

    function immediatelyPay(supplierSid) {
        $("#goodsDetailForm").attr("action", "/shopping/index");
        var $form = $('#goodsDetailForm');
        $form.submit(function () {
            if ($form.valid()) {
                $(".btn-buyNow").attr("disabled", true);
            }
            return true;
        });
        if(supplierSid != -1){
            var amount = $("#amount").val();
            var saleCount = $("#saleCount").text();
            amount = parseInt(amount, 10);
            saleCount = parseInt(saleCount, 10);
            if(amount < saleCount){
                $(".minBuyCountError").show();
                showCountError();
                return false;
            }else {
                $(".minBuyCountError").hide();
            }
        }
        $("#goodsDetailForm").submit();
    }

    function addShoppingCart(supplierSid) {
        var $form = $('#goodsDetailForm');
        $form.submit(function () {
            if ($form.valid()) {
                $(".btn-addShopingCart").attr("disabled", true);
            }
            return true;
        });
        if(supplierSid != -1){
            var amount = $("#amount").val();
            var saleCount = $("#saleCount").text();
            amount = parseInt(amount, 10);
            saleCount = parseInt(saleCount, 10);
            if(amount < saleCount){
                $(".minBuyCountError").show();
                showCountError();
                return false;
            }else {
                $(".minBuyCountError").hide();
            }
        }
        $("#goodsDetailForm").submit();
    }

    function showCountError() {
        var c = 5;
        var interval = setInterval(function () {
            c--;
            if (c == 0) {
                $(".minBuyCountError").hide();
                clearInterval(interval);
            }
        }, 1000);
    }
</script>

<script type="text/javascript">
    var isCommitted = false;//表单是否已经提交标识，默认为false
    function dosubmit() {
        if (isCommitted == false) {
            isCommitted = true;//提交表单后，将表单是否已经提交标识设置为true
            return true;//返回true让表单正常提交
        } else {
            return false;//返回false那么表单将不提交
        }
    }
</script>
</body>
</html>