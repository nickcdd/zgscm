<link rel="stylesheet" href="/assets/plugins/select2/select2.css">
<script src="/assets/plugins/select2/select2.full.js"></script>
<script type="text/javascript">
    $(function () {
        $(".select2").select2();
//        $(".select2").select2({
//            ajax: {
//                url: "/shopKeeper/findResellsers",
//                dataType: 'json',
//                delay: 1500,
//                data: function (params) {
//                    return {
//                        q: params.term, // search term
//                        page: params.page
//                    };
//                },
//                processResults: function (data, params) {
//                    // parse the results into the format expected by Select2
//                    // since we are using custom formatting functions we do not need to
//                    // alter the remote JSON data, except to indicate that infinite
//                    // scrolling can be used
//                    params.page = params.page || 1;
//
//                    return {
//                        results: data.items
////                        pagination: {
////                            more: (params.page * 30) < data.total_count
////                        }
//                    };
//                },
//                cache: true
//            },
//            escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
//            minimumInputLength: 1,
////            templateResult: formatRepo, // omitted for brevity, see the source of this page
////            templateSelection: formatRepoSelection // omitted for brevity, see the source of this page
//        });
    });

    function saveReseller(flag) {
//        $.ajax({
//            type: "POST",
//            url: "/shopKeeper/saveReseller",
//            data:{shopKeeperSid:$('#shopKeeperSid').val(),resellerSid:$('#resellerSid').val()},
//            dataType: "json",
//            async: false,
//            success: function (result) {
//              if(result.success){
//               history.go(-1);
//              }else{
//                  showInfoFun(result.msg,"danger");
//              }
//            },
//            error: function () {
//
//            }
//        });
        $('.btn-cancel').attr("disabled", "disabled");
        $('.btn-submit').attr("disabled", "disabled");
        if (flag) {
            $('#flag').val("true");
            $('#infoForm').submit();
        } else {
            $('#flag').val("false");
            $('#infoForm').submit();
        }
    }

</script>
<div class="col-md-12">
    <div class="box box-info">
        <div class="box-header with-border">
            <h3 class="box-title" id="updateTitle">分销商详情</h3>

        </div>
        <form id="infoForm" class="form-horizontal" method="post" action="saveReseller"
              role="form">
            <input type="hidden" name="flag" id="flag"/>
            <input type="hidden" name="shopKeeperSid" id="shopKeeperSid" value="${shopKeeperSid}"/>
        <#if resellerProvince ??>
            <input type="hidden" name="resellerProvince" id="resellerProvince" value="${resellerProvince?c}"/>
        </#if>
        <#if resellerCity ??>
            <input type="hidden" name="resellerCity" id="resellerCity" value="${resellerCity?c}"/>
        </#if>
        <#if resellerArea ??>
            <input type="hidden" name="resellerArea" id="resellerArea" value="${resellerArea?c}"/>
        </#if>
            <input type="hidden" name="resellerQ" id="resellerQ" value="${resellerQ!''}"/>
            <input type="hidden" name="resellerPage" id="resellerPage" value="${resellerPage?c}"/>
            <input type="hidden" name="resellerSize" id="resellerSize" value="${resellerSize?c}"/>

            <div class="box-body">


                <div class="form-group">
                    <label for="telephone" class="col-sm-3 control-label">&nbsp;&nbsp;分销商</label>
                    <div class="col-sm-3">
                        <select class="form-control select2" style="width:100%;" id="resellerSid" name="resellerSid"
                                data-placeholder="请选择分销商" style="width: 50%;">
                        <#if resellerSid == -1>
                            <option value="-1" selected="selected">无</option>
                            <#if resellerList ??>
                                <#list resellerList as reseller>
                                    <option value="${reseller.sid?c}">${reseller.cname!''}</option>
                                </#list>
                            </#if>
                        <#else >
                            <#--<option value="-1">无</option>-->
                            <#if resellerList ??>
                                <#list resellerList as reseller>
                                    <#if reseller.sid == resellerSid>
                                        <option value="${reseller.sid?c}"
                                                selected="selected">${reseller.cname!''}</option>
                                    <#else >
                                        <#--<option value="${reseller.sid?c}">${reseller.cname!''}</option>-->
                                    </#if>
                                </#list>
                            </#if>
                        </#if>
                        </select>
                    </div>
                </div>


            </div>
        <@shiro.hasPermission name="shopKeeper:save">
            <div class="box-footer">
                <a type="button" class="btn btn-danger pull-right btn-cancel" onclick="saveReseller(false)">
                    <i class="fa fa-close"></i> 取消
                </a>
                <#if resellerSid == -1>
                <button type="button" class="btn btn-primary pull-right btn-submit" id="commitButton" onclick="saveReseller(true)">
                    <i class="fa fa-save"></i> 保存
                </button>
                </#if>
            </div>
        </@shiro.hasPermission>
        </form>
    </div>
</div>

