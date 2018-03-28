<script src="/assets/js/goods/detail.js"></script>
<div class="col-md-12" id="goodsBaseInfoDetail" style="display: none;">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title" id="updateTitle">商品详情</h3>
            <h3 class="box-title" id="addTitle">新增商品</h3>

        </div>
        <form id="detailForm" class="form-horizontal" method="post" action="save" enctype="multipart/form-data"
              data-toggle="validator" role="form">
            <input type="hidden" name="sid" id="sid"/>
            <input type="hidden" name="goodsSpecificationStr" id="goodsSpecificationStr"/>
            <input type="hidden" name="redirectSize" id="redirectSize"/>
            <input type="hidden" name="redirectPage" id="redirectPage"/>
            <input type="hidden" name="redirectQ" id="redirectQ"/>
            <input type="hidden" name="redirectStatus" id="redirectStatus"/>
            <input type="hidden" name="redirectBigCategory" id="redirectBigCategory"/>
            <input type="hidden" name="redirectSmallCategory" id="redirectSmallCategory"/>
            <input type="hidden" name="reviewStatus" id="reviewStatus"/>
            <div class="box-body" id="goodsSpecification" >


                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品名称</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="cname" name="cname" placeholder="商品名称最多50个字"
                               required="required" maxlength="50" autocomplete="false"/>
                        <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                        <div class="help-block with-errors"></div>
                    </div>
                </div>
                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;商品条码</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="goodsBarcode" name="goodsBarcode"
                               maxlength="50" autocomplete="false"/>
                    </div>
                </div>
                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;统一编码</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" id="unifiedCode" name="unifiedCode"
                               maxlength="50" autocomplete="false"/>

                    </div>
                </div>

                <div class="form-group">
                    <label for="Province" class="col-sm-3 control-label"><span
                            style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品大类</label>
                    <div class="col-sm-2">
                        <select class="form-control" name="bigCatecory" id="bigCatecory"
                                onchange="getAllBigCatecory($('#bigCatecory option:selected').val(),$('#smallCatecory option:selected').val())"
                                required="required">

                        </select>
                    </div>
                    <label for="City" class="col-sm-1 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品小类</label>
                    <div class="col-sm-2">
                        <select class="form-control" name="smallCatecory" id="smallCatecory"
                                required="required">

                        </select>
                    </div>

                </div>
                <#--<div class="form-group">-->
                    <#--<label for="telephone" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;是否平台商品</label>-->
                    <#--<div class="col-sm-3">-->
                        <#--<select class="form-control" name="freeGoods" id="freeGoods"-->
                                <#--required="required">-->

                        <#--</select>-->
                    <#--</div>-->
                <#--</div>-->
                <div class="form-group has-feedback" id="oldImg">

                    <label for="" class="col-sm-3 control-label">&nbsp;&nbsp;当前商品封面</label>
                    <div class="col-sm-9">


                        <img class="img-rounded" id="oldImgUrl" src="/assets/img/goods/img-goods-default.png" alt="暂时没有封面" height="80" width="80"/>

                    </div>
                </div>


                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;上传商品封面</label>
                    <div class="col-sm-9">
                        <input name="myavatar" accept="image/png,image/jpeg" type="file"/>

                    </div>
                </div>
                <div class="form-group ">
                    <div class="col-sm-3">
                        <button type="button" class="btn btn-info btn-block " id="addNewPrice"
                                onclick="addNewGoodsSpecification()"><i class="fa  fa-plus"></i>新增规格
                        </button>
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
                <button type="button" class="btn btn-info pull-right " id="reviewBtn">
                    <i class="fa fa-hand-paper-o"></i> 提交审核
                </button>

            </div>
            <div class="box-footer">
                <div class="list-group" id="logsList">
                </div>


            </div>
        </form>
    </div>
</div>

