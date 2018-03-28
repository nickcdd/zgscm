<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
<#include "/_head_with_datepicker.ftl" />
    <style>
        .box-width {
            min-width: 700px;
        }
    </style>
    <meta name="nav-url" content="/orders/index">
    <script type="text/javascript">
        $(function () {
            var picker1 = $('#datetimepicker1').datetimepicker({
                format: "yyyy-mm-dd hh:ii",
                language: 'zh-CN',
                //minDate: '2016-7-1'
            });
            var picker2 = $('#datetimepicker2').datetimepicker({
                format: "yyyy-mm-dd hh:ii",
                language: 'zh-CN',
            });
            //动态设置最小值
            picker1.on('changeDate', function (e) {

                picker2.datetimepicker('setStartDate', e.date);
            });
            //动态设置最大值
            picker2.on('changeDate', function (e) {

                picker1.datetimepicker('setEndDate', e.date);

            });
            var $form = $('#detailForm');
            $(document).on('click', '.btn-detail', function () {
                var $t = $(this), sid = $t.data('sid');
                var pageStr = setPageInfo();

                location.href = "detail?sid=" + sid + pageStr;

            });


            $('.btn-cancel').click(function () {
                $form.clearForm(true);
                $('#supplierList').show();
                $('#supplierDetail').hide();
            });

            $form.submit(function () {
                if ($form.valid()) {
                    var data = $form.formJSON('get');


                }

                return true;
            });

            $form.clearForm(true);
        });
        function setPageInfo() {
            var str = "";
            str += "&redirectPage=" + ($('#infoTable').attr("data-page-number") - 1);
            str += "&redirectSize=" + $('#infoTable').attr("data-page-size");

            if ($('#startDate').val() != undefined && $('#startDate').val() != "") {
                str += "&redirectStartDate=" + $('#startDate').val();
//                $('#redirectStartDate').val($('#startDate').val());
            }
            if ($('#endDate').val() != undefined && $('#endDate').val() != "") {

//                $('#redirectEndDate').val($('#endDate').val());
                str += "&redirectEndDate=" + $('#endDate').val();
            }

            if ($('#shopKeeperName').val() != undefined && $('#shopKeeperName').val() != "") {

//                $('#redirectQ').val($('#q').val());
                str += "&redirectShopKeeperName=" + $('#shopKeeperName').val();
            }
            if ($('#goodsName').val() != undefined && $('#goodsName').val() != "") {

//                $('#redirectQ').val($('#q').val());
                str += "&redirectGoodsName=" + $('#goodsName').val();
            }
            if ($('#status').val() != undefined && $('#status').val() != "") {

//                $('#redirectQ').val($('#q').val());
                str += "&redirectStatus=" + $('#status').val();
            }
            return str;
        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">订单列表</h3>
            </div>
            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form action="/orders/index" method="post" class="form-inline" role="search-form">
                            <input type="hidden" name="page"/>
                            <input type="hidden" name="size"/>
                            <div class="form-group">
                                <label class="" for="name">日期</label>
                                <div class='input-group date' id='datetimepicker1'>
                                    <input type='text' name="startDate" class="form-control" id="startDate"
                                           value="${startDate}" readonly/>
                                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
                                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-remove"></span>
                </span>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 至 </label>
                                <div class='input-group date' id='datetimepicker2'>
                                    <input type='text' name="endDate" class="form-control" id="endDate"
                                           value="${endDate}" readonly/>
                                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-calendar"></span>
                </span>
                                    <span class="input-group-addon">
                    <span class="glyphicon glyphicon-remove"></span>
                </span>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 商户名称 </label>
                                <div class='input-group'>
                                    <input type='text' name="shopKeeperName" class="form-control" id="shopKeeperName"
                                           value="${shopKeeperName}"/>

                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 商品名称 </label>
                                <div class='input-group'>
                                    <input type='text' name="goodsName" class="form-control" id="goodsName"
                                           value="${goodsName}"/>

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
                                            已付款
                                        </option>
                                        <option value="3" ${(status?? && status == 3)?string('selected="selected"', "")}>
                                            已发货
                                        </option>
                                        <option value="4" ${(status?? && status == 4)?string('selected="selected"', "")}>
                                            已收货
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
                                        <option value="10" ${(status?? && status == 10)?string('selected="selected"', "")}>
                                            退、换货成功
                                        </option>

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
                                                                class="text-info">${order.supplierCname!''}</p></div>
                                                        <#if order.childrenOrders?size gt 0>
                                                            <div class="col-md-2"><span
                                                                    class="text-info">订单状态：已拆分</span>
                                                            </div>
                                                            <div class="col-md-4"><span
                                                                    class="text-info">您的订单有缺货商品，故拆分订单</span>
                                                            </div>
                                                        <#else >
                                                            <#if order.logisticsNo??>
                                                                <div class="col-md-5"><span
                                                                        class="text-info">物流信息：${order.logisticsCompany!''},${order.logisticsNo?replace("\n","  ")}</span>
                                                                </div>
                                                            </#if>
                                                        </#if>
                                                    </div>
                                                </div>
                                                <div class="list-group-item"
                                                     style="background:#f9f9f9 ">
                                                    <div class="row">
                                                        <div class="col-md-2"><span
                                                                class="text-info">收货人：${order.shopKeeper.realName!''}</span>
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
                                                                    <span class="text-info">付款方式：网银支付</span>
                                                                </#if>
                                                            </#if>
                                                        </div>
                                                        <div class="col-md-2"><span
                                                                class="text-info">收货地址：${order.province!''},${order.city!''},${order.area!''},${order.address!''}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="box-body" style="width: 100%">
                                            <#if order.childrenOrders?size gt 0>
                                                <#list order.childrenOrders as childrenOrder>
                                                    <div class="row">
                                                        <div class="col-md-2">${childrenOrder.createTime}</div>
                                                        <div class="col-md-2">订单号：${childrenOrder.sid?c}</div>
                                                        <div class="col-md-2"><p>${childrenOrder.supplierCname!''}</p>
                                                        </div>
                                                        <#if childrenOrder.logisticsNo??>
                                                            <div class="col-md-5"><p>
                                                                物流信息：${childrenOrder.logisticsCompany!''},${childrenOrder.logisticsNo?replace("\n","  ")}</p>
                                                            </div>
                                                        </#if>
                                                    </div>
                                                    <table border="1" cellpadding="0" cellspacing="0"
                                                           style="border:1px solid #daf3ff;width: 100%">
                                                        <#list childrenOrder.ordersGoodsList as childrenOrderGood>
                                                            <tr>
                                                                <td style="width: 61%;">
                                                                    <div class="row">
                                                                        <div class="col-md-4">
                                                                        <#--<#if childrenOrderGood.goods.goodsFiles ??>-->
                                                                        <#--<#if childrenOrderGood.goods.goodsFiles?size ==0>-->
                                                                        <#--<img style="width: 30%;margin-left:10%"-->
                                                                        <#--class="img-thumbnail"-->
                                                                        <#--src="/assets/img/goods/img-goods-default.png"/>-->
                                                                        <#--<#else >-->
                                                                        <#--<#list childrenOrderGood.goods.goodsFiles as childrenGoodsfile>-->
                                                                        <#--<#if childrenGoodsfile_index == 0>-->
                                                                        <#--<img style="width: 30%;margin-left:10%"-->
                                                                        <#--class="img-thumbnail"-->
                                                                        <#--src="${childrenGoodsfile.url}"/>-->
                                                                        <#--</#if>-->
                                                                        <#--</#list>-->
                                                                        <#--</#if>-->
                                                                        <#--<#else >-->
                                                                        <#--<img style="width: 30%;margin-left:10%"-->
                                                                        <#--class="img-thumbnail"-->
                                                                        <#--src="/assets/img/goods/img-goods-default.png"/>-->
                                                                        <#--</#if>-->
                                                                            <#if childrenOrderGood.goods.goodsFiles ??>
                                                                                <#if childrenOrderGood.goods.goodsFiles?size == 0>
                                                                                    <img style="width: 30%;margin-left:10%"
                                                                                         class="img-thumbnail"
                                                                                         src="/assets/img/goods/img-goods-default.png"/>
                                                                                <#else>
                                                                                    <#list childrenOrderGood.goods.goodsFiles as goodsfile>
                                                                                        <#if goodsfile_index == 0>
                                                                                            <img style="width: 30%;margin-left:10%"
                                                                                                 class="img-thumbnail"
                                                                                                 src="${goodsfile.url}"/>
                                                                                        </#if>
                                                                                    </#list>
                                                                                </#if>

                                                                            <#else>
                                                                                <img style="width: 30%;margin-left:10%"
                                                                                     class="img-thumbnail"
                                                                                     src="/assets/img/goods/img-goods-default.png"/>
                                                                            </#if>
                                                                        </div>
                                                                        <div class="col-md-3"
                                                                             style="margin-top: 2%">
                                                                            <p>
                                                                                商品名称：${childrenOrderGood.goodsCname!''}</p>
                                                                        </div>
                                                                        <div class="col-md-3"
                                                                             style="margin-top: 2%">
                                                                            <p>
                                                                                商品数量：${childrenOrderGood.goodsCount}
                                                                                件</p>
                                                                        </div>
                                                                        <div class="col-md-2"
                                                                             style="margin-top: 2%">
                                                                            <p>
                                                                                ￥：${childrenOrderGood.goodsSpecificationPrice}/件</p>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <#if childrenOrderGood_index == 0>
                                                                    <td style="width: 13%; text-align: center;"
                                                                        rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                        ￥${childrenOrder.payAmount}</td>
                                                                    <#if childrenOrder.status == 0>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">已取消</p></td>
                                                                    <#elseif childrenOrder.status == 1>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">待付款</p></td>
                                                                    <#elseif childrenOrder.status == 2>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">已付款</p>
                                                                        </td>
                                                                    <#elseif childrenOrder.status == 3>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">已发货</p></td>
                                                                    <#elseif childrenOrder.status == 4>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">已签收</p></td>
                                                                    <#elseif childrenOrder.status == 5>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">待退款</p></td>
                                                                    <#elseif childrenOrder.status == 6>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">已退款</p></td>
                                                                    <#elseif childrenOrder.status == 7>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">待分拣</p></td>
                                                                    <#elseif childrenOrder.status == 8>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">申请退货</p></td>
                                                                    <#elseif childrenOrder.status == 9>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">申请换货</p></td>
                                                                    <#elseif childrenOrder.status == 10>
                                                                        <td style="width: 13%;text-align: center;"
                                                                            rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                            <p class="text-primary">退、换货成功</p></td>
                                                                    </#if>
                                                                    <td style="width:13%;text-align: center;"
                                                                        rowspan="${childrenOrder.ordersGoodsList?size}">
                                                                    <#--<#if childrenOrder.status == 1>-->
                                                                        <button data-sid="${childrenOrder.sid?c}"
                                                                           type="button"
                                                                           class="btn btn-info btn-xs btn-detail"
                                                                           data-sid="1">
                                                                            <i class="fa fa-info fa-fw"></i> 详情
                                                                        </button>
                                                                    <#--</#if>-->
                                                                    </td>
                                                                </#if>
                                                            </tr>
                                                        </#list>
                                                    </table>
                                                </#list>
                                            <#else >
                                                <table border="1" cellpadding="0" cellspacing="0"
                                                       style="border:1px solid #daf3ff;width: 100%;">
                                                    <#list order.ordersGoodsList as orderGood>
                                                        <tr>
                                                            <td style="width: 61%;">
                                                                <div class="row">
                                                                    <div class="col-md-4">
                                                                    <#--<#if orderGood.goods.goodsFiles ??>-->
                                                                    <#--<#list orderGood.goods.goodsFiles as goodsfile>-->
                                                                    <#--<#if goodsfile_index == 0>-->
                                                                    <#--<img style="width: 30%;margin-left:10%"-->
                                                                    <#--class="img-thumbnail"-->
                                                                    <#--src="${goodsfile.url}"/>-->
                                                                    <#--</#if>-->
                                                                    <#--</#list>-->
                                                                    <#--</#if>-->
                                                                        <#if orderGood.goods.goodsFiles ??>
                                                                            <#if orderGood.goods.goodsFiles?size == 0>
                                                                                <img style="width: 30%;margin-left:10%"
                                                                                     class="img-thumbnail"
                                                                                     src="/assets/img/goods/img-goods-default.png"/>
                                                                            <#else>
                                                                                <#list orderGood.goods.goodsFiles as goodsfile>
                                                                                    <#if goodsfile_index == 0>
                                                                                        <img style="width: 30%;margin-left:10%"
                                                                                             class="img-thumbnail"
                                                                                             src="${goodsfile.url}"/>
                                                                                    </#if>
                                                                                </#list>
                                                                            </#if>

                                                                        <#else>
                                                                            <img style="width: 30%;margin-left:10%"
                                                                                 class="img-thumbnail"
                                                                                 src="/assets/img/goods/img-goods-default.png"/>
                                                                        </#if>
                                                                    </div>
                                                                    <div class="col-md-3"
                                                                         style="margin-top: 2%">
                                                                        <p class="text-info">
                                                                            商品名称：${orderGood.goodsCname!''}</p>
                                                                    </div>
                                                                    <div class="col-md-3"
                                                                         style="margin-top: 2%">
                                                                        <p class="text-info">
                                                                            商品数量：${orderGood.goodsCount} 件</p>
                                                                    </div>
                                                                    <div class="col-md-2"
                                                                         style="margin-top: 2%">
                                                                        <p class="text-info">
                                                                            ￥：${orderGood.goodsSpecificationPrice}/件</p>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <#if orderGood_index == 0>
                                                                <td style="width: 13%; text-align: center;"
                                                                    rowspan="${order.ordersGoodsList?size}">
                                                                    ￥${order.payAmount}</td>
                                                                <#if order.status == 0>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">已取消</p></td>
                                                                <#elseif order.status == 1>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">待付款</p></td>
                                                                <#elseif order.status == 2>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">买家已付款</p></td>
                                                                <#elseif order.status == 3>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">已发货</p></td>
                                                                <#elseif order.status == 4>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">已签收</p></td>
                                                                <#elseif order.status == 5>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">待退款</p></td>
                                                                <#elseif order.status == 6>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">已退款</p></td>
                                                                <#elseif order.status == 7>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">待分拣</p></td>
                                                                <#elseif order.status == 8>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">申请退货</p></td>
                                                                <#elseif order.status == 9>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">申请换货</p></td>
                                                                <#elseif order.status == 10>
                                                                    <td style="width: 13%;text-align: center;"
                                                                        rowspan="${order.ordersGoodsList?size}">
                                                                        <p class="text-primary">退、换货成功</p></td>
                                                                </#if>
                                                                <td style="width: 13%;text-align: center;"
                                                                    rowspan="${order.ordersGoodsList?size}">
                                                                    <button
                                                                       type="button" data-sid="${order.sid?c}"
                                                                       class="btn btn-info btn-xs btn-detail"
                                                                       data-sid="1">
                                                                        <i class="fa fa-info fa-fw"></i> 详情
                                                                    </button>
                                                                </td>
                                                            </#if>
                                                        </tr>
                                                    </#list>
                                                </table>
                                            </#if>
                                        </div>
                                    </div>
                                </#list>
                            </#if>
                                <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
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
</div>


<#--<div class="row">-->
<#--<div class="col-md-12" id="ordersList">-->
<#--<div class="box box-info">-->
<#--<div class="box-header with-border">-->
<#--<h3 class="box-title">订单列表</h3>-->
<#--</div>-->
<#--<div class="box-body">-->
<#--<div class="row placeholders">-->
<#--<div class="col-md-12 placeholders">-->
<#--<form action="/orders/index" method="post" class="form-inline" role="search-form">-->
<#--<input type="hidden" name="page"/>-->
<#--<input type="hidden" name="size"/>-->
<#--<div class="form-group">-->
<#--<label class="" for="name">日期</label>-->
<#--<div class='input-group date' id='datetimepicker1'>-->
<#--<input type='text' name="startDate" class="form-control" id="startDate"-->
<#--value="${startDate}" readonly/>-->
<#--<span class="input-group-addon">-->
<#--<span class="glyphicon glyphicon-calendar"></span>-->
<#--</span>-->
<#--<span class="input-group-addon">-->
<#--<span class="glyphicon glyphicon-remove"></span>-->
<#--</span>-->
<#--</div>-->
<#--</div>-->
<#--<div class="form-group ">-->
<#--<label class="" for="name"> 至 </label>-->
<#--<div class='input-group date' id='datetimepicker2'>-->
<#--<input type='text' name="endDate" class="form-control" id="endDate"-->
<#--value="${endDate}" readonly/>-->
<#--<span class="input-group-addon">-->
<#--<span class="glyphicon glyphicon-calendar"></span>-->
<#--</span>-->
<#--<span class="input-group-addon">-->
<#--<span class="glyphicon glyphicon-remove"></span>-->
<#--</span>-->
<#--</div>-->
<#--</div>-->
<#--<div class="form-group ">-->
<#--<label class="" for="name"> 商户名称 </label>-->
<#--<div class='input-group'>-->
<#--<input type='text' name="shopKeeperName" class="form-control" id="shopKeeperName"-->
<#--value="${shopKeeperName}"/>-->

<#--</div>-->
<#--</div>-->
<#--<div class="form-group ">-->
<#--<label class="" for="name"> 商品名称 </label>-->
<#--<div class='input-group'>-->
<#--<input type='text' name="goodsName" class="form-control" id="goodsName"-->
<#--value="${goodsName}"/>-->

<#--</div>-->
<#--</div>-->
<#--<div class="form-group ">-->
<#--<label class="" for="name">状态</label>-->
<#--<div class="input-group date">-->
<#--<select class="form-control" name="status">-->
<#--<option value="">请选择</option>-->
<#--<option value="0" ${(status?? && status == 0)?string('selected="selected"', "")}>-->
<#--已取消-->
<#--</option>-->
<#--<option value="1" ${(status?? && status == 1)?string('selected="selected"', "")}>-->
<#--待付款-->
<#--</option>-->
<#--<option value="2" ${(status?? && status == 2)?string('selected="selected"', "")}>-->
<#--已付款-->
<#--</option>-->
<#--<option value="3" ${(status?? && status == 3)?string('selected="selected"', "")}>-->
<#--已发货-->
<#--</option>-->
<#--<option value="4" ${(status?? && status == 4)?string('selected="selected"', "")}>-->
<#--已收货-->
<#--</option>-->
<#--<option value="5" ${(status?? && status == 5)?string('selected="selected"', "")}>-->
<#--待退款-->
<#--</option>-->
<#--<option value="6" ${(status?? && status == 6)?string('selected="selected"', "")}>-->
<#--已退款-->
<#--</option>-->

<#--</select>-->
<#--</div>-->
<#--</div>-->
<#--<div class="form-group ">-->
<#--<button type="submit" class="btn btn-info btn-block ">查找</button>-->
<#--</div>-->
<#--<div class="table-responsive" style="margin-top: 2%">-->
<#--<table data-toggle="table" data-page-info='${pageInfo}'-->
<#--data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">-->
<#--<thead style="display:none ">-->
<#--<tr>-->
<#--<th></th>-->
<#--</tr>-->
<#--</thead>-->
<#--<#list orders as o>-->
<#--<tr>-->
<#--<td>-->
<#--<div class="box box-info">-->
<#--<div class="box-body">-->
<#--<div class="row">-->
<#--<div class="col-md-2">-->
<#--订单时间：${o.createTime?string("yyyy-MM-dd HH:mm:ss")!''}</div>-->
<#--<div class="col-md-2">订单号：${o.sid !''}</div>-->
<#--<div class="col-md-2"><p class="text-info">-->
<#--商户名称：${o.shopKeeper.cname!''}</p></div>-->
<#--</div>-->
<#--<table border="1" cellpadding="0" cellspacing="0"-->
<#--style="border:1px solid #daf3ff">-->
<#--<#if o.ordersGoodsList ?? >-->
<#--<#list o.ordersGoodsList as ordersGoodsList>-->
<#--<tr>-->
<#--<td style="width: 70%;">-->
<#--<div class="row">-->
<#--<div class="col-md-4">-->
<#--<#if ordersGoodsList.goods.goodsFiles ?? >-->
<#--<#list ordersGoodsList.goods.goodsFiles as file>-->
<#--<#if file_index==0>-->
<#--<img style="width: 30%;margin-left:10%"-->
<#--class="img-thumbnail"-->
<#--src="${file.url}"/>-->
<#--</#if>-->
<#--</#list>-->
<#--</#if>-->
<#--</div>-->
<#--<div class="col-md-3"-->
<#--style="margin-top: 2%">-->
<#--<p class="text-info">-->
<#--商品名称：${ordersGoodsList.goodsCname!''}</p>-->
<#--</div>-->
<#--<div class="col-md-3"-->
<#--style="margin-top: 2%">-->
<#--<p class="text-info">-->
<#--商品数量：${ordersGoodsList.goodsCount!''}-->
<#--件</p>-->
<#--</div>-->
<#--<div class="col-md-2"-->
<#--style="margin-top: 2%">-->
<#--<p class="text-info">-->
<#--￥：${ordersGoodsList.goodsSpecificationPrice!''}/件</p>-->
<#--</div>-->
<#--</div>-->
<#--</td>-->
<#--<#if ordersGoodsList_index==0>-->
<#--<td style="width: 10%; text-align: center;"-->
<#--rowspan="${ordersGoodsList?size}">￥${o.payAmount}-->
<#--</td>-->
<#--<td style="width: 10%;text-align: center;"-->
<#--rowspan="${ordersGoodsList?size}"><p-->
<#--class="text-primary"><#if o.status==0>-->
<#--已取消-->
<#--<#elseif o.status==1>-->
<#--待付款-->
<#--<#elseif o.status==2>-->
<#--待发货-->
<#--<#elseif o.status==3>-->
<#--已发货-->
<#--<#elseif o.status==4>-->
<#--已收货-->
<#--<#elseif o.status==5>-->
<#--待退款-->
<#--<#elseif o.status==6>-->
<#--已退款-->

<#--<#else>-->

<#--</#if></p></td>-->
<#--<td style="width: 10%;text-align: center;"-->
<#--rowspan="${ordersGoodsList?size}">-->
<#--<a href="/orders/detail?sid=${o.sid?c}"-->
<#--type="button"-->
<#--class="btn btn-info btn-xs btn-detail"-->
<#--data-sid="">-->
<#--<i class="fa fa-info fa-fw"></i> 详情-->
<#--</a>-->
<#--</td>-->
<#--</#if>-->
<#--</tr>-->
<#--</#list>-->
<#--</#if>-->
<#--</table>-->
<#--</div>-->
<#--</div>-->
<#--</td>-->
<#--</tr>-->
<#--</#list>-->
<#--</table>-->
<#--</div>-->
<#--</form>-->
<#--</div>-->
<#--</div>-->
<#--</div>-->
<#--</div>-->
<#--</div>-->
<#--</div>-->

</body>
</html>