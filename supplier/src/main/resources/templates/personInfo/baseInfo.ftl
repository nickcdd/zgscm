<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
<#include "/_head_with_datepicker.ftl" />
    <script src="/assets/js/personInfo/baseInfo.js"></script>
    <script type="text/javascript">
        var updateId = 1;
        var addId = 1;
        $(function () {
            showInfoFun("正在加载数据。。。")
            var $form = $('#detailForm');
            $.getJSON('detail', function (result) {
//                    proviceBind();
                if (result.success) {


                    $('#newImg').show();
                    $('#oldImg').show();

                    $form.clearForm(true);
                    $form.formJSON('set', result.record);
                    $('#supplierDetail').show();
                    var province = result.record.province;
                    var city = result.record.city;
                    var area = result.record.area;
                    var provinceStr = "<option value=" + province.split(",")[0] + " selected>" + province.split(",")[1] + "</option>";
                    var cityStr = "<option value=" + city.split(",")[0] + " selected>" + city.split(",")[1] + "</option>";
                    var areaStr = "<option value=" + area.split(",")[0] + " selected>" + area.split(",")[1] + "</option>";
                    var updateLicenceStr = ""
                    if (result.record.licencesList != null) {
                        if (result.record.licencesList.length > 0) {
//                                alert(result.record.licencesList.length);
                            for (var i = 0; i < result.record.licencesList.length; i++) {
                                var statusStr = "";
                                if (result.record.licencesList[i].status == 0) {
                                    statusStr = "<select class='form-control'  id='updateStatus" + updateId + "'> <option selected='selected' value='0'>无效</option> <option value='1'>有效</option> </select>";
                                } else {
                                    statusStr = "<select class='form-control'  id='updateStatus" + updateId + "'> <option  value='0'>无效</option> <option selected='selected' value='1'>有效</option> </select>";
                                }
                                updateLicenceStr += "<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;图片名称</label>"
                                        + "<div class='col-sm-2'><input type='text' class='form-control' id='updateCname" + updateId + "' value='" + result.record.licencesList[i].cname + "' data-sid='" + result.record.licencesList[i].sid + "' placeholder='图片名称'required='required'/> </div>"
                                        + "<label for='' class='col-sm-1 control-label'>当前图片</label>"
                                        + "<div class='col-sm-2'> <img class='img-rounded' id='oldImgUrl' onclick='showImg(this)' src='" + result.record.licencesList[i].url + "' alt='暂时没有封面' height='120' width='120'/>"
                                        + "</div>"
                                        + "<label for='' class='col-sm-1 control-label'><input name='updateLicences' accept='image/png,image/jpeg' type='file'  /></label>"
                                        + "<div class='col-sm-1'>"

                                        + "</div>"
                                        + "<label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label>"
                                        + "<div class='col-sm-2'>"
                                        + statusStr + "</div> </div>";
                                updateId += 1;
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
            $('.btn-cancel').click(function () {


                $('.removeFlag').remove();
                updateId = 1;
                addId = 1;
                location.href = "/index";
            });
//            $form.submit(function () {
//                if ($form.valid()) {
//
//
//                }
//
//                return true;
//            });


        });
        function commitFrom() {
            var updateflag = true;
            var addflag = true
            var updateLicenceStr = "";
            var addLicenceStr = "";
            if (updateId == 1) {
                if ($('#updateCname' + 1).length > 0) {
                    if ($('#updateCname' + updateId).val().trim() != "") {
                        updateLicenceStr = $('#updateCname' + updateId).attr('data-sid') + "," + $('#updateCname' + updateId).val() + "," + $('#updateStatus' + updateId).val() + ";";
//                    $('#updateLicenceStr').val(updateLicenceStr.substring(0, updateLicenceStr.length - 1));
//                    $('#detailForm').submit();
                    } else {
                        updateflag = false;
//                    showInfoFun("请完善证照信息", "danger");
                    }
                } else {
                    updateflag = true;
                }
            } else {

                for (var i = 1; i < updateId; i++) {
                    if ($('#updateCname' + i).val().trim() != "") {
                        updateLicenceStr += $('#updateCname' + i).attr('data-sid') + "," + $('#updateCname' + i).val() + "," + $('#updateStatus' + i).val() + ";";
                    } else {
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
            if (addId == 1) {
                if ($('#addCname' + 1).length > 0) {
                    if ($('#addCname' + 1).val().trim() != "" && $('#addLicence' + 1).val().trim() != "") {
                        addLicenceStr = $('#addCname' + 1).val() + "," + $('#addStatus' + 1).val() + ";";
                    } else {
                        addflag = false;
                    }
                } else {
                    addflag = true;
                }
            } else {
                for (var i = 1; i < addId; i++) {
                    if ($('#addCname' + i).length > 0) {
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
            if (updateflag && addflag) {
                $('#updateLicenceStr').val(updateLicenceStr.substring(0, updateLicenceStr.length - 1));
                $('#addLicenceStr').val(addLicenceStr.substring(0, addLicenceStr.length - 1));

                if ($('#detailForm').valid()) {
                    $('#commitButton').attr("disabled", "disabled");
                    $('#detailForm').submit();
                }

//                alert(addLicenceStr);
            } else {
                showInfoFun("请完善证照信息", "danger");
            }

        }
        function addNewLicence() {
            var addStr = "";
            if (addId == 1) {
                addStr = "<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;证照名称</label>"
                        + "<div class='col-sm-2'><input type='text' class='form-control' id='addCname" + addId + "' placeholder='证照名称' required='required'/> </div>"
                        + "<label for='' class='col-sm-1 control-label'><input name='addLicences' id='addLicence" + addId + "' accept='image/png,image/jpeg' type='file'  /></label>"
                        + "<div class='col-sm-1'> </div>"
                        + "<label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label>"
                        + "<div class='col-sm-2'>"
                        + "<select class='form-control'  id='addStatus" + addId + "'>"
                        + "<option  value='0'>无效</option> <option value='1' selected='selected' >有效</option> </select> </div> <div class='col-sm-1'><button type='button' class='btn btn-danger btn-xs 'onclick='removeDiv(this)' id='' >移除</button></div></div>";

                $('#supplierLicence').append(addStr);
                addId++;
            } else {
                var flag = true;
                for (var i = 1; i < addId; i++) {
                    if ($('#addCname' + i).length > 0) {
                        if ($('#addCname' + i).val().trim() == "" || $('#addLicence' + i).val().trim() == "") {
                            showInfoFun("请完善上一个证照信息，再增加", "danger");
                            flag = false;
                            break;
                        }
                    }
                }
                if (flag) {
                    addStr = "<div class='form-group removeFlag'><label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;证照名称</label>"
                            + "<div class='col-sm-2'><input type='text' class='form-control' id='addCname" + addId + "' placeholder='证照名称' required='required'/> </div>"
                            + "<label for='' class='col-sm-1 control-label'><input name='addLicences' id='addLicence" + addId + "' accept='image/png,image/jpeg' type='file'  /></label>"
                            + "<div class='col-sm-1'> </div>"
                            + "<label for='' class='col-sm-1 control-label'><span style='color: red;'>&nbsp;*</span>&nbsp;&nbsp;状态</label>"
                            + "<div class='col-sm-2'>"
                            + "<select class='form-control'  id='addStatus" + addId + "'>"
                            + "<option  value='0'>无效</option> <option selected='selected' value='1'>有效</option> </select> </div> <div class='col-sm-1'><button type='button' class='btn btn-danger btn-xs 'onclick='removeDiv(this)' id='' >移除</button></div></div>";

                    $('#supplierLicence').append(addStr);
                    addId++;
                }
            }
        }
        function removeDiv(obj) {

            $(obj).parent().parent().remove();
        }

        function showImg(obj) {
//            alert($(obj).attr("src"));
            $("#modelImg").attr("src", $(obj).attr("src"));

            $('#myModal').modal('show');
        }
    </script>
</head>
<body>
<div class="col-md-12" id="supplierDetail" style="display: none;">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title" id="updateTitle">个人信息详情</h3>

        </div>
        <ul id="myTab" class="nav nav-tabs">
            <li class="active">
                <a href="#supplierBaseInfo" data-toggle="tab">
                    基本信息
                </a>
            </li>

            <li>
                <a href="#supplierLicence" data-toggle="tab">
                    证照
                </a>
            </li>

        </ul>
        <form id="detailForm" class="form-horizontal" method="post" action="save" enctype="multipart/form-data"
              data-toggle="validator" role="form">
            <input type="hidden" name="updateLicenceStr" id="updateLicenceStr"/>
            <input type="hidden" name="addLicenceStr" id="addLicenceStr"/>
            <input type="hidden" name="sid" id="sid"/>
            <div class="box-body">
                <div id="myTabContent" class="tab-content">
                    <div class="tab-pane fade in active" id="supplierBaseInfo">
                        <div class="form-group has-feedback" id="oldImg">

                            <label for="" class="col-sm-3 control-label">&nbsp;&nbsp;当前头像</label>
                            <div class="col-sm-9">
                                <img class="img-circle" id="newImg" src="" alt="没有头像" height="50" width="50"/>


                            </div>
                        </div>


                        <div class="form-group has-feedback">
                            <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;上传头像</label>
                            <div class="col-sm-9">
                                <input name="myavatar" accept="image/png,image/jpeg" type="file"/>

                            </div>
                        </div>
                        <div class="form-group has-feedback">
                            <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;供应商名</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="cname" name="cname"
                                       placeholder="供应商名，最多12个字"
                                       required="required" maxlength="12" autocomplete="false"/>
                                <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                                <div class="help-block with-errors"></div>
                            </div>
                        </div>


                        <div class="form-group">
                            <label for="contact" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;联系人</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="contact" name="contact" placeholder="供应商联系人"
                                       required="required"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="telephone" class="col-sm-3 control-label"><span
                                    style="color: red;">&nbsp;*</span>&nbsp;&nbsp;联系电话</label>
                            <div class="col-sm-9">
                                <input type="tel" class="form-control" id="telephone" name="telephone" digits="true"
                                       isMobile="true" phonesame="true"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       onafterpaste="this.value=this.value.replace(/\D/g,'')"
                                       placeholder="供应商联系电话" required="required"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="Province" class="col-sm-3 control-label"><span
                                    style="color: red;">&nbsp;*</span>&nbsp;&nbsp;省</label>
                            <div class="col-sm-2">
                                <select class="form-control" name="province" id="province"
                                        onchange="getAllCity($('#province option:selected').val(),$('#city option:selected').val())"
                                        required="required">

                                </select>
                            </div>
                            <label for="City" class="col-sm-1 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;市</label>
                            <div class="col-sm-2">
                                <select class="form-control" name="city" id="city"
                                        onchange="getAllArea($('#city option:selected').val(),$('#area option:selected').val())"
                                        required="required">

                                </select>
                            </div>
                            <label for="Village" class="col-sm-1 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;区/县</label>
                            <div class="col-sm-2">
                                <select class="form-control" name="area" id="area" required="required">

                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="address" class="col-sm-3 control-label">&nbsp;&nbsp;地址</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="address" name="address" placeholder="地址"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="note" class="col-sm-3 control-label">&nbsp;&nbsp;备注</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="note" name="note" placeholder="备注"/>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="supplierLicence">
                        <div class="form-group ">
                            <div class="col-sm-1">
                                <button type="button" class="btn btn-info btn-block " id=""
                                        onclick="addNewLicence()"><i class="fa  fa-plus"></i>新增
                                </button>
                            </div>
                        </div>


                    </div>


                </div>

                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">×</span>
                                </button>
                                <h4 class="modal-title" id="myModalLabel"></h4>
                            </div>
                            <div class="modal-body">
                                <img class="img-rounded" id="modelImg" src="" alt='暂时没有封面' height="400" width="400"/>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                            <#--<button type="button" class="btn btn-primary">Save</button>-->
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <div class="box-footer">
                <button type="button" class="btn btn-danger pull-right btn-cancel">
                    <i class="fa fa-close"></i> 取消
                </button>
                <button type="button" class="btn btn-primary pull-right" id="commitButton" onclick="commitFrom()">
                    <i class="fa fa-save"></i> 保存
                </button>

            </div>

        </form>
    </div>
</div>


</body>
</html>