<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />

    <meta name="nav-url" content="/supplier/index">
    <script type="text/javascript">
        var updateId=1;
        var addId=1;
        $(function () {

            intiSearchArea(true);
            var $form = $('#detailForm');
            $(document).on('click', '.btn-detail', function () {
                var $t = $(this), sid = $t.data('sid');
                $.getJSON('detail?sid=' + sid, function (result) {
//                    proviceBind();
                    if (result.success) {
                        $('#supplierList').hide();
                        $('#supplierDetail').show();
                        $('#updateTitle').show();
                        $('#addTitle').hide();
                        $('#newImg').show();
                        $('#oldImg').show();
                        $('#newPassword').hide();
                        $form.clearForm(true);
                        $form.formJSON('set', result.record);
                        setPageInfo();
                        var province = result.record.province;
                        var city = result.record.city;
                        var area = result.record.area;
                        var provinceStr = "<option value=" + province.split(",")[0] + " selected>" + province.split(",")[1] + "</option>";
                        var cityStr = "<option value=" + city.split(",")[0] + " selected>" + city.split(",")[1] + "</option>";
                        var areaStr = "<option value=" + area.split(",")[0] + " selected>" + area.split(",")[1] + "</option>";
                        var updateLicenceStr=""
                        if(result.record.licencesList!=null){
                            if(result.record.licencesList.length>0){
//                                alert(result.record.licencesList.length);
                                for(var i=0;i<result.record.licencesList.length;i++){
                                    var statusStr="";
                                    if(result.record.licencesList[i].status==0){
                                        statusStr ="<select class='form-control'  id='updateStatus"+updateId+"'> <option selected='selected' value='0'>无效</option> <option value='1'>有效</option> </select>";
                                    }else{
                                        statusStr ="<select class='form-control'  id='updateStatus"+updateId+"'> <option  value='0'>无效</option> <option selected='selected' value='1'>有效</option> </select>";
                                    }
                                    updateLicenceStr +="<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;图片名称</label>"
                                    +"<div class='col-sm-2'><input type='text' class='form-control' id='updateCname"+updateId+"' value='"+result.record.licencesList[i].cname+"' data-sid='"+result.record.licencesList[i].sid+"' placeholder='图片名称'required='required'/> </div>"
                                            +"<label for='' class='col-sm-1 control-label'>当前图片</label>"
                                            +"<div class='col-sm-2'> <img class='img-rounded' id='oldImgUrl' onclick='showImg(this)' src='"+result.record.licencesList[i].url+"' alt='暂时没有封面' height='120' width='120'/>"
                                            +"</div>"
                                            +"<label for='' class='col-sm-1 control-label'><input name='updateLicences' accept='image/png,image/jpeg' type='file'  /></label>"
                                            +"<div class='col-sm-1'>"

                                            +"</div>"
                                            +"<label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label>"
                                    +"<div class='col-sm-2'>"
                                          +statusStr +"</div> </div>";
                                    updateId +=1;
                                }
                                $('#supplierLicence').append(updateLicenceStr);
                            }
                        }
                        $("#province").html(provinceStr);
                        $("#city").html(cityStr);
                        $("#area").html(areaStr);
                        $("#newImg").attr("src", result.record.avatar);
                        intiArea(false);
                    } else {
                        showInfoFun(result.msg);
                    }
                });
            });

            $(document).on('click', '.btn-remove', function () {
                var $t = $(this), sid = $t.data('sid');
                $('#confirmModal').modal('show');
//                confirmFun('remove?sid=' + sid, '该操作将无法撤消，是否继续？');
                $('.btn-confirm').click(function () {

                    $.getJSON('remove?sid=' + sid, function (result) {
//
                        if (result.success) {
                            $('#infoForm').submit();
                        } else {
                            showInfoFun(result.msg);
                        }
                    });
                });
            });


            $('.btn_search').click(function () {
                $('#page').val("");
                $('#infoForm').submit();

            });
            $('.btn-reset').click(function () {
                $form.clearForm(true);
            });
            $('.btn-cancel').click(function () {
                $form.validate().resetForm();
//                $form.clearForm(true);
                $('#supplierList').show();
                $('#supplierDetail').hide();
                $('.removeFlag').remove();
                updateId=1;
                addId=1;
            });
            $('.btn_disable').click(function () {
                var $t = $(this), sid = $t.data('sid');
                $.ajax({
                    type: "POST",
                    url: "/supplier/disable",
                    data: {"sid": sid},
                    dataType: "JSON",
                    async: false,
                    success: function (result) {
                        if (result.success) {

                            $('#infoForm').submit();
                        } else {
                            showInfoFun(result.msg);
                        }

                    },
                    error: function () {

                    }
                });
//                alert("禁用"+sid);
//                $.getJSON('disable?sid=' + sid, function (result) {
////
//                    if (result.success) {
////                    $('#infoForm').submit();
//                    } else {
//                        showInfoFun(result.msg);
//                    }
//                });
            });
            $('.btn_enable').click(function () {
                var $t = $(this), sid = $t.data('sid');
                $.ajax({
                    type: "POST",
                    url: "/supplier/enable",
                    data: {"sid": sid},
                    dataType: "JSON",
                    async: false,
                    success: function (result) {
                        if (result.success) {
                            $('#infoForm').submit();

                        } else {
                            showInfoFun(result.msg);
                        }

                    },
                    error: function () {

                    }
                });
                //                alert("启用"+sid);
//                $.getJSON('enable?sid=' + sid, function (result) {
////
//                    if (result.success) {
////                        $('#infoForm').submit();
//                    } else {
//                        showInfoFun(result.msg);
//                    }
//                });
            });
            $('.btn-add').click(function () {
                $form.clearForm(true);
                $("#province").find("option").remove();
                $("#city").find("option").remove();
                $("#area").find("option").remove();
                $('#supplierList').hide();
                $('#supplierDetail').show();
                $('#addTitle').show();
                $('#updateTitle').hide();
                $('#newImg').show();
                $('#oldImg').hide();
                $('#newPassword').show();
                setPageInfo();
                intiArea(true);

            });


//            $form.submit(function () {
//
//                if ($form.valid()) {
//                    var data = $form.formJSON('get');
//
//
//                }
//
//                return true;
//            });

            $form.clearForm(true);


        });
        function setPageInfo() {

            $('#redirectPage').val($('#infoTable').attr("data-page-number") - 1);
            $('#redirectSize').val($('#infoTable').attr("data-page-size"));

            if ($('#searchProvince').val() != undefined && $('#searchProvince').val() != "") {

                $('#redirectProvince').val($('#searchProvince').val());
            }
            if ($('#searchCity').val() != undefined && $('#searchCity').val() != "") {

                $('#redirectCity').val($('#searchCity').val());
            }
            if ($('#searchArea').val() != undefined && $('#searchArea').val() != "") {

                $('#redirectArea').val($('#searchArea').val());
            }
            if ($('#q').val() != undefined && $('#q').val() != "") {

                $('#redirectQ').val($('#q').val());
            }

        }
        function commitFrom() {
            var updateflag=true;
            var addflag=true
            var updateLicenceStr="";
            var addLicenceStr="";
            if(updateId==1){
                if($('#updateCname' + 1).length>0) {
                if($('#updateCname' + updateId).val().trim() != ""){
                    updateLicenceStr=$('#updateCname' + updateId).attr('data-sid') + "," + $('#updateCname' + updateId).val() + ","+$('#updateStatus'+updateId).val()+";";
//                    $('#updateLicenceStr').val(updateLicenceStr.substring(0, updateLicenceStr.length - 1));
//                    $('#detailForm').submit();
                }else{
                    updateflag=false;
//                    showInfoFun("请完善证照信息", "danger");
                }
                }else{
                    updateflag=true;
                }
            }else{

                for (var i = 1; i < updateId; i++) {
                    if($('#updateCname' + i).val().trim() != ""){
                        updateLicenceStr+=$('#updateCname' + i).attr('data-sid') + "," + $('#updateCname' + i).val() + ","+$('#updateStatus'+i).val()+";";
                    }else{
                        updateflag = false;
//                        showInfoFun("请完善证照信息", "danger");
                        break;
                    }
                }
//                if(flag){
//                    $('#updateLicenceStr').val(updateLicenceStr.substring(0, updateLicenceStr.length - 1));
//                    $('#detailForm').submit();
//                }
            }
            if(addId==1){
                if($('#addCname' + 1).length>0) {
                    if ($('#addCname' + 1).val().trim() != ""  && $('#addLicence' + 1).val().trim() != ""  ) {
                        addLicenceStr = $('#addCname' + 1).val() + "," + $('#addStatus' + 1).val() + ";";
                    } else {
                        addflag=false;
                    }
                }else{
                    addflag=true;
                }
            }else{
                for(var i=1;i<addId;i++){
                    if($('#addCname' + i).length>0) {
                        if ($('#addCname' + i).val().trim() != "" && $('#addLicence' + i).val().trim() != "") {
                            addLicenceStr += $('#addCname' + i).val() + "," + $('#addStatus' + i).val() + ";";
                        } else {
                            addflag = false;
                            break;
                        }
                    }
                }

            }
            //提交表单
            if(updateflag && addflag){
                $('#updateLicenceStr').val(updateLicenceStr.substring(0, updateLicenceStr.length - 1));
                $('#addLicenceStr').val(addLicenceStr.substring(0, addLicenceStr.length - 1));

                if( $('#detailForm').valid()){
                    $('#commitButton').attr("disabled","disabled");
                    $('#detailForm').submit();
                }

//                alert(addLicenceStr);
            }else{
                showInfoFun("请完善证照信息", "danger");
            }

        }
        function addNewLicence(){
            var addStr="";
            if(addId==1){
                addStr="<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;证照名称</label>"
                +"<div class='col-sm-2'><input type='text' class='form-control' id='addCname"+addId+"' placeholder='证照名称' required='required'/> </div>"
                        +"<label for='' class='col-sm-1 control-label'><input name='addLicences' id='addLicence"+addId+"' accept='image/png,image/jpeg' type='file'  /></label>"
                        +"<div class='col-sm-1'> </div>"
                        +"<label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label>"
                +"<div class='col-sm-2'>"
                        +"<select class='form-control'  id='addStatus"+addId +"'>"
                        +"<option  value='0'>无效</option> <option value='1' selected='selected' >有效</option> </select> </div> <div class='col-sm-1'><button type='button' class='btn btn-danger btn-xs 'onclick='removeDiv(this)' id='' >移除</button></div></div>";

                $('#supplierLicence').append(addStr);
                addId++;
            }else{
              var  flag =true;
                for(var i=1;i<addId;i++){
                    if($('#addCname' + i).length>0) {
                        if ($('#addCname' + i).val().trim() == "" || $('#addLicence' + i).val().trim() == "") {
                            showInfoFun("请完善上一个证照信息，再增加", "danger");
                            flag = false;
                            break;
                        }
                    }
                }
                if(flag){
                    addStr="<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;证照名称</label>"
                            +"<div class='col-sm-2'><input type='text' class='form-control' id='addCname"+addId+"' placeholder='证照名称' required='required'/> </div>"
                            +"<label for='' class='col-sm-1 control-label'><input name='addLicences' id='addLicence"+addId+"' accept='image/png,image/jpeg' type='file'  /></label>"
                            +"<div class='col-sm-1'> </div>"
                            +"<label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label>"
                            +"<div class='col-sm-2'>"
                            +"<select class='form-control'  id='addStatus"+addId +"'>"
                            +"<option  value='0'>无效</option> <option selected='selected' value='1'>有效</option> </select> </div> <div class='col-sm-1'><button type='button' class='btn btn-danger btn-xs 'onclick='removeDiv(this)' id='' >移除</button></div></div>";

                    $('#supplierLicence').append(addStr);
                    addId++;
                }
            }
        }
        function removeDiv(obj){

            $(obj).parent().parent().remove();
        }

        function showImg(obj){
//            alert($(obj).attr("src"));
            $("#modelImg").attr("src",$(obj).attr("src"));

            $('#myModal').modal('show');
        }
    </script>
