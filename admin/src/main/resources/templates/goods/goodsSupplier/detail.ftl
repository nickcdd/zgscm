<link rel="stylesheet" href="/assets/plugins/select2/select2.css">
<script src="/assets/plugins/select2/select2.full.js"></script>
<div class="col-md-12" id="goodsSupplierDetail" style="display: none;">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title" id="updateTitle">选择商品供应商</h3>


        </div>
        <form id="detailForm" class="form-horizontal" method="post" action="save" data-toggle="validator" role="form">
            <input type="hidden" name="sid" id="sid"/>
            <input type="hidden" name="redirectSize" id="redirectSize"/>
            <input type="hidden" name="redirectPage" id="redirectPage"/>
            <input type="hidden" name="redirectQ" id="redirectQ"/>
            <input type="hidden" name="redirectStatus" id="redirectStatus"/>
            <input type="hidden" name="redirectBigCategory" id="redirectBigCategory"/>
            <input type="hidden" name="redirectSmallCategory" id="redirectSmallCategory"/>
            <div class="box-body">


                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品名称</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="cname" name="cname" placeholder="商品名称"
                               maxlength="50" autocomplete="false" readonly/>
                        <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                        <div class="help-block with-errors"></div>
                    </div>
                </div>
                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;商品条码</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="goodsBarcode" name="goodsBarcode" placeholder=""
                               maxlength="50" autocomplete="false" readonly/>

                    </div>
                </div>
                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;统一编码</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="unifiedCode" name="unifiedCode" placeholder=""
                               maxlength="50" autocomplete="false" readonly/>

                    </div>
                </div>

                <div class="form-group">
                    <label for="Province" class="col-sm-3 control-label"><span
                            style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品大类</label>
                    <div class="col-sm-2">
                        <select class="form-control" name="bigCatecory" id="bigCatecory"
                                readonly>

                        </select>
                    </div>
                    <label for="City" class="col-sm-1 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品小类</label>
                    <div class="col-sm-2">
                        <select class="form-control" name="smallCatecory" id="smallCatecory"
                                readonly>

                        </select>
                    </div>

                </div>
                <div class="form-group">
                    <label for="" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;是否平台商品</label>
                    <div class="col-sm-3">
                        <select class="form-control" name="freeGoods" id="freeGoods"
                                readonly>

                        </select>
                    </div>
                </div>
                <div class="form-group has-feedback" id="oldImg">

                    <label for="" class="col-sm-3 control-label">&nbsp;&nbsp;当前商品封面</label>
                    <div class="col-sm-9">


                        <img class="img-rounded" id="oldImgUrl" src="/assets/img/goods/img-goods-default.png" alt="暂时没有封面" height="80" width="80"/>

                    </div>
                </div>
            <#--<div class="form-group">-->
            <#--<label for="" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;选择供应商</label>-->
            <#--<div class="col-sm-6">-->
            <#--<select class="form-control select2" multiple="multiple" id="allSuppliers"-->
            <#--data-placeholder="选择供应商" style="width: 100%;">-->

            <#--</select>-->
            <#--</div>-->


            <#--</div>-->
                <div class="form-group">
                    <label for="" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;选择供应商</label>
                    <div class="col-sm-6">
                        <select class="form-control select2" id="allSuppliers" name="allSuppliers"
                                data-placeholder="请选择供应商" style="width: 50%;" required="required">

                        </select>

                    </div>


                </div>

            </div>
        <@shiro.hasPermission name="goods:managerSupplier">
            <div class="box-footer">

                <button type="button" class="btn btn-danger pull-right btn-cancel">
                    <i class="fa fa-close"></i> 取消
                </button>
                <button type="submit" class="btn btn-primary pull-right" id="commitButton">
                    <i class="fa fa-save"></i> 保存
                </button>

            </div>
        </@shiro.hasPermission>
            <div class="box-footer">
                <div class="list-group" id="logsList">
                </div>


            </div>
        </form>
    </div>
</div>

