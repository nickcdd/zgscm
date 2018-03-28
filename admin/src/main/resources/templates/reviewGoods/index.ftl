<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/reviewGoods/index">

     <script type="text/javascript">

         $(function () {
             initSearchGoodsCategory();
             var $form = $('#detailForm');
             $(document).on('click', '.btn-detail', function () {
                 var $t = $(this), sid = $t.data('sid');
                 $.getJSON('/reviewGoods/detail?sid=' + sid, function (result) {
                     if (result.success) {
                         $('.wrapper').animate({scrollTop:0}, 'fast');
                         $form.clearForm(true);

                         $form.formJSON('set', result.record);
                         setPageInfo();
//

//                         if (result.record.supplierList.length > 0) {
////                            var arr=new Array();
//                             //初始化供应商
//                             var strResult = "";
//                             for (var i = 0; i < result.record.supplierList.length; i++) {
////                                arr[i]=result.record.supplierList[i].sid;
//                                 strResult += result.record.supplierList[i].cname + ";";
//                             }
////                           alert(strResult);
//                             $('#supplierName').val(strResult.substring(0, strResult.length - 1))
//                         }
                         $('#supplierName').val(result.record.supplier.cname);
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
                         var reasonStr=" <div class='modal-body'><div class='form-group has-feedback'>"
                                 +"<label for='' class='col-sm-3 control-label'>&nbsp;&nbsp;<span style='color: red;'>审核意见</span></label>"
                                 +"<div class='col-sm-6'>"
                                 +"<input type='text' class='form-control' id='reason' name='reason' placeholder='不通过时审核意见不能为空'"
                                 +"maxlength='50' autocomplete='false' />"
                                 +"</div> </div></div>";
                         $('#goodsSpecification').append(reasonStr);
                         var goodsCategoryOneStr = "<option value=" + result.record.goodsCategoryOne.sid + " selected>" + result.record.goodsCategoryOne.cname + "</option>";
                         var goodsCategoryTwoStr = "<option value=" + result.record.goodsCategoryTwo.sid + " selected>" + result.record.goodsCategoryTwo.cname + "</option>";
                         var freeGoodsStr="";
                         if(result.record.freeGoods ==0) {
                             freeGoodsStr = "<option value='0' selected>否</option>";
                         }else{
                             freeGoodsStr = "<option value='1' selected>是</option>";
                         }
                         if (result.record.goodsFiles.length > 0) {
                             $("#oldImgUrl").attr("src", result.record.goodsFiles[0].url);
                         }
                         //商品操作日志
                         var logsStr="";
                         if(result.record.goodsLogs.length > 0){
                             for(var i=0;i<result.record.goodsLogs.length;i++) {

//                                logsStr += "<a href='javascript:void (0)' class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>"+  new Date(parseInt(result.record.goodsLogs[i].createTime))      + "         "+      result.record.goodsLogs[i].note+"</span></div></div></a>";
                                 logsStr += "<div  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>"+  (new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleDateString()+""+(new Date(parseInt(result.record.goodsLogs[i].createTime))).toLocaleTimeString()      + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+      result.record.goodsLogs[i].note+"</span></div></div></div>";
                             }
                         }else{
                             logsStr = "<div  class='list-group-item' style='background:#f9f9f9 '><div class='row'><div class='col-md-12'><span class='text-info'>暂无操作记录</span></div></div></div>";
                         }
                         $('#logsList').html(logsStr);
                         $('#freeGoods').html(freeGoodsStr);
                         $("#bigCatecory").html(goodsCategoryOneStr);
                         $("#smallCatecory").html(goodsCategoryTwoStr);

                         $('#reviewPriceList').hide();
                         $('#reviewPriceDetail').show();


                     } else {
                         showInfoFun(result.msg);
                     }
                 });
             });


             $('.btn-cancel').click(function () {
                 $form.clearForm(true);
                 $('#reviewPriceList').show();
                 $('#reviewPriceDetail').hide();
//                for(var i=0;i<priceId;i++){
//                    $('#cname'+i).remove();
//                    $('#price'+i).remove();
//                    $('#cost'+i).remove();
//                }
                 $('.removeFlag').remove();


             });


             $form.submit(function () {

                 if ($form.valid()) {
                     var data = $form.formJSON('get');


                 }

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
         function reviewSuccess() {
             $('#reviewStatus').val(3);
             $('#detailForm').submit();
         }
         //信息不通过
         function reviewFail() {
             $('#reviewStatus').val(4);
             if($('#reason').val()=="" || $('#reason').val()==undefined || $('#reason').val()==null){
                 showInfoFun("请填写审核意见","danger");
             }else {
                 $('#detailForm').submit();
             }
             // $('#detailForm').submit();
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
                 url: "/reviewGoods/getGoodsCategorys",
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

         //响应批量提交按钮
         function batchBtns(status){
             $('#modelReason').val("");
             var array = [];
             $("[name=goodsSids]:checkbox").each(function () {
                 if (this.checked) {
//                    alert($(this).val());
                     array.push($(this).val());
                 }
             });
//            alert(array.length);
             if(array.length==0){
                 showInfoFun("请选择至少一条数据","danger");
             }else{
                 if(status==4){
                     $('#confirmModal').modal('show');
                     $('.btn-confirm').click(function () {

                         if($('#modelReason').val()=="" || $('#modelReason').val()==undefined || $('#modelReason').val()==null){
                             showInfoFun("审核意见不能为空","danger");
                         }else{
                             $('.btn-confirm').attr("disabled","disabled");
                             $('#confirmModal').modal('hide');
                             batchSummit(array,status,$('#modelReason').val());
                         }
                     });
                 }else if(status==3){
                     batchSummit(array,status,"");
                 }

             }
         }

         function batchSummit(array,status,reason){
             $('.btn-sign').attr("disabled","disabled");
             $.ajax({
                 type: "POST",
                 url: "/reviewGoods/batchCommitReview",
                 data: {"goodsSids": array, "status": status,"reason":reason},
                 dataType: "JSON",
                 traditional: true,
                 async: false,
                 success: function (result) {
                     if (result.success) {
                         showInfoFun(result.msg);
                         $('#infoForm').submit();



                     } else {
                         $('.btn-sign').removeAttr("disabled");
                         showInfoFun(result.msg);
                     }

                 },
                 error: function () {
                     $('.btn-sign').removeAttr("disabled");
                 }
             });

         }
         function singleBtn(obj,status){
             if(status==4){
                 $('#confirmModal').modal('show');
                 $('.btn-confirm').click(function () {

                     if($('#modelReason').val()=="" || $('#modelReason').val()==undefined || $('#modelReason').val()==null){
                         showInfoFun("审核意见不能为空","danger");
                     }else{
                         $('.btn-confirm').attr("disabled","disabled");
                         $('#confirmModal').modal('hide');
                         singleSummit(obj,status,$('#modelReason').val());
                     }
                 });
             }else if(status==3){
                 singleSummit(obj,status,"");
             }
         }
         function singleSummit(obj,status,reason){
//            alert($(obj).val());
             $(obj).attr("disabled","disabled");
             $.ajax({
                 type: "POST",
                 url: "/reviewGoods/commitReview",
                 data: {"sid": $(obj).val(), "status": status,"reason":reason},
                 dataType: "JSON",
                 async: false,
                 success: function (result) {
                     if (result.success) {
                         showInfoFun(result.msg);
                         $('#infoForm').submit();
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
    <div class="col-md-12" id="reviewPriceList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">商品待审核列表</h3>
            </div>


            <div class="box-body">
                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form id="infoForm" action="index" method="post" class="form-inline" role="search-form">
                            <input type="hidden" name="page" value="${pageInfo.page-1}" />
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
                                <button type="submit" class="btn btn-info btn-block "><i class="fa  fa-search"></i>查找
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-success btn-block btn-sign" onclick="batchBtns(3)"> <i class="fa fa-check"></i>批量通过
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-danger btn-block btn-sign" onclick="batchBtns(4)"><i class="fa fa-close"></i>批量不通过
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
                                        <th width="10%">
                                            <div class="th-inner">价格信息</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">是否平台商品</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">供应商</div>
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
                                        <td style="text-align: center;">
                                            <#if g.goodsSpecifications ?? >
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
                                            </#if>
                                        </td>
                                        <td style="text-align: center;"><#if g.freeGoods == 0>

                                            否

                                        <#else>
                                            是
                                        </#if></td>
                                        <td style="text-align: left;">${g.supplier.cname!''}</td>
                                        <td style="text-align: left;">${g.note!''}</td>
                                        <td style="text-align: center;">
                                            <button type="button" class="btn btn-info btn-xs btn-detail"
                                                    data-sid="${g.sid?c}">
                                                <i class="fa fa-edit fa-fw"></i> 审核
                                            </button>
                                            <button type="button" class="btn btn-success btn-xs" value="${g.sid?c}" onclick="singleBtn(this,3)">
                                                <i class="fa fa-check"></i> 通过
                                            </button>
                                            <button type="button" class="btn btn-danger btn-xs" value="${g.sid?c}" onclick="singleBtn(this,4)">
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
<#include "/reviewGoods/detail.ftl" />
</div>
</body>
</html>