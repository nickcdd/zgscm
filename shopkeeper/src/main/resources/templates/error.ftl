<!DOCTYPE html>
<html>
<head>
<#include "_head.ftl" />
    <title>出错了！</title>
    <style type="text/css">
        pre {
            word-wrap: break-word;
            word-break: break-all;
            white-space: pre-wrap;
            margin-top: 40px;
        }
    </style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<#if status??>
    <#switch status>
        <#case 404>
            <#assign icon="aqua" />
            <#assign error="该页面没找到！" />
            <#break>
        <#case 401>
            <#assign icon="yellow" />
            <#assign error="你没有访问该页面的权限！" />
            <#break>
        <#case 403>
            <#assign icon="yellow" />
            <#assign error="你没有访问该页面的权限！" />
            <#break>
        <#default>
            <#assign icon="red" />
            <#assign error="系统出错了！" />
    </#switch>
<#else>
    <#assign icon="red" />
    <#assign error="系统出错了！" />
</#if>
<div class="wrapper">
    <div class="content-wrapper" style="margin: 0 auto; padding: 0 10%;">
        <!-- Main content -->
        <section class="content">
            <div class="error-page" style="width: 100%;">
                <h2 style="float: none; text-align: center;" class="headline text-${icon}">${status!'500'}</h2>
                <div class="error-content" style="margin-left: 0;">
                    <h3 style="text-align: center;">
                        <i class="fa fa-warning text-${icon}"></i> ${error}
                    </h3>
                    <p class="text-center"><a href="javascript: history.back();">返回上一页</a></p>
                <#if DEBUG_MODE>
                    <pre><p>异常名称：<b>${exception!""}</b></p>${message!""}</pre>
                </#if>
                </div>
            </div>
            <!-- /.error-page -->
        </section>
    </div>
</div>
</body>
</html>