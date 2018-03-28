<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
<#include "../_head_with_table.ftl" />
    <style>
        .box-width {
            min-width: 700px;
        }
    </style>
    <meta name="nav-url" content="/order/index">
</head>

<body>
<div class="panel box box-primary">
    <div class="box-header with-border">
        采购记录
    </div>
    <div class="box-body">
        <div class="tab-content">
            <div class="tab-pane active" id="orders_tab">
                <div class="row placeholders">
                    <div class="col-md-12 placeholder">
                        <form id="goodsIndexForm" action="/order/index" method="post" class="form-inline"
                              role="form">
                            <input type="hidden" name="page" />
                            <input type="hidden" name="size" />
                            <div class="form-group">
                                <label class="" for="name">日期</label>
                                <div class='input-group date' id='startTime'>
                                    <input type='text' name="startTime" class="form-control" value="${startTime}" />
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-calendar"></span>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 至 </label>
                                <div class='input-group date' id='endTime'>
                                    <input type='text' name="endTime" class="form-control" value="${endTime}" />
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-calendar"></span>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">状态</label>
                                <div class="input-group date">
                                    <select class="form-control" name="status">
                                        <option value="">请选择</option>
                                        <option value="0" ${(status?? && status == 0)?string('selected="selected"', "")}>
                                            已取消
                                        </option>
                                        <option value="1" ${(status?? && status == 1)?string('selected="selected"', "")}>
                                            待付款
                                        </option>
                                        <option value="2" ${(status?? && status == 2)?string('selected="selected"', "")}>
                                            待发货
                                        </option>
                                        <option value="3" ${(status?? && status == 3)?string('selected="selected"', "")}>
                                            已发货
                                        </option>
                                        <option value="4" ${(status?? && status == 4)?string('selected="selected"', "")}>
                                            已签收
                                        </option>
                                        <option value="5" ${(status?? && status == 5)?string('selected="selected"', "")}>
                                            待退款
                                        </option>
                                        <option value="6" ${(status?? && status == 6)?string('selected="selected"', "")}>
                                            已退款
                                        </option>
                                        <option value="7" ${(status?? && status == 7)?string('selected="selected"', "")}>
                                            待分拣
                                        </option>
                                        <option value="8" ${(status?? && status == 8)?string('selected="selected"', "")}>
                                            申请退货
                                        </option>
                                        <option value="9" ${(status?? && status == 9)?string('selected="selected"', "")}>
                                            申请换货
                                        </option>
                                    <#--<option value="10" ${(status?? && status == 10)?string('selected="selected"', "")}>
                                        退货成功
                                    </option>-->
                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="submit" class="btn btn-info btn-block ">查找</button>
                            </div>

                            <div class="table-responsive" style="margin-top: 2%">

                            <#if orders ??>
                                <#list orders as order>
                                    <div class="box box-warning box-width" style="width:100%;background: #f9f9f9;">
                                        <div class="box-header with-border">
                                            <div class="list-group">
                                                <div class="list-group-item"
                                                     style="background:#f9f9f9 ">
                                                    <div class="row">
                                                        <div class="col-md-2"><span
                                                                class="text-info">${order.createTime}</span>
                                                        </div>
                                                        <div class="col-md-2"><span
                                                                class="text-info">订单号：${order.sid?c}</span></div>
                                                        <div class="col-md-2"><p
                                                                class="text-info">${order.shopKeeper.cname}</p></div>
                                                        <#if order.childrenOrders?size gt 0>
                                                            <div class="col-md-2">
                                                                <span class="text-info">订单状态：已拆分</span>
                                                            </div>
                                                            <div class="col-md-4"><span class="text-info">您订单中的商品由不同供应商提供，故已经拆分为以下订单分开配送</span>
                                                            </div>
                                                        </#if>
                                                    </div>
                                                </div>
                                                <div class="list-group-item"
                                                     style="background:#f9f9f9 ">
                                                    <div class="row">
                                                        <div class="col-md-2"><span
                                                                class="text-info">收货人：${order.shopKeeper.realName}</span>
                                                        </div>
                                                        <div class="col-md-2"><span
                                                                class="text-info">订单金额：${order.totalAmount}</span></div>
                                                        <div class="col-md-2">
                                                            <#if order.channel ??>
                                                                <#if order.channel == 1>
                                                                    <span class="text-info">付款方式：微信支付</span>
                                                                <#elseif order.channel == 2>
                                                                    <span class="text-info">付款方式：支付宝支付</span>
                                                                <#elseif order.channel == 3>
                                                                    <span class="text-info">付款方式：采购余额支付</span>
                                                                </#if>
                                                            </#if>
                                                        </div>
                                                        <div class="col-md-2"><span
                                                                class="text-info">收货地址：${order.address}</span></div>
                                                        <#if order.status ==1>
                                                            <div class="col-md-2 col-md-offset-1">
                                                                <button
                                                                        onclick="buyNow('${order.sid?c}')"
                                                                        type="button"
                                                                        class="btn btn-info btn-detail"
                                                                        data-sid="1">
                                                                    <i class="fa fa-flash fa-fw"></i> 立即购买
                                                                </button>
                                                            </div>
                                                        </#if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="box-body" style="width: 100%">
                                            <#if order.childrenOrders?size gt 0>
                                                <#list order.childrenOrders as childrenOrder>
                                                    <div class="row">
                                                    <#--<div class="col-md-2 text-info">${childrenOrder.createTime}</div>-->
                                                        <div class="col-md-2 text-info">订单号：${childrenOrder.sid?c}</div>
                                                    <#if childrenOrder.status == 3>
                                                        <div class="col-md-2 text-info">
                                                            <#if childrenOrder.logisticsCompany ??>
                                                                物流公司：${childrenOrder.logisticsCompany}
                                                            </#if>
                                                        </div>
                                                        <div class="col-md-8 text-info">
                                                            <#if childrenOrder.logisticsNo ??>
                                                                物流单号：${childrenOrder.logisticsNo?replace('\n','　')}
                                                            </#if>
                                                        </div>
                                                    </#if>

                                                    </div>
                                                    <table border="1" cellpadding="0" cellspacing="0"
                                                           style="border:1px solid #CCCCCC/*#daf3ff*/;width: 100%">
                                                        <#list childrenOrder.ordersGoodsList as childrenOrderGood>
                                                            <tr>
                                                                <td style="width: 61%;">
                                                                    <div class="row">
                                                                        <div class="col-md-4">
                                                                            <#if childrenOrderGood.goods.goodsFiles ??>
                                                                                <#if childrenOrderGood.goods.goodsFiles?size == 0>
                                                                                    <img style="width: 30%;margin-left:10%"
                                                                                         class="img-thumbnail"
                                                                                         src="/assets/img/goods/img-goods-default.png" />
                                                                                </#if>
                                                                                <#list childrenOrderGood.goods.goodsFiles as childrenGoodsfile>
                                                                                    <#if childrenGoodsfile_index == 0>
                                                                                        <img style="width: 30%;margin-left:10%"
                                                                                             class="img-thumbnail"
                                                                                             onerror="checkImgFun(this)"
                                                                                             src="${childrenGoodsfile.url}" />
                                                                                    <#else>
                                                                                        <img style="width: 30%;margin-left:10%"
                                                                                             class="img-thumbnail"
                                                                                             src="/assets/img/goods/img-goods-default.png" />
                                                                                    </#if>
                                                                                </#list>
                                                                            <#else>
                                                                                <img style="width: 30%;margin-left:10%"
                                                                                     class="img-thumbnail"
                                                                                     src="/assets/img/goods/img-goods-default.png" />
                                                                            </#if>
                                                                        </div>
                                                                        <div class="col-md-3 text-info"
                                                                             style="margin-top: 40px;">
                                                                            <p>
                                                                                商品名称：${childrenOrderGood.goodsCname}</p>
                                                                        </div>
                                                                        <div class="col-md-3 text-info"
                                                                             style="margin-top: 40px;">
                                                                            <p>
                                                                                商品数量：${childrenOrderGood.goodsCount}
                                                                                件</p>
                                                                        </div>
                                                                        <div class="col-md-2 text-info"
                                                                             style="margin-top: 40px;">
                                                                            <p>
                                                                                ￥：#{childrenOrderGood.goodsSpecificationPrice;m2M2}/件</p>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <#if childrenOrderGood_index == 0>
                                                                    <td class="text-info" style="width: 13%; text-align: center;"
                                                                        rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                        ￥#{childrenOrder.totalAmount;m2M2}</td>
                                                                    <#if childrenOrder.status == 0>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">已取消</p></td>
                                                                    <#elseif childrenOrder.status == 1>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">待付款</p></td>
                                                                    <#elseif childrenOrder.status == 2>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">待发货</p>
                                                                        </td>
                                                                    <#elseif childrenOrder.status == 3>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">已发货</p></td>
                                                                    <#elseif childrenOrder.status == 4>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">已签收</p></td>
                                                                    <#elseif childrenOrder.status == 5>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">待退款</p></td>
                                                                    <#elseif childrenOrder.status == 6>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">已退款</p></td>
                                                                    <#elseif childrenOrder.status == 7>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">待分拣</p></td>
                                                                    <#elseif childrenOrder.status == 8>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">申请退货</p></td>
                                                                    <#elseif childrenOrder.status == 9>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">申请换货</p></td>
                                                                    <#elseif childrenOrder.status == 10>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">申请退货成功</p></td>
                                                                    </#if>
                                                                    <#if childrenOrder.status == 3>
                                                                        <td style="width: 13%; text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <button type="button" style="min-width: 100px;margin-bottom: 3px;" class="btn btn-primary btn-takeGoods" data-sid="${childrenOrder.sid?c}">
                                                                                确认收货
                                                                            </button>
                                                                            <button type="button" style="min-width: 100px;margin-bottom: 3px;" class="btn btn-default" onclick="afterSaleModal('${childrenOrder.sid?c}')">
                                                                                申请退换货
                                                                            </button>
                                                                        </td>
                                                                    <#else>
                                                                        <td style="width: 13%;" rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                        </td>
                                                                    </#if>
                                                                </#if>
                                                            </tr>
                                                        </#list>
                                                    </table>
                                                </#list>
                                            <#else >
                                            <#if order.status == 3>
                                                <div class="row">
                                                    <div class="col-md-2 text-info">
                                                        <#if order.logisticsCompany ??>
                                                            物流公司：${order.logisticsCompany}
                                                        </#if>
                                                    </div>
                                                    <div class="col-md-8 text-info">
                                                        <#if order.logisticsNo ??>
                                                            物流单号：${order.logisticsNo?replace('\n','　')}
                                                        </#if>
                                                    </div>
                                                </div>
                                            </#if>
                                                <table border="1" cellpadding="0" cellspacing="0"
                                                       style="border:1px solid #CCCCCC;width: 100%;">
                                                    <#list order.ordersGoodsList as orderGood>
                                                        <tr>
                                                            <td style="width: 61%;">
                                                                <div class="row">
                                                                    <div class="col-md-4">
                                                                        <#if orderGood.goods.goodsFiles ??>
                                                                            <#if orderGood.goods.goodsFiles?size == 0>
                                                                                <img style="width: 30%;margin-left:10%"
                                                                                     class="img-thumbnail"
                                                                                     src="/assets/img/goods/img-goods-default.png" />
                                                                            </#if>
                                                                            <#list orderGood.goods.goodsFiles as goodsfile>
                                                                                <#if goodsfile_index == 0>
                                                                                    <img style="width: 30%;margin-left:10%"
                                                                                         onerror="checkImgFun(this)"
                                                                                         class="img-thumbnail"
                                                                                         src="${goodsfile.url}" />
                                                                                <#else>
                                                                                    <img style="width: 30%;margin-left:10%"
                                                                                         class="img-thumbnail"
                                                                                         src="/assets/img/goods/img-goods-default.png" />
                                                                                </#if>
                                                                            </#list>
                                                                        <#else>
                                                                            <img style="width: 30%;margin-left:10%"
                                                                                 class="img-thumbnail"
                                                                                 src="/assets/img/goods/img-goods-default.png" />
                                                                        </#if>
                                                                    </div>
                                                                    <div class="col-md-3"
                                                                         style="margin-top: 40px;">
                                                                        <p class="text-info">
                                                                            商品名称：${orderGood.goodsCname}</p>
                                                                    </div>
                                                                    <div class="col-md-3"
                                                                         style="margin-top: 40px;">
                                                                        <p class="text-info">
                                                                            商品数量：${orderGood.goodsCount} 件</p>
                                                                    </div>
                                                                    <div class="col-md-2"
                                                                         style="margin-top: 40px;">
                                                                        <p class="text-info">
                                                                            ￥：#{orderGood.goodsSpecificationPrice ;m2M2}/件</p>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <#if orderGood_index == 0>
                                                                <td class="text-info" style="width: 13%; text-align: center;"
                                                                    rowspan="${order.ordersGoodsList?size}">
                                                                    ￥#{order.totalAmount;m2M2}</td>
                                                                <#if order.status == 0>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">已取消</p></td>
                                                                <#elseif order.status == 1>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">待付款</p></td>
                                                                <#elseif order.status == 2>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">待发货</p></td>
                                                                <#elseif order.status == 3>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">已发货</p></td>
                                                                <#elseif order.status == 4>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">已签收</p></td>
                                                                <#elseif order.status == 5>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">待退款</p></td>
                                                                <#elseif order.status == 6>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">已退款</p></td>
                                                                <#elseif order.status == 7>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">待分拣</p></td>
                                                                <#elseif order.status == 8>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">申请退货</p></td>
                                                                <#elseif order.status == 9>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">申请换货</p></td>
                                                                <#elseif order.status == 10>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">申请退货成功</p></td>
                                                                </#if>
                                                                <#if order.status == 3>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <button type="button" style="min-width: 100px;margin-bottom: 3px;" class="btn btn-primary btn-takeGoods" data-sid="${order.sid?c}">
                                                                            确认收货
                                                                        </button>
                                                                        <button type="button" style="min-width: 100px;margin-bottom: 3px;" class="btn btn-default" onclick="afterSaleModal('${order.sid?c}')">
                                                                            申请退换货
                                                                        </button>
                                                                    </td>
                                                                <#else>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                    </td>
                                                                </#if>
                                                            </#if>
                                                        </tr>
                                                    </#list>
                                                </table>
                                            </#if>
                                        </div>
                                    </div>
                                </#list>
                            </#if>
                            <#if orders?size == 0>
                                <p style="text-align: center;">没有采购记录！</p>
                            </#if>
                                <table data-toggle="table" data-page-info='${pageInfo}'
                                       data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                    <thead>
                                        <tr>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tr>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="afterSaleModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        选择退/换货
                    </h4>
                </div>
                <div class="modal-body">
                    <form id="afterSaleForm" action="/afterSale/index" method="post" class="form-inline">
                        <input type="radio" name="afterSaleStatus" value="8" checked="checked" /><span class="text-info">&nbsp;&nbsp;申请退货&nbsp;&nbsp;&nbsp;&nbsp;</span>
                        <input type="radio" name="afterSaleStatus" value="9" /><span class="text-info">&nbsp;&nbsp;申请换货&nbsp;&nbsp;&nbsp;&nbsp;</span>
                        <input id="afterSaleOrdersSid" type="hidden" name="ordersSid">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button id="afterSaleButton" onclick="submitBuyNowafterSale()" type="button" class="btn btn-primary">
                        确认
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>
    <div class="modal fade" id="buyModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        选择支付方式
                    </h4>
                </div>
                <div class="modal-body">
                    <form id="buyNowForm" action="/shopping/pay" method="post" class="form-inline">
                        <input type="radio" name="payType" value="1" checked="checked" /><span class="text-red">&nbsp;&nbsp;微信支付&nbsp;&nbsp;&nbsp;&nbsp;</span>
                        <input type="radio" name="payType" value="2" /><span class="text-red">&nbsp;&nbsp;支付宝支付&nbsp;&nbsp;&nbsp;&nbsp;</span>
                        <input type="radio" name="payType" value="3" /><span class="text-red">&nbsp;&nbsp;网银支付</span>
                        <input id="ordersSid" type="hidden" name="ordersSid">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button id="BuyNowButton" onclick="submitBuyNow()" type="button" class="btn btn-primary">
                        确认
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
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

        $(document).on('click', '.btn-takeGoods', function () {
            var $t = $(this), sid = $t.data('sid');
            confirmFun('/shopping/takeGoods?orderid=' + sid, '确认收货？');
        });
    });

    function afterSaleModal(ordersSid) {
        $('#afterSaleModal').modal('show');
        $("#afterSaleOrdersSid").val(ordersSid);
    }

    function submitBuyNowafterSale() {
        $('#afterSaleModal').modal('hide');
        var $form = $('#afterSaleForm');
        $form.submit(function () {
            if ($form.valid()) {
                $("#afterSaleButton").attr("disabled", true);
            }
            return true;
        });
        $("#afterSaleForm").submit();
    }

    function buyNow(ordersSid) {
        $('#buyModal').modal('show');
        $("#ordersSid").val(ordersSid);
    }

    function submitBuyNow() {
        $('#buyModal').modal('hide');
        var $form = $('#buyNowForm');
        $form.submit(function () {
            if ($form.valid()) {
                $("#BuyNowButton").attr("disabled", true);
            }
            return true;
        });
        $("#buyNowForm").submit();
    }
</script>
</body>
</html>