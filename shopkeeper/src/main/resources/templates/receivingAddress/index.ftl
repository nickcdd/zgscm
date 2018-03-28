<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/receivingAddress/index">
</head>
<body>
<div class="panel box box-primary" style="min-width: 737px;">
    <div class="box-header with-border">
        收货地址管理
    </div>
    <div class="box-body">
        <div style="min-width: 718px;">
            <!-- /.tab-pane -->
            <div class="row" style="margin-bottom:1%">
                <div class="col-xs-2" style="min-width: 150px;">
                    <!--<button type="submit" class="btn btn-primary btn-block" data-toggle="modal" data-target="#onlyAddBank_modal">添加银行卡</button>-->
                    <a href="/receivingAddress/add" class="btn btn-primary btn-block" >新增收货地址</a>
                </div>
            </div>
            <div class="">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-striped">
                        <thead>
                        <tr>
                            <th style="width:10%;text-align: left">收货人</th>
                            <th style="width:15%;text-align: left">所在地区</th>
                            <th style="width:30%;text-align: left">详细地址</th>
                            <th style="width:15%;text-align: left">手机号码</th>
                            <th style="width:15%;text-align: left">操作</th>
                            <th style="width:15%;text-align: left">是否默认</th>
                        </tr>
                        </thead>
                    <#if receivingAddresses ??>
                        <#list  receivingAddresses as address>
                            <tr>
                                <td class="text-left">${address.name}</td>
                                <td class="text-left">${address.province}${address.city}${address.area}${address.city}${address.area}</td>
                                <td class="text-left">${address.address}</td>
                                <td class="text-left">${address.telephone}</td>
                                <td class="text-left">
                                    <a href="/receivingAddress/detail?sid=${address.sid?c}"  class="btn btn-xs btn-info" data-sid="${address.sid?c}" >
                                        <i class="fa fa-edit fa-fw"></i> 修改
                                    </a>
                                    <button type="button" class="btn btn-danger btn-xs btn-remove" data-sid="${address.sid?c}" >
                                        <i class="fa fa-remove fa-fw"></i> 删除
                                    </button>
                                </td>
                                <td class="text-left">
                                    <#if address.isDefault == 1>

                                        <a>默认地址</a>
                                    <#else>
                                        <div>

                                            <a  id="defaultAddress" data-sid="${address.sid?c}" type="button" class="btn btn-success" >设为默认</a>
                                        </div>

                                    </#if>
                                </td>
                            </tr>
                        </#list>
                    </#if>
                    <#if receivingAddresses?size == 0>
                        <tr>
                            <td colspan="6" style="text-align: center">
                                暂无收获地址信息
                            </td>
                        </tr>
                    </#if>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    function delcfm() {
        if (!confirm("确认要删除？")) {
            window.event.returnValue = false;
        }
    }
    $(document).on('click', '.btn-remove', function () {
        var $t = $(this), sid = $t.data('sid');
        confirmFun('/receivingAddress/delete?sid=' + sid, '确认删除？');
    });
    $(document).on('click', '#defaultAddress', function () {
        var $t = $(this), sid = $t.data('sid');
        confirmFun('/receivingAddress/setDefault?sid=' + sid, '是否设为默认地址？');
    });

</script>
</body>
</html>