<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/goods/goodsSupplier/index">
    <script src="/assets/js/goods/goodsSupplier/index.js"></script>

</head>
<body>
<div class="row">
    <div class="col-md-12" id="goodsSupplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">商品列表供应商管理</h3>
            </div>


            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form action="/goods/goodsSupplier/index" method="post" class="form-inline" role="search-form">
                            <input type="hidden" name="page"/>
                            <input type="hidden" name="size"/>
                            <div class="form-group ">
                                <label class="" for="name">大类</label>
                                <div class="input-group date">
                                    <select class="form-control" name="searchBigCatecory" id="searchBigCatecory"
                                            onchange="getSearchAllSmallCatecory($('#searchBigCatecory option:selected').val(),$('#searchSmallCatecory option:selected').val())">

                                    <#if searchBigCatecory!="">
                                        <option value="${searchBigCatecory?split(",")[0]}"
                                                selected="selected">${searchBigCatecory?split(",")[1]}</option>
                                    </#if>


                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">小类</label>
                                <div class="input-group date">
                                    <select class="form-control" name="searchSmallCatecory" id="searchSmallCatecory"
                                    ">
                                <#if searchSmallCatecory!="">
                                    <option value="${searchSmallCatecory?split(",")[0]}"
                                            selected="selected">${searchSmallCatecory?split(",")[1]}</option>
                                </#if>

                                    </select>
                                </div>
                            </div>
                        <#--<div class="form-group ">-->
                        <#--<label class="" for="name"> 大类名称 </label>-->
                        <#--<div class='input-group'>-->
                        <#--<input type='text' name="bigCategory" class="form-control" id="bigCategory"-->
                        <#--value="${bigCategory}"/>-->

                        <#--</div>-->
                        <#--</div>-->
                        <#--<div class="form-group ">-->
                        <#--<label class="" for="name"> 小类名称 </label>-->
                        <#--<div class='input-group'>-->
                        <#--<input type='text' name="smallCategory" class="form-control" id="smallCategory"-->
                        <#--value="${smallCategory}"/>-->

                        <#--</div>-->
                        <#--</div>-->
                        <#--<div class="form-group ">-->
                        <#--<label class="" for="name"> 单价 </label>-->
                        <#--<div class='input-group' >-->
                        <#--<input type='text' name="price" class="form-control" id="price"  value="${price}"/>-->

                        <#--</div>-->
                        <#--</div>-->
                            <div class="form-group ">
                                <label class="" for="name"> 商品名称 </label>
                                <div class='input-group'>
                                    <input type='text' name="q" class="form-control" id="q" value="${q}"/>

                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">状态</label>
                                <div class="input-group date">
                                    <select class="form-control" name="status" id="status">
                                    <#--<#if status == 1>-->
                                    <#--<option selected="selected" value="1">有效</option>-->
                                    <#--<option value="4">基本信息审核已通过</option>-->
                                    <#--<option value="7">价格信息审核已通过</option>-->


                                    <#--<#elseif status == 4>-->
                                    <#--<option value="1">有效</option>-->
                                    <#--<option selected="selected" value="4">基本信息审核已通过</option>-->
                                    <#--<option value="7">价格信息审核已通过</option>-->
                                    <#--<#else>-->
                                    <#--<option value="1">有效</option>-->
                                    <#--<option value="4">基本信息审核已通过</option>-->
                                    <#--<option selected="selected" value="7">价格信息审核已通过</option>-->
                                    <#--</#if>-->
                                        <option value="">请选择</option>
                                        <option value="1" ${(status?? && status == 1)?string('selected="selected"', "")}>
                                            有效
                                        </option>
                                        <option value="4" ${(status?? && status == 4)?string('selected="selected"', "")}>
                                            基本信息审核已通过
                                        </option>
                                        <option value="7" ${(status?? && status == 7)?string('selected="selected"', "")}>
                                            价格信息审核已通过
                                        </option>

                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="submit" class="btn btn-info btn-block "><i class="fa  fa-search"></i>查找
                                </button>
                            </div>


                            <div class="table-responsive" style="margin-top: 2%">
                                <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
                                       data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                    <thead>
                                    <tr>
                                        <th width="15%">
                                            <div class="th-inner">商品名称</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">商品图片</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">大类</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">小类</div>
                                        </th>
                                        <#--<th width="15%">-->
                                            <#--<div class="th-inner">单价</div>-->
                                        <#--</th>-->
                                        <th width="5%">
                                            <div class="th-inner">是否平台商品</div>
                                        </th>
                                        <th width="5%">
                                            <div class="th-inner">供应商</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">备注</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">状态</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">操作</div>
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <#list goods as g>
                                    <tr>
                                        <td style="text-align: center;">${g.cname!''}</td>
                                    <td style="text-align: center;">
                                        <#if g.goodsFiles ?? >
                                            <#if g.goodsFiles?size ==0>
                                                <img class="img-rounded" src="/assets/img/goods/img-goods-default.png"
                                                     alt="" height="60" width="60"/></td>
                                            <#else>
                                                <#list g.goodsFiles as gf>
                                                    <#if gf_index==0>
                                                        <img class="img-rounded" src="${gf.url}"
                                                             alt="" height="60" width="60"/></td>

                                                    </#if>
                                                </#list>
                                            </#if>
                                        <#else>
                                            <img class="img-rounded" src="/assets/img/goods/img-goods-default.png"
                                                 alt="" height="60" width="60"/></td>
                                        </#if>
                                        </td>
                                        <td style="text-align: center;">${g.goodsCategoryOne.cname!''}</td>
                                        <td style="text-align: center;">${g.goodsCategoryTwo.cname!''}</td>
                                        <#--<td style="text-align: left;"> <#if g.goodsSpecifications ?? >-->
                                        <#--<#list g.goodsSpecifications as gf>-->
                                            <#--<#if gf_index==0>-->
                                            <#--${gf.price}-->
                                            <#--</#if>-->
                                        <#--</#list>-->
                                    <#--</#if></td>-->
                                        <td style="text-align: center;"><#if g.freeGoods == 0>

                                            否

                                        <#else>
                                            是
                                        </#if></td>
                                        <td style="text-align: center;"><#if g.supplierList ?? >
                                        <#list g.supplierList as gs>
                                            <#if gs_index==0>
                                               ${gs.cname!''}

                                            </#if>
                                        </#list>
                                    </#if></td>
                                        <td style="text-align: center;">${g.note!''}</td>
                                        <td style="text-align: center;"><#if g.status == 1>
                                            有效
                                        <#elseif g.status==4>
                                            基本信息审核已通过
                                        <#elseif g.status==7>
                                            价格信息审核已通过
                                        </#if></td>
                                        <td style="text-align: center;">
                                            <button type="button" class="btn btn-info btn-xs btn-detail"
                                                    data-sid="${g.sid?c}">
                                                <i class="fa fa-edit fa-fw"></i> 选择供应商
                                            </button>

                                        </td>
                                    </tr>
                                    </#list>
                                    </tbody>
                                </table>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

<#-- 显示供应商详情 -->
<#include "/goods/goodsSupplier/detail.ftl" />
</div>
</body>
</html>