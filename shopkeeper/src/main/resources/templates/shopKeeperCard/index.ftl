<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
    <style>
        input[type="number"]::-webkit-outer-spin-button,
        input[type="number"]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        input[type="number"] {
            -moz-appearance: textfield;
        }
    </style>
</head>
<body>
<div class="nav-tabs-custom">
    <ul class="nav nav-tabs">
        <li class=""><a href="/index">订单</a></li>
        <li class=""><a href="/order/index">采购记录</a></li>
        <li class="active"><a href="#bankManagement_tab" data-toggle="tab" aria-expanded="true">银行卡管理</a></li>
        <li class=""><a href="/receivingAddress/index">收货地址管理</a></li>
        <li class=""><a href="/withdrawApply/index">提现记录</a></li>
        <li class=""><a href="/goods/index">商品列表</a></li>
    </ul>
    <div class="tab-content">
        <!-- /.tab-pane -->
        <div class="tab-pane active" id="bankManagement_tab" style="width: 70%">
            <div class="row" style="margin-bottom:1%">
                <div class="col-xs-2">
                    <button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#addBank_Modal">添加银行卡</button>
                </div>
            </div>
            <ul class="list-group">
                <#if shopKeeperCards ??>
                    <#list shopKeeperCards as card>
                        <li class="list-group-item">
                            <div class="row">
                                <div class="col-xs-3">
                                    <img src="/assets/img/bankImg/${card.bankName}.png" class="img-thumbnail">
                                </div>
                                <div class="col-xs-2"><p class="text-info" style="margin:10% 0 0 0">尾号 ：${card.cardNo?substring(card.cardNo?length-4,card.cardNo?length)} </p><p class="text-info">姓名：${shopKeeper.cname}</p></div>
                                <div class="col-xs-2 col-xs-offset-3"><a href="/shopKeeperCard/detail?sid=${card.sid?c}" class="btn btn-info btn-block " style="margin:10% 0 0 0">编辑</a></div>
                                <div class="col-xs-2">
                                    <button type="button" class="btn btn-danger btn-remove btn-block" data-sid="${card.sid?c}" style="margin:10% 0 0 0">
                                        <i class="fa fa-remove fa-fw"></i> 删除
                                    </button>
                                </div>
                            </div>
                        </li>
                    </#list>
                </#if>
            </ul>
            <!--添加（only）银行卡模态框-->
            <!--添加银行卡模态框-->
            <div class="modal fade" id="addBank_Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                &times;
                            </button>
                            <h4 class="modal-title" id="myModalLabel">
                                添加银行卡
                            </h4>
                        </div>
                        <div class="modal-body">
                            <p>为了您的安全，即日起只能添加快捷卡才能进行提现。</p>
                            <div class="row form-group">
                                <div class="col-xs-3" >
                                    <a href="/shopKeeperCard/add?bankCardName=ABC"><img src="/assets/img/bankImg/ABC.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=BJBANK"><img src="/assets/img/bankImg/BJBANK.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=BOC"><img src="/assets/img/bankImg/BOC.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=CCB"><img src="/assets/img/bankImg/CCB.png" class="img-thumbnail"></a>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-xs-3" >
                                    <a href="/shopKeeperCard/add?bankCardName=CCQTGB"><img src="/assets/img/bankImg/CCQTGB.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=CDCB"><img src="/assets/img/bankImg/CDCB.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=CIB"><img src="/assets/img/bankImg/CIB.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=CITIC"><img src="/assets/img/bankImg/CITIC.png" class="img-thumbnail"></a>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-xs-3" >
                                    <a href="/shopKeeperCard/add?bankCardName=CMB"><img src="/assets/img/bankImg/CMB.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=CMBC"><img src="/assets/img/bankImg/CMBC.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=COMM"><img src="/assets/img/bankImg/COMM.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=CQBANK"><img src="/assets/img/bankImg/CQBANK.png" class="img-thumbnail"></a>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-xs-3" >
                                    <a href="/shopKeeperCard/add?bankCardName=CRCBANK"><img src="/assets/img/bankImg/CRCBANK.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=GDB"><img src="/assets/img/bankImg/GDB.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=HXBANK"><img src="/assets/img/bankImg/HXBANK.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=ICBC"><img src="/assets/img/bankImg/ICBC.png" class="img-thumbnail"></a>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-xs-3" >
                                    <a href="/shopKeeperCard/add?bankCardName=PINGAN"><img src="/assets/img/bankImg/PINGAN.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=PSBC"><img src="/assets/img/bankImg/PSBC.png" class="img-thumbnail"></a>
                                </div>
                                <div class="col-xs-3">
                                    <a href="/shopKeeperCard/add?bankCardName=SPDB"><img src="/assets/img/bankImg/SPDB.png" class="img-thumbnail"></a>
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
    $(document).on('click', '.btn-remove', function () {
        var $t = $(this), sid = $t.data('sid');
        confirmFun('/shopKeeperCard/delete?sid=' + sid, '是否删除？');
    });

</script>
</body>
</html>