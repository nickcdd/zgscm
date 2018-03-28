<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_table.ftl" />
<#include "../_head_with_datepicker.ftl" />
    <link rel="stylesheet" href="/assets/plugins/select2/select2.css">
    <script src="/assets/plugins/select2/select2.full.js"></script>
    <style>
        .box-width {
            min-width: 800px;
        }
    </style>
    <meta name="nav-url" content="/ordersStatistics/index">
    <script type="text/javascript">
        $(function () {
//            initSelect();

            var picker1 = $('#datetimepicker1').datetimepicker({
                format: "yyyy-mm-dd hh:ii",
                language: 'zh-CN',
                autoclose: true,
                pickerPosition: "bottom-left"
                //minDate: '2016-7-1'
            });
            var picker2 = $('#datetimepicker2').datetimepicker({
                format: "yyyy-mm-dd hh:ii",
                language: 'zh-CN',
                autoclose: true,
                pickerPosition: "bottom-left"
            });
            //动态设置最小值
            picker1.on('changeDate', function (e) {
//                alert(e.date);
//                picker2.data('DateTimePicker').minDate(e.date);
                picker2.datetimepicker('setStartDate', e.date);
            });
            //动态设置最大值
            picker2.on('changeDate', function (e) {
//                picker1.data('DateTimePicker').maxDate(e.date);
                picker1.datetimepicker('setEndDate', e.date);
//                alert(e.date);
            });
            //查找
            $('.btn_search').click(function () {
                $('#totalAmount').val("");
                $('#totalQuantity').val("");
                $('#infoTable').submit();
            });
            //导出
            $('.btn-export').click(function () {
                exportExecl();
            });


        });

        function exportExecl() {
//            alert($('#startDate').val());
            $('#exportSupplierSid').val($('#supplierSid').val());
            $('#exportStartDate').val($('#startDate').val());
            $('#exportEndDate').val($('#endDate').val());
            $('#exportState').val($('#status').val());
            $('#exportForm').submit();
        }
        function initSelect() {
            $(".select2").select2();


            var supplierStr = getAllSuppliers();
            $('#supplierSid').html(supplierStr);


        }
        function getAllSuppliers() {

            var str = "<option value=''>请选择</option>";
            $.ajax({
                type: "POST",
                url: "/supplier/getAllSuppliers",

                dataType: "JSON",
                async: false,
                success: function (data) {
                    //从服务器获取数据进行绑定
                    if ($('#checkSupplierSid').val() == -1) {
                        str += "<option selected='selected' value='-1'>平台</option>";
                    } else {
                        str += "<option value='-1'>平台</option>";
                    }
                    $.each(data.record, function (i, item) {

                        // str="<option value=''>请选择</option>";
                        if ($('#checkSupplierSid').val() == item.sid) {
                            str += "<option selected='selected' value=" + item.sid + ">" + item.cname + "</option>";
                        } else {
                            str += "<option value=" + item.sid + ">" + item.cname + "</option>";
                        }

                    })

                    return str;
                },
                error: function () {

                }
            });
            return str;

        }

    </script>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="orderList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">订单列表</h3>
            </div>
            <div class="box-body">
                <form id="exportForm" action="/ordersStatistics/export" method="post">
                    <input type="hidden" name="exportSupplierSid" id="exportSupplierSid"/>
                    <input type="hidden" name="exportStartDate" id="exportStartDate"/>
                    <input type="hidden" name="exportEndDate" id="exportEndDate"/>
                    <input type="hidden" name="exportState" id="exportState"/>
                </form>
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">

                        <form id="infoTable" action="/ordersStatistics/index" method="post" class="form-inline"
                              role="search-form">

                            <input type="hidden" name="page"/>
                            <input type="hidden" name="size"/>
                            <input type="hidden" name="totalAmount" id="totalAmount" value="${totalAmount}"/>
                            <input type="hidden" name="totalQuantity" id="totalQuantity" value="${totalQuantity}"/>
                            <input type="hidden" id="checkSupplierSid" value="${checkSupplierSid}"/>
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
                        <#--<div class="form-group ">-->
                        <#--<label class="" for="name"> 供应商 </label>-->
                        <#--<div class='input-group'>-->
                        <#--<select class="form-control select2" style="width:100%;" id="supplierSid"-->
                        <#--name="supplierSid"-->
                        <#--data-placeholder="请选择供应商" style="width: 50%;" required="required">-->

                        <#--</select>-->

                        <#--</div>-->
                        <#--</div>-->
                            <input type="hidden" name="supplierSid" id="supplierSid" value="-1" name="supplierSid"/>
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
                                            已签收
                                        </option>


                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn_search"><i
                                        class="fa  fa-search"></i>查找
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-export"><i
                                        class="fa  fa-file-excel-o"></i>导出excel
                                </button>
                            </div>
                            <div class="table-responsive" style="margin-top: 2%">

                            <#if orders ??>
                                <#list orders as order>
                                    <div class="box box-info" box-width
                                    " style="width:100%;background: #f9f9f9;">
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
                                                <#--<div class="col-md-2"><span-->
                                                <#--class="text-info">收货地址：${order.address}</span></div>-->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <div class="box-body" style="width: 100%">
                                <table border="1" cellpadding="0" cellspacing="0"
                                       style="border:1px solid #daf3ff;width: 100%">
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
                                <div class="col-md-2"
                                     style="margin-top: 2%">
                                    <p class="text-info">
                                        商品名称：${orderGood.goodsCname}</p>
                                </div>
                                <div class="col-md-2"
                                     style="margin-top: 2%">
                                    <p class="text-info">
                                        商品数量：${orderGood.goodsCount} 件</p>
                                </div>
                                <div class="col-md-2"
                                     style="margin-top: 2%">
                                    <p class="text-info">
                                        进价：￥${orderGood.goodsSpecificationCost}/件</p>
                                </div>
                                <div class="col-md-2"
                                     style="margin-top: 2%">
                                    <p class="text-info">
                                        售价：￥${orderGood.goodsSpecificationPrice}/件</p>
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
                                        <p class="text-primary">买家已付款(待发货)</p></td>
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
                            <#--<td style="width: 200px;text-align: center;"-->
                            <#--rowspan="${order.ordersGoodsList?size}">-->
                            <#--<#if order.status == 2>-->
                            <#--<button type="button"-->
                            <#--class="btn btn-info  btn-deliver"-->
                            <#--data-sid="${order.sid?c}">-->
                            <#--<i class="fa fa-flash fa-fw"></i> 发货-->
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
                            <div class="text-right" style="margin-bottom: 5px">
                            <#--<button type="button" id="deliver" class="btn-lg btn btn-primary"-->
                            <#--data-toggle="modal" data-target="#deliverModal"-->
                            <#--disabled="disabled">选中项发货-->
                            <#--</button>-->
                                <span><strong>订单总数：</strong><strong class="text-red"> <span
                                >${totalQuantity!''}</span> 笔</strong></span>
                                <span><strong>合计金额：</strong><strong class="text-red">￥ <span
                                >${totalAmount!''}</span> 元</strong></span>
                            </div>
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


</body>
</html>