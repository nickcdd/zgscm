<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
</head>
<body>
<div class="box box-primary" style="padding:0% 10% 10% 10%">
    <div style="min-width:600px;width: 50%">
        <div class="box-header with-border" style="margin:0 0 2% 0">
            <h3 class="box-title">收货地址</h3>
        </div>
        <form id="editAddress" action="/receivingAddress/update" method="post" data-toggle="validator" role="form">
            <div >
                <input type="hidden" name="sid" class="form-control" value="${receivingAddresses.sid?c}" />
            </div>
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:10%">所在地:</p>
                </div>
                <div class="col-xs-3">
                    <select name="province" id="province" class="form-control" onchange="loadCityContent($('#province option:selected').val(),$('#province option:selected').text())">
                        <option selected="selected">${receivingAddresses.province}</option>
                    </select>
                </div>
                <div class="col-xs-3">
                    <select name="city" id="city" class="form-control" onchange="loadAreaContent($('#city option:selected').val(),$('#city option:selected').text())">
                        <option selected="selected">${receivingAddresses.city}</option>
                    </select>
                </div>
                <div class="col-xs-3">
                    <select name="area" id="area" class="form-control">
                        <option selected="selected">${receivingAddresses.area}</option>
                    </select>
                </div>
            </div>
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:15%">详细地址:</p>
                </div>
                <div class="col-xs-9">
                    <input name="address" type="text" class="form-control" value="${receivingAddresses.address}"  required/>
                </div>
            </div>
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:10%">收货人姓名:</p>
                </div>
                <div class="col-xs-9">
                    <input name="name" type="text" class="form-control" value="${receivingAddresses.name}" required  />
                </div>
            </div>
            <div class="row form-group">
                <div class="col-xs-3">
                    <p class="" style="margin-top:10%">手机号码:</p>
                </div>
                <div class="col-xs-9">
                    <input onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')" name="telephone" type="text" class="form-control" value="${receivingAddresses.telephone}" required  />
                </div>
            </div>
            <div class="row form-group">
                <div class="col-xs-4 col-xs-offset-8 text-right">
                    <#if receivingAddresses.isDefault != 1>
                            <input name="isDefault" type="checkbox"   value="1"><span style="margin-left:5%;"  >设为默认地址</span>
                    </#if>
                </div>
            </div>

            <div class="row form-group">
                <div class="col-xs-12">
                    <button id="submitButton" onclick="submitEditAddress()" type="button" class="btn btn-primary">确认</button>　　
                    <a href="javascript:history.go(-1)" class="btn btn-default">返回</a>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    $(function() {
        var provinceText = $("#province option:selected").text();
        /**
         * 初始化加载省
         */
        $("#province").html(getNextLevelArea(1, provinceText));
        /**
         * 初始化加载市
         */
        if (provinceText != undefined && provinceText != '') {
            var cityContent = getNextLevelArea($("#province option:selected").val(), $("#city option:selected").text());
            $("#city").html("<option>请选择</option>"+cityContent);

        }
        var cityText = $("#city option:selected").text();
        /**
         * 初始化加载区
         */
        if (cityText != undefined && cityText != '') {
            var areaContent = getNextLevelArea($("#city option:selected").val(), $("#area option:selected").text());
            $("#area").html(areaContent);
        }
    });

    /**
     * 加载市
     */
    function loadCityContent(sid){
        if(flag == "请选择"){
            return;
        }
        var cityContent = getNextLevelArea(sid, null);
        $("#city").html("<option selected='selected'>请选择</option>"+cityContent);
    }
    /**
     * 加载区域
     */
    function loadAreaContent(sid, flag){
        if(flag == "请选择"){
            return;
        }
        var areaContent = getNextLevelArea(sid, null);
        $("#area").html("<option selected='selected'>请选择</option>"+areaContent);
    }
    /**
     * 根据父级Sid加载下一级地区列表
     * @param name
     * @param sid
     */
    var getNextLevelArea = function (sid, flag) {
        var str="";
        $.ajax({
            type: "GET",
            async: false,
            url : "/area",
            data: {'sid' : sid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                $.each(result.record,function (index,value) {
                    if(flag == value.cname ){
                        str+="<option value="+value.sid+" selected='selected'>"+value.cname+"</option>";
                    }else{
                        str+="<option value="+value.sid+">"+value.cname+"</option>";
                    }
                })
            },
            error: function (msg) {
                alert("系统繁忙");
                return;
            }
        });
        return str;
    }

    /**
     * 提交的时候将select中value的值改变成Text值
     */
    function submitEditAddress(){
        $("#province option:selected").val($("#province option:selected").text());
        $("#city option:selected").val($("#city option:selected").text());
        $("#area option:selected").val($("#area option:selected").text());
        var $form = $('#editAddress');

        $form.submit(function () {
            if ($form.valid()) {
                var data = $form.formJSON('get');
                if ($('#province option:selected').text() == "请选择") {
                    showInfoFun('请选择一个省。', 'warning');
                    return false;
                }
                if ($('#city option:selected').text() == "请选择") {
                    showInfoFun('请选择一个市。', 'warning');
                    return false;
                }
                if ($('#area option:selected').text() == "请选择") {
                    showInfoFun('请选择一个区。', 'warning');
                    return false;
                }
                $("#submitButton").attr("disabled",true);
            }

            return true;
        });
        $("#editAddress").submit();
    }
</script>
</body>
</html>