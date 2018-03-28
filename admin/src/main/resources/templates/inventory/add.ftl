<link rel="stylesheet" href="/assets/plugins/select2/select2.css">
<script src="/assets/plugins/select2/select2.full.js"></script>
<script type="text/javascript" src="/assets/plugins/select2/i18n/zh-CN.js"></script></span>
<script type="text/javascript">
    $(function () {
        //加载仓库
        var storageStr = getAllStorages();
        $('#storageSid').html(storageStr);

        $("#goodsSid").select2({
            language: "zh-CN",
            minimumInputLength: 1,
            ajax: {
                type: "POST",
                url: "/inventory/getGoodsByName",
                dataType: 'json',
                delay: 250,
                data: function (params) {
                    return {
                        name: params.term, // 函数的参数
                        //page: params.page  //分页显示先不要，没有效果
                    };
                },
                processResults: function (data, params) {
                    //params.page = params.page || 1;
                    var itemList = [];
//                    for(var i=0; i<data.length; i++){
//                        itemList.push({id: data[i].id, text: data[i].title})
//                    }
                    $.each(data.record, function (i, item) {


                        itemList.push({id: item.sid, text: item.cname});
                    })
                    return {
                        results: itemList,
                        //pagination: {
                        //    more: (params.page * 10) < data.total_count
                        //}
                    };
                },
//                cache: true
            },
//            escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
//            minimumInputLength: 1,
//            templateResult: formatRepo,
//            templateSelection: formatRepo
        });

//        $("#goodsSid").select2({
//            minimumInputLength: 1,
//            query: function (query) {
//                var data = {results: []}, i, j, s;
//                for (i = 1; i < 5; i++) {
//                    s = "";
//                    for (j = 0; j < i; j++) {s = s + query.term;}
//                    data.results.push({id: query.term + i, text: s});
//                }
//                query.callback(data);
//            }
//        });
//        $("#goodsSid").select2({
//            language: "zh-CN",
//            minimumInputLength: 1
//            query: function (query) {
//                var data = {results: []}, i, j, s;
//                if (query.term != null && query != "" && query != undefined) {
//                    $.ajax({
//                        type: "POST",
//                        url: "/inventory/getGoodsByName",
//                        data:{'name':query.term},
//                        dataType: "JSON",
//                        async: false,
//                        success: function (result) {
//                            //从服务器获取数据进行绑定
//
//                            $.each(result.record, function (i, item) {
//
//
//                                data.results.push({id: item.sid, text: item.cname});
//                            })
//                        },
//
//                        error: function () {
//
//                        }
//
//                    })
//
////                    alert(query.term);
////                        data.results.push({id: query.term, text: s});
//
//                }
//                query.callback(data);
//            }
//
//
//        });
    });

    //    function formatRepo(repo) {
    //        if (repo.loading) return repo.text;
    //        var markup = "<div>" + repo.name + "</div>";
    //        return markup;
    //    }
    //查找商品规格
    function findGoods() {
//        alert($("#goodsSid").val());
        var str = "";
        $.ajax({
            type: "POST",
            url: "/inventory/getGoodsSpecificationByGoodsSid",
            data:{'goodsSid':$("#goodsSid").val()},
            dataType: "JSON",
            async: false,
            success: function (data) {
                //从服务器获取数据进行绑定

                $.each(data.record, function (i, item) {

                    // str="<option value=''>请选择</option>";
//                    if ($('#checkStorageSid').val() == item.sid) {
//                        str += "<option selected='selected' value=" + item.sid + ">" + item.cname + "</option>";
//                    } else {
//                        str += "<option value=" + item.sid + ">" + item.cname + "</option>";
//                    }
                    str += "<option value=" + item.sid + ">" + item.cname + "</option>";

                })
                $('#specificationSid').html(str);

            },
            error: function () {

            }
        });
    }
    function getAllStorages() {

        var str = "";
        $.ajax({
            type: "POST",
            url: "/inventory/getAllStorages",

            dataType: "JSON",
            async: false,
            success: function (data) {
                //从服务器获取数据进行绑定

                $.each(data.record, function (i, item) {

                    // str="<option value=''>请选择</option>";
//                    if ($('#checkStorageSid').val() == item.sid) {
//                        str += "<option selected='selected' value=" + item.sid + ">" + item.cname + "</option>";
//                    } else {
//                        str += "<option value=" + item.sid + ">" + item.cname + "</option>";
//                    }
                    str += "<option value=" + item.sid + ">" + item.cname + "</option>";

                })

                return str;
            },
            error: function () {

            }
        });
        return str;

    }

    function save(){
        $('#commitButton').attr("disabled","disabled");
        $("#addForm").ajaxSubmit({
            type: "POST",
            url: "/inventory/save",
            dataType: "json",
            success: function (data) {
                if (data.flag) {
                    confirmInfoFun("cancel()", data.msg, "新增成功", false);
//                    cancel();
                }
                else {
                    confirmInfoFun("", data.msg, "新增失败", false);
                }

            },
            complete: function () {
                $('#commitButton').attr("disabled","");
            }
        });
    }
    function cancel(){
        var str=setPageInfo();
        location.href="/inventory/index?"+str;
    }
    function setPageInfo() {
        var str = "";
        str += "page=" + $('#redirectPage').val();
        str += "&size=" + $('#redirectSize').val();

        if ($('#redirectGoodsName').val() != undefined && $('#redirectGoodsName').val() != "") {
            str += "&goodsName=" + $('#redirectGoodsName').val();
//                $('#redirectStartDate').val($('#startDate').val());
        }
        if ($('#redirectStorageSid').val() != undefined && $('#redirectStorageSid').val() != "") {

//                $('#redirectEndDate').val($('#endDate').val());
            str += "&storageSid=" + $('#redirectStorageSid').val();
        }



        return str;
    }
