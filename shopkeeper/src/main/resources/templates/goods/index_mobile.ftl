<!DOCTYPE html>
<html>
<head>
<#include "../_head_with_datepicker.ftl" />
    <script src="/assets/js/jquery.visible.min.js"></script>
    <style>
        .nowrap {
            overflow: hidden;
            white-space: nowrap;
            -o-text-overflow: ellipsis;
            text-overflow: ellipsis;
        }

        .hideClass {
            display: none;
        }

        .showClass {
            display: inline;
        }

        .pecificationsDefaultUp {
            border: 1px solid #fc5b01;
            color: #fff;
            background: #fc5b01;
            padding: 2%;
            margin: 0 3% 2% 0;
            display: inline-block
        }

        .pecificationsDefault {
            border: 1px solid #fc5b01;
            color: #666;
            padding: 2%;
            margin: 0 3% 2% 0;
            display: inline-block
        }

        .space {
            white-space: normal;
        }

        .footer_fixed {
            position: fixed;
            z-index: 1000;
            bottom: 51px;
            left: 0;
            right: 0;
            height: 60px;
            background: #00a65a;
        }

        .bg {
            display: none;
            position: absolute;
            top: 0%;
            left: 0%;
            width: 100%;
            height: 100%;
            background-color: black;
            z-index: 1001;
            -moz-opacity: 0.6;
            opacity: .60;
            filter: alpha(opacity=60);
        }

        .loading {
            position: absolute;
            top: 40%;
            left: 60%;
            margin-left: -75px;
            text-align: center;
            line-height: 25px;
            font-size: 12px;
            font-weight: bold;
            color: #F00;
            z-index: 1002;
        }

        .container-wrapper {
            position: absolute;
            left: 0;
            right: 0;
            top: 50px;
            bottom: 111px;
            overflow: hidden;
        }

        .container-left {
            width: 100px;
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            overflow: auto;
            background: #ffffff;
        }

        .container-left a {
            color: #444;
        }

        .container-left li:hover > a.children_goodsCategorys {
            background: #fff !important;
        }

        .container-left .menu-item-cate.active {
            color: #fc5b01 !important;
        }

        .container-right {
            position: absolute;
            left: 100px;
            right: 0;
            top: 0;
            bottom: 0;
            overflow: auto;
            padding: 15px;
        }

    </style>
</head>
<body>
<div class="footer_fixed">
    <div style="width: 35%; float: left;line-height: 30px;padding: 0 0 0 5%">
        <div>
            <span style="font-weight: bold;color: #FFFFFF">已选 <strong id="totalCount" style="color: #f1a417;">${totalCount}</strong> 件商品</strong></span>
        </div>
        <div>
            <span style="font-size: 20px;color: #f1a417;">￥ <span id="totalPrice">#{totalPrice;m2M2}</span></span>
        </div>
    </div>
    <div style="width: 60%; float: left;line-height: 60px;text-align: right">
        <a href="/shoppingCart/index" class="btn btn-default ">确认订单</a>
    </div>
</div>
<div id="bg" class="bg" style="background-image: url('/assets/img/bankImg/ABC.png');background-repeat:no-repeat;background-position:center top">
    <img src="/assets/img/await.jpg" class="loading">
</div>

<div class="container-wrapper">
    <div class="container-left">

        <ul class="sidebar-menu tree" data-widget="tree">
        <#if goodsCategories ??>
            <#list goodsCategories as goodsCategorie>
                <li class="treeview">
                    <a class="children_goodsCategorys" data-sid="${goodsCategorie.sid?c}" href="javascript:void(0);">
                        <span class="space">${goodsCategorie.cname}</span>
                    </a>
                    <ul class="treeview-menu">
                    </ul>
                </li>
            </#list>
        </#if>
        </ul>
    </div>

    <div class="container-right">
        <div style="width: 100%;text-align: center">
            <a class="hospitaltitel-center next_first" disabled="disabled" href="javascript: void(0);">数据加载中……</a>
        </div>
        <div class="record_content" id="record_ul_first"></div>
    </div>

