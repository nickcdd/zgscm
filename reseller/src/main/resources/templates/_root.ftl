<!DOCTYPE html>
<html>
<head>
<#include "_head.ftl" />
    <title>正格集采平台</title>
    <sitemesh:write property='head' />
</head>
<body class="hold-transition skin-yellow-light sidebar-mini fixed">
<div class="wrapper">
    <!-- Main Header -->
<#include "_top_nav.ftl" />
    <!-- Left side column. contains the logo and sidebar -->
<#include "_left_nav.ftl" />

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Main content -->
        <section class="content">
            <sitemesh:write property='body' />
            <!-- Your Page Content Here -->
        </section>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    <!-- Main Footer -->
<#include "_foot.ftl" />
</div>
<!-- ./wrapper -->

<#include "_flash.ftl" />
</body>
</html>