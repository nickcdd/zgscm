<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/selfSupportGoods/publishGoods/index">
<#--<script src="/assets/js/goods/publishGoods/index.js"></script>-->
    <script type="text/javascript">

        $(function () {
            initSearchGoodsCategory();
            if ($('#status').val().length != 0) {
                if ($('#status').val() == 1) {
                    $('.btn-publishDown').show();
                    $('.btn-publishUp').hide();
                } else if ($('#status').val() == 3) {
                    $('.btn-publishDown').hide();
                    $('.btn-publishUp').show();
                } else {
                    $('.btn-publishDown').hide();
                    $('.btn-publishUp').hide();
                }
            } else {
                $('.btn-publishDown').hide();
                $('.btn-publishUp').hide();
            }
            var $form = $('#detailForm');
            $(document).on('click', '.btn-detail', function () {
                var $t = $(this), sid = $t.data('sid');
                $.getJSON('/selfSupportGoods/detail?sid=' + sid, function (result) {
                    if (result.success) {
                        $('.wrapper').animate({scrollTop: 0}, 'fast');
                        $form.clearForm(true);

                        $form.formJSON('set', result.record);
                        setPageInfo();

                        if (result.record.status == 3) {
                            $('#publishUp').show();
                            $('#publishDown').hide();
                        } else if (result.record.status == 1) {
                            $('#publishUp').hide();
                            $('#publishDown').show();
                        } else {
                            $('#publishUp').hide();
                            $('#publishDown').hide();
                        }


                        if (result.record.goodsSpecifications.length > 0) {
                            for (var i = 0; i < result.record.goodsSpecifications.length; i++) {

                                var statusStr = "";
                                if (result.record.goodsSpecifications[i].status == 1) {

                                    statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control' readonly ><option selected='selected' value='1'>有效</option></select></div> ";
                                } else if (result.record.goodsSpecifications[i].status == 0) {

                                    statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control' readonly ><option selected='selected' value='0'>无效</option></select></div> ";
                                }
                                // var str = "<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;规格名称</label><div class='col-sm-2'><input type='text' data-sid='" + result.record.goodsSpecifications[i].sid + "' class='form-control'  value='" + result.record.goodsSpecifications[i].cname + "' placeholder='规格名称' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;进价</label><div class='col-sm-2'><input type='text' class='form-control'  placeholder='进价'value='" + result.record.goodsSpecifications[i].cost + "' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;售价</label><div class='col-sm-2'><input type='text' class='form-control'  value='" + result.record.goodsSpecifications[i].price + "' placeholder='售价' readonly/></div>" + statusStr + "</div>";
                                var str = "<div  class='list-group-item removeFlag' style='background:#f9f9f9 '><div class='form-group '><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品编码</label><div class='col-sm-3'><input type='text' data-sid='" + result.record.goodsSpecifications[i].goodsBm + "' class='form-control'  value='" + result.record.goodsSpecifications[i].goodsBm + "' placeholder='商品编码' readonly/></div><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;规格名称</label><div class='col-sm-3'><input type='text' data-sid='" + result.record.goodsSpecifications[i].sid + "' class='form-control'  value='" + result.record.goodsSpecifications[i].cname + "' placeholder='规格名称' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;进价</label><div class='col-sm-3'><input type='number' class='form-control'  placeholder='进价' value='" + result.record.goodsSpecifications[i].cost + "' readonly/></div></div><div class='form-group '><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;售价</label><div class='col-sm-3'><input type='number' class='form-control' value='" + result.record.goodsSpecifications[i].price + "' placeholder='售价' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;建议售价</label><div class='col-sm-3'><input type='number' class='form-control' value='" + result.record.goodsSpecifications[i].suggestPrice + "' placeholder='建议售价' readonly/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;最低批发数量</label><div class='col-sm-3'><input type='number' class='form-control' value='" + result.record.goodsSpecifications[i].saleCount + "' placeholder='最地批发数量' readonly/></div></div><div class='form-group '>" + statusStr + "</div></div>";
                                $('#goodsSpecification').append(str);
                            }

                        }
                        var goodsCategoryOneStr = "<option value=" + result.record.goodsCategoryOne.sid + " selected>" + result.record.goodsCategoryOne.cname + "</option>";
                        var goodsCategoryTwoStr = "<option value=" + result.record.goodsCategoryTwo.sid + " selected>" + result.record.goodsCategoryTwo.cname + "</option>";


                        if (result.record.goodsFiles.length > 0) {
                            $("#oldImgUrl").attr("src", result.record.goodsFiles[0].url);
                        }
                        //商品操作日志
                        var logsStr = "";
                        if (result.record.goodsLogs.length > 0) {
                            for (var i = 0; i < result.record.goodsLogs.length; i++) {

//                                logsStr += "<a href='javascript:void (0)' class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>"+  new Date(parseInt(result.record.goodsLogs[i].createTime))      + "         "+      result.record.goodsLogs[i].note+"</span></div></div></a>";
                                logsStr += "<div  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>" + (new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleDateString() + "" + (new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleTimeString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + result.record.goodsLogs[i].note + "</span></div></div></div>";
                            }
                        } else {
                            logsStr = "<div  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>暂无操作记录</span></div></div></div>";
                        }
                        $('#logsList').html(logsStr);

                        $("#bigCatecory").html(goodsCategoryOneStr);
                        $("#smallCatecory").html(goodsCategoryTwoStr);

                        $('#publishGoodsList').hide();
                        $('#publishGoodsDetail').show();


                    } else {
                        showInfoFun(result.msg);
                    }
                });
            });


            $('.btn-cancel').click(function () {

                $form.clearForm(true);
                $('#publishGoodsList').show();
                $('#publishGoodsDetail').hide();

                $('.removeFlag').remove();


            });
            //查找按钮
            $('.btn_search').click(function () {
                $('#page').val("");
                $('#infoForm').submit();


            });
            $("#selectAll").click(function () {

                $("[name=goodsSids]:checkbox").prop("checked", this.checked);

            });
            $("[name=goodsSids]:checkbox").click(function () {
                var flag = true;
                $("[name=goodsSids]:checkbox").each(function () {
                    if (!this.checked) {
                        flag = false;
                    }
                });
                $("#selectAll").prop("checked", flag);
            });
            $form.submit(function () {

                if ($form.valid()) {
                    var data = $form.formJSON('get');


                }

                return true;
            });

            $form.clearForm(true);

        });
        function setPageInfo() {

            $('#redirectPage').val($('#infoTable').attr("data-page-number") - 1);
            $('#redirectSize').val($('#infoTable').attr("data-page-size"));
            $('#redirectStatus').val($('#status').val());

            if ($('#searchBigCatecory').val() != undefined && $('#searchBigCatecory').val() != "") {

                $('#redirectBigCategory').val($('#searchBigCatecory').val());
            }
            if ($('#searchSmallCatecory').val() != undefined && $('#searchSmallCatecory').val() != "") {

                $('#redirectSmallCategory').val($('#searchSmallCatecory').val());
            }
            if ($('#q').val() != undefined && $('#q').val() != "") {

                $('#redirectQ').val($('#q').val());
            }

        }
        //信息通过
        function publishSuccess() {
            $('#reviewStatus').val(1);
            $('#detailForm').submit();
        }
        //信息不通过
        function publishFail() {
            $('#reviewStatus').val(0);
            $('#detailForm').submit();
        }
        //查询商品类别联动
        function initSearchGoodsCategory() {

            var bigCatecoryId = $("#searchBigCatecory option:selected").val();
            var smallCatecoryId = $("#searchSmallCatecory option:selected").val();
            /**
             * 加载大类
             */
            var bigCatecoryStr = getSearchGoodsCatecory(1, bigCatecoryId);

            $("#searchBigCatecory").html("<option selected='selected'></option>" + bigCatecoryStr)
            /**
             * 加载小类
             */
            if (bigCatecoryId != undefined && bigCatecoryId != '') {
                var smallCatecoryStr = getSearchGoodsCatecory($("#searchBigCatecory option:selected").val(), $("#searchSmallCatecory option:selected").val());
                // $("#searchSmallCatecory").html(smallCatecoryStr);
                if (smallCatecoryId != undefined && smallCatecoryId != '') {
                    $("#searchSmallCatecory").html("<option ></option>" + smallCatecoryStr);
                } else {
                    $("#searchSmallCatecory").html("<option selected='selected'></option>" + smallCatecoryStr);
                }

            }

        }
        function getSearchAllSmallCatecory(sid, areaName) {
            var smallCatecoryStr = getSearchGoodsCatecory(sid, areaName);
            $("#searchSmallCatecory").html("<option selected='selected'></option>" + smallCatecoryStr);

        }

        function getSearchGoodsCatecory(parentSid, areaName) {

            var str;
            $.ajax({
                type: "POST",
                url: "/selfSupportGoods/getGoodsCategorys",
                data: {"parentSid": parentSid, "status": 1},
                dataType: "JSON",
                async: false,
                success: function (data) {
                    //从服务器获取数据进行绑定
                    $.each(data.record, function (i, item) {

                        if (areaName == item.sid) {
                            str += "<option value=" + item.sid + " selected>" + item.cname + "</option>";
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
        function batchSummit(obj, status) {
            $(obj).attr("disabled", "disabled");
            var array = [];
            $("[name=goodsSids]:checkbox").each(function () {
                if (this.checked) {
//                    alert($(this).val());
                    array.push($(this).val());
                }
            });
//            alert(array.length);
            if (array.length == 0) {
                $(obj).removeAttr("disabled");
                showInfoFun("请选择至少一条数据", "danger");
            } else {
//                alert(array[0]);

                $.ajax({
                    type: "POST",
                    url: "/selfSupportGoods/batchCommitReview",
                    data: {"goodsSids": array, "status": status},
                    dataType: "JSON",
                    traditional: true,
                    async: false,
                    success: function (result) {
                        if (result.success) {
                            var str = "status=" + $('#status').val() + "&page=" + ($('#infoTable').attr("data-page-number") - 1) + "&size=" + $('#infoTable').attr("data-page-size");
                            if ($('#searchBigCatecory').val() != undefined && $('#searchBigCatecory').val() != "") {

                                str += "&searchBigCatecory=" + $('#searchBigCatecory').val();
                            }
                            if ($('#searchSmallCatecory').val() != undefined && $('#searchSmallCatecory').val() != "") {

                                str += "&searchSmallCatecory=" + $('#searchSmallCatecory').val();
                            }
                            if ($('#q').val() != undefined && $('#q').val() != "") {

                                str += "&q=" + $('#q').val()
                            }
                            // location.href = "index?q=" + $('#q').val() + "&searchBigCatecory=" + $('#searchBigCatecory').val() + "&searchSmallCatecory=" + $('#searchSmallCatecory').val() + "&status=" + $('#status').val()+"&page="+($('#infoTable').attr("data-page-number") - 1)+"&size="+$('#infoTable').attr("data-page-size");
                            location.href = "index?" + str;

                            showInfoFun(result.msg);

                        } else {
                            $(obj).removeAttr("disabled");
                            showInfoFun(result.msg);
                        }

                    },
                    error: function () {
                        $(obj).removeAttr("disabled");
                    }
                });
            }
        }
        function singleSummit(obj, status) {
//            alert($(obj).val());
            $(obj).attr("disabled", "disabled");
            $.ajax({
                type: "POST",
                url: "/selfSupportGoods/commitReview",
                data: {"sid": $(obj).val(), "status": status},
                dataType: "JSON",
                async: false,
                success: function (result) {
                    if (result.success) {
                        var str = "status=" + $('#status').val() + "&page=" + ($('#infoTable').attr("data-page-number") - 1) + "&size=" + $('#infoTable').attr("data-page-size");
                        if ($('#searchBigCatecory').val() != undefined && $('#searchBigCatecory').val() != "") {

                            str += "&searchBigCatecory=" + $('#searchBigCatecory').val();
                        }
                        if ($('#searchSmallCatecory').val() != undefined && $('#searchSmallCatecory').val() != "") {

                            str += "&searchSmallCatecory=" + $('#searchSmallCatecory').val();
                        }
                        if ($('#q').val() != undefined && $('#q').val() != "") {

                            str += "&q=" + $('#q').val()
                        }
                        // location.href = "index?q=" + $('#q').val() + "&searchBigCatecory=" + $('#searchBigCatecory').val() + "&searchSmallCatecory=" + $('#searchSmallCatecory').val() + "&status=" + $('#status').val()+"&page="+($('#infoTable').attr("data-page-number") - 1)+"&size="+$('#infoTable').attr("data-page-size");
                        location.href = "index?" + str;

                        showInfoFun(result.msg);

                    } else {
                        $(obj).removeAttr("disabled");
                        showInfoFun(result.msg);
                    }

                },
                error: function () {
                    $(obj).removeAttr("disabled");
                }
            });
        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="publishGoodsList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">商品列表上下架</h3>
            </div>

            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form id="infoForm" action="index" method="post" class="form-inline" role="search-form">
                            <input type="hidden" name="page" />
                            <input type="hidden" name="size" />
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
                                    <input type='text' name="q" class="form-control" id="q" value="${q}" />

                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">状态</label>
                                <div class="input-group date">
                                    <select class="form-control" name="status" id="status">
                                    <#--<#if status == 0>-->
                                    <#--<option selected="selected" value="0">已下架</option>-->
                                    <#--<option value="1">有效</option>-->
                                    <#--<option value="7">价格信息审核已通过</option>-->
                                    <#--<#elseif status == 1>-->
                                    <#--<option value="0">已下架</option>-->
                                    <#--<option selected="selected" value="1">有效</option>-->
                                    <#--<option value="7">价格信息审核已通过</option>-->
                                    <#--<#else>-->
                                    <#--<option value="0">已下架</option>-->
                                    <#--<option value="1">有效</option>-->
                                    <#--<option selected="selected" value="7">价格信息审核已通过</option>-->
                                    <#--</#if>-->
                                        <option value="">请选择</option>
                                    <#--<option value="0" ${(status?? && status == 0)?string('selected="selected"', "")}>-->
                                    <#--已下架-->
                                    <#--</option>-->
                                        <option value="1" ${(status?? && status == 1)?string('selected="selected"', "")}>
                                            已上架
                                        </option>
                                        <option value="3" ${(status?? && status == 3)?string('selected="selected"', "")}>
                                            商品信息审核已通过
                                        </option>

                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="submit" class="btn btn-info btn-block "><i class="fa  fa-search"></i>查找
                                </button>
                            </div>
                        <@shiro.hasPermission name="selfSupport:publishManager">
                            <div class="form-group ">
                                <button type="button" class="btn btn-danger btn-block btn-publishDown" onclick="batchSummit(this,0)">
                                    <i
                                            class="fa fa-hand-paper-o"></i>批量下架
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-success btn-block btn-publishUp" onclick="batchSummit(this,1)">
                                    <i
                                            class="fa fa-hand-paper-o"></i>批量上架
                                </button>
                            </div>
                        </@shiro.hasPermission>
                            <div class="table-responsive" style="margin-top: 2%">
                                <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
                                       data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                    <thead>
                                        <tr>
                                            <th width="1%">
                                                <div class="th-inner"><input type="checkbox" style="" id="selectAll" />
                                                </div>
                                            </th>
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
                                            <th width="10%">
                                                <div class="th-inner">价格信息</div>
                                            </th>
                                            <th width="15%">
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
                                            <td style="text-align: center;"> <#if g.status==1 || g.status==3 >
                                                <input style="margin: 3.5% 3% 0 3%"
                                                       type="checkbox" value="${g.sid?c}"
                                                       name="goodsSids" /></#if></td>
                                            <td style="text-align: center;">${g.cname!''}</td>
                                        <td style="text-align: center;">
                                            <#if g.goodsFiles ?? >
                                                <#if g.goodsFiles?size ==0>
                                                    <img class="img-rounded" src="/assets/img/goods/img-goods-default.png"
                                                         alt="" height="60" width="60" /></td>
                                                <#else>
                                                    <#list g.goodsFiles as gf>
                                                        <#if gf_index==0>
                                                            <img class="img-rounded" src="${gf.url}"
                                                                 alt="" height="60" width="60" /></td>

                                                        </#if>
                                                    </#list>
                                                </#if>
                                            <#else>
                                                <img class="img-rounded" src="/assets/img/goods/img-goods-default.png"
                                                     alt="" height="60" width="60" /></td>
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
                                            <td style="text-align: center;"><#if g.goodsSpecifications ?? >
                                                <#list g.goodsSpecifications as gg>
                                                <#--<div class="row">-->
                                                <#--<div class="col-sm-12">规格名称：${gg.cname!''}  进价：￥${gg.cost!''}  售价：￥${gg.price!''}</div>-->
                                                <#--</div>-->
                                                    <#if gg.status==1>
                                                        <a href="javascript:void (0)" class="list-group-item"
                                                           style="background:#f9f9f9 ">
                                                            <div class="row">

                                                                <div class="col-md-4"><span
                                                                        class="text-info">规格名称：${gg.cname!''}</span></div>
                                                                <div class="col-md-4"><span
                                                                        class="text-info">售价：￥${gg.price!''}</span></div>
                                                                <div class="col-md-4"><span
                                                                        class="text-info">起批数量：${gg.saleCount!''}</span></div>


                                                            </div>
                                                        </a>
                                                    </#if>
                                                </#list>
                                            </#if></td>
                                            <td style="text-align: left;">${g.note!''}</td>
                                            <td style="text-align: center;"><#if g.status == 0>
                                                已下架
                                            <#elseif g.status==1>
                                                已上架
                                            <#elseif g.status==3>
                                                价格信息审核已通过
                                            </#if></td>
                                            <td style="text-align: center;">
                                                <button type="button" class="btn btn-info btn-xs btn-detail"
                                                        data-sid="${g.sid?c}">
                                                    <i class="fa fa-edit fa-fw"></i> 详情
                                                </button>
                                                <@shiro.hasPermission name="selfSupport:publishManager">
                                                    <#if g.status==3 >
                                                        <button type="button" class="btn btn-success btn-xs" value="${g.sid?c}"
                                                                onclick="singleSummit(this,1)">
                                                            <i class="fa fa-hand-paper-o"></i> 上架
                                                        </button>
                                                    <#elseif  g.status==1>
                                                        <button type="button" class="btn btn-danger btn-xs" value="${g.sid?c}"
                                                                onclick="singleSummit(this,0)">
                                                            <i class="fa fa-hand-paper-o"></i> 下架
                                                        </button>
                                                    </#if>
                                                </@shiro.hasPermission>
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


<#include "/selfSupportGoods/publishGoods/detail.ftl" />
</div>
</body>
</html>