<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_table.ftl" />
<#include "../_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/orders/index">
    <style>
        .box-width {
            min-width: 800px;
        }
    </style>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info" style="">
            <div class="box-header with-border">
                <h3 class="box-title">订单列表</h3>
            </div>
            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form id="exportForm" action="/orders/export" method="post">
                            <input type="hidden" name="startTimeXLS" id="startTimeXLS"/>
                            <input type="hidden" name="endTimeXLS" id="endTimeXLS"/>
                            <input type="hidden" name="statusXLS" id="statusXLS"/>
                        </form>
                        <form action="/orders/index" method="post" class="form-inline" role="search-form">
                            <input type="hidden" name="page"/>
                            <input type="hidden" name="size"/>
                            <div class="form-group">
                                <label class="" for="name">日期</label>
                                <div class='input-group date' id='startTime'>
                                    <input type='text' name="startTime" id="startTime" class="form-control"
                                           value="${startTime}"/>
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-calendar"></span>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 至 </label>
                                <div class='input-group date' id='endTime'>
                                    <input type='text' name="endTime" id="endTime" class="form-control"
                                           value="${endTime}"/>
                                    <span class="input-group-addon">
                                        <span class="glyphicon glyphicon-calendar"></span>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">状态</label>
                                <div class="input-group date">
                                    <select class="form-control" name="status" id="status">
                                        <option value="">请选择</option>
                                        <option value="2" ${(status?? && status == 2)?string('selected="selected"', "")}>
                                            已付款
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
                                <button type="submit" class="btn btn-info btn-block ">查找</button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-export">
                                    <i class="fa  fa-file-excel-o"></i> 导出Excel
                                </button>
                            </div>
                            <div class="table-responsive" style="margin-top: 2%;width: 100%;">
                                <input type="checkbox" id="selectAll"> <span style=""><strong>全选</strong></span>
                            <#if orders ??>
                                <#list orders as order>
                                    <div class="box box-info box-width" style="width:100%;background: #f9f9f9;">
                                        <div class="box-header with-border">
                                            <div class="list-group">
                                                <a href="javascript:void (0)" class="list-group-item"
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
                                                </a>
                                                <a href="javascript:void (0)" class="list-group-item"
                                                   style="background:#f9f9f9 ">
                                                    <div class="row">
                                                        <div class="col-md-2"><span
                                                                class="text-info">收货人：${order.shopKeeper.realName}</span>
                                                        </div>
                                                        <div class="col-md-2"><span
                                                                class="text-info">电话：${order.shopKeeper.telephone}</span>
                                                        </div>
                                                        <div class="col-md-2"><span
                                                                class="text-info">订单金额：#{order.totalAmount;m2M2}</span>
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
                                                </a>
                                            </div>
                                        </div>
                                        <div class="box-body" style="width: 100%">
                                            <table border="1" cellpadding="0" cellspacing="0"
                                                   style="border:1px solid #daf3ff;width: 100%;">
                                                <#list order.ordersGoodsList as orderGood>
                                                    <tr>
                                                        <#if orderGood_index == 0>
                                                            <#if order.status == 2>
                                                                <td rowspan="${order.ordersGoodsList?size}">
                                                                    <div style="margin: 0 10px 0 10px;">
                                                                        <input type="checkbox" name="ordersSid"
                                                                               style="display: none">
                                                                        <input type="hidden" value="${order.sid?c}">
                                                                        <input type="hidden"
                                                                               value="${order.shopKeeper.realName}">
                                                                        <input type="hidden"
                                                                               value="${order.shopKeeper.telephone}">
                                                                        <input type="hidden" value="${order.address}">
                                                                        <i class="fa fa-check-square-o fa-3x"
                                                                           style="display: none;"></i>
                                                                        <i class="fa fa-square-o fa-3x"></i>
                                                                    </div>
                                                                </td>
                                                            </#if>
                                                        </#if>
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
                                                                                     class="img-thumbnail"
                                                                                     onerror="checkImgFun(this)"
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
                                                                        ￥：#{orderGood.goodsSpecificationPrice;m2M2}/件</p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <#if orderGood_index == 0>
                                                            <td style="width: 13%; text-align: center;"
                                                                rowspan="${order.ordersGoodsList?size}">
                                                                ￥#{order.payAmount;m2M2}</td>
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
                                                                <td style="width: 13%; text-align: center;"
                                                                    rowspan="${order.ordersGoodsList?size}">
                                                                    <p class="text-primary">待检货</p></td>
                                                            </#if>
                                                            <td style="width: 13%;text-align: center;"
                                                                rowspan="${order.ordersGoodsList?size}">
                                                                <#if order.status == 2>
                                                                    <button type="button"
                                                                            class="btn btn-info  btn-deliver"
                                                                            data-sid="${order.sid?c}">
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
                                <div class="text-right box-width" style="margin-bottom: 5px;">
                                    <button type="button" id="deliver" class="btn-lg btn btn-primary" onclick="showModalContent()"
                                            disabled="disabled">选中项发货
                                    </button>
                                </div>
                                <div class="box-width" style="margin-bottom: 5px;">
                                    <table data-toggle="table" data-page-info='${pageInfo}'
                                           data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                        <thead style="display:none;">
                                        <tr>
                                            <th></th>
                                        </tr>
                                        </thead>
                                        <tr>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="batchDeliverModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="myModalLabel">
                    物流信息<span style="color: #666;font-size: 12px;">(多个物流单号，请换行输入)</span>
                </h4>
            </div>
            <div class="modal-body">
                <div id="modalBody"></div>
                <form id="batchDeliverForm" action="/orders/deliverMultiGoods/" method="post">
                    <input type="hidden" name="paramArray" id="paramArray">
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button onclick="batchDeliver()" type="button" class="btn btn-primary">
                    确认发货
                </button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="deliverModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">

        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        物流信息<span style="color: #666;font-size: 12px;">(多个物流单号，请换行输入)</span>
                    </h4>
                </div>
                <div class="modal-body">
                    <form id="singleDeliverForm" action="/orders/deliverGoods/" method="post" class="form-inline">
                        <div class="input-group">
                            <span class="text-info">物流信息填写　</span>
                        </div>
                        <div class="input-group">
                            <input type="hidden" name="sid" id="singleDeliverSid" class="form-control">
                        </div>
                        <div class="input-group">
                            <input name="logisticsCompany" id="singleDeliverLogisticsCompany" class="form-control" placeholder="物流公司">
                        </div>
                        <div class="input-group">
                            <textarea name="logisticsNo" id="singleDeliverLogisticsNo" placeholder="物流单号" class="form-control" rows="1" cols="10"  onkeyup="this.value=this.value.replace(/[^\r\n0-9]/g,'');"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                    </button>
                    <button type="button" class="btn btn-primary" onclick="singleDeliver()">
                        确认发货
                    </button>
                </div>
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

        $(document).on('click', '.btn-deliver', function () {
            var $t = $(this), sid = $t.data('sid');
            $("#singleDeliverSid").val(sid);
            $('#deliverModal').modal('show');
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
        $(document).on('click', '.btn-export', function () {
            exportForm();
        });
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
    /*
    单个商品发货
    */
    function singleDeliver() {
        var singleDeliverLogisticsCompany = $("#singleDeliverLogisticsCompany").val();
        var singleDeliverLogisticsNo = $("#singleDeliverLogisticsNo").val();
        if(singleDeliverLogisticsCompany == '' || singleDeliverLogisticsCompany == undefined){
            showInfoFun('请将物流信息填写完成。', 'warning');
            return false;
        }
        if(singleDeliverLogisticsNo == '' || singleDeliverLogisticsNo == undefined){
            showInfoFun('请将物流信息填写完成。', 'warning');
            return false;
        }
        goodsInventoryValidate($("#singleDeliverSid").val());
    }
    /*
    批量发货
     */
    function batchDeliver() {
        var paramArray = new Array();
        var i = 0;
        var flag = true;
        $("[name=modelCheck]:checkbox").each(function (index, value) {
            if ($(this).is(':checked')) {
                var logisticsCompany = $(this).parent().find("input").eq(2).val();
                var logisticsNo = $(this).parent().find("input").eq(3).val();
                if(logisticsCompany == "" || logisticsCompany == undefined){
                    flag = false;
                }
                if(logisticsNo == "" || logisticsNo == undefined){
                    flag = false;
                }
                paramArray[i] = {
                    'sid': $(this).parents('form').find("input").eq(1).val(),
                    'logisticsCompany': logisticsCompany,
                    'logisticsNo': logisticsNo
                };
                i++;
            }
        });
        if(flag){
            var paramJson = JSON.stringify(paramArray);
            $("#paramArray").val(paramJson);
            batchGoodsInventoryValidate(paramJson);
        }else {
            showInfoFun('请将物流信息填写完成。', 'warning');
        }
    }
    function showModalContent() {
        var content = new Array();
        var i = 0;
        $("[name=ordersSid]:checkbox").each(function () {
            if ($(this).is(':checked')) {
                content[i] = {
                    "sid": $(this).parent().find("input").eq(1).val(),
                    "cname": $(this).parent().find("input").eq(2).val(),
                    "telephone": $(this).parent().find("input").eq(3).val(),
                    "receivingAddress":$(this).parent().find("input").eq(4).val()
                };
                i++;
            }
        });
        var str = "";
        $.each(content, function (index,value) {
            str +="<div class='list-group'>"+
                    "<a href='javascript:void(0)' class='list-group-item disabled'>"+
                        "<h4 class='list-group-item-heading'>"+
                            "<span>收货人：</span><span>"+value['cname']+"　</span><span>电话号码：</span><span>"+value['telephone']+"</span>"+
                        "</h4>"+
                    "</a>"+
                    "<a href='javascript:void(0)' class='list-group-item'>"+
                        "<h4 class='list-group-item-heading'>"+
                            "<span>收货地址：</span><span>"+value['receivingAddress']+"</span>"+
                        "</h4>"+
                    "</a>"+
                    "<a href='javascript:void(0)' class='list-group-item'>"+
                        "<form class='form-inline'>"+
                            "<div class='input-group'>"+
                                "<span class='text-info'>物流信息填写　</span>"+
                            "</div>"+
                            "<input type='checkbox' name='modelCheck' checked='checked' style='display:none '>"+
                            "<input type='hidden' class='form-control' value='"+value['sid']+"' placeholder='订单sid'>" +
                            "<div class='input-group'>"+
                                "<input class='form-control' placeholder='物流公司'>"+
                            "</div>"+
                            "<span> </span>"+
                            "<div class='input-group'>"+
                    "<textarea  placeholder='物流单号' class='form-control' rows='1' cols='10'  onkeyup='inputNumber(this)'" +
                    "></textarea>"+
                            "</div>"+
                        "</form>"+
                    "</a>"+
                "</div>";

            var xx= "'');></textarea>";
        });
        $("#modalBody").html(str);
        $('#batchDeliverModal').modal('show');
    }
    function inputNumber(obj) {
        obj.value=obj.value.replace(/[^\r\n0-9]/g,'');
    }
    function exportForm() {
        $("#startTimeXLS").val($("#startTime").val());
        $("#endTimeXLS").val($("#endTime").val());
        $("#statusXLS").val($("#status option:selected").val());
        $("#exportForm").submit();
    }

    function batchGoodsInventoryValidate(paramArray) {
        $.ajax({
            type: "GET",
            url: "/orders/batchGoodsInventoryValidate",
            data: {'paramArray': paramArray},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                if(result.msg == 'error'){
                    showInfoFun(result.record, 'warning');
                }else {
                    $("#batchDeliverForm").submit();
                }
            },
            error: function (msg) {
                alert("系统繁忙");
            }
        });
    }
    function goodsInventoryValidate(sid) {
        $.ajax({
            type: "GET",
            url: "/orders/goodsInventoryValidate",
            data: {'sid': sid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                if(result.msg == 'error'){
                    showInfoFun(result.record, 'warning');
                }else {
                    $("#singleDeliverForm").submit();
                }
            },
            error: function (msg) {
                alert("系统繁忙");
            }
        });
    }
</script>
</body>
</html>