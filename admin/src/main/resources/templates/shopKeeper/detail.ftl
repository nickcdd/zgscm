<script src="/assets/js/shopKeeper/detail.js"></script>
<div class="col-md-12" id="supplierDetail" style="display: none;">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title" id="updateTitle">商户详情</h3>
            <h3 class="box-title" id="addTitle">新增商户</h3>
        </div>
        <form id="detailForm" class="form-horizontal" method="post" action="save" enctype="multipart/form-data"
              data-toggle="validator" role="form">
            <input type="hidden" name="sid" id="sid"/>
            <input type="hidden" name="redirectSize" id="redirectSize"/>
            <input type="hidden" name="redirectPage" id="redirectPage"/>
            <input type="hidden" name="redirectQ" id="redirectQ"/>
            <input type="hidden" name="redirectProvince" id="redirectProvince"/>
            <input type="hidden" name="redirectCity" id="redirectCity"/>
            <input type="hidden" name="redirectArea" id="redirectArea"/>

            <div class="box-body">
                <div class="form-group has-feedback" id="oldImg">

                    <label for="" class="col-sm-3 control-label">&nbsp;&nbsp;当前头像</label>
                    <div class="col-sm-9">


                        <img class="img-circle" id="newImg" src="" alt="没有头像" height="50" width="50"/>

                    </div>
                </div>


                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;上传头像</label>
                    <div class="col-sm-9">
                        <input name="myavatar" accept="image/png,image/jpeg"  type="file"/>

                    </div>
                </div>
                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商户名</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="cname" name="cname" placeholder="商户名，最多20个字"
                               required="required" maxlength="20" autocomplete="false"/>
                        <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                        <div class="help-block with-errors"></div>
                    </div>
                </div>
                <div class="form-group" id="newPassword">
                    <label for="password" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;密码</label>
                    <div class="col-sm-9">
                        <input type="password" class="form-control" id="password" name="password" placeholder=""
                               rangelength="[6,16]"/>
                    </div>
                </div>
                <div class="form-group">
                    <label for="telephone" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;联系电话</label>
                    <div class="col-sm-9">
                        <input type="tel" class="form-control" id="telephone" name="telephone" digits="true" isMobile="true" phonesame="true" onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')"
                               placeholder="商户联系电话"  required="required"/>
                    </div>
                </div>
                <#--<div class="form-group">-->
                    <#--<label for="telephone" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商户类型</label>-->
                    <#--<div class="col-sm-3">-->
                        <#--<select class="form-control" name="level" id="level"-->
                                <#--required="required">-->

                        <#--</select>-->
                    <#--</div>-->
                <#--</div>-->
                <input type="hidden" name="level" value="0"/>
                <div class="form-group">
                    <label for="Province" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;省</label>
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
        <@shiro.hasPermission name="shopKeeper:save">
            <div class="box-footer">
                <button type="button" class="btn btn-danger pull-right btn-cancel">
                    <i class="fa fa-close"></i> 取消
                </button>
                <button type="submit" class="btn btn-primary pull-right" id="commitButton" >
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