</div>

<div class="modal fade" id="modal_specification" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="myModalLabel"></h4>
            </div>
            <div class="modal-body">
                <p>规格：</p>
                <div id="modelContentSpicification"></div>
                <div style="padding: 5%;">
                    <div id="modelPrice" style="width: 50%;text-align: left;float: left">
                    </div>
                    <div id="modelClickAddSubtract" style="width: 50%;text-align: right;float: left">
                        <i class="glyphicon glyphicon-minus"></i>
                        <span> 1 </span>
                        <i class="glyphicon glyphicon-plus"></i>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" onclick="modalSubmitInventoryExamine(this)">确认</button>
            </div>
        </div>
    </div><!-- /.modal -->
</div>

<script>
    var checkImgFun = function (img) {
        var checkImg = function (img) {
            if (img.naturalHeight <= 1 && img.naturalWidth <= 1) {
                img.src = '/assets/img/goods/img-goods-default.png';
            }
        };

        try {
            if (img.complete) {
                checkImg(img);
            } else {
                $(img).load(function () {
                    checkImg(this);
                }).error(function () {
                    this.src = '/assets/img/goods/img-goods-default.png';
                });
            }
        } catch (e) {
        }
    };

    $(document).on('click', '.but-subtract-click', function () {
        var goodsCount = $(this).next(".goods_count").html();
        goodsCount = parseInt(goodsCount);
        goodsCount = goodsCount - 1;
        $(this).next(".goods_count").html(goodsCount);
        hideClass(this);
        var pecificationsSid = $(this).data('sid');
        var subtractflag = "subtractflag";
        inventory(pecificationsSid, 1, subtractflag, goodsCount, this);
    });
    $(document).on('click', '.but-add-click', function () {
        var goodsCount = $(this).parent().children(".goods_count").html();
        goodsCount = parseInt(goodsCount);
        var pecificationsSid = $(this).data('sid');
        var addFlag = "addflag";
        inventory(pecificationsSid, 1, addFlag, goodsCount, this);
    });

    function hideClass(obj) {
        var goodsCount = $(obj).next(".goods_count").html();
        goodsCount = parseInt(goodsCount, 10);
        if (goodsCount != 0) {
            $(obj).parent().children(".hideClass").addClass("showClass").removeClass("hideClass");
        } else {
            $(obj).parent().children(".showClass").addClass("hideClass").removeClass("showClass");
        }
        $("#bg").css('display', 'none');
    }

    $(document).on('click', '.modal-but-subtract-click', function () {
        var goodsCount = $(this).next(".goods_count").html();
        goodsCount = parseInt(goodsCount);
        goodsCount = goodsCount - 1;
        var specificationSid = $(this).data('sid');
        modalSessionSpecificationCount(specificationSid, goodsCount);
        $(this).parent().children(".goods_count").html(goodsCount);
        hideClass(this);
    });
    $(document).on('click', '.modal-but-add-click', function () {
        var goodsCount = $(this).parent().children(".goods_count").html();
        goodsCount = parseInt(goodsCount);
        goodsCount = goodsCount + 1;
        var specificationSid = $(this).data('sid');
        modalSessionSpecificationCount(specificationSid, goodsCount);
        $(this).parent().children(".goods_count").html(goodsCount);
        hideClass(this);
    });
    function modalSessionSpecificationCount(specificationSid, count) {
        $.ajax({
            type: "GET",
            url: "/goods/sessionSpecificationCount",
            data: {'specificationSid': specificationSid, 'count': count},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
            },
            error: function (msg) {
                alert("系统繁忙");
            }
        });
    }

    function modalSubmitInventoryExamine(obj) {
        $(obj).attr('disabled', true);
        $.ajax({
            type: "GET",
            url: "/goods/submitInventoryExamine",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                if (result.msg == 'true') {
                    $("#totalCount").html(result.record.totalCount);
                    $("#totalPrice").html(result.record.totalPrice);
                    $(obj).attr('disabled', false);
                    $("#modal_specification").modal('hide');
                } else {
                    $(obj).attr('disabled', false);
                    alert(result.record)
                }
            },
            error: function (msg) {
                alert("系统繁忙");
            }
        });
    }

    //获取库存
    var inventory = function (pecificationsSid, goodsAmount, addFlag, goodsCountTemp, obj) {
        var str = 0;
        $.ajax({
            type: "GET",
            url: "/goods/queryInventory",
            data: {
                'pecificationsSid': pecificationsSid,
                'goodsAmount': goodsAmount,
                'addFlag': addFlag,
                'goodsCountTemp': goodsCountTemp
            },
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                str = result.record.inventory;
                if (addFlag == 'addflag') {
                    if (goodsCountTemp > str || goodsCountTemp == str) {
                        alert("该商品库存不足");
                        return false;
                    }
                    goodsCountTemp = goodsCountTemp + 1;
                    $(obj).parent().children(".goods_count").html(goodsCountTemp);
                    hideClass(obj);
                }
                $("#totalCount").html(result.record.totalCount);
                $("#totalPrice").html(result.record.totalPrice);

            },
            error: function (msg) {
                alert("系统繁忙");
            }
        });
        return str;
    }

    function modelPecification(goodsSid) {
        var strSpicification = '';
        var strPrice = '';
        var modalLabel = '';
        var modelClickAddSubtract = '';
        $.ajax({
            type: "GET",
            url: "/goods/querySpecification",
            data: {'goodsSid': goodsSid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                var flag = 'false';
                var goodsAmount = 0;
                modalLabel = result.record.goods.cname;
                $.each(result.record.goods.goodsSpecifications, function (index, value) {
                    if (index == 0) {
                        var tempPrice = parseFloat(value.price);
                        tempPrice = tempPrice.toFixed(2);
                        strPrice += "<span class='text-red' style='font-size: 18px;'>￥" + tempPrice + "</span>";
                        strSpicification += "<div class='pecificationsDefaultUp'><span data-sid='" + value.sid.toString() + "'>" + value.cname + "</span></div>"
                        $.each(result.record.shopKeeperCards, function (indexN, valueN) {
                            if (valueN.goodsSpecification.sid == value.sid) {
                                flag = 'true';
                                goodsAmount = valueN.goodsAmount;
                            }
                        });
                        if (flag == 'true') {
                            modelClickAddSubtract += "<i class='glyphicon glyphicon-minus showClass modal-but-subtract-click' data-sid='" + value.sid.toString() + "'></i>&nbsp;";
                            modelClickAddSubtract += "<span class='showClass goods_count'>" + goodsAmount + "</span>&nbsp;";
                            modelClickAddSubtract += "<i class='glyphicon glyphicon-plus modal-but-add-click' data-sid='" + value.sid.toString() + "'></i>";
                        } else {
                            modelClickAddSubtract += "<i class='glyphicon glyphicon-minus hideClass modal-but-subtract-click' data-sid='" + value.sid.toString() + "'></i>&nbsp;";
                            modelClickAddSubtract += "<span class='hideClass goods_count'>0</span>&nbsp;";
                            modelClickAddSubtract += "<i class='glyphicon glyphicon-plus modal-but-add-click' data-sid='" + value.sid.toString() + "'></i>";
                        }

                    } else {
                        strSpicification += "<div class='pecificationsDefault'><span data-sid='" + value.sid.toString() + "'>" + value.cname + "</span></div>"
                    }
                });
                $("#modelContentSpicification").html(strSpicification);
                $("#modelPrice").html(strPrice);
                $("#myModalLabel").html(modalLabel);
                $("#modelClickAddSubtract").html(modelClickAddSubtract);
                $("#modal_specification").modal('show');
            },
            error: function (msg) {
                alert("系统繁忙");
            }
        });
    }

    //多个规格的改变价格
    function changePrice(speicificationSid, obj) {
        var modelClickAddSubtract = '';
        $.ajax({
            type: "GET",
            url: "/goods/changeGooodsPrice",
            data: {'speicificationSid': speicificationSid},
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                var speicification = result.record.goodsSpecification;
                var tempPrice = parseFloat(speicification.price);
                tempPrice = tempPrice.toFixed(2);
                $("#modelPrice").html("<span class='text-red' style='font-size: 18px;'>￥" + tempPrice + "</span>");
                var flag = 'false';
                var goodsAmount = 0;
                $.each(result.record.shopKeeperCards, function (indexN, valueN) {
                    if (valueN.goodsSpecification.sid == speicification.sid) {
                        flag = 'true';
                        goodsAmount = valueN.goodsAmount;
                    }
                });
                if (flag == 'true') {
                    modelClickAddSubtract += "<i class='glyphicon glyphicon-minus showClass modal-but-subtract-click' data-sid='" + speicification.sid.toString() + "'></i>&nbsp;";
                    modelClickAddSubtract += "<span class='showClass goods_count'>" + goodsAmount + "</span>&nbsp;";
                    modelClickAddSubtract += "<i class='glyphicon glyphicon-plus modal-but-add-click' data-sid='" + speicification.sid.toString() + "'></i>";
                } else {
                    modelClickAddSubtract += "<i class='glyphicon glyphicon-minus hideClass modal-but-subtract-click' data-sid='" + speicification.sid.toString() + "'></i>&nbsp;";
                    modelClickAddSubtract += "<span class='hideClass goods_count'>0</span>&nbsp;";
                    modelClickAddSubtract += "<i class='glyphicon glyphicon-plus modal-but-add-click' data-sid='" + speicification.sid.toString() + "'></i>";
                }
                $("#modelClickAddSubtract").html(modelClickAddSubtract);
                $(".pecificationsDefaultUp").removeClass("pecificationsDefaultUp").addClass("pecificationsDefault");
                $(obj).removeClass("pecificationsDefault").addClass("pecificationsDefaultUp");
            },
            error: function (msg) {
                alert("系统繁忙");
            }
        });
    }

    $(function () {
        $(document).on('click', '.pecificationsDefault', function () {
            var speicificationSid = $(this).children().data('sid');
            changePrice(speicificationSid, this);
        });

        $(document).on('click', '.menu-item-cate', function () {
            if ($(this).hasClass('active')) {
                return false;
            }
            $('.menu-item-cate.active').removeClass('active');
            $(this).addClass('active');

            $('#record_ul_first').load('page', {
                categorySid: $(this).data('sid'),
            }, function () {
                $('a.next_first').remove();
            });
        });

        $(document).on('click', '.children_goodsCategorys', function () {
            var $t = $(this), sid = $t.data('sid');
            if ($t.next().children().length == 0) {

                $.get('/goods/getChildrenGoodsCategorys', {
                    parentSid: sid
                }, function (result) {
                    if (result.success) {
                        var html = [];
                        $.each(result.record, function (i, v) {
                            html.push('<li><a class="menu-item-cate" href="javascript:void(0);" data-sid="', v.sid, '" >', v.cname, '</a></li>');
                        });

                        $('.treeview-menu').hide();
                        $t.next('.treeview-menu').html(html.join('')).show().find('.menu-item-cate:first').click();
                    }
                });
            } else {
                $('.treeview-menu').hide();
                $t.next('.treeview-menu').show().find('.menu-item-cate:first').click();
            }
        });

        $('.children_goodsCategorys:first').click();

        $('.container-right').scroll(function () {
            var $link = $('a.next');
            if ($link.length > 0 && $link.visible(true)) {
                var sid = $link.data('sid'), nextPage = $link.data('page');
                if ($link.data('disabled')) {
                    return false;
                }
                $link.data('disabled', true).children().text('数据加载中... ...');
                $('a.next').next('.record_content').load('page', {
                    categorySid: sid,
                    page: nextPage
                }, function () {
                    $link.remove();
                });
            }
        });
    });
</script>
</body>
</html>