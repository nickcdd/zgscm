<script src="/assets/js/goods/goodsCategory/detail.js"></script>
<div class="col-md-7" id="detailGoodsCategory" style="display: none;">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title" id="updateTitle">商品类别详情</h3>
            <h3 class="box-title" id="addTitle">新增商品类别</h3>
        </div>
        <form id="detailForm" class="form-horizontal" method="post" action="save" data-toggle="validator" role="form">
            <input type="hidden" name="sid" id="sid"/>

            <div class="box-body">

                <div class="form-group has-feedback">
                    <label for="username" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;类别名称</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="cname" name="cname" placeholder="类别名称，最多20个字"
                               placeholder="" checkCname="true" required="required" maxlength="20" autocomplete="false"/>
                        <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                        <div class="help-block with-errors"></div>
                    </div>
                </div>
                <div class="form-group" id="goodsCatecoryParent">
                    <label for="parentSid" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;大类类别</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="parentSid" id="parentSid" required="required">

                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="status" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;状态</label>
                    <div class="col-sm-4">
                        <select class="form-control" name="status" id="status" required="required">

                        </select>
                    </div>
                </div>


                <div class="form-group">
                    <label for="cname" class="col-sm-3 control-label">&nbsp;&nbsp;备注</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="note" name="note" placeholder="备注"
                        />
                    </div>
                </div>


            </div>
        <@shiro.hasPermission name="goods:managerCategory">
            <div class="box-footer">
                <button type="submit" class="btn btn-primary pull-right" id="commitButton">
                    <i class="fa fa-save"></i> 保存
                </button>

            </div>
        </@shiro.hasPermission>
        </form>
    </div>
</div>