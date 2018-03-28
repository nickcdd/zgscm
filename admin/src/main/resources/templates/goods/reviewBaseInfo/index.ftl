<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/goods/reviewBaseInfo/index">
    <script src="/assets/js/goods/reviewBaseInfo/index.js"></script>

</head>
<body>
<div class="row">
    <div class="col-md-12" id="goodsBaseInfoList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">商品列表审核基本信息</h3>
            </div>


            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form  id="infoForm" action="/goods/reviewBaseInfo/index" method="post" class="form-inline" role="search-form">
                            <input type="hidden" name="page" value="${pageInfo.page-1}"/>
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
                                    <select class="form-control" name="searchSmallCatecory" id="searchSmallCatecory">
                                <#if searchSmallCatecory!="">
                                    <option value="${searchSmallCatecory?split(",")[0]}"
                                            selected="selected">${searchSmallCatecory?split(",")[1]}</option>
                                </#if>

                                    </select>
                                </div>
                            </div>
                        <#--<div class="form-group ">-->
                        <#--<label class="" for="name"> 大类名称 </label>-->
                        <#--<div class='input-group' >-->
                        <#--<input type='text' name="bigCategory" class="form-control" id="bigCategory"  value="${bigCategory}"/>-->

                        <#--</div>-->
                        <#--</div>-->
                        <#--<div class="form-group ">-->
                        <#--<label class="" for="name"> 小类名称 </label>-->
                        <#--<div class='input-group' >-->
                        <#--<input type='text' name="smallCategory" class="form-control" id="smallCategory"  value="${smallCategory}"/>-->

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
                                <button type="submit" class="btn btn-info btn-block "><i class="fa  fa-search"></i>查找
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-success btn-block btn-sign" onclick="batchBtns(4)"> <i class="fa fa-check"></i>批量通过
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-danger btn-block btn-sign" onclick="batchBtns(3)"><i class="fa fa-close"></i>批量不通过
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
                                        <th width="15%">
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
                                            <div class="th-inner">是否平台商品</div>
                                        </th>
                                        <th width="15%">
                                            <div class="th-inner">备注</div>
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
                                        <td style="text-align: center;"><#if g.freeGoods == 0>

                                            否

                                        <#else>
                                            是
                                        </#if></td>
                                        <td style="text-align: left;">${g.note!''}</td>
                                        <td style="text-align: center;">
                                            <button type="button" class="btn btn-info btn-xs btn-detail"
                                                    data-sid="${g.sid?c}">
                                                <i class="fa fa-edit fa-fw"></i> 审核
                                            </button>
                                            <button type="button" class="btn btn-success btn-xs" value="${g.sid?c}" onclick="singleBtn(this,4)">
                                                <i class="fa fa-check"></i> 通过
                                            </button>
                                            <button type="button" class="btn btn-danger btn-xs" value="${g.sid?c}" onclick="singleBtn(this,3)">
                                                <i class="fa fa-close"></i> 不通过
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
    <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">请填写原因</h4>
                </div>
                <div class="modal-body">
                    <div class="row form-group">


                                <div class="form-group has-feedback">
                                    <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;审核意见</label>
                                    <div class="col-sm-6">
                                        <input type="text" class="form-control" id="modelReason"  placeholder="不通过时审核意见不能为空"
                                               maxlength="50" autocomplete="false" />

                                    </div>
                                </div>


                </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-confirm">确认</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>

                </div>
            </div>
        </div>
    </div>
<#-- 显示详情 -->
<#include "/goods/reviewBaseInfo/detail.ftl" />
</div>
</body>
</html>