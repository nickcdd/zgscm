<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
</head>
<body>
<div class="row">
    <div class="col-xs-12">
        <div class="box box-primary">
            <div class="box-header with-border">
                <div>
                    <div style="width: 85%;float: left;"><span>添加收货地址</span></div>
                    <div style="width: 15%;float: left;"><a href="javascript:history.go(-1)">返回</a></div>
                </div>
            </div>
            <div class="box-body">
                <form id="addAddress" action="/receivingAddress/save" method="post" data-toggle="validator" role="form" >
                    <div style="height: 50px;">
                        <div style="width: 25%;float: left;">
                            <p class="" style="margin-top:10%">省　　份:</p>
                        </div>
                        <div style="width: 75%;float: left;">
                            <select style="min-width: 100px;" name="province" id="province" class="form-control" onchange="loadCityContent($('#province option:selected').val(),$('#province option:selected').text())">
                            </select>
                        </div>
                    </div>
                    <div style="height: 50px;">
                        <div style="width: 25%;float: left;">
                            <p class="" style="margin-top:10%">市　　区:</p>
                        </div>
                        <div style="width: 75%;float: left;">
                            <select style="min-width: 100px;" name="city" id="city" class="form-control" onchange="loadAreaContent($('#city option:selected').val(),$('#city option:selected').text())">
                            </select>
                        </div>
                    </div>
                    <div style="height: 50px;">
                        <div style="width: 25%;float: left;">
                            <p class="" style="margin-top:10%">区　　县:</p>
                        </div>
                        <div style="width: 75%;float: left;">
                            <select style="min-width: 100px;" name="area" id="area" class="form-control">
                            </select>
                        </div>
                    </div>

                    <div style="height: 50px;">
                        <div style="width: 25%;float: left;">
                            <p class="" style="margin-top:20%">详细地址:</p>
                        </div>
                        <div style="width: 75%;float: left;">
                            <input id="address" name="address" class="form-control" type="text" >

                        </div>
                    </div>
                    <div style="height: 50px;">
                        <div style="width: 25%;float: left;">
                            <p class="" style="margin-top:15%">收货人:</p>
                        </div>
                        <div style="width: 75%;float: left;">
                            <input id="name" name="name" class="form-control" type="text">

                        </div>
                    </div>
                    <div style="height: 50px;">
                        <div style="width: 25%;float: left;">
                            <p class="" style="margin-top:15%">电话号码:</p>
                        </div>
                        <div style="width: 75%;float: left;">
                            <input id="telephone" onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')" name="telephone" class="form-control" type="text"  >

                        </div>
                    </div>
                    <div style="height: 50px;">
                        <div>
                            <input name="isDefault" type="checkbox" value="1"><span style="margin-left:5%;" >设为默认地址</span>
                        </div>
                    </div>
                    <div style="height: 50px;">
                        <div>
                            <button id="submitButton" onclick="submitAddAddress()" type="button" class="btn btn-primary btn-block">确认</button>　　
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(function() {
        var provinceText = $("#province option:selected").text();
        /**
         * 初始化加载省
         */
        $("#province").html("<option selected='selected'>请选择</option>"+getNextLevelArea(1, provinceText));

    });

    /**
     * 加载市
     */
    function loadCityContent(sid, flag){
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
        if("请选择" == flag){
            return str;
        }
        $.ajax({
            type: "GET",
            async: false,
            url : "/area",
            data: {'sid' : sid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                $.each(result.record,function (index,value) {
                    str+="<option value="+value.sid+">"+value.cname+"</option>";
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
    function submitAddAddress(){
        $("#province option:selected").val($("#province option:selected").text());
        $("#city option:selected").val($("#city option:selected").text());
        $("#area option:selected").val($("#area option:selected").text());
        var $form = $('#addAddress');
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
                if($('#address').val() == ""){
                    showInfoFun('请填写详细地址', 'warning');
                    return false;
                }
                if($('#name').val() == ""){
                    showInfoFun('请填写收货人姓名', 'warning');
                    return false;
                }
                if($('#telephone').val() == ""){
                    showInfoFun('请填写电话号码', 'warning');
                    return false;
                }
                $("#submitButton").attr("disabled",true);
            }
            return true;
        });
        $("#addAddress").submit();
    }
</script>

</body>
</html>