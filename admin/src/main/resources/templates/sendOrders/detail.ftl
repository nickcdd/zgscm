<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
<#include "/_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/sendOrders/index">
    <script type="text/javascript">
        $(function () {
            $('.btn-cancel').click(function () {
                var resultStr = setPageInfo();
//                        location.href = "index?shopKeeperName=" + $('#redirectShopKeeperName').val() + "&goodsName=" + $('#redirectGoodsName').val() + "&status=" + $('#redirectStatus').val() + "&startDate=" + $('#redirectStartDate').val() + "&endDate=" + $('#redirectEndDate').val() + "&page=" + $('#redirectPage').val() + "&size=" + $('#redirectSize').val();
                location.href = "index?" + resultStr;

            });
        });
        function reviewRefund(flag) {
//            alert($('#orderSid').val());
//            alert($('#redirectSize').val());
            $('.btn-review').attr("disabled", "disabled");
            $.ajax({
                type: "POST",
                url: "/sendOrders/singleSendOrders",
                data: {
                    "sid": $('#orderSid').val(),
                    "logisticsCompany": $('#logisticsCompany').val(),
                    "logisticsNo": $('#logisticsNo').val(),
                    "flag": flag
                },
                dataType: "JSON",
                async: false,
                success: function (result) {
                    if (result.success) {
//                        var resultStr=setPageInfo();
////                        location.href = "index?shopKeeperName=" + $('#redirectShopKeeperName').val() + "&goodsName=" + $('#redirectGoodsName').val() + "&status=" + $('#redirectStatus').val() + "&startDate=" + $('#redirectStartDate').val() + "&endDate=" + $('#redirectEndDate').val() + "&page=" + $('#redirectPage').val() + "&size=" + $('#redirectSize').val();
//                        location.href = "index?shopKeeperName="+resultStr;
//                        showInfoFun(result.msg);
                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);
                    } else {
                        $('.btn-review').removeAttr("disabled");
                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);
//                        showInfoFun(result.msg);
                    }

                },
                error: function () {

                }
            });
        }
        function confirmOrders(flagStatus) {
            if ($('#logisticsCompany').val() == null || $('#logisticsCompany').val() == "" || $('#logisticsCompany').val() == undefined || $('#logisticsNo').val() == null || $('#logisticsNo').val() == "" || $('#logisticsNo').val() == undefined) {
                showInfoFun("请完整填写物流信息", "danger");
            } else {
                if (flagStatus) {
                    confirmInfoFun("reviewRefund(" + flagStatus + ")", "确认发货？", '信息提示', true);
                } else {
                    confirmInfoFun("reviewRefund(" + flagStatus + ")", "确认修改？", '信息提示', true);
                }
            }
        }
        function setPageInfo() {
            var str = "";
            str += "page=" + $('#redirectPage').val();
            str += "&size=" + $('#redirectSize').val();

            if ($('#redirectStartDate').val() != undefined && $('#redirectStartDate').val() != "") {
                str += "&startDate=" + $('#redirectStartDate').val();
//                $('#redirectStartDate').val($('#startDate').val());
            }
            if ($('#redirectEndDate').val() != undefined && $('#redirectEndDate').val() != "") {

//                $('#redirectEndDate').val($('#endDate').val());
                str += "&endDate=" + $('#redirectEndDate').val();
            }

            if ($('#redirectShopKeeperName').val() != undefined && $('#redirectShopKeeperName').val() != "") {

//                $('#redirectQ').val($('#q').val());
                str += "&shopKeeperName=" + $('#redirectShopKeeperName').val();
            }
            if ($('#redirectGoodsName').val() != undefined && $('#redirectGoodsName').val() != "") {

//                $('#redirectQ').val($('#q').val());
                str += "&goodsName=" + $('#redirectGoodsName').val();
            }
            if ($('#redirectGoodsName').val() != undefined && $('#redirectGoodsName').val() != "") {

//                $('#redirectQ').val($('#q').val());
                str += "&goodsName=" + $('#redirectGoodsName').val();
            }
            if ($('#redirectStatus').val() != undefined && $('#redirectStatus').val() != "") {

//                $('#redirectQ').val($('#q').val());
                str += "&status=" + $('#redirectStatus').val();
            }

            return str;
        }
        function refreshForm() {
            var resultStr = setPageInfo();
            location.href = "index?" + resultStr;
        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <input type="hidden" name="redirectSize" id="redirectSize" value="${redirectSize!''}"/>
        <input type="hidden" name="redirectPage" id="redirectPage" value="${redirectPage!''}"/>
        <input type="hidden" name="redirectShopKeeperName" id="redirectShopKeeperName"
               value="${redirectShopKeeperName!''}"/>
        <input type="hidden" name="redirectGoodsName" id="redirectGoodsName" value="${redirectGoodsName!''}"/>
        <input type="hidden" name="redirectStartDate" id="redirectStartDate" value="${redirectStartDate!''}"/>
        <input type="hidden" name="redirectEndDate" id="redirectEndDate" value="${redirectEndDate!''}"/>
        <input type="hidden" name="redirectStatus" id="redirectStatus" value="${redirectStatus!''}"/>
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">订单详情</h3>
                <input type="hidden" id="orderSid" value="${orders.sid?c}"/>
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
                                    <p>${orders.shopKeeper.realName!''}
                                        ，${orders.shopKeeper.telephone!''}，${orders.province!''}  ${orders.city!''}  ${orders.area!''} ${orders.address!''}</p>
                                </div>
                            </div>
                            <hr/>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-1 text-right">
                                        <label class="" for="name">买家信息：</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-2 col-md-offset-1 text-center">
                                        <p>商户名称，${orders.shopKeeper.cname!''}</p>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <p>姓名，${orders.shopKeeper.realName!''}</p>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <p>联系电话，${orders.shopKeeper.telephone!''}</p>
                                    </div>
                                </div>
                            </div>
                            <hr/>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-1 text-right">
                                        <label class="" for="name">订单信息：</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-2 col-md-offset-1 text-center">
                                        <p>下单时间：${orders.createTime!''}</p>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <p>订单编号：${orders.sid}</p>
                                    </div>
                                    <div class="col-md-3 text-center">
                                    <#if orders.status == 0>
                                        <p>订单状态：已取消</p>
                                    <#elseif orders.status == 1>
                                        <p>订单状态：待付款</p>
                                    <#elseif orders.status == 2>
                                        <p>订单状态：已付款</p>
                                    <#elseif orders.status == 3>
                                        <p>订单状态：已发货</p>
                                    <#elseif orders.status == 4>
                                        <p>订单状态：已签收</p>
                                    <#elseif orders.status == 5>
                                        <p>订单状态：待退款</p>
                                    <#elseif orders.status == 6>
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
                                            <#if orders.ordersGoodsList ??>
                                                <#list orders.ordersGoodsList as orderGood>
                                                <tr>
                                                    <td width="20%">
                                                        <div class="th-inner">
                                                            <#if orderGood.goods.goodsFiles ??>
                                                                <#if orderGood.goods.goodsFiles?size ==0>
                                                                    <img style="width: 30%;margin-left:10%"
                                                                         class="img-thumbnail"
                                                                         src="/assets/img/goods/img-goods-default.png"/>
                                                                <#else >
                                                                <#list orderGood.goods.goodsFiles as goodsfile>
                                                                    <#if goodsfile_index == 0>
                                                                        <img style="width: 30%;margin-left:10%"
                                                                             class="img-thumbnail"
                                                                             src="${goodsfile.url}"/>
                                                                    </#if>
                                                                </#list>
                                                            </#if>
                                                             <#else >
                                                                 <img style="width: 30%;margin-left:10%"
                                                                      class="img-thumbnail"
                                                                      src="/assets/img/goods/img-goods-default.png"/>
                                                            </#if>
                                                        </div>
                                                    </td>
                                                    <td width="20%">
                                                        <div class="th-inner">${orderGood.goodsCname!''}</div>
                                                    </td>
                                                    <td width="20%">
                                                        <div class="th-inner">${orderGood.goodsCount!''}</div>
                                                    </td>
                                                    <td width="20%">
                                                        <div class="th-inner">${orderGood.goodsSpecificationPrice!''}</div>
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
                            <hr/>

                            <form class="form-horizontal">
                            <#--<div class="form-group">-->
                            <#--<label for="exampleInputName2">审核意见</label>-->
                            <#--<input type="text" class="form-control" id="reason" name="reason" placeholder="不通过时审核意见不能为空" maxlength="50" autocomplete="false">-->
                            <#--</div>-->
                            <#if orders.status == 2 || orders.status == 3>
                                <div class="form-group">
                                    <label for="inputPassword" class="col-sm-2 control-label">物流公司：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="logisticsCompany"
                                               value="${orders.logisticsCompany!''}" placeholder="不能为空" maxlength="50"
                                               autocomplete="false">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="inputPassword" class="col-sm-2 control-label">物流单号：</label>
                                    <div class="col-sm-8">
                                        <textarea type="" class="form-control" id="logisticsNo"
                                               value="" placeholder="不能为空,多个物流单号请换行" maxlength="1024"
                                                  autocomplete="false">${orders.logisticsNo!''}</textarea>
                                    </div>
                                </div>
                            <#else>
                                <div class="form-group">
                                    <label for="inputPassword" class="col-sm-2 control-label">物流公司：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="logisticsCompany"
                                               value="${orders.logisticsCompany!''}" placeholder="不能为空" maxlength="50" readonly
                                               autocomplete="false">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="inputPassword" class="col-sm-2 control-label">物流单号：</label>
                                    <div class="col-sm-8">
                                        <#--<input type="text" class="form-control" id="logisticsNo"-->
                                               <#--value="${orders.logisticsNo!''}" placeholder="不能为空" maxlength="1024" readonly-->
                                               <#--autocomplete="false">-->
                                            <textarea type="" class="form-control" id="logisticsNo"
                                                      value="" placeholder="不能为空,多个物流单号请换行" maxlength="1024" readonly
                                                      autocomplete="false">${orders.logisticsNo!''}</textarea>
                                    </div>
                                </div>
                            </#if>

                            </form>
                        <#--<div class="row form-group">-->
                        <#--<div class="col-md-12 text-right">-->
                        <#--<a href="javascript:history.go(-1)" class="btn btn-default" for="name">返回</a>-->
                        <#--<button type="button" class="btn btn-primary pull-right" onclick="reviewSuccess()">-->
                        <#--<i class="fa fa-save"></i> 通过-->
                        <#--</button>-->
                        <#--<button type="button" class="btn btn-info pull-right " onclick="reviewFail()">-->
                        <#--<i class="fa fa-hand-paper-o"></i> 不通过-->
                        <#--</button>　　-->

                        <#--</div>-->
                        <#--</div>-->
                        </div>
                    </div>
                </div>
            </div>
        <@shiro.hasPermission name="orders:sendOrders">
            <div class="box-footer">
                <button class="btn btn-default pull-right btn-cancel"><i
                        class="fa  fa-reply"></i>返回
                </button>
                <#if orders.status == 2>
                    <button type="button" class="btn btn-success pull-right btn-review" onclick="confirmOrders(true)">
                        <i class="fa  fa-check"></i> 发货
                    </button>
                <#--<button type="button" class="btn btn-danger pull-right btn-review" onclick="reviewRefund(false)">-->
                <#--<i class="fa  fa-close"></i> 不通过-->
                <#--</button>-->
                    　</#if>
                　
                <#if orders.status == 3>
                    <button type="button" class="btn btn-success pull-right btn-review" onclick="confirmOrders(false)">
                        <i class="fa  fa-check"></i> 保存
                    </button>
                <#--<button type="button" class="btn btn-danger pull-right btn-review" onclick="reviewRefund(false)">-->
                <#--<i class="fa  fa-close"></i> 不通过-->
                <#--</button>-->
                    　</#if>　
            </div>
        </@shiro.hasPermission>
        </div>
    </div>
</div>
<script>

</script>
</body>
</html>