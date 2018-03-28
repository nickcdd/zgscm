<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/goods/baseInfo/index">
<#--<script src="/assets/js/goods/baseInfo/index.js"></script>-->
    <script src="/assets/js/perfectLoad.js"></script>
    <script type="text/javascript">
        $(function () {
            initSearchGoodsCategory();
            var $form = $('#detailForm');
            $(document).on('click', '.btn-detail', function () {

                var $t = $(this), sid = $t.data('sid');
                $.getJSON('/goods/detail?sid=' + sid, function (result) {
                    if (result.success) {
                        $('.wrapper').animate({scrollTop: 0}, 'fast');
                        $form.clearForm(true);
                        $form.formJSON('set', result.record);
                        setPageInfo();
                        var goodsCategoryOneStr = "<option value=" + result.record.goodsCategoryOne.sid + " selected>" + result.record.goodsCategoryOne.cname + "</option>";
                        var goodsCategoryTwoStr = "<option value=" + result.record.goodsCategoryTwo.sid + " selected>" + result.record.goodsCategoryTwo.cname + "</option>";
                        var freeGoodsStr = "";
                        if (result.record.freeGoods == 0) {
                            freeGoodsStr = "<option value='0' selected> 否</option><option value='1' > 是</option>";
                        } else {
                            freeGoodsStr = "<option value='0' > 否</option><option value='1' selected > 是</option>";
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
                        $('#freeGoods').html(freeGoodsStr);
                        $("#bigCatecory").html(goodsCategoryOneStr);
                        $("#smallCatecory").html(goodsCategoryTwoStr);
                        $('#goodsBaseInfoList').hide();
                        $('#goodsBaseInfoDetail').show();
                        $('#updateTitle').show();
                        $('#reviewBtn').show();
                        $('#addTitle').hide();
                        $('#oldImg').show();
                        if (result.record.goodsFiles.length > 0) {
                            $("#oldImgUrl").attr("src", result.record.goodsFiles[0].url);
                        }
                        intiGoodsCategory();

                    } else {
                        showInfoFun(result.msg);
                    }
                });
            });

            $('.upload-button').click(function () {
//                $form.clearForm(true);
                $('#excelModal').modal('show');
            });
            $('.btn-add').click(function () {
                $form.clearForm(true);
                var freeGoodsStr = "<option value='0' > 否</option><option value='1' selected> 是</option>";
                $('#freeGoods').html(freeGoodsStr);
                $("#bigCatecory").find("option").remove();
                $("#smallCatecory").find("option").remove();
                $('#goodsBaseInfoList').hide();
                $('#goodsBaseInfoDetail').show();
                $('#updateTitle').hide();
                $('#addTitle').show();
                $('#oldImg').hide();
                $('#reviewBtn').hide();
                setPageInfo();
                intiGoodsCategory();
            });

            $('.btn-cancel').click(function () {
//                $form.clearForm(true);
                $form.validate().resetForm();
                $('#goodsBaseInfoList').show();
                $('#goodsBaseInfoDetail').hide();
                $('#updateTitle').show();
                $('#addTitle').hide();
            });
            $('#reviewBtn').click(function () {
                if ($('#detailForm').valid()) {
                    $('#reviewStatus').val("2");
                    $('#commitButton').attr("disabled", "disabled");
                    $('#reviewBtn').attr("disabled", "disabled");
                    $('#detailForm').submit();

//                $.ajax({
//                    type: "POST",
//                    url: "/goods/commitReview",
//                    data: {"sid": $('#sid').val(), "status": 2},
//                    dataType: "JSON",
//                    async: false,
//                    success: function (result) {
//                        if (result.success) {
////                            var str = "status=" + $('#status').val() + "&page=" + ($('#infoTable').attr("data-page-number") - 1) + "&size=" + $('#infoTable').attr("data-page-size");
////                            if ($('#searchBigCatecory').val() != undefined && $('#searchBigCatecory').val() != "") {
////
////                                str += "&searchBigCatecory=" + $('#searchBigCatecory').val();
////                            }
////                            if ($('#searchSmallCatecory').val() != undefined && $('#searchSmallCatecory').val() != "") {
////
////                                str += "&searchSmallCatecory=" + $('#searchSmallCatecory').val();
////                            }
////                            if ($('#q').val() != undefined && $('#q').val() != "") {
////
////                                str += "&q=" + $('#q').val()
////                            }
////                            // location.href = "index?q=" + $('#q').val() + "&searchBigCatecory=" + $('#searchBigCatecory').val() + "&searchSmallCatecory=" + $('#searchSmallCatecory').val() + "&status=" + $('#status').val()+"&page="+($('#infoTable').attr("data-page-number") - 1)+"&size="+$('#infoTable').attr("data-page-size");
////                            location.href = "index?" + str;
//                            $('#detailForm').submit();
//                            showInfoFun(result.msg);
//
//                        } else {
//                            showInfoFun(result.msg);
//                        }
//
//                    },
//                    error: function () {
//
//                    }
//                });
                } else {
                    showInfoFun("请完善信息再提交审核", "danger");
                }
            });
            $form.submit(function () {

                if ($form.valid()) {
                    var data = $form.formJSON('get');

                    $('#commitButton').attr("disabled", "disabled");
                    $('#reviewBtn').attr("disabled", "disabled");
                }
//                $('#commitButton').attr("disabled","disabled");
                return true;
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
                url: "/goods/getGoodsCategorys",
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
        function batchSummit(obj) {
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
                    url: "/goods/batchCommitReview",
                    data: {"goodsSids": array, "status": 2},
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
        function singleSummit(obj) {
//            alert($(obj).val());
            $(obj).attr("disabled", "disabled");
            $.ajax({
                type: "POST",
                url: "/goods/commitReview",
                data: {"sid": $(obj).val(), "status": 2},
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
        function confirmUploadExcel() {
            if ($('#excelFile').val() == null || $('#excelFile').val() == "" || $('#excelFile').val() == undefined) {
                showInfoFun("请选择文件再上传");
            } else {
                confirmInfoFun("uploadExcel()", "确认上传?", '信息提示', true);
            }
//          $("#excelForm").ajaxSubmit({
//              type: "POST",
//              url:"/goods/uploadFile",
//              dataType: "json",
//              success: function(data){
//                  if(data.success){
//                      showInfoFun(data.msg);
//                  }
//                  else{
//                      showInfoFun(data.msg);
//                  }
//              }
//          });
        }
        function uploadExcel() {
            $.bootstrapLoading.start({loadingTips: "正在处理数据，请稍候..."});
            $('#excelModal').modal('hide');
            $("#excelForm").ajaxSubmit({
                type: "POST",
                url: "/goods/uploadFile",
                dataType: "json",
                success: function (data) {
                    if (data.flag) {
//                        showInfoFun(data.msg);
//                        confirmInfoFun("",data.msg,"导入结果",false);
                        if (data.downloadUrl != "" && data.downloadUrl != undefined && data.downloadUrl != null) {
                            var allData = data.msg + "<br/>" + "<a id='downloadExcel' href=" + data.downloadUrl + " style='display:none;'></a>";
                            confirmInfoFun("refresh()", allData + "    失败结果请查看浏览器下载文件", "导入结果", false);
                            document.getElementById("downloadExcel").click();
//                            alert("不为空");
                        } else {
                            confirmInfoFun("refresh()", data.msg, "导入结果", false);
//                            alert("为空");
                        }

                    }
                    else {
                        confirmInfoFun("", data.msg, "导入结果", false);
                    }
                    cancleModal();
                },
                complete: function () {
                    $.bootstrapLoading.end();
                }
            });
        }
        function cancleModal() {
            $('#excelFile').val("");
            $('#excelModal').modal('hide');

        }
        function refresh() {
            $('#infoForm').submit();
        }
    </script>

</head>
<body>
<div class="row">
    <div class="col-md-12" id="goodsBaseInfoList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">商品列表</h3>
            </div>


            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form id="infoForm" action="/goods/baseInfo/index" method="post" class="form-inline"
                              role="search-form">
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
                                    <#--<#if status == 0>-->
                                    <#--<option selected="selected" value="0">已下架</option>-->
                                    <#--<option value="3">基本信息审核未通过</option>-->

                                    <#--<#elseif status == 3>-->
                                    <#--<option value="0">已下架</option>-->
                                    <#--<option selected="selected" value="3">基本信息审核未通过</option>-->
                                    <#--<#else>-->
                                    <#--<option selected="selected" value="">请选择</option>-->
                                    <#--<option selected="selected" value="0">已下架</option>-->
                                    <#--<option value="3">基本信息审核未通过</option>-->
                                    <#--</#if>-->
                                        <option value="">请选择</option>
                                        <option value="0" ${(status?? && status == 0)?string('selected="selected"', "")}>
                                            已下架
                                        </option>
                                        <option value="3" ${(status?? && status == 3)?string('selected="selected"', "")}>
                                            基本信息审核未通过
                                        </option>


                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="submit" class="btn btn-info btn-block "><i class="fa  fa-search"></i>查找
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-add"><i class="fa  fa-plus"></i>新增
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block" onclick="batchSummit(this)"><i
                                        class="fa fa-hand-paper-o"></i>批量提交审核
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block upload-button"><i
                                        class="fa  fa-file-excel-o"></i>批量导入商品
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
                                        <th width="5%">
                                            <div class="th-inner">是否平台商品</div>
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
                                        <td style="text-align: center;"><input style="margin: 3.5% 3% 0 3%"
                                                                               type="checkbox" value="${g.sid?c}"
                                                                               name="goodsSids"/></td>
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
                                        <td style="text-align: center;">${g.note!''}</td>
                                        <td style="text-align: center;"><#if g.status == 0>
                                            已下架
                                        <#elseif g.status==3>
                                            基本信息审核未通过
                                        </#if></td>
                                        <td style="text-align: center;">
                                            <button type="button" class="btn btn-info btn-xs btn-detail"
                                                    data-sid="${g.sid?c}">
                                                <i class="fa fa-edit fa-fw"></i> 详情
                                            </button>
                                            <button type="button" class="btn btn-success btn-xs" value="${g.sid?c}"
                                                    onclick="singleSummit(this)">
                                                <i class="fa fa-hand-paper-o"></i> 提交审核
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
<#include "/goods/baseInfo/detail.ftl" />
</div>
<div class="modal fade" id="excelModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">上传excel</h4>
            </div>
            <div class="modal-body">
                <form id="excelForm" class="form-horizontal" method="post" action="uploadFile"
                      enctype="multipart/form-data">


                    <div class="form-group">
                        <label for="inputPassword" class="col-sm-2 control-label">文件选择：</label>
                        <div class="col-sm-8">
                            <input type="file" class="form-control" id="excelFile" name="excelFile" accept=".XLS,.xlsx">
                        </div>
                    </div>


                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-confirm" onclick="confirmUploadExcel()">确认</button>

                <button type="button" class="btn btn-default" onclick="cancleModal()">取消</button>

            </div>
        </div>
    </div>
</div>
</body>
</html>