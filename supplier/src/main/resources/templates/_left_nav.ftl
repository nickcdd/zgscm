<aside class="main-sidebar">
    <section class="sidebar">
        <ul class="sidebar-menu">
        <#assign MENU=NAV_MENUS />
        <#list MENU as m>
            <@shiro.hasPermission name=m.permission!''>
                <#assign CHILDREN=m.children />
                <#if CHILDREN?? && (CHILDREN?size > 0) >
                    <#assign cls="treeview" />
                <#else>
                    <#assign cls="" />
                </#if>
                <li class="${cls!''}">
                    <a href="${m.url!''}"><i class="${m.icon!''}"></i><span>${m.cname!''}</span><i class="fa fa-angle-right pull-right"></i></a>
                    <#include "_left_nav_children.ftl" />
                </li>
            </@shiro.hasPermission>
        </#list>
        </ul>
    </section>
</aside>
