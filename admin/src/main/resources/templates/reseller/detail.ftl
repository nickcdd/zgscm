<script type="text/javascript">
    $(function () {
        jQuery.validator.addMethod("isMobile", function(value, element) {
            var length = value.length;
            var mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
            return this.optional(element) || (length == 11 && mobile.test(value));
        }, "请正确填写您的手机号码");
        jQuery.validator.addMethod("phonesame", function(value, element) {
            var flag = 1;
            var sid=$('#sid').val();

            $.ajax({
                type:"POST",
                url:'/reseller/checkTelephone',
                async:false,
                data:{'telephone':value,'sid':sid},
                success: function(result){
                    if(result.success){
                        flag = 1;
                    }else{
                        flag = 0;
                    }
                }
            });

            if(flag == 0){
                return false;
            }else{
                return true;
            }

        }, "该手机号已经注册");
    });
            </script>
        <div class="col-md-12" id="resellerDetail" style="display: none;">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title" id="updateTitle">分销商详情</h3>
            <h3 class="box-title" id="addTitle">新增分销商</h3>
        </div>
        <form id="detailForm" class="form-horizontal" method="post" action="save" enctype="multipart/form-data"
              data-toggle="validator" role="form">
            <input type="hidden" name="sid" id="sid"/>
            <input type="hidden" name="redirectSize" id="redirectSize"/>
            <input type="hidden" name="redirectPage" id="redirectPage"/>
            <input type="hidden" name="redirectQ" id="redirectQ"/>
            <#--<input type="hidden" name="redirectProvince" id="redirectProvince"/>-->
            <#--<input type="hidden" name="redirectCity" id="redirectCity"/>-->
            <#--<input type="hidden" name="redirectArea" id="redirectArea"/>-->

            <div class="box-body">

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
                    <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;分销商名称</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="cname" name="cname" placeholder="分销商名称，最多12个字"
                               required="required" maxlength="12" autocomplete="false"/>
                        <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                        <div class="help-block with-errors"></div>
                    </div>
                </div>
                <div class="form-group" id="newPassword">
                    <label for="password" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;密码</label>
                    <div class="col-sm-9">
                        <input type="password" class="form-control" id="password" name="password" placeholder=""
                               rangelength="[6,16]" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="telephone" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;联系电话</label>
                    <div class="col-sm-9">
                        <input type="tel" class="form-control" id="telephone" name="telephone" digits="true" isMobile="true" phonesame="true" onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')"
                               placeholder="分销商联系电话"  required="required"/>
                    </div>
                </div>





            </div>
        <@shiro.hasPermission name="reseller:save">
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

