<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/goods/index">
<#--<script src="/assets/js/goods/baseInfo/index.js"></script>-->
    <script src="/assets/js/perfectLoad.js"></script>
    <script type="text/javascript">
        var priceId = 1;
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
                        if (result.record.goodsSpecifications.length > 0) {
                            for (var i = 0; i < result.record.goodsSpecifications.length; i++) {
                                var statusStr = "";
                                if (result.record.goodsSpecifications[i].status == 1) {

                                    statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control'  id='priceStatus" + priceId + "'><option selected='selected' value='1'>有效</option><option value='0'>无效</option></select></div> ";
                                } else if (result.record.goodsSpecifications[i].status == 0) {

                                    statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control'  id='priceStatus" + priceId + "'><option  value='1'>有效</option><option selected='selected' value='0'>无效</option></select></div> ";
                                }
                                var str = "<div  class='list-group-item removeFlag' style='background:#f9f9f9 '><div class='form-group '><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品编码</label><div class='col-sm-3'><input type='text' data-sid='" + result.record.goodsSpecifications[i].goodsBm + "' class='form-control' id='goodsBm" + priceId + "' value='" + result.record.goodsSpecifications[i].goodsBm + "' placeholder='商品编码' /></div><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;规格名称</label><div class='col-sm-3'><input type='text' data-sid='" + result.record.goodsSpecifications[i].sid + "' class='form-control' id='cname" + priceId + "' value='" + result.record.goodsSpecifications[i].cname + "' placeholder='规格名称' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;进价</label><div class='col-sm-3'><input type='number' class='form-control' id='cost" + priceId + "' placeholder='进价' value='" + result.record.goodsSpecifications[i].cost + "' required='required'/></div></div><div class='form-group '><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;售价</label><div class='col-sm-3'><input type='number' class='form-control' id='price" + priceId + "'value='" + result.record.goodsSpecifications[i].price + "' placeholder='售价' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;建议售价</label><div class='col-sm-3'><input type='number' class='form-control'id='suggestPrice" + priceId + "' value='" + result.record.goodsSpecifications[i].suggestPrice + "' placeholder='建议售价' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;最低批发数量</label><div class='col-sm-3'><input type='number' class='form-control'id='saleCount" + priceId + "' value='" + result.record.goodsSpecifications[i].saleCount + "' placeholder='最地批发数量' required='required'/></div></div><div class='form-group '>" + statusStr + "</div></div>";

                                $('#goodsSpecification').append(str);
                                priceId += 1;
                            }
//                            $('#reviewBtn').show();
                            if (result.record.status != 0 && result.record.status != 5) {

                                $('#reviewBtn').hide();
                            } else {
                                $('#reviewBtn').show();
                            }
                        } else {
                            $('#reviewBtn').hide();
                            // var statusStr = "  <label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control'  id='priceStatus" + priceId + "'><option selected='selected' value='1'>有效</option><option value='0'>无效</option></select></div> ";
                            // var str = "<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;名称</label><div class='col-sm-2'><input type='text' data-sid='' class='form-control' id='cname" + priceId + "'  placeholder='价格名称' required='required'/></div><label for=''class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品进价</label><div class='col-sm-2'><input type='number' class='form-control' id='cost"+ priceId + "' placeholder='商品进价' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品售价</label><div class='col-sm-2'><input type='number' class='form-control' id='price" + priceId + "'  placeholder='商品售价' required='required'/></div>" + statusStr +"</div>";
                            // $('#goodsSpecification').append(str);
                            // priceId += 1;
                        }
                        var goodsCategoryOneStr = "<option value=" + result.record.goodsCategoryOne.sid + " selected>" + result.record.goodsCategoryOne.cname + "</option>";
                        var goodsCategoryTwoStr = "<option value=" + result.record.goodsCategoryTwo.sid + " selected>" + result.record.goodsCategoryTwo.cname + "</option>";
                        var freeGoodsStr = "";
