<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/receivingAddress/index">
    <style>
        .colorP{
            color: #666;
        }
        a,a:hover{ text-decoration:none; color:#000}
    </style>
</head>
<body>
<div class="row">
    <div class="col-xs-12">
        <div class="box box-primary">
            <div class="box-header with-border">
                <div>
                    <div style="width: 85%;float: left;"><span>收货地址管理</span></div>
                    <div style="width: 15%;float: left;"><a href="javascript:history.go(-1)">返回</a></div>
                </div>
            </div>
            <div class="box-body">
            <#if receivingAddresses ??>
                <#list  receivingAddresses as address>
                    <#if address.isDefault == 1>
                        <div style="height:70px;">
                            <a href="/receivingAddress/detail?sid=${address.sid?c}">
                                <div style="width: 90%;float: left;height:100%;background-color: #5e6b85;color: #FFFFFF;padding: 2% 0 0 2%">
                                    <p>收货人：${address.name}　　${address.telephone}</p>
                                    <p style="font-size: 10px;">
                                        收货地址：${address.province}${address.city}${address.area}
                                        <#if address.address?length gt 28>
                                        ${address.address[0..28]}
                                        <#else >
                                        ${address.address}
                                        </#if>
                                    </p>
                                </div>
                                <div style="width: 10%;float: left;height:100%;background-color: #5e6b85;color: #FFFFFF;padding: 7% 0 0 0">
                                    <span class="glyphicon glyphicon-ok"></span>
                                </div>
                            </a>
                        </div>
                    </#if>
                </#list>
                <#list  receivingAddresses as address>
                    <#if address.isDefault != 1>
                        <div style="height:70px;border-bottom: 1px solid #c2ccd1;">
                            <a href="/receivingAddress/detail?sid=${address.sid?c}">
                                <div style="width: 90%;float: left;height:100%;padding: 2% 0 0 2%">
                                    <p class="colorP">收货人：${address.name}　　${address.telephone}</p>
                                    <p style="font-size: 10px;">
                                        收货地址：${address.province}${address.city}${address.area}
                                        <#if address.address?length gt 28>
                                        ${address.address[0..28]}
                                        <#else >
                                        ${address.address}
                                        </#if>
                                    </p>
                                </div>
                                <div style="width: 10%;float: left;height:100%;"></div>
                                <a>
                        </div>
                    </#if>
                </#list>
            </#if>
                <div style="margin: 5% 0 0 0">
                    <a href="/receivingAddress/add" class="btn btn-info btn-lg btn-block">新增收货地址</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
</script>
</body>
</html>