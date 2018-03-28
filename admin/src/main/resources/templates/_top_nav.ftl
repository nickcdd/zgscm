<header class="main-header">

    <!-- Logo -->
    <a href="/" class="logo">
        <span class="logo-mini"><b>正格集采</b></span>
        <span class="logo-lg"><b>正格集采平台</b></span>
    </a>

    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
        <!-- Sidebar toggle button-->
        <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">切换导航</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </a>

        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
            <#if Session?? && Session[SESSION_KEY.CURRENT_USER]??>
                <#assign user=Session[SESSION_KEY.CURRENT_USER] />
                <li class="dropdown notifications-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="fa fa-user-o"></i>
                        <span class="hidden-xs">${user.cname!""}</span>
                    </a>
                    <ul class="dropdown-menu" style="width: 140px!important; min-width: 140px!important; height: 124px!important;">
                        <li>
                            <ul class="menu text-center">
                                <li>
                                    <a href="/personInfo/baseInfo"><i class="fa fa-fw fa-pencil-square-o"></i> 个人信息</a>
                                </li>
                                <li>
                                    <a href="/personInfo/password"><i class="fa fa-fw fa-lock"></i> 修改密码</a>
                                </li>
                                <li>
                                    <a href="/logout"><i class="fa fa-fw fa-sign-out"></i> 注　　销</a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </li>
            </#if>
            </ul>
        </div>
    </nav>
</header>
