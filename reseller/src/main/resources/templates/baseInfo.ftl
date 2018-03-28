<!DOCTYPE html>
<html>
<head>
<#include "_head_with_datepicker.ftl" />
<#include "_flash.ftl" />
</head>
<body>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">编辑个人资料</h3>
        </div>
        <div class="tab-pane active" id="peopleData_tab">
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:30%">当前头像:</p>
                </div>
                <div class="col-xs-3">
                    <#if reseller.avatar ??>
                        <form id="formUpAvatar" action="/upAvatar" method="post" enctype="multipart/form-data">
                            <div class="thumbnail" style="width: 70px;height: 70px;background: url(${reseller.avatar!''}) no-repeat; background-size: cover;">
                                <input  onchange="submitUpAcatar()" type="file" name="avatar" style="opacity: 0;width: 100%;height: 100%" />
                                <input type="hidden" name="sid" class="form-control" value="${reseller.sid?c}" />
                            </div>
                        </form>
                        <#else >
                            <form id="formUpAvatar" action="/upAvatar" method="post" enctype="multipart/form-data">
                                <div class="thumbnail" style="width: 70px;height: 70px;">
                                    <input  onchange="submitUpAcatar()" type="file" name="avatar" style="opacity: 0;width: 100%;height: 100%" />
                                    <input type="hidden" name="sid" class="form-control" value="${reseller.sid?c}" />
                                </div>
                            </form>
                    </#if>
                </div>
            </div>
            <form id="editShopKeeper" action="/save" method="post" data-toggle="validator" role="form">
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="display: none;">分销商sid:</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="hidden" name="sid" class="form-control" value="${reseller.sid?c}" />
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">姓名:</p>
                    </div>
                    <div class="col-xs-9">
                        <#if reseller.cname ??>
                            <input type="text" name="cname" class="form-control" value="${reseller.cname}" required/>
                            <#else>
                                <input type="text" name="cname" class="form-control" value="" required/>
                        </#if>
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">联系电话:</p>
                    </div>
                    <div class="col-xs-9">
                        <input type="text" name="telephone" class="form-control" value="${reseller.telephone}" required />
                    </div>
                </div>
                <div class="row form-group">
                    <div class="col-xs-12">
                        <button onclick="submitShopKeeper()" type="button" class="btn btn-primary">确认</button>　　
                        <a href="/index" class="btn btn-default">返回</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    /**
     * 提交的时候将select中value的值改变成Text值
     */
    function submitShopKeeper(){
       $("#editShopKeeper").submit();
    }
    /**
     * 头像修改提交
     */
    function submitUpAcatar() {
        $("#formUpAvatar").submit();
    }

</script>
</body>
</html>