</head>
<body>
<div class="row">
    <div class="col-md-12" id="supplierList">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">供应商列表</h3>
            </div>


            <div class="box-body">

                <div class="row placeholders">
                    <div class="col-md-12 placeholders">
                        <form action="/supplier/index" method="post" class="form-inline" id="infoForm"
                              role="search-form">
                            <input type="hidden" name="page" id="page" value="${pageInfo.page-1}"/>
                            <input type="hidden" name="size"/>
                            <div class="form-group ">
                                <label class="" for="name">省</label>
                                <div class="input-group date">
                                    <select class="form-control" name="searchProvince" id="searchProvince"
                                            onchange="getSearchAllCity($('#searchProvince option:selected').val(),$('#searchCity option:selected').val())">

                                    <#if searchProvince!="">
                                        <option value="${searchProvince?split(",")[0]}"
                                                selected="selected">${searchProvince?split(",")[1]}</option>
                                    </#if>


                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">市</label>
                                <div class="input-group date">
                                    <select class="form-control" name="searchCity" id="searchCity"
                                            onchange="getSearchAllArea($('#searchCity option:selected').val(),$('#searchArea option:selected').val())">
                                    <#if searchCity!="">
                                        <option value="${searchCity?split(",")[0]}"
                                                selected="selected">${searchCity?split(",")[1]}</option>
                                    </#if>

                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name">区</label>
                                <div class="input-group date">
                                    <select class="form-control" name="searchArea" id="searchArea">
                                    <#if searchArea!="">
                                        <option value="${searchArea?split(",")[0]}"
                                                selected="selected">${searchArea?split(",")[1]}</option>
                                    </#if>

                                    </select>
                                </div>
                            </div>
                            <div class="form-group ">
                                <label class="" for="name"> 供应商名称 </label>
                                <div class='input-group'>
                                    <input type='text' name="q" class="form-control" id="q" value="${q}"/>

                                </div>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn_search"><i
                                        class="fa  fa-search"></i>查找
                                </button>
                            </div>
                            <div class="form-group ">
                                <button type="button" class="btn btn-info btn-block btn-add"><i class="fa  fa-plus"></i>新增
                                </button>
                            </div>
                            <div class="table-responsive" style="margin-top: 2%">
                                <table id="infoTable" data-toggle="table" data-page-info='${pageInfo}'
                                       data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                                    <thead>
                                    <tr>
                                        <th width="5%">
                                            <div class="th-inner">头像</div>
                                        </th>
                                        <th width="20%">
                                            <div class="th-inner">供应商名称</div>
                                        </th>
                                        <th width="10%">
                                            <div class="th-inner">省、市、区</div>
                                        </th>
                                        <th width="25%">
                                            <div class="th-inner">地址</div>
                                        </th>
                                        <th width="20%">
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
                                    <#list suppliers as s>
                                    <tr>
                                        <td style="text-align: center;"><img class="img-circle" src="${s.avatar!''}"
                                                                             alt="头像" height="40" width="40"/></td>
                                        <td style="text-align: center;">${s.cname!''}</td>
                                        <td style="text-align: center;">${s.province!''}  ${s.city!''}  ${s.area!''}</td>
                                        <td style="text-align: center;">${s.address!''}</td>
                                        <td style="text-align: center;">${s.note!''}</td>
                                        <td style="text-align: center;"><#if s.status == 0>

                                            已禁用
                                        <#elseif s.status == 1>
                                            已启用
                                        <#else>
                                            已删除
                                        </#if></td>
                                        <td style="text-align: center;">
                                            <#if s.status != -1>
                                            <button type="button" class="btn btn-info btn-xs btn-detail"
                                                    data-sid="${s.sid?c}">
                                                <i class="fa fa-edit fa-fw"></i> 详情
                                            </button>
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
                                            <@shiro.hasPermission name="supplier:save">
                                                <#if s.status == 0>
                                                    <button class="btn btn-success btn-xs btn_enable"
                                                            data-sid="${s.sid?c}">
                                                        <i class="fa fa-check fa-fw"></i> 启用
                                                    </button>
                                                <#else>
                                                    <button class="btn btn-warning btn-xs btn_disable"
                                                            data-sid="${s.sid?c}">
                                                        <i class="fa fa-ban fa-fw"></i> 禁用
                                                    </button>
                                                </#if>
                                            </@shiro.hasPermission>
                                            <@shiro.hasPermission name="supplier:remove">
                                                <button type="button" class="btn btn-danger btn-xs btn-remove"
                                                        data-sid="${s.sid?c}">
                                                    <i class="fa fa-edit fa-fw"></i> 删除
                                                </button>
                                            </@shiro.hasPermission>
                                            </#if>
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
    <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel"></h4>
                </div>
                <div class="modal-body">
                    是否确认删除？
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">否</button>
                    <button type="button" class="btn btn-primary btn-confirm">是</button>
                </div>
            </div>
        </div>
    </div>
<#-- 显示供应商详情 -->
<#include "/supplier/detail.ftl" />
</div>
</body>
</html>