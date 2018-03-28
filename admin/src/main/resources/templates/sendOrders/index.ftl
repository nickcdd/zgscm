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
    <meta name="nav-url" content="/sendOrders/index">
    <script type="text/javascript">
        //全局变量 用于保存单个的ordersid
        var singleOrdersSid = "";
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
            //导出
            $('.btn-export').click(function () {
                exportExecl();
            });
            //查找
            $('.btn-search').click(function () {
                $('#page').val(0);
                $('#infoForm').submit();

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
//            $(document).on('click', '.btn-deliver', function () {
//                var $t = $(this), sid = $t.data('sid');
//                $(this).attr("disabled", "disabled");
//                confirmInfoFun("singleSendOrders("+sid+")","确认执行操作？？？",'信息提示',true);
//                $(this).removeAttr("disabled");
////                singleSendOrders(sid);
////                confirmFun('/orders/deliverGoods?sid=' + sid, '确认发货？');
//            });
            $("#selectAll").click(function () {
                $("[name=ordersSid]:checkbox").prop("checked", this.checked);
                if (this.checked) {
                    $(".fa-check-square-o").show();
                    $(".fa-square-o").hide();
                } else {
                    $(".fa-square-o").show();
                    $(".fa-check-square-o").hide();
                }
                deliverBtnChange();
            });
            $(document).on('click', '.fa-check-square-o', function () {
                var thisChecked = $(this).parent().children("input").get(0).checked;
                $(this).parent().children("input:first-child").prop("checked", !thisChecked);
                $(this).hide();
                $(this).parent().children(".fa-square-o").show();
                deliverBtnChange();
                selectAllChange();
            });
            $(document).on('click', '.fa-square-o', function () {
                var thisChecked = $(this).parent().children("input").get(0).checked;
                $(this).parent().children("input:first-child").prop("checked", !thisChecked);
                $(this).hide();
                $(this).parent().children(".fa-check-square-o").show();
                deliverBtnChange();
                selectAllChange();
            });
            $form.clearForm(true);
        });
        /**
         * 发货按钮状态改变
         */
        function deliverBtnChange() {
            var flag = true;
            $("[name=ordersSid]:checkbox").each(function () {
                if (this.checked) {
                    flag = false;
                }
            });
            $("#deliver").prop("disabled", flag);
        }
        /**
         * 全选按钮改变
         */
        function selectAllChange() {
            var flag = true;
            $("[name=ordersSid]:checkbox").each(function () {
                if (!this.checked) {
                    flag = false;
                }
            });
            $("#selectAll").prop("checked", flag);
        }
        /**
         * 批量发货
         */
        function deliverGoods() {

            var sids = new Array();
//            $("[name=ordersSid]:checkbox").each(function (index, value) {
            $('input:checkbox[name=ordersSid]:checked').each(function (index, value) {
                if (this.checked) {
                    sids[index] = $(this).next("input").val();
                }
            });
            if (sids.length > 0) {
                $('#deliver').attr("disabled", "disabled");
                batchSendOrders(sids);
            } else {
                showInfoFun("请选择至少一条数据", "danger");
            }
//            window.location.href = "/orders/deliverMultiGoods/?ordersSids=" + sids;
        }
        function confirmBatchOrders() {
            confirmInfoFun("deliverGoods()", "确认执行操作？", '信息提示', true);
        }
        //批量发货
        function batchSendOrders(sids) {


            $.ajax({
                type: "POST",
                url: "/sendOrders/batchSendOrders",
                data: {"ordersSids": sids},
                dataType: "JSON",
                traditional: true,
                async: false,
                success: function (result) {
                    if (result.success) {

                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);
//                        showInfoFun(result.msg);
//                        $('#infoForm').submit();
                    } else {
                        $('#deliver').removeAttr("disabled");
                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);
//                        showInfoFun(result.msg);
                    }

                },
                error: function () {
                    $('#deliver').removeAttr("disabled");
                }
            });

        }
        function fillModal(orderSid) {

            singleOrdersSid = orderSid;
            $('#logisticsModal').modal("show");

        }
        //隐藏填写原因模态框
        function cancleModal() {
            singleOrdersSid = "";
            $('#logisticsCompany').val("");
            $('#logisticsNo').val("");
            $('#logisticsModal').modal("hide");
        }
        function confirmSingleOrders(orderSid) {

            if ($('#logisticsCompany').val() == null || $('#logisticsCompany').val() == "" || $('#logisticsCompany').val() == undefined || $('#logisticsNo').val() == null || $('#logisticsNo').val() == "" || $('#logisticsNo').val() == undefined) {
                showInfoFun("请完整填写物流信息", "danger");
            } else {
                $('#reasonModal').modal("hide");
                confirmInfoFun("singleSendOrders(" + singleOrdersSid + ")", "确认发货？", '信息提示', true);
            }

        }
        //单个发货
        function singleSendOrders(sid) {
            $.ajax({
                type: "POST",
                url: "/sendOrders/singleSendOrders",
                data: {
                    "sid": sid,
                    "logisticsCompany": $('#logisticsCompany').val(),
                    "logisticsNo": $('#logisticsNo').val(),
                    "flag": true
                },
                dataType: "JSON",
                async: false,
                success: function (result) {
                    if (result.success) {

                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);
//                        showInfoFun(result.msg);
//                        $('#infoForm').submit();

                    } else {
                        $('.btn-deliver').removeAttr("disabled");
                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);
//                        showInfoFun(result.msg);
                    }
                    cancleModal();

                },
                error: function () {
                    $('.btn-deliver').removeAttr("disabled");
                }
            });
        }
        function refreshForm() {
            $('#infoForm').submit();
        }
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
        function exportExecl() {
//            alert($('#startDate').val());

            $('#exportState').val($('#status').val());
            $('#exportShopKeeperName').val($('#shopKeeperName').val());
            $('#exportGoodsName').val($('#goodsName').val());
            $('#exportStartDate').val($('#startDate').val());
            $('#exportEndDate').val($('#endDate').val());

            $('#exportForm').submit();
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
                        <form id="infoForm" action="/sendOrders/index" method="post" class="form-inline"
                              role="search-form">
                            <input type="hidden" name="page" value="${pageInfo.page-1}" id="page"/>
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
                                    <select class="form-control" name="status" id="status">
                                        <option value="">请选择</option>

                                        <option value="2" ${(status?? && status == 2)?string('selected="selected"', "")}>
                                            待发货
                                        </option>
                                        <option value="3" ${(status?? && status == 3)?string('selected="selected"', "")}>
                                            已发货
                                        </option>
                                        <option value="4" ${(status?? && status == 4)?string('selected="selected"', "")}>
                                            已收货
                                        </option>


                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-search">查找</button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-export"><i
                                        class="fa  fa-file-excel-o"></i>导出excel
                                </button>
                            </div>
                            <div class="table-responsive" style="margin-top: 2%;width: 100%;">
                            <#--<input type="checkbox" id="selectAll"> <span style=""><strong>全选</strong></span>-->
                            <#if orders ??>
                                <#list orders as order>
                                    <div class="box box-info box-width" style="width:100%;background: #f9f9f9;">
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
                                                                class="text-info">${order.shopKeeper.cname}</p>
                                                        </div>
                                                        <#if order.status != 2>
                                                            <#if order.logisticsNo??>
                                                                <div class="col-md-5"><p class="text-info">
                                                                    物流信息：${order.logisticsCompany!''},${order.logisticsNo?replace("\n","  ")}</p>
                                                                </div>
                                                            </#if>
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
                                                                class="text-info">电话：${order.shopKeeper.telephone}</span>
                                                        </div>
                                                        <div class="col-md-2"><span
                                                                class="text-info">订单金额：${order.totalAmount}</span>
                                                        </div>
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
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="box-body" style="width: 100%">
                                            <table border="1" cellpadding="0" cellspacing="0"
                                                   style="border:1px solid #daf3ff;width: 100%;">
                                                <#list order.ordersGoodsList as orderGood>
                                                    <tr>
                                                    <#--<#if orderGood_index == 0>-->
                                                    <#--<#if order.status == 2>-->
                                                    <#--<td rowspan="${order.ordersGoodsList?size}">-->
                                                    <#--<div style="margin: 0 10px 0 10px;">-->
                                                    <#--<input type="checkbox" name="ordersSid"-->
                                                    <#--style="display: none">-->
                                                    <#--<input type="hidden" value="${order.sid?c}">-->
                                                    <#--<i class="fa fa-check-square-o fa-4x"-->
                                                    <#--style="display: none;"></i>-->
                                                    <#--<i class="fa fa-square-o fa-4x"></i>-->
                                                    <#--</div>-->
                                                    <#--</td>-->
                                                    <#--</#if>-->
                                                    <#--</#if>-->
                                                        <td style="width: 61%;">
                                                            <div class="row">
                                                                <div class="col-md-4">
                                                                    <#if orderGood.goods.goodsFiles ??>
                                                                        <#if orderGood.goods.goodsFiles?size==0>
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
                                                                        商品名称：${orderGood.goodsCname}</p>
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
                                                            </#if>
                                                            <td style="width: 13%; text-align: center;"
                                                                rowspan="${order.ordersGoodsList?size}">
                                                                <button type="button"
                                                                        class="btn btn-info btn-xs btn-detail"
                                                                        data-sid="${order.sid?c}">
                                                                    <i class="fa fa-edit fa-fw"></i> 详情
                                                                </button>
                                                                <#if order.status == 2>
                                                                    <button type="button"
                                                                            class="btn btn-info btn-xs  btn-deliver"
                                                                            data-sid="${order.sid?c}"
                                                                            onclick="fillModal(${order.sid?c})">
                                                                        <i class="fa fa-flash fa-fw"></i> 发货
                                                                    </button>
                                                                </#if>
                                                            </td>
                                                        </#if>
                                                    </tr>
                                                </#list>
                                            </table>
                                        </div>
                                    </div>
                                </#list>
                            </#if>
                            <#--<div class="text-right" style="margin-bottom: 5px">-->
                            <#--<button type="button" id="deliver" class="btn-lg btn btn-primary"-->
                            <#--data-toggle="modal" data-target="#deliverModal"-->
                            <#--disabled="disabled" onclick="confirmBatchOrders()">选中项发货-->
                            <#--</button>-->
                            <#--</div>-->
                                <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
                                       data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                    <thead style="display:none ">
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


<form id="exportForm" action="/sendOrders/export" method="post">
    <input type="hidden" name="exportState" id="exportState"/>
    <input type="hidden" name="exportStartDate" id="exportStartDate"/>
    <input type="hidden" name="exportEndDate" id="exportEndDate"/>
    <input type="hidden" name="exportShopKeeperName" id="exportShopKeeperName"/>
    <input type="hidden" name="exportGoodsName" id="exportGoodsName"/>

</form>
<div class="modal fade" id="logisticsModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">请填写物流信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">

                    <div class="form-group">
                        <label for="inputPassword" class="col-sm-2 control-label">物流公司：</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="logisticsCompany" placeholder="不能为空"
                                   maxlength="50" autocomplete="false">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword" class="col-sm-2 control-label">物流单号：</label>
                        <div class="col-sm-8">
                            <textarea type="" class="form-control" id="logisticsNo" placeholder="不能为空，多个物流单号请换行"
                                      maxlength="1024" autocomplete="false"></textarea>
                        </div>
                    </div>


                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-confirm" id="singleReasonConfirm"
                        onclick="confirmSingleOrders(null)">确认
                </button>

                <button type="button" class="btn btn-default" onclick="cancleModal()">取消</button>

            </div>
        </div>
    </div>
</div>
</body>
</html>