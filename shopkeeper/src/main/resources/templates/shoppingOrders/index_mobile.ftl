<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
<#include "../_head_with_table.ftl" />
    <script src="/assets/js/jquery.visible.min.js"></script>
    <meta name="nav-url" content="/order/index">
    <style>
        .container-wrapper {
            position: absolute;
            left: 0;
            right: 0;
            top: 50px;
            bottom: 0px;
            overflow: hidden;
            background: #F5F5F5;
        }

        .container-right {
            position: absolute;
            left: 0px;
            right: 0;
            top: 0;
            bottom: 0;
            overflow: auto;
            bottom: 10px;
            padding: 15px;
        }
    </style>
</head>

<body>
<div class="container-wrapper">
    <div class="container-right">
        <form id="goodsIndexForm" action="/order/index" method="get" class="form-inline"
              role="form">
            <input type="hidden" name="page" />
            <input type="hidden" name="size" />
            <div class="form-group">
                <label class="" for="name">日期</label>
                <div class='input-group date' id='startTime'>
                    <input type='text' id="startTimeInput" name="startTime" class="form-control" value="${startTime}" />
                    <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </div>
            <div class="form-group ">
                <label class="" for="name"> 至 </label>
                <div class='input-group date' id='endTime'>
                    <input type='text' id="endTimeInput" name="endTime" class="form-control" value="${endTime}" />
                    <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                </div>
            </div>
            <div style="height: 50px;margin: 2% 0 0 0">
                <div style="width:100%;" class="input-group date">
                    <select id="status" class="form-control" name="status">
                        <option value="">请选择状态</option>
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
                        &lt;#&ndash;<option value="10" ${(status?? && status == 10)?string('selected="selected"', "")}>
                        退货成功
                    </option>&ndash;&gt;
                    </select>
                </div>
            </div>
            <div class="form-group ">
                <button type="submit" class="btn btn-info btn-block ">查找</button>
            </div>
        </form>
        <div class="">
            <div style="width: 100%;text-align: center">
                <a class="hospitaltitel-center next_first" disabled="disabled" href="javascript: void(0);">数据加载中...
                    ...</a>
            </div>
            <div class="record_content" id="record_ul_first"></div>
        </div>
    </div>
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
                    <input type="radio" name="payType" value="2" checked /><span class="text-red">&nbsp;&nbsp;支付宝支付&nbsp;&nbsp;&nbsp;&nbsp;</span>
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
        $("#endTime").val();
        var endTimeInput = $("#endTimeInput").val();
        var startTimeInput = $("#startTimeInput").val();
        var status = $("#status option:selected").val();
        $('#record_ul_first').load('page', {
            status: status,
            endTime: endTimeInput,
            startTime: startTimeInput,
        }, function () {
            $('a.next_first').remove();
        });

        $('.container-right').scroll(function () {
            var $link = $('a.next');
            // alert($link.length + "  "+ $link.visible(true))
            if ($link.length > 0 && $link.visible(true)) {
                var nextPage = $link.data('page');
                if ($link.data('disabled')) {
                    return false;
                }
                $link.data('disabled', true).children().text('数据加载中... ...');
                $('a.next').next('.record_content').load('page', {
                    status: status,
                    endTime: endTimeInput,
                    startTime: startTimeInput,
                    page: nextPage
                }, function () {
                    $link.remove();
                });
            }
        });

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
    });
    $(function () {

        $(document).on('click', '.btn-takeGoods', function () {
            var $t = $(this), sid = $t.data('sid');
            confirmFun('/shopping/takeGoods?orderid=' + sid, '确认收货？');
        });
    })

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