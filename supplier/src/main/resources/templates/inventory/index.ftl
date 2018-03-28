<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/inventory/index">
    <link rel="stylesheet" href="/assets/plugins/select2/select2.css">
    <script src="/assets/plugins/select2/select2.full.js"></script>
    <script type="text/javascript">

        $(function () {
            initSelect();



            $('.btn_search').click(function () {
                $('#page').val("");
                $('#infoForm').submit();

            });

        });
        function initSelect() {
            $(".select2").select2();


            var storageStr = getAllStorages();
            $('#storageSid').html(storageStr);


        }
        function getAllStorages() {

            var str = "<option value=' '>全部</option>";
            $.ajax({
                type: "POST",
                url: "/inventory/getAllStorages",

                dataType: "JSON",
                async: false,
                success: function (data) {
                    //从服务器获取数据进行绑定

                    $.each(data.record, function (i, item) {

                        // str="<option value=''>请选择</option>";
                        if ($('#checkStorageSid').val() == item.sid) {
                            str += "<option selected='selected' value=" + item.sid + ">" + item.cname + "</option>";
                        } else {
                            str += "<option value=" + item.sid + ">" + item.cname + "</option>";
                        }

                    })

                    return str;
                },
                error: function () {

                }
            });
            return str;

        }
        function setPageInfo() {
            var str = "";
            str += "&redirectPage=" + ($('#infoTable').attr("data-page-number") - 1);
            str += "&redirectSize=" + $('#infoTable').attr("data-page-size");

            if ($('#goodsName').val() != undefined && $('#goodsName').val() != "") {
                str += "&redirectGoodsName=" + $('#goodsName').val();
//                $('#redirectStartDate').val($('#startDate').val());
            }
            if ($('#storageSid').val().trim() != undefined && $('#storageSid').val().trim() != "") {

//                $('#redirectEndDate').val($('#endDate').val());
                str += "&redirectStorageSid=" + $('#storageSid').val();
            }



            return str;
        }
    function toAdd(){
        var str=setPageInfo();
        location.href="/inventory/add?"+str;
    }
        function toEdit(sid){

            var str=setPageInfo();
            location.href="/inventory/edit?sid="+sid+str;
        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">库存列表</h3>
            </div>


            <div class="box-body">

                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form action="/inventory/index" method="post" class="form-inline" id="infoForm"
                              role="search-form">
                            <input type="hidden" name="page" id="page" value="${pageInfo.page-1}"/>
                            <input type="hidden" name="size"/>
                            <input type="hidden" id="checkStorageSid" value="${checkStorageSid}"/>



                            <div class="form-group ">
                                <label class="" for="name"> 商品名称 </label>
                                <div class='input-group'>
                                    <input type='text' name="goodsName" class="form-control" id="goodsName" value="${goodsName}"/>

                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 仓储 </label>
                                <div class='input-group'>
                                    <select class="form-control select2" style="width:100%;" id="storageSid"
                                            name="storageSid"
                                            data-placeholder="全部" style="width: 50%;" required="required">

                                    </select>

                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn_search"><i
                                        class="fa  fa-search"></i>查找
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button"  class="btn btn-info btn-block btn-add" onclick="toAdd()"><i class="fa  fa-plus"  ></i>新增
                                </button>
                            </div>
                            <div class="table-responsive" style="margin-top: 2%">
                                <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
                                       data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                    <thead>
                                    <tr>
                                        <th width="5%">
                                            <div class="th-inner">商品图片</div>
                                        </th>
                                        <th width="5%">
                                            <div class="th-inner">商品名称</div>
                                        </th>
                                        <th width="20%">
                                            <div class="th-inner">商品规格</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">仓储名称</div>
                                        </th>
                                        <th width="25%">
                                            <div class="th-inner">商品数量</div>
                                        </th>
                                        <th width="25%">
                                            <div class="th-inner">操作</div>
                                        </th>

                                    </tr>
                                    </thead>
                                    <tbody>
                                    <#list inventorys as inventory>
                                    <tr>
                                        <td style="text-align: center;"> <#if inventory.goods.goodsFiles ?? >
                                            <#if inventory.goods.goodsFiles?size ==0>
                                                <img class="img-rounded" src="/assets/img/goods/img-goods-default.png"
                                                     alt="" height="60" width="60"/>
                                            <#else>
                                                <#list inventory.goods.goodsFiles as gf>
                                                    <#if gf_index==0>
                                                        <img class="img-rounded" src="${gf.url}"
                                                             alt="" height="60" width="60"/>

                                                    </#if>
                                                </#list>
                                            </#if>
                                        <#else>
                                            <img class="img-rounded" src="/assets/img/goods/img-goods-default.png"
                                                 alt="" height="60" width="60"/>
                                        </#if>
                                        </td>
                                        <td style="text-align: center;">${inventory.goods.cname!''}</td>

                                        <td style="text-align: center;">${inventory.goodsSpecification.cname!''}</td>
                                        <td style="text-align: center;">${inventory.storage.cname!''}</td>
                                            <td style="text-align: center;">${inventory.amount!''}</td>
                                            <td>


                                        <#--<@shiro.hasPermission name="supplier:save">-->
                                        <#--<#if s.status == 0>-->
                                        <#--<a class="btn btn-success btn-xs" href="enable?sid=${s.sid?c}">-->
                                        <#--<i class="fa fa-check fa-fw"></i> 启用-->
                                        <#--</a>-->
                                        <#--<#else>-->
                                        <#--<a class="btn btn-warning btn-xs" href="disable?sid=${s.sid?c}">-->
                                        <#--<i class="fa fa-ban fa-fw"></i> 禁用-->
                                        <#--</a>-->
                                        <#--</#if>-->
                                        <#--</@shiro.hasPermission>-->

                                                <button  type="button" class="btn btn-info btn-xs btn-detail"
                                                        data-sid="${inventory.sid?c}" onclick="toEdit(${inventory.sid?c})">
                                                    <i class="fa fa-edit fa-fw"></i> 详情
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


</div>
</body>
</html>