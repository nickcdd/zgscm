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
                <h3 class="box-title">订单详情</h3>
            </div>
            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <div class="tab-pane active" id="peopleData_tab">
                            <div class="row form-group">
                                <div class="col-md-1 text-right">
                                    <label class="" for="name">收货地址：</label>
                                </div>
                                <div class="col-md-9">
                                    <p>${order.shopKeeper.realName}，${order.shopKeeper.telephone}，${order.address}</p>
                                </div>
                            </div>
                            <hr />
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-1 text-right">
                                        <label class="" for="name">买家信息：</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-2 col-md-offset-1 text-center">
                                        <p>商户名称，${order.shopKeeper.cname}</p>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <p>姓名，${order.shopKeeper.realName}</p>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <p>联系电话，${order.shopKeeper.telephone}</p>
                                    </div>
                                </div>
                            </div>
                            <hr />
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-1 text-right">
                                        <label class="" for="name">订单信息：</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-2 col-md-offset-1 text-center">
                                        <p>下单时间：${order.createTime}</p>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <p>订单编号：${order.sid}</p>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <#if order.status == 0>
                                            <p>订单状态：已取消</p>
                                        <#elseif order.status == 1>
                                            <p>订单状态：待付款</p>
                                        <#elseif order.status == 2>
                                            <p>订单状态：已付款</p>
                                        <#elseif order.status == 3>
                                            <p>订单状态：已发货</p>
                                        <#elseif order.status == 4>
                                            <p>订单状态：已签收</p>
                                        <#elseif order.status == 5>
                                            <p>订单状态：待退款</p>
                                        <#elseif order.status == 6>
                                            <p>订单状态：已退款</p>
                                        </#if>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-11 col-md-offset-1 text-center">
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th width="20%">
                                                        <div class="th-inner">商品展示</div>
                                                    </th>
                                                    <th width="20%">
                                                        <div class="th-inner">商品名称</div>
                                                    </th>
                                                    <th width="20%">
                                                        <div class="th-inner">商品数量</div>
                                                    </th>
                                                    <th width="20%">
                                                        <div class="th-inner">商品单价/元</div>
                                                    </th>
                                                    <th width="20%">
                                                        <div class="th-inner">商品总价/元</div>
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <#if order.ordersGoodsList ??>
                                                <#list order.ordersGoodsList as orderGood>
                                                <tr>
                                                    <td width="20%">
                                                        <div class="th-inner">
                                                            <#if orderGood.goods.goodsFiles ??>
                                                                <#list orderGood.goods.goodsFiles as goodsfile>
                                                                    <#if goodsfile_index == 0>
                                                                        <img style="width: 30%;margin-left:10%"
                                                                             class="img-thumbnail"
                                                                             src="${goodsfile.url}"/>
                                                                    </#if>
                                                                </#list>
                                                            </#if>
                                                        </div>
                                                    </td>
                                                    <td width="20%">
                                                        <div class="th-inner">${orderGood.goodsCname}</div>
                                                    </td>
                                                    <td width="20%">
                                                        <div class="th-inner">${orderGood.goodsCount}</div>
                                                    </td>
                                                    <td width="20%">
                                                        <div class="th-inner">${orderGood.goodsSpecificationPrice}</div>
                                                    </td>
                                                    <td width="20%">
                                                        <div class="th-inner">${(orderGood.goodsSpecificationPrice) * (orderGood.goodsCount)}</div>
                                                    </td>
                                                </tr>
                                                </#list>
                                            </#if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-md-12 text-right">
                                    <a href="javascript:history.go(-1)" class="btn btn-default" for="name">返回</a>　　
                                    <button disabled="disabled" class="btn btn-primary" for="name">发货</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>

</script>
</body>
</html>