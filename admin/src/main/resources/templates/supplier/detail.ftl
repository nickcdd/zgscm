<script src="/assets/js/supplier/detail.js"></script>
    <div class="col-md-12" id="supplierDetail" style="display: none;">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title" id="updateTitle">供应商详情</h3>
                <h3 class="box-title" id="addTitle">新增供应商</h3>
            </div>
            <ul id="myTab" class="nav nav-tabs">
                <li class="active">
                    <a href="#supplierBaseInfo" data-toggle="tab">
                        供应商基本信息
                    </a>
                </li>

                <li>
                    <a href="#supplierLicence" data-toggle="tab">
                        供应商证照
                    </a>
                </li>

            </ul>
            <form  id="detailForm" class="form-horizontal" method="post" action="save" enctype="multipart/form-data" data-toggle="validator" role="form">
                <input type="hidden" name="updateLicenceStr" id="updateLicenceStr"/>
                <input type="hidden" name="addLicenceStr" id="addLicenceStr"/>
                <input type="hidden" name="sid" id="sid"/>
                <input type="hidden" name="redirectSize" id="redirectSize"/>
                <input type="hidden" name="redirectPage" id="redirectPage"/>
                <input type="hidden" name="redirectQ" id="redirectQ"/>
                <input type="hidden" name="redirectProvince" id="redirectProvince"/>
                <input type="hidden" name="redirectCity" id="redirectCity"/>
                <input type="hidden" name="redirectArea" id="redirectArea"/>
                <div class="box-body">
                    <div id="myTabContent" class="tab-content">
                        <div class="tab-pane fade in active" id="supplierBaseInfo">
                            <div class="form-group has-feedback" id="oldImg">

                                <label for="" class="col-sm-3 control-label">&nbsp;&nbsp;当前头像</label>
                                <div class="col-sm-9">
                                    <img class="img-circle" id="newImg" src="" alt="没有头像" height="50" width="50" />



                                </div>
                            </div>



                            <div class="form-group has-feedback" >
                                <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;上传头像</label>
                                <div class="col-sm-9">
                                    <input name="myavatar" accept="image/png,image/jpeg" type="file" onchange="previewImg(this)"  />

                                </div>
                            </div>
                            <div class="form-group has-feedback">
                                <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;供应商名</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="cname" name="cname" placeholder="供应商名，最多20个字"
                                           required="required" maxlength="20" autocomplete="false"/>
                                    <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                                    <div class="help-block with-errors"></div>
                                </div>
                            </div>

                            <div class="form-group" id="newPassword">
                                <label for="password" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;密码</label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" id="password" name="password" placeholder="" rangelength="[6,16]"  />
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
                                <label for="telephone" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;联系电话</label>
                                <div class="col-sm-9">
                                    <input type="tel" class="form-control" id="telephone" name="telephone"  digits="true" isMobile="true" phonesame="true" onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')"
                                           placeholder="供应商联系电话" required="required"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="Province" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;省</label>
                                <div class="col-sm-2">
                                    <select class="form-control" name="province" id="province" onchange="getAllCity($('#province option:selected').val(),$('#city option:selected').val())" required="required">

                                    </select>
                                </div>
                                <label for="City" class="col-sm-1 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;市</label>
                                <div class="col-sm-2">
                                    <select class="form-control" name="city" id="city" onchange="getAllArea($('#city option:selected').val(),$('#area option:selected').val())" required="required">

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
                                <label for="api" class="col-sm-3 control-label">&nbsp;&nbsp;供应商对接接口api</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="api" name="api" placeholder="供应商对接接口api"/>
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
                            <#--<div class="form-group"><label for="" class="col-sm-1 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;证照名称</label>-->
                                <#--<div class="col-sm-2"><input type="text" class="form-control" id="addCname" placeholder="证照名称"-->
                                                             <#--required="required"/>-->
                                <#--</div>-->

                                <#--<label for="" class="col-sm-1 control-label"><input name="addLicences" type="file"  /></label>-->
                                <#--<div class="col-sm-1">-->

                                <#--</div>-->
                                <#--<label for="" class="col-sm-1 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;状态</label>-->
                                <#--<div class="col-sm-2">-->
                                    <#--<select class="form-control"  id="addStatus">-->
                                        <#--<option selected="selected" value="0">无效</option>-->
                                        <#--<option value="1">有效</option>-->
                                    <#--</select>-->
                                <#--</div>-->
                            <#--</div>-->



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
            <@shiro.hasPermission name="supplier:save">
                <div class="box-footer">
                    <button type="button" class="btn btn-danger pull-right btn-cancel">
                        <i class="fa fa-close"></i> 取消
                    </button>
                    <button type="button" class="btn btn-primary pull-right" id="commitButton" onclick="commitFrom()">
                        <i class="fa fa-save"></i> 保存
                    </button>
                    <button type="button" class="btn btn-info pull-right btn-reset">
                        <i class="fa fa-eraser"></i> 重置
                    </button>
                </div>
            </@shiro.hasPermission>
            </form>
        </div>
    </div>