</script>
<div class="col-md-12" id="">
    <div class="box box-info">
        <div class="box-header with-border">

            <h3 class="box-title" id="addTitle">新增库存信息</h3>
        </div>
        <form id="addForm" class="form-horizontal" method="post" action=""
              data-toggle="validator" role="form">
            <input type="hidden" name="redirectGoodsName" id="redirectGoodsName" value="${redirectGoodsName!''}" />
            <input type="hidden" name="redirectStorageSid" id="redirectStorageSid" value="${redirectStorageSid!''}" />
            <input type="hidden" name="redirectPage" id="redirectPage" value="${redirectPage!''}" />
            <input type="hidden" name="redirectSize" id="redirectSize" value="${redirectSize!''}" />
            <div class="box-body">
                <div class="form-group">
                    <label for="goodsSid" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品名称</label>
                    <div class="col-sm-4">
                        <select class="form-control select2" style="width:100%;" id="goodsSid"
                                name="goodsSid"
                                data-placeholder="请输入查询" style="width: 50%;"  onchange="findGoods()">

                        </select>
                    </div>

                </div>
                <div class="form-group">
                    <label for="specificationSid" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品规格</label>
                    <div class="col-sm-4">
                        <select class="form-control select2" style="width:100%;" id="specificationSid"
                                name="specificationSid"
                                data-placeholder="选择规格" style="width: 50%;" >

                        </select>
                    </div>

                </div>
                <div class="form-group">
                    <label for="storageSid" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;仓储</label>
                    <div class="col-sm-4">
                        <select class="form-control select2" style="width:100%;" id="storageSid"
                                name="storageSid"
                                data-placeholder="全部" style="width: 50%;" >

                        </select>
                    </div>

                </div>

                <div class="form-group has-feedback">
                    <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;商品数量</label>
                    <div class="col-sm-3">
                        <input type="number" class="form-control" id="amount" name="amount" placeholder=""
                               required="required" maxlength="12" autocomplete="false" />
                        <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                        <div class="help-block with-errors"></div>
                    </div>
                </div>


            </div>
        <@shiro.hasPermission name="reseller:save">
            <div class="box-footer">
                <button type="button" class="btn btn-danger pull-right btn-cancel" onclick="cancel()">
                    <i class="fa fa-close"></i> 取消
                </button>
                <button type="button" class="btn btn-primary pull-right" id="commitButton" onclick="save()">
                    <i class="fa fa-save"></i> 保存
                </button>
                <#--<button type="button" class="btn btn-info pull-right btn-reset">-->
                    <#--<i class="fa fa-eraser"></i> 重置-->
                <#--</button>-->
            </div>
        </@shiro.hasPermission>
        </form>
    </div>
</div>

