<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
<#include "../_head_with_table.ftl" />
    <meta name="nav-url" content="/goods/index">
    <style>
        .nowrap {
            overflow: hidden;
            white-space: nowrap;
            -o-text-overflow: ellipsis;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body>
<div class="nav-tabs-custom">
    <ul class="nav nav-tabs">
        <li class="active"><a href="#goods_tab" data-toggle="tab" aria-expanded="true">产品列表</a></li>
        <li><a href="/supplier/index">供应商列表</a></li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane active" id="goods_tab">
            <div class="row placeholders">
                <div class="col-md-12 placeholder">
                    <form id="goodsIndexForm" action="/goods/index" method="get" class="form-inline" role="form">
                        <input type="hidden" name="page" />
                        <input type="hidden" name="size" />
                        <label class="" style="margin: 1%" for="name">商品分类</label>
                        <div class="input-group col-md-1">
                            <select id="bigCategory" style="min-width: 100px;"
                                    onchange="laodSmallCategory($('#bigCategory option:selected').val(),$('#bigCategory option:selected').val())"
                                    class="form-control" name="bigCategory">
                            </select>
                        </div>
                        <label style="display: none;" id="smallCategoryLabel" class="" for="name">详细分类</label>
                        <div style="display: none;" id="smallCategoryDiv" class="input-group col-md-1">
                            <select id="smallCategory" class="form-control" name="smallCategory">
                            </select>
                        </div>
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
                                                            <div style="height: 12px;">
                                                                <#if good.supplier.sid == -1>
                                                                    <span style="color: #fff;font-size: 12px;padding: 2px;background: #ff0000;">平台自营</span>
                                                                </#if>
                                                            </div>
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
    <#if bigCategory ??>
        $("#bigCategory").html(categoryLoad(1,${bigCategory}));
        $("#smallCategoryLabel").show();
        $("#smallCategoryDiv").show();
        $("#smallCategory").html(categoryLoad(${bigCategory}, null));
    <#else >
        $("#bigCategory").html(categoryLoad(1, null));
    </#if>

    <#if smallCategory ??>
        $("#smallCategoryLabel").show();
        $("#smallCategoryDiv").show();
        $("#smallCategory").html(categoryLoad(${bigCategory},${smallCategory}));
    </#if>
    });
    function laodSmallCategory(parentSid, falg) {

        if (parentSid == '') {
            $("#smallCategoryLabel").hide();
            $("#smallCategoryDiv").hide();
            $("#smallCategory").html("");
        } else {
            $("#smallCategoryLabel").show();
            $("#smallCategoryDiv").show();
            $("#smallCategory").html(categoryLoad(parentSid, falg));
        }
    }
    var categoryLoad = function (parentSid, falg) {

        var str = "<option value=''>请选择</option>";
        $.ajax({
            type: "GET",
            async: false,
            url: "/goods/category",
            data: {'parentSid': parentSid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                $.each(result.record, function (index, value) {
                    if (falg == value.sid) {
                        str += "<option selected='selected' value=" + value.sid + ">" + value.cname + "</option>";
                    } else {
                        str += "<option value=" + value.sid + ">" + value.cname + "</option>";
                    }
                })
            },
            error: function (msg) {
                alert("系统繁忙");
                return;
            }
        });
        return str;
    }

    function goodsIndexFormSubmit() {

        $("#goodsIndexForm").submit();
    }

</script>
</body>
</html>