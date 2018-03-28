<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
    <meta name="nav-url" content="/password">
    <link href="https://cdn.bootcss.com/bootstrap-fileinput/4.4.2/css/fileinput.min.css" rel="stylesheet">
    <script src="https://cdn.bootcss.com/bootstrap-fileinput/4.4.2/js/fileinput.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap-fileinput/4.4.2/js/locales/zh.js"></script>
</head>
<body>
<#if afterSaleStatus == 8>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="min-width:600px;width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">退货申请</h3>
        </div>
        <div class="tab-pane active" id="peopleData_tab">
            <form id="formValidate" action="/afterSale/afterSale" enctype="multipart/form-data" method="post"
                  data-toggle="validator" role="form">
                <input  type="hidden" id="ordersSid" name="ordersSid" value="${ordersSid?c}">
                <input  type="hidden" id="afterSaleStatus" name="afterSaleStatus" value="${afterSaleStatus}">
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">请输入退货原因</p>
                    </div>
                    <div class="col-xs-9">
                        <textarea maxlength="200" id="note" name="note" rows="3" cols="30" placeholder="请输入退货原因" required></textarea>
                    </div>
                </div>
                <div class="row form-group" id="divControl">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">请上传退货图片</p>
                    </div>
                    <div class="col-xs-9">
                        <input id="myFile" type="file" name="myFile" multiple class="file-loading">
                    </div>
                </div>

                <div class="row form-group">
                    <div class="col-xs-12">
                        <button id="submitButton" onclick="submitValidate()" type="button" class="btn btn-primary">提交</button>
                        <a href="javascript:history.go(-1)" class="btn btn-default">返回</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<#elseif afterSaleStatus == 9>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="min-width:600px;width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">换货申请</h3>
        </div>
        <div class="tab-pane active" id="peopleData_tab">
            <form id="formValidate" action="/afterSale/afterSale" enctype="multipart/form-data" method="post"
                  data-toggle="validator" role="form">
                <input  type="hidden" id="ordersSid" name="ordersSid" value="${ordersSid?c}">
                <input  type="hidden" id="afterSaleStatus" name="afterSaleStatus" value="${afterSaleStatus}">
                <div class="row form-group">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">请输入换货原因</p>
                    </div>
                    <div class="col-xs-9">
                        <textarea maxlength="200" id="note" name="note" rows="3" cols="30" placeholder="请输入退货原因"></textarea>
                    </div>
                </div>
                <div class="row form-group" id="divControl">
                    <div class="col-xs-3">
                        <p class="" style="margin-top:10%">请上传换货图片</p>
                    </div>
                    <div class="col-xs-9">
                        <input id="myFile" type="file" name="myFile" multiple class="file-loading">
                    </div>
                </div>

                <div class="row form-group">
                    <div class="col-xs-12">
                        <button id="submitButton" onclick="submitValidate()" class="btn btn-primary">提交</button>
                        <a href="javascript:history.go(-1)" class="btn btn-default">返回</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</#if>

<script>
    $(function () {
        //0.初始化fileinput
        var oFileInput = new FileInput();
        oFileInput.Init("myFile", "/afterSale/uplode/photo");
        $(".fileinput-upload-button").hide();
    });
    var FileInput = function () {
        var oFile = new Object();

        //初始化fileinput控件（第一次初始化）
        oFile.Init = function (ctrlName, uploadUrl) {
            var control = $('#' + ctrlName);

            //初始化上传控件的样式
            control.fileinput({
                language: 'zh', //设置语言
                uploadUrl: uploadUrl, //上传的地址
                allowedFileExtensions: ['jpg', 'gif', 'png'],//接收的文件后缀
                showUpload: true, //是否显示上传按钮
                showCaption: false,//是否显示标题
                browseClass: "btn btn-info", //按钮样式
                dropZoneEnabled: false,//是否显示拖拽区域
                maxFileSize: 2048,//单位为kb，如果为0表示不限制文件大小
                maxFileCount: 5, //表示允许同时上传的最大文件个数
                minFileCount: 1,
                enctype: 'multipart/form-data',
                validateInitialCount: true,
                previewFileIcon: "<i class='glyphicon glyphicon-king'></i>",
                msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
                fileActionSettings: {
                    showUpload: false,
                    showZoom: false
                }
            });

            //导入文件上传完成之后的事件
            $("#myFile").on("fileuploaded", function (event, data, previewId, index) {
            });
        }
        return oFile;
    };

    function submitValidate() {
        var afterSaleStatus = $("#afterSaleStatus").val();
        var fileStr = $("#myFile").val();
        var note = $("#note").val();

        var $form = $('#formValidate');
        $form.submit(function () {
            if ($form.valid()) {
                var data = $form.formJSON('get');
                if(afterSaleStatus == 8 && note == ''){
                    showInfoFun('请输入退货原因', 'warning');
                    return false;
                }else if(note == ''){
                    showInfoFun('请输入换货原因', 'warning');
                    return false;
                }
                if (fileStr == '' || fileStr == undefined) {
                    showInfoFun('请至少选择一张图片上传', 'warning');
                    return false;
                }
                $("#submitButton").attr("disabled",true);
            }
            return true;
        });
        $(".fileinput-upload-button").click();
        $form.submit();
    }
</script>
</body>
</html>