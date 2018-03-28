<div class="col-md-12" id="publishGoodsDetail" style="display: none;">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title" id="updateTitle">商品价格信息</h3>


        </div>
        <form id="detailForm" class="form-horizontal" method="post" action="save" data-toggle="validator"
              role="form">
            <input type="hidden" name="sid" id="sid"/>
            <input type="hidden" name="reviewStatus" id="reviewStatus"/>
            <input type="hidden" name="redirectSize" id="redirectSize"/>
            <input type="hidden" name="redirectPage" id="redirectPage"/>
            <input type="hidden" name="redirectQ" id="redirectQ"/>
            <input type="hidden" name="redirectStatus" id="redirectStatus"/>
            <input type="hidden" name="redirectBigCategory" id="redirectBigCategory"/>
            <input type="hidden" name="redirectSmallCategory" id="redirectSmallCategory"/>
            <div class="box-body" id="goodsSpecification">


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
                    <label for="" class="col-sm-3 control-label">&nbsp;&nbsp;供应商</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="supplierName" name="" placeholder="没有供应商"
                               readonly/>
                        <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                        <div class="help-block with-errors"></div>
                    </div>


                </div>


            </div>
        <@shiro.hasPermission name="goods:managerGoods">
            <div class="box-footer">

                <button type="button" class="btn btn-default pull-right btn-cancel"><i
                        class="fa fa-reply"></i>返回
                </button>
                　
                <button type="button" class="btn btn-success pull-right" id="publishUp" onclick="publishSuccess()">
                    <i class="fa  fa-arrow-up"></i> 上架
                </button>
                <button type="button" class="btn btn-danger pull-right " id="publishDown" onclick="publishFail()">
                    <i class="fa fa-arrow-down"></i> 下架
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