//                        if (result.record.freeGoods == 0) {
//                            freeGoodsStr = "<option value='0' selected> 否</option><option value='1' > 是</option>";
//                        } else {
//                            freeGoodsStr = "<option value='0' > 否</option><option value='1' selected > 是</option>";
//                        }
//                        商品操作日志
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
//                        $('#freeGoods').html(freeGoodsStr);
                        $("#bigCatecory").html(goodsCategoryOneStr);
                        $("#smallCatecory").html(goodsCategoryTwoStr);
                        $('#goodsBaseInfoList').hide();
                        $('#goodsBaseInfoDetail').show();
                        $('#updateTitle').show();
//                        $('#reviewBtn').show();
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
//                var freeGoodsStr = "<option value='0' > 否</option><option value='1' selected> 是</option>";
//                $('#freeGoods').html(freeGoodsStr);
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
                $('#logsList').html("");


                $('.removeFlag').remove();
                priceId = 1;
            });
            $('#reviewBtn').click(function () {
                if ($('#detailForm').valid()) {
                    $('#reviewStatus').val("2");
                    $('#commitButton').attr("disabled", "disabled");
                    $('#reviewBtn').attr("disabled", "disabled");
                    $('#detailForm').submit();


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
        function addNewGoodsSpecification() {

            var flag = true;
            if (priceId == 1) {
                flag = true;
            } else {
                for (var i = 1; i < priceId; i++) {
                    if ($('#cname' + i).length > 0) {
                        if ($('#cname' + i).val().trim() == "" || $('#cost' + i).val().trim() == "" || $('#price' + i).val().trim() == "" || $('#suggestPrice' + i).val().trim() == "" || $('#saleCount' + i).val().trim() == "") {

                            flag = false
                            break;
                        }
                    }
                }
            }
            if (flag) {
                var str = "<div class='list-group-item removeFlag' style='background:#f9f9f9 '><div class='form-group '><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;商品编码</label><div class='col-sm-3'><input type='text' data-sid='' class='form-control' id='goodsBm" + priceId + "' placeholder='商品编码' /></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;规格名称</label><div class='col-sm-3'><input type='text' data-sid='' class='form-control' id='cname" + priceId + "' placeholder='规格名称' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;进价 </label><div class='col-sm-3'><input type='number' class='form-control' id='cost" + priceId + "' placeholder='进价' required='required'/></div></div><div class='form-group '><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;售价</label><div class='col-sm-3'><input type='number' class='form-control' id='price" + priceId + "'placeholder='售价' required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color:red;'>&nbsp;*</span>&nbsp;&nbsp;建议售价</label><div class='col-sm-3'><input type='number' class='form-control' id='suggestPrice" + priceId + "' placeholder='建议售价'required='required'/></div><label for='' class='col-sm-1 control-label'><span style='color:red;'>&nbsp;*</span>&nbsp;&nbsp;最低批发数量</label><div class='col-sm-3'><input type='number' class='form-control' id='saleCount" + priceId + "' placeholder='最低批发数量'required='required'/></div></div><div class='form-group '><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label><div class='col-sm-2'><select class='form-control'  id='priceStatus" + priceId + "'><option selected='selected' value='1'>有效</option><option value='0'>无效</option></select></div><div class='col-sm-1'><button type='button' class='btn btn-danger btn-xs 'onclick='removeDiv(this)' id='' >移除</button></div></div></div>";
                $('#goodsSpecification').append(str);
                priceId += 1;
            } else {
                showInfoFun("请完善价格信息再添加", "danger");
            }
        }

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
        function commitFrom() {
            var goodsSpecificationStr = "";

            if (priceId == 1) {
                if ($('#cname1').length > 0) {
                    // if ($.trim($('#cname' + priceId).val()) != "" && $.trim($('#cost' + priceId).val()) != "" && $.trim($('#price' + priceId).val()) != "" && $.trim($('#suggestPrice' + priceId).val()) != "" && $.trim($('#goodsBm' + priceId).val()) != "") {
                    if ($.trim($('#cname' + priceId).val()) != "" && $.trim($('#cost' + priceId).val()) != "" && $.trim($('#price' + priceId).val()) != "" && $.trim($('#suggestPrice' + priceId).val()) != "" && $.trim($('#saleCount' + priceId).val()) != "") {
                        goodsSpecificationStr = $('#cname' + priceId).attr('data-sid') + "," + $('#cname' + priceId).val() + "," + $('#cost' + priceId).val() + "," + $('#price' +
                                        priceId).val() + "," + $('#suggestPrice' + priceId).val() + "," + $('#priceStatus' + priceId).val() + "," + $('#goodsBm' + priceId).val() + "," + $('#saleCount' + priceId).val() + ";";
                        $('#goodsSpecificationStr').val(goodsSpecificationStr.substring(0, goodsSpecificationStr.length - 1));
                        $('#commitButton').attr("disabled", "disabled");
                        $('#reviewBtn').attr("disabled", "disabled");
                        $('#detailForm').submit();
                    } else {
                        showInfoFun("请完善价格信息", "danger");
                    }
                } else {
//                    showInfoFun("当前商品没有添加价格信息，无需保存");
                    if ($('#detailForm').valid()) {
                        $('#commitButton').attr("disabled", "disabled");
                        $('#reviewBtn').attr("disabled", "disabled");
                        $('#detailForm').submit();
                    }
                }

            } else {
                var flag = true;

                for (var i = 1; i < priceId; i++) {
                    if ($('#cname' + i).length > 0) {

                        // if ($.trim($('#cname' + i).val()) != "" && $.trim($('#cost' + i).val()) != "" && $.trim($('#price' + i).val()) != "" && $.trim($('#suggestPrice' + i).val()) != "" && $.trim($('#goodsBm' + i).val()) != "" ) {
                        if ($.trim($('#cname' + i).val()) != "" && $.trim($('#cost' + i).val()) != "" && $.trim($('#price' + i).val()) != "" && $.trim($('#suggestPrice' + i).val()) != "" && $.trim($('#saleCount' + i).val()) != "") {
                            // alert($('#goodsBm' + i).val());
                            goodsSpecificationStr += $('#cname' + i).attr('data-sid') + "," + $('#cname' + i).val() + "," + $('#cost' + i).val() + "," + $('#price' + i).val() + "," + $('#suggestPrice' + i).val() + "," + $('#priceStatus' + i).val() + "," + $('#goodsBm' + i).val() + "," + $('#saleCount' + i).val() + ";";

                        } else {
                            flag = false;

                            showInfoFun("请完善价格信息再保存", "danger");
                            break;
                        }
                    }
                }
//                if(flag) {
//                    if (goodsSpecificationStr == "") {
//                        showInfoFun("当前商品没有添加价格信息，无需保存");
//                        flag = false;
//                    }
//                }
                if (flag) {
                    $('#goodsSpecificationStr').val(goodsSpecificationStr.substring(0, goodsSpecificationStr.length - 1));
                    if ($('#detailForm').valid()) {
                        $('#commitButton').attr("disabled", "disabled");
                        $('#reviewBtn').attr("disabled", "disabled");
                        $('#detailForm').submit();
                    }
                    // $('#commitButton').attr("disabled","disabled");
                    // $('#detailForm').submit();
                }


            }
        }
        function cancleModal() {
            $('#excelFile').val("");
            $('#excelModal').modal('hide');

        }
        function refresh() {
            $('#infoForm').submit();
        }
        function removeDiv(obj) {

            $(obj).parent().parent().parent().remove();
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
                        <form id="infoForm" action="/goods/index" method="post" class="form-inline"
                              role="search-form">
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
                                    <input type='text' name="q" class="form-control" id="q" value="${q}" />

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
                                                <div class="th-inner"><input type="checkbox" style="" id="selectAll" />
                                                </div>
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
                                            <td style="text-align: center;">
                                                <#if g.status==0 || g.status==5>
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
<#include "/goods/detail.ftl" />
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