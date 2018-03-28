<aside class="main-sidebar">
    <section class="sidebar">
        <ul class="sidebar-menu">
        <#assign MENU=NAV_MENUS />
        <#list MENU as m>
            <@shiro.hasPermission name=m.permission!''>
                <#assign CHILDREN=m.children />
                <#if CHILDREN?? && (CHILDREN?size > 0) >
                    <#assign cls="treeview" />
                    <li class="menu-first ${cls!''}">
                        <a href="${m.url!''}"><i class="${m.icon!''}"></i><span>&nbsp;${m.cname!''}</span><i class="fa fa-angle-right pull-right"></i></a>
                        <#include "_left_nav_children.ftl" />
                    </li>
                </#if>
            </@shiro.hasPermission>
        </#list>
        </ul>
    </section>
</aside>
<script>
    $('.main-sidebar ul.treeview-menu').each(function () {
        var $t = $(this);
        if ($('li', $t).length === 0) {
            $t.parents('.menu-first').remove();
        }
    });
</script>
