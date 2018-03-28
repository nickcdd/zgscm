<div class="col-md-12" id="supplierDetail" style="display: none;">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title">提现申请详情</h3>

        </div>
        <form id="detailForm" class="form-horizontal" method="post" action="save" data-toggle="validator" role="form">
            <input type="hidden" name="sid" id="sid"/>
            <input type="hidden" name="redirectSize" id="redirectSize"/>
            <input type="hidden" name="redirectPage" id="redirectPage"/>
            <input type="hidden" name="redirectQ" id="redirectQ"/>
            <input type="hidden" name="redirectStatus" id="redirectStatus"/>
            <input type="hidden" name="redirectStartDate" id="redirectStartDate"/>
            <input type="hidden" name="redirectEndDate" id="redirectEndDate"/>
            <div class="box-body">


                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;商户名称</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="shopKeeperCname" name="shopKeeperCname"
                               readonly maxlength="12" autocomplete="false"/>


                    </div>
                </div>


                <#--<div class="form-group">-->
                    <#--<label for="amount" class="col-sm-3 control-label">&nbsp;&nbsp;提现金额</label>-->
                    <#--<div class="col-sm-9">-->
                        <#--<input type="text" class="form-control" id="amount" name="amount"-->
                               <#--readnoly/>-->
                    <#--</div>-->
                <#--</div>-->
                <div class="form-group">
                    <label for="amount" class="col-sm-3 control-label">&nbsp;&nbsp;金额</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="amount" name="amount" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <label for="bankName" class="col-sm-3 control-label">&nbsp;&nbsp;银行名称</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="bankName" name="bankName" readonly/>
                    </div>
                </div>

                <div class="form-group">
                    <label for="cardNo" class="col-sm-3 control-label">&nbsp;&nbsp;银行卡号</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="cardNo" name="cardNo" readonly/>
                    </div>
                </div>

                <div class="form-group">
                    <label for="" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;审核状态</label>
                    <div class="col-sm-2">
                        <select class="form-control" name="status" id="detailStatus" required="required" >
                            <#--<option value="2" >通过</option>-->
                            <#--<option value="0">不通过</option>-->

                        </select>
                    </div>

                </div>
                <div class="form-group">
                    <label for="note" class="col-sm-3 control-label">&nbsp;&nbsp;审核原因</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="reason" name="reason"/>
                    </div>
                </div>


            </div>
        <@shiro.hasPermission name="withdrawApply:save">
            <div class="box-footer">

                <button type="button" class="btn btn-danger pull-right btn-cancel">
                    <i class="fa fa-close"></i> 取消
                </button>
                <button type="submit" class="btn btn-primary pull-right" id="saveBtn">
                    <i class="fa fa-save"></i> 保存
                </button>

            </div>
        </@shiro.hasPermission>
        </form>
    </div>
</div>

