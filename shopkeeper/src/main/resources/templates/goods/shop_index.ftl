<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
<#include "../_head_with_table.ftl" />
    <meta name="nav-url" content="/goods/index">
    <style>
        .nowrap {
            /* height: 20px;*/
            overflow: hidden;
            white-space: nowrap;
            -o-text-overflow: ellipsis;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body>
<div class="panel box box-primary">
    <div class="box-header with-border">
        ${supplierName}  商品列表
    </div>
    <div class="box-body">
        <div class="tab-content">
            <div class="tab-pane active" id="goods_tab">
                <div class="row placeholders">
                    <div class="col-md-12 placeholder">
                        <form id="goodsIndexForm" action="/goods/shopIndex" method="get" class="form-inline" role="form">
                            <input type="hidden" name="page" />
                            <input type="hidden" name="size" />
                            <label class="" style="margin: 1%" for="name">店铺内搜索</label>
                            <div class="form-group ">
                                <div class="input-group ">
                                <#if cname ??>
                                    <input type="text" name="cname" id="cname" class="form-control" placeholder="请输入搜索的关键词"
                                           value="${cname}" />
                                <#else >
                                    <input type="text" name="cname" id="cname" class="form-control"
                                           placeholder="请输入搜索的关键词" />
                                </#if>
                                </div>
                            </div>
                            <div class="form-group ">
                                <button id="goodsIndexButton" type="submit" class="btn btn-info btn-block ">搜索</button>
                            </div>
                            <div style="margin-top: 10px;">
                                <div class="row">
                                <#if goods ??>
                                    <#list goods as good>
                                        <div class="col-lg-2 col-md-3 col-sm-6 col-xs-12">
                                            <div class="box box-info">
                                                <div class="box-body">
                                                    <a href="/goods/detail?sid=${good.sid?c}">
                                                        <div style="height: 200px;">
                                                            <#if good.goodsFiles ??>
                                                                <#if good.goodsFiles?size == 0>
                                                                    <img style="max-height: 200px;" class="img-responsive" src="/assets/img/goods/img-goods-default.png" />
                                                                </#if>
                                                                <#list good.goodsFiles as goodsfile>
                                                                    <#if goodsfile_index == 0>
                                                                        <img style="max-height: 200px;" class="img-responsive" onerror="checkImgFun(this)" src="${goodsfile.url}" />
                                                                    <#else>
                                                                        <img style="max-height: 200px;" class="img-responsive" src="/assets/img/goods/img-goods-default.png" />
                                                                    </#if>
                                                                </#list>
                                                            <#else>
                                                                <img style="max-height: 200px;" class="img-responsive" src="/assets/img/goods/img-goods-default.png" />
                                                            </#if>
                                                        </div>
                                                        <#if good.goodsSpecifications ??>
                                                            <#list good.goodsSpecifications as pecifications>
                                                                <#if pecifications_index == 0>
                                                                    <#assign minPrice = pecifications.price maxPirce = pecifications.price>
                                                                </#if>
                                                                <#if minPrice gt pecifications.price>
                                                                    <#assign minPrice = pecifications.price>
                                                                </#if>
                                                                <#if maxPirce lt pecifications.price>
                                                                    <#assign maxPirce = pecifications.price>
                                                                </#if>
                                                            </#list>
                                                            <div>
                                                                <div style="margin-top: 2%;">
                                                                    <#if minPrice == maxPirce>
                                                                        <p class="text-red text-bold nowrap" title="￥ #{minPrice;m2M2} 元">
                                                                            ￥ #{minPrice;m2M2} 元</p>
                                                                    <#else >
                                                                        <p class="text-red text-bold nowrap" title="￥ #{minPrice;m2M2} ~ #{maxPirce;m2M2} 元">
                                                                            ￥ #{minPrice;m2M2} ~ #{maxPirce;m2M2} 元</p>
                                                                    </#if>
                                                                </div>
                                                                <a href="/goods/detail?sid=${good.sid?c}" title="${good.cname}">
                                                                    <div class="nowrap">
                                                                    ${good.cname}
                                                                    </div>
                                                                </a>
                                                            </div>
                                                        </#if>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </#list>
                                </#if>
                                </div>
                            </div>
                            <table data-toggle="table" data-page-info='${pageInfo}'
                                   data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}" data-page-list="6,12,24,48">
                                <thead style="display:none ">
                                    <tr>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody style="display:none ">
                                    <tr>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>

                </div>
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
</script>
</body>
</html>