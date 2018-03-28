<#if orders_mobile ?? && orders_mobile.totalElements gt 0>
    <#list orders_mobile.content as order>
        <#if order.childrenOrders?size gt 0>
        <div class="box box-warning" style="background: #f9f9f9;">
            <div class="box-body">
                <#list order.childrenOrders as childrenOrder>
                    <div style="background-color: #FFFFFF;">
                        <div style="height: 20px;padding: 5% 0 10% 0;border-bottom: 1px solid #999;background: #f9f9f9; ">
                            <div style="width:60%;float: left;">
                                <p style="font-size: 10px;">职工生活平台</p>
                            </div>
                            <div style="width:40%;float: left;text-align: right">
                                <#if childrenOrder.status == 0>
                                    <p style="color:red;font-size: 10px;">已取消</p>
                                <#elseif childrenOrder.status == 1>
                                    <p style="color:red;font-size: 10px;">待付款</p>
                                <#elseif childrenOrder.status == 2>
                                    <p style="color:red;font-size: 10px;">待发货</p>
                                <#elseif childrenOrder.status == 3>
                                    <p style="color:red;font-size: 10px;">已发货</p>
                                <#elseif childrenOrder.status == 4>
                                    <p style="color:red;font-size: 10px;">已签收</p>
                                <#elseif childrenOrder.status == 5>
                                    <p style="color:red;font-size: 10px;">待退款</p>
                                <#elseif childrenOrder.status == 6>
                                    <p style="color:red;font-size: 10px;">已退款</p>
                                <#elseif childrenOrder.status == 7>
                                    <p style="color:red;font-size: 10px;">待分拣</p>
                                <#elseif childrenOrder.status == 8>
                                    <p style="color:red;font-size: 10px;">申请退货</p>
                                <#elseif childrenOrder.status == 9>
                                    <p style="color:red;font-size: 10px;">申请换货</p>
                                <#elseif childrenOrder.status == 10>
                                    <p style="color:red;font-size: 10px;">申请退货成功</p>
                                </#if>
                            </div>
                        </div>
                        <#list childrenOrder.ordersGoodsList as childrenOrderGood>
                            <div style="height: 80px;;background:#f9f9f9; ">
                                <div style="width:16%;float: left;margin: 3% 0 0 0">
                                    <#if childrenOrderGood.goods.goodsFiles ??>
                                        <#if childrenOrderGood.goods.goodsFiles?size == 0>
                                            <img width="100%" src="/assets/img/goods/img-goods-default.png" />
                                        </#if>
                                        <#list childrenOrderGood.goods.goodsFiles as childrenGoodsfile>
                                            <#if childrenGoodsfile_index == 0>
                                                <img width="100%" onerror="checkImgFun(this)" src="${childrenGoodsfile.url}" />
                                            <#else>
                                                <img width="100%" src="/assets/img/goods/img-goods-default.png" />
                                            </#if>
                                        </#list>
                                    <#else>
                                        <img width="100%" src="/assets/img/goods/img-goods-default.png" />
                                    </#if>
                                </div>
                                <div style="width:60%;float: left;margin: 0 2% 0 2%">
                                    <p style="font-size: 10px;">${childrenOrderGood.goodsCname}</p>
                                    <p style="font-size: 10px;color: #666">${childrenOrderGood.goodsSpecification.cname}</p>
                                </div>
                                <div style="width:20%;float: left;">
                                    <p style="font-size: 10px;">￥ ${childrenOrderGood.goodsSpecification.price?c}</p>
                                    <p style="font-size: 10px;">×${childrenOrderGood.goodsCount}</p>
                                </div>
                            </div>
                        </#list>
                        <div style="height: 30px;text-align: right;border-bottom: 1px solid #c4e3f3;">
                            <span style="margin: 0 5% 0 0">共：${childrenOrder.ordersGoodsList?size}件商品</span>
                            <span>合计：￥#{childrenOrder.totalAmount;m2M2}</span>
                        </div>
                        <div style="height: 40px;text-align: right;margin: 3% 0 0 0">
                            <#if childrenOrder.status == 1>
                                <button onclick="buyNow('${childrenOrder.sid?c}')" type="button" class="btn btn-info btn-detail"
                                <i class="fa fa-flash fa-fw"></i> 立即购买
                                </button>
                            <#elseif childrenOrder.status == 3>
                                <button type="button" class="btn btn-default" onclick="afterSaleModal('${childrenOrder.sid?c}')">
                                    申请退换货
                                </button>
                                <button type="button" class="btn btn-info btn-takeGoods" data-sid="${childrenOrder.sid?c}">
                                    确认收货
                                </button>
                            </#if>
                        </div>
                    </div>
                </#list>
            </div>
        </div>
        <#else >
        <div class="box box-warning" style="background: #f9f9f9;">
            <div class="box-body">
                <div style="background-color: #FFFFFF;">
                    <div style="height: 20px;padding: 5% 0 10% 0;border-bottom: 1px solid #999;background: #f9f9f9; ">
                        <div style="width:60%;float: left;">
                            <p style="font-size: 10px;">职工生活平台</p>
                        </div>
                        <div style="width:40%;float: left;text-align: right">
                            <#if order.status == 0>
                                <p style="color:red;font-size: 10px;">已取消</p>
                            <#elseif order.status == 1>
                                <p style="color:red;font-size: 10px;">待付款</p>
                            <#elseif order.status == 2>
                                <p style="color:red;font-size: 10px;">待发货</p>
                            <#elseif order.status == 3>
                                <p style="color:red;font-size: 10px;">已发货</p>
                            <#elseif order.status == 4>
                                <p style="color:red;font-size: 10px;">已签收</p>
                            <#elseif order.status == 5>
                                <p style="color:red;font-size: 10px;">待退款</p>
                            <#elseif order.status == 6>
                                <p style="color:red;font-size: 10px;">已退款</p>
                            <#elseif order.status == 7>
                                <p style="color:red;font-size: 10px;">待分拣</p>
                            <#elseif order.status == 8>
                                <p style="color:red;font-size: 10px;">申请退货</p>
                            <#elseif order.status == 9>
                                <p style="color:red;font-size: 10px;">申请换货</p>
                            <#elseif order.status == 10>
                                <p style="color:red;font-size: 10px;">申请退货成功</p>
                            </#if>
                        </div>
                    </div>
                    <#list order.ordersGoodsList as childrenOrderGood>
                        <div style="height: 80px;;background:#f9f9f9; ">
                            <div style="width:16%;float: left;margin: 3% 0 0 0">
                                <#if childrenOrderGood.goods.goodsFiles ??>
                                    <#if childrenOrderGood.goods.goodsFiles?size == 0>
                                        <img width="100%" src="/assets/img/goods/img-goods-default.png" />
                                    </#if>
                                    <#list childrenOrderGood.goods.goodsFiles as childrenGoodsfile>
                                        <#if childrenGoodsfile_index == 0>
                                            <img width="100%" onerror="checkImgFun(this)" src="${childrenGoodsfile.url}" />
                                        <#else>
                                            <img width="100%" src="/assets/img/goods/img-goods-default.png" />
                                        </#if>
                                    </#list>
                                <#else>
                                    <img width="100%" src="/assets/img/goods/img-goods-default.png" />
                                </#if>
                            </div>
                            <div style="width:60%;float: left;margin: 0 2% 0 2%">
                                <p style="font-size: 10px;">${childrenOrderGood.goodsCname}</p>
                                <p style="font-size: 10px;color: #666">${childrenOrderGood.goodsSpecification.cname}</p>
                            </div>
                            <div style="width:20%;float: left;">
                                <p style="font-size: 10px;">￥ ${childrenOrderGood.goodsSpecification.price?c}</p>
                                <p style="font-size: 10px;">×${childrenOrderGood.goodsCount}</p>
                            </div>
                        </div>
                    </#list>
                    <div style="height: 30px;text-align: right;border-bottom: 1px solid #c4e3f3;">
                        <span style="margin: 0 5% 0 0">共：${order.ordersGoodsList?size}件商品</span>
                        <span>合计：￥#{order.totalAmount;m2M2}</span>
                    </div>
                    <div style="height: 40px;text-align: right;margin: 3% 0 0 0">
                        <#if order.status == 1>
                            <button onclick="buyNow('${order.sid?c}')" type="button" class="btn btn-info btn-detail"
                            <i class="fa fa-flash fa-fw"></i> 立即购买
                            </button>
                        <#elseif order.status == 3>
                            <button type="button" class="btn btn-default" onclick="afterSaleModal('${order.sid?c}')">
                                申请退换货
                            </button>
                            <button type="button" class="btn btn-primary btn-takeGoods" data-sid="${order.sid?c}">确认收货
                            </button>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
        </#if>
    </#list>
    <#if !orders_mobile.last>
    <#--<div style="width: 100%;text-align: center">
        <a class="hospitaltitel-center next_first" disabled="disabled"  href="javascript: void(0);" data-page="${orders_mobile.number + 1}">数据加载中... ...</a>
    </div>-->
    <a class="hospitaltitel-center next" href="javascript: void(0);" data-page="${orders_mobile.number + 1}">
        <div style="width: 100%;text-align: center">点击加载更多</div>
    </a>
    <div class="record_content" id="record_ul"></div>
    </#if>
<#else >
<p style="text-align: center;">没有采购记录！</p>
</#if>