/**
 * Created by Administrator on 2017/5/9 0009.
 */

$(function () {

    jQuery.validator.addMethod("checkCname", function(value, element) {
        var flag = 1;
        var sid=$('#sid').val();
        $.ajax({
            type:"POST",
            url:'/goods/goodsCategory/findCategoryByCname',
            async:false,
            data:{'cname':value,"sid":sid},
            success: function(result){
                if(result.success){
                    flag = 1;
                }else{
                    flag = 0;
                }
            }
        });

        if(flag == 0){
            return false;
        }else{
            return true;
        }

    }, "类别名称已存在");

});
