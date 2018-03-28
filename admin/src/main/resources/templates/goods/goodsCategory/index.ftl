<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
    <link href="/assets/css/tree.css" rel="stylesheet"/>
    <meta name="nav-url" content="/goods/goodsCategory/index">
    <script src="/assets/js/goods/goodsCategory/index.js"></script>
<style type="text/css">
    div.tree {height:500px;overflow-y:scroll;overflow-x:auto;}

</style>
</head>
<body>
<div class="row">
    <div class="col-md-5">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">商品类别</h3>
            </div>
            <div class="box-body">
                <div class="box-header">
                    <button type="button" class="btn btn-info pull-right btn-add"><i class="fa  fa-plus"></i>新增</button>

                </div>

                <div class="row">
                    <div class="col-md-12">

                        <div class="tree" id="myTree">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<#include "/goods/goodsCategory/detail.ftl" />

</div>
</body>
</html>