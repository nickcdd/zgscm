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
    <meta name="nav-url" content="/pickingGoods/index">
    <script src="/assets/js/perfectLoad.js"></script>
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
                location.href = "detail?sid=" + sid;

            });
            //导入
            $('.upload-button').click(function () {
//                $form.clearForm(true);
                $('#excelModal').modal('show');
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
            //确认是否有商品全选
            $(".check-all").click(function () {
//                alert(this.checked);
                $('input[name="subBox"]').prop("checked", this.checked);

            });
//            var $subBox = $("input[name='subBox']");
//            $subBox.click(function () {
//                alert($("input[name='subBox']:checked").length+"    "+$subBox.length);
//                if ($subBox.length == $("input[name='subBox']:checked").length) {
//
//                    $(".check-all").prop("checked", true);
//                } else {
//
//                    $(".check-all").prop("checked", false);
//                }
//
//            });

            $(document).on('click', '.btn-deliver', function () {
                var $t = $(this), sid = $t.data('sid');
                var flagStatus = $(this).attr("flagStatus");
                $(this).attr("disabled", "disabled");
                confirmInfoFun("singleSendOrders(" + sid + "," + flagStatus + ")", "确认执行操作？？？", '信息提示', true);
                $(this).removeAttr("disabled");
//                singleSendOrders(sid,flagStatus);
//                confirmFun('/orders/deliverGoods?sid=' + sid, '确认发货？');
            });
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
        //单项时改变全选状态
        function checkSubBox(){
            var $subBox = $("input[name='subBox']");
            $subBox.click(function () {

                if ($subBox.length == $("input[name='subBox']:checked").length) {

                    $(".check-all").prop("checked", true);
                } else {

                    $(".check-all").prop("checked", false);
                }

            });
        }
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
            $("#batchBtn1").prop("disabled", flag);
            $("#batchBtn2").prop("disabled", flag);
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
         * 批量操作
         */
        function deliverGoods(flagStatus) {
            var sids = new Array();
//            $("[name=ordersSid]:checkbox").each(function (index, value) {
            $('input:checkbox[name=ordersSid]:checked').each(function (index, value) {
                if (this.checked) {
                    sids[index] = $(this).next("input").val();
                }
            });
            if (sids.length > 0) {

                $('#batchBtn1').attr("disabled", "disabled");
                $('#batchBtn2').attr("disabled", "disabled");

                batchSendOrders(sids, flagStatus);
            } else {
                showInfoFun("请选择至少一条数据", "danger");
            }
//            window.location.href = "/orders/deliverMultiGoods/?ordersSids=" + sids;
        }

        //
        function confirmBatchOrders(flagStatus) {
            confirmInfoFun("deliverGoods(" + flagStatus + ")", "确认执行操作？？？", '信息提示', true);
        }
        //批量检货
        function batchSendOrders(sids, flagStatus) {


            $.ajax({
                type: "POST",
                url: "/pickingGoods/batchPickingGoods",
                data: {"ordersSids": sids, "flagStatus": flagStatus},
                dataType: "JSON",
                traditional: true,
                async: false,
                success: function (result) {
                    if (result.success) {

                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);
//                            showInfoFun(result.msg);
//                            $('#infoForm').submit();
                    } else {
                        $('#batchBtn1').removeAttr("disabled");
                        $('#batchBtn2').removeAttr("disabled");
//                            showInfoFun(result.msg);
                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);
                    }

                },
                error: function () {
                    $('#batchBtn1').removeAttr("disabled");
                    $('#batchBtn2').removeAttr("disabled");
                }
            });

        }
        //单个操作
        function singleSendOrders(sid, flagStatus) {
            $.ajax({
                type: "POST",
                url: "/pickingGoods/singlePickingGoods",
                data: {"sid": sid, "flagStatus": flagStatus},
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

                },
                error: function () {
                    $('.btn-deliver').removeAttr("disabled");
                }
            });
        }
        function refreshForm() {
            $('#infoForm').submit();
        }
        function exportExecl() {
//            alert($('#startDate').val());
            $('#exportShopKeeperName').val($('#shopKeeperName').val());
            $('#exportGoodsName').val($('#goodsName').val());
            $('#exportStartDate').val($('#startDate').val());
            $('#exportEndDate').val($('#endDate').val());

            $('#exportForm').submit();
        }
        //查找商品
        function openGoodsModal(sid) {
            $.ajax({
                type: "POST",
                url: "/pickingGoods/detail",
                data: {"ordersSid": sid},
                dataType: "JSON",
                async: false,
                success: function (result) {
                    if (result.flag) {
//
                        var str = "";
                        $('#modal_orderSid').val(sid);
                        if (result.orderGoods != null) {
                            if (result.orderGoods.length > 0) {

                                for (var i = 0; i < result.orderGoods.length; i++) {

                                    str += "<div class='checkbox col-sm-4'><label> <input name='subBox' type='checkbox' value='" + result.orderGoods[i].orderGoodsSid + "'/>" + result.orderGoods[i].goodsCname + "(" + result.orderGoods[i].goodsSpecificationCname + ")  数量 "+result.orderGoods[i].count + " </label> </div>";
                                }
                                $('#goodsLists').append(str);
                                checkSubBox();
                                $(".check-all").click();
                                $('#confirmModal').modal('show');
                            } else {
                                confirmInfoFun('refreshForm()', "没有查询到该订单相关商品信息，请联系后台！", '信息提示', false);
                            }

                        }

                    }
                },
                error: function () {

                }
            });
//
        }
        function pinckingOrders() {
            var orderGoodsSids = [];
//            $("[name=ordersSid]:checkbox").each(function (index, value) {
            $('input:checkbox[name=subBox]:checked').each(function (index, value) {
                if (this.checked) {
                    orderGoodsSids[index] = $(this).val();
                }
            });
//            alert(orderGoodsSids.length);
            $.ajax({
                type: "POST",
                url: "/pickingGoods/pickingGoods",
                data: {"orderGoodsSids": orderGoodsSids, "ordersSid": $('#modal_orderSid').val()},
                dataType: "JSON",
                traditional: true,
                async: false,
                success: function (result) {
                    if (result.success) {
                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);


                    } else {

                        confirmInfoFun('refreshForm()', result.msg, '信息提示', false);
//                        showInfoFun(result.msg);
                    }
                    modalCancle();

                },
                error: function () {

                }
            });
        }
        //显示商品modal取消
        function modalCancle(){
            $('#goodsLists').html("");
            if( $(".check-all").prop("checked")) {
                $(".check-all").click();
            }
            $('#confirmModal').modal('hide');
        }
        function confirmUploadExcel() {
            if ($('#excelFile').val() == null || $('#excelFile').val() == "" || $('#excelFile').val() == undefined) {
                showInfoFun("请选择文件再上传");
            } else {
                confirmInfoFun("uploadExcel()", "确认上传?", '信息提示', true);
            }
//          $("#excelForm").ajaxSubmit({
//              type: "POST",
//              url:"/goods/uploadFile",
//              dataType: "json",
//              success: function(data){
//                  if(data.success){
//                      showInfoFun(data.msg);
//                  }
//                  else{
//                      showInfoFun(data.msg);
//                  }
//              }
//          });
        }
        function uploadExcel() {
            $.bootstrapLoading.start({loadingTips: "正在处理数据，请稍候..."});
            $('#excelModal').modal('hide');
            $("#excelForm").ajaxSubmit({
                type: "POST",
                url: "/pickingGoods/uploadFile",
                dataType: "json",
                success: function (data) {
                    if (data.flag) {
//                        showInfoFun(data.msg);
//                        confirmInfoFun("",data.msg,"导入结果",false);
                        if (data.downloadUrl != "" && data.downloadUrl != undefined && data.downloadUrl != null) {
                            var allData = data.msg + "<br/>" + "<a id='downloadExcel' href=" + data.downloadUrl + " style='display:none;'></a>";
                            confirmInfoFun("refresh()", allData + "    失败结果请查看浏览器下载文件", "导入结果", false);
                            document.getElementById("downloadExcel").click();
//                            alert("不为空");
                        } else {
                            confirmInfoFun("refresh()", data.msg, "导入结果", false);
//                            alert("为空");
                        }

                    }
                    else {
                        confirmInfoFun("", data.msg, "导入结果", false);
                    }
                    cancleModal();
                },
                complete: function () {
                    $.bootstrapLoading.end();
                }
            });
        }
        function cancleModal() {
            $('#excelFile').val("");
            $('#excelModal').modal('hide');

        }
        function refresh() {
            $('#infoForm').submit();
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
                        <form id="infoForm" action="/pickingGoods/index" method="post" class="form-inline"
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
                        <#--<div class="form-group ">-->
                        <#--<label class="" for="name">状态</label>-->
                        <#--<div class="input-group date">-->
                        <#--<select class="form-control" name="status">-->
                        <#--<option value="">请选择</option>-->

                        <#--<option value="2" ${(status?? && status == 2)?string('selected="selected"', "")}>-->
                        <#--已付款-->
                        <#--</option>-->
                        <#--<option value="3" ${(status?? && status == 3)?string('selected="selected"', "")}>-->
                        <#--已发货-->
                        <#--</option>-->
                        <#--<option value="4" ${(status?? && status == 4)?string('selected="selected"', "")}>-->
                        <#--已收货-->
                        <#--</option>-->


                        <#--</select>-->
                        <#--</div>-->
                        <#--</div>-->
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-search">查找</button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-export"><i
                                        class="fa  fa-file-excel-o"></i>导出待分拣订单
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block upload-button"><i
                                        class="fa  fa-file-excel-o"></i>确认导入
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
                                                        <#if orderGood_index == 0>
                                                            <#if order.status == 7>
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
                                                            </#if>
                                                        </#if>
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
                                                                    <p class="text-primary">买家已付款</p></td>
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
                                                                    <p class="text-primary">待拣货</p></td>
                                                            </#if>
                                                        <#--  屏蔽单独拣货按钮-->
                                                            <#--<td style="width: 13%; text-align: center;"-->
                                                                <#--rowspan="${order.ordersGoodsList?size}">-->
                                                                <#--<#if order.status == 7>-->
                                                                <#---->
                                                                    <#--<button type="button"-->
                                                                            <#--class="btn btn-info  "-->
                                                                            <#--data-sid="${order.sid?c}"-->
                                                                            <#--onclick="openGoodsModal(${order.sid?c})">-->
                                                                        <#--<i class="fa fa-flash fa-fw"></i> 拣货-->
                                                                    <#--</button>-->
                                                                <#--</#if>-->
                                                            <#--</td>-->
                                                        </#if>
                                                    </tr>
                                                </#list>
                                            </table>
                                        </div>
                                    </div>
                                </#list>
                            </#if>
                            <#--<div class="text-right" style="margin-bottom: 5px">-->
                            <#--<button type="button" id="batchBtn1" class="btn-lg btn btn-primary"-->
                            <#--data-toggle="modal" data-target="#deliverModal"-->
                            <#--disabled="disabled" onclick="confirmBatchOrders(1)">选中项有货-->
                            <#--</button>-->
                            <#--<button type="button" id="batchBtn2" class="btn-lg btn btn-primary btn-danger"-->
                            <#--data-toggle="modal" data-target="#deliverModal"-->
                            <#--disabled="disabled" onclick="confirmBatchOrders(0)">选中项缺货-->
                            <#--</button>-->
                            <#--</div>-->
                                <table data-toggle="table" data-page-info='${pageInfo}'
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


<form id="exportForm" action="/pickingGoods/export" method="post">

    <input type="hidden" name="exportStartDate" id="exportStartDate"/>
    <input type="hidden" name="exportEndDate" id="exportEndDate"/>
    <input type="hidden" name="exportShopKeeperName" id="exportShopKeeperName"/>
    <input type="hidden" name="exportGoodsName" id="exportGoodsName"/>

</form>

<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">请确认以下商品是否有货</h4><span style="color: red;">&nbsp;(勾选代表有货)</span>
                <input type="hidden"  value="" id="modal_orderSid"/>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-12">

                        <div class="row">

                            <div class="checkbox col-sm-4">
                                <label class="">
                                    <input type="checkbox" class="check-all"/>全选
                                </label>
                            </div>
                        </div>


                        <div class="row" >
                            <form class="form-inline" id="goodsLists">

                                    <#--<div class="checkbox col-sm-4">-->
                                        <#--<label>-->
                                            <#--<input name="subBox" type="checkbox" value="1"/>商品-->
                                        <#--</label>-->
                                    <#--</div>-->
                                    <#--<div class="checkbox col-sm-4">-->
                                        <#--<label>-->
                                            <#--<input name="subBox" type="checkbox" value="2"/>商品-->
                                        <#--</label>-->
                                    <#--</div>-->


                                    <#--<div class="checkbox col-sm-4">-->
                                        <#--<label>-->
                                            <#--<input name="subBox" type="checkbox" value="1"/>商品-->
                                        <#--</label>-->
                                    <#--</div>-->
                                    <#--<div class="checkbox col-sm-4">-->
                                        <#--<label>-->
                                            <#--<input name="subBox" type="checkbox" value="2"/>商品-->
                                        <#--</label>-->
                                    <#--</div>-->
                                <#--<div class="checkbox col-sm-4">-->
                                    <#--<label>-->
                                        <#--<input name="subBox" type="checkbox" value="2"/>商品-->
                                    <#--</label>-->
                                <#--</div>-->
                                <#--<div class="checkbox col-sm-4">-->
                                    <#--<label>-->
                                        <#--<input name="subBox" type="checkbox" value="2"/>商品-->
                                    <#--</label>-->
                                <#--</div>-->
                                <#--<div class="checkbox col-sm-4">-->
                                    <#--<label>-->
                                        <#--<input name="subBox" type="checkbox" value="2"/>商品-->
                                    <#--</label>-->
                                <#--</div>-->
                                <#--<div class="checkbox col-sm-4">-->
                                    <#--<label>-->
                                        <#--<input name="subBox" type="checkbox" value="2"/>商品-->
                                    <#--</label>-->
                                <#--</div>-->


                            </form>

                        </div>


                    </div>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-confirm" onclick="pinckingOrders()">确定</button>
                <button type="button" class="btn btn-default" onclick="modalCancle() ">取消</button>

            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="excelModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">上传excel</h4>
            </div>
            <div class="modal-body">
                <form id="excelForm" class="form-horizontal" method="post" action="uploadFile"
                      enctype="multipart/form-data">


                    <div class="form-group">
                        <label for="inputPassword" class="col-sm-2 control-label">文件选择：</label>
                        <div class="col-sm-8">
                            <input type="file" class="form-control" id="excelFile" name="excelFile" accept=".XLS,.xlsx">
                        </div>
                    </div>


                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-confirm" onclick="confirmUploadExcel()">确认</button>

                <button type="button" class="btn btn-default" onclick="cancleModal()">取消</button>

            </div>
        </div>
    </div>
</div>
</body>
</html>