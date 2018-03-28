<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
<#include "/_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/orders/customerService/index">
    <script type="text/javascript">
        $(function () {
            $('.btn-cancel').click(function () {
                var resultStr = setPageInfo();
//                        location.href = "index?shopKeeperName=" + $('#redirectShopKeeperName').val() + "&goodsName=" + $('#redirectGoodsName').val() + "&status=" + $('#redirectStatus').val() + "&startDate=" + $('#redirectStartDate').val() + "&endDate=" + $('#redirectEndDate').val() + "&page=" + $('#redirectPage').val() + "&size=" + $('#redirectSize').val();
                location.href = "index?" + resultStr;

            });
        });
        function confirmReview(flag) {
            if (flag) {
                confirmInfoFun("reviewRefund(" + flag + ")", "确认通过？", '信息提示', true);
            } else {
                confirmInfoFun("reviewRefund(" + flag + ")", "确认不通过？", '信息提示', true);
            }
        }
        function reviewRefund(flag) {
//            alert($('#orderSid').val());
//            alert($('#redirectSize').val());
            var reasonFlag = true;
            if (flag) {
                reasonFlag = true;
            } else {
                if ($('#reason').val() == null || $('#reason').val() == "" || $('#reason').val() == undefined) {
                    reasonFlag = false;
                    showInfoFun("原因必须填写", "danger");
                } else {
                    reasonFlag = true;
                }
            }
            if (reasonFlag) {

                $('.btn-review').attr("disabled", "disabled");
                $.ajax({
                    type: "POST",
                    url: "/customerService/singleReviewRefund",
                    data: {"ordersSid": $('#orderSid').val(), "flag": flag, "reason": $('#reason').val()},
                    dataType: "JSON",
                    async: false,
                    success: function (result) {
                        if (result.success) {
//                        var resultStr = setPageInfo();
////                        location.href = "index?shopKeeperName=" + $('#redirectShopKeeperName').val() + "&goodsName=" + $('#redirectGoodsName').val() + "&status=" + $('#redirectStatus').val() + "&startDate=" + $('#redirectStartDate').val() + "&endDate=" + $('#redirectEndDate').val() + "&page=" + $('#redirectPage').val() + "&size=" + $('#redirectSize').val();
//                        location.href = "index?shopKeeperName=" + resultStr;
//                        showInfoFun(result.msg);
                            confirmInfoFun('returnBack(true)', result.msg, '信息提示', false);
                        } else {
                            $('.btn-review').removeAttr("disabled");
//                        showInfoFun(result.msg);
                            confirmInfoFun('returnBack(false)', result.msg, '信息提示', false);
                        }

                    },
                    error: function () {

                    }
                });
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
            if ($('#redirectStatus').val() != undefined && $('#redirectStatus').val() != "") {

//                $('#redirectQ').val($('#q').val());
                str += "&status=" + $('#redirectStatus').val();
            }

            return str;
        }
        function showImg(obj) {
//            alert($(obj).attr("src"));
            $("#modelImg").attr("src", $(obj).attr("src"));

            $('#myModal').modal('show');
        }
        function returnBack(flag) {
            if (flag) {
                var resultStr = setPageInfo();
                location.href = "index?" + resultStr;
            }
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
        <input type="hidden" name="redirectStatus" id="redirectStatus" value="${redirectStatus!''}"/>
        <input type="hidden" name="redirectStartDate" id="redirectStartDate" value="${redirectStartDate!''}"/>
        <input type="hidden" name="redirectEndDate" id="redirectEndDate" value="${redirectEndDate!''}"/>
        <div class="box box-info">
            <div class="box-header with-border">
            <#if orders.status==8>
                <h3 class="box-title">退货订单详情</h3>
            <#elseif orders.status==9>
                <h3 class="box-title">换货订单详情</h3>
            </#if>
                <input type="hidden" id="orderSid" value="${orders.sid?c}"/>
            </div>
            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <div class="tab-pane active" id="peopleData_tab">
                            <div class="row form-group">
                                <div class="col-md-2 text-left">
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
                                    <div class="col-md-2 text-left">
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
                                    <div class="col-md-2 text-left">
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
                                    <#elseif orders.status == 8>
                                        <p>订单状态：申请售后</p>
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
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-12">

                                        <div class="row">
                                            <div class="col-md-2 text-left">
                                                <label class="" for="name">退换货图片：</label>
                                            </div>
                                        </div>


                                        <div class="row">
                                            <form class="form-inline" id="goodsLists">
                                            <#if afterSaleList ??>
                                                <#if afterSaleList?size gt 0>
                                                    <#list afterSaleList as afterSale>

                                                        <div class="checkbox col-sm-4">
                                                            <label>
                                                                <img class='img-rounded' onclick='showImg(this)'
                                                                     src='${afterSale.photo}'
                                                                     alt='' height='120' width='120'/>
                                                            </label>
                                                        </div>
                                                    </#list>
                                                </#if>
                                            </#if>
                                            <#--<div class="checkbox col-sm-4">-->
                                            <#--<label>-->
                                            <#--<img class='img-rounded'  onclick='showImg(this)' src='http://localhost:8080/attachment/goodsFile/7462ade7-c0a0-4840-90f2-342e1ff2c6bb.jpg' alt='暂时没有封面' height='120' width='120'/>-->
                                            <#--</label>-->
                                            <#--</div>-->
                                            <#--<div class="checkbox col-sm-4">-->
                                            <#--<label>-->
                                            <#--<img class='img-rounded'  onclick='showImg(this)' src='http://localhost:8080/attachment/goodsFile/7462ade7-c0a0-4840-90f2-342e1ff2c6bb.jpg' alt='暂时没有封面' height='120' width='120'/>-->
                                            <#--</label>-->
                                            <#--</div>-->
                                            <#--<div class="checkbox col-sm-4">-->
                                            <#--<label>-->
                                            <#--<img class='img-rounded'  onclick='showImg(this)' src='http://localhost:8080/attachment/goodsFile/7462ade7-c0a0-4840-90f2-342e1ff2c6bb.jpg' alt='暂时没有封面' height='120' width='120'/>-->
                                            <#--</label>-->
                                            <#--</div>-->
                                            <#--<div class="checkbox col-sm-4">-->
                                            <#--<label>-->
                                            <#--<img class='img-rounded'  onclick='showImg(this)' src='http://localhost:8080/attachment/goodsFile/7462ade7-c0a0-4840-90f2-342e1ff2c6bb.jpg' alt='暂时没有封面' height='120' width='120'/>-->
                                            <#--</label>-->
                                            <#--</div>-->
                                            <#--<div class="checkbox col-sm-4">-->
                                            <#--<label>-->
                                            <#--<img class='img-rounded'  onclick='showImg(this)' src='http://localhost:8080/attachment/goodsFile/7462ade7-c0a0-4840-90f2-342e1ff2c6bb.jpg' alt='暂时没有封面' height='120' width='120'/>-->
                                            <#--</label>-->
                                            <#--</div>-->


                                            </form>

                                        </div>


                                    </div>
                                </div>
                            </div>
                            <hr/>

                            <form class="form-horizontal">
                            <#--<div class="form-group">-->
                            <#--<label for="exampleInputName2">审核意见</label>-->
                            <#--<input type="text" class="form-control" id="reason" name="reason" placeholder="不通过时审核意见不能为空" maxlength="50" autocomplete="false">-->
                            <#--</div>-->
                                <div class="form-group">
                                    <label for="inputPassword" class="col-sm-2 control-label">审核意见：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="reason" name="reason"
                                               placeholder="不通过时审核意见不能为空" maxlength="50" autocomplete="false">
                                    </div>
                                </div>


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
        <@shiro.hasPermission name="goods:reviewPrice">
            <div class="box-footer">
                <button class="btn btn-default pull-right btn-cancel"><i
                        class="fa  fa-reply"></i>返回
                </button>
                <#if orders.status == 8 || orders.status == 9>
                    <button type="button" class="btn btn-success pull-right btn-review" onclick="confirmReview(true)">
                        <i class="fa  fa-check"></i> 通过
                    </button>
                    <button type="button" class="btn btn-danger pull-right btn-review" onclick="confirmReview(false)">
                        <i class="fa  fa-close"></i> 不通过
                    </button>
                    　</#if>
                　
            </div>
        </@shiro.hasPermission>
            <div class="box-footer">
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-12  text-left">
                        <#if orders.ordersLogs ??>
                            <#if orders.ordersLogs?size gt 0 >
                                <#list orders.ordersLogs as ordersLogs>
                                    <div class='list-group-item'
                                         style='background:#f9f9f9 '>
                                        <div class='row'>
                                            <div class='col-md-12'><span
                                                    class='text-info'>${ordersLogs.createTime!''}       ${ordersLogs.note!''}</span>
                                            </div>
                                        </div>
                                    </div>
                                </#list>
                            <#else>
                                <div class='list-group-item'
                                     style='background:#f9f9f9 '>
                                    <div class='row'>
                                        <div class='col-md-12'><span class='text-info'>没有操作记录</span>
                                        </div>
                                    </div>
                                </div>
                            </#if>
                        </#if>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel"></h4>
            </div>
            <div class="modal-body">
                <img class="img-rounded" id="modelImg" src="" alt='暂时没有封面' height="400" width="400"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            <#--<button type="button" class="btn btn-primary">Save</button>-->
            </div>
        </div>
    </div>
</div>
<script>

</script>
</body>
</html>