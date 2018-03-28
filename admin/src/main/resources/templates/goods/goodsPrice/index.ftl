<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/goods/goodsPrice/index">
    <script src="/assets/js/goods/goodsPrice/index.js"></script>

</head>
<body>
<div class="row">
    <div class="col-md-12" id="goodsPriceList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">商品列表价格管理</h3>
            </div>


            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form action="index" method="post" class="form-inline" role="search-form">
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

                                        <option value="">请选择</option>
                                        <option value="0" ${(status?? && status == 0)?string('selected="selected"', "")}>
                                            已下架
                                        </option>
                                        <option value="4" ${(status?? && status == 4)?string('selected="selected"', "")}>
                                            基本信息审核已通过
                                        </option>
                                        <option value="6" ${(status?? && status == 6)?string('selected="selected"', "")}>
                                            价格信息审核未通过
                                        </option>

                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="submit" class="btn btn-info btn-block "><i class="fa  fa-search"></i>查找
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block" onclick="batchSummit(this)"><i class="fa fa-hand-paper-o"></i>批量提交审核
                                </button>
                            </div>


                            <div class="table-responsive" style="margin-top: 2%">
                                <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
                                       data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                    <thead>
                                    <tr>
                                        <th width="1%">
                                            <div class="th-inner"><input type="checkbox" style="" id="selectAll"/></div>
                                        </th>
                                        <th width="14%">
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
                                        <th width="10%">
                                            <div class="th-inner">价格信息</div>
                                        </th>
                                        <th width="5%">
                                            <div class="th-inner">是否平台商品</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">备注</div>
                                        </th>
                                        <th width="5%">
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
                                        <td style="text-align: center;"> <input style="margin: 3.5% 3% 0 3%" type="checkbox" value="${g.sid?c}" name="goodsSids"/></td>
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
                                        <td style="text-align: center;">
                                            <#if g.goodsSpecifications ?? >
                                                <#list g.goodsSpecifications as gg>
                                                <#--<div class="row">-->
                                                    <#--<div class="col-sm-12">规格名称：${gg.cname!''}  进价：￥${gg.cost!''}  售价：￥${gg.price!''}</div>-->
                                                <#--</div>-->
                                                <#if gg.status==1>
                                                    <a href="javascript:void (0)" class="list-group-item" style="background:#f9f9f9 ">
                                                        <div class="row">

                                                            <div class="col-md-6"><span
                                                                    class="text-info">规格名称：${gg.cname!''}</span></div>
                                                            <div class="col-md-3"><span
                                                                    class="text-info">进价：￥${gg.cost!''}</span></div>
                                                            <div class="col-md-3"><span
                                                                    class="text-info">售价：￥${gg.price!''}</span></div>


                                                        </div>
                                                    </a>
                                                </#if>
                                                </#list>
                                            </#if>
                                        </td>
                                        <td style="text-align: center;"><#if g.freeGoods == 0>

                                            否

                                        <#else>
                                            是
                                        </#if></td>
                                        <td style="text-align: left;">${g.note!''}</td>
                                        <td style="text-align: center;"><#if g.status == 0>
                                            已下架
                                        <#elseif g.status==4>
                                            基本信息审核已通过
                                        <#elseif g.status==6>
                                            价格信息审核未通过
                                        </#if></td>
                                        <td style="text-align: center;">
                                            <button type="button" class="btn btn-info btn-xs btn-detail"
                                                    data-sid="${g.sid?c}">
                                                <i class="fa fa-edit fa-fw"></i> 详情
                                            </button>
                                            <button type="button" class="btn btn-success btn-xs" value="${g.sid?c}" onclick="singleSummit(this)">
                                                <i class="fa fa-hand-paper-o"></i>提交审核
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
<#include "/goods/goodsPrice/detail.ftl" />
</div>
</body>
</html>