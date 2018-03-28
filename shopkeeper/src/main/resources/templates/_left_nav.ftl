<aside class="main-sidebar">
    <section class="sidebar">
    <#assign USER = VIEW_UTILS.getSessionAttribute(SESSION_KEY.CURRENT_USER) />
        <div class="user-panel">
            <div class="pull-left image">
            <#if USER.avatar ?? && USER.avatar != ''>
                <img src="${USER.avatar!''}" class="img-circle" />
            <#else >
                <img src="/assets/img/head/deficiency_head.jpg" class="img-circle" />
            </#if>
            </div>
            <div class="pull-left info">
                <p style="width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                <#if USER.cname ??>
                        ${USER.cname!''}
                    </#if>
                </p>
            </div>
            <div style="clear:both; height: 15px;">&nbsp;</div>
        </div>
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
                    <a href="${m.url!''}"><i class="${m.icon!''}"></i><span>${m.cname!''}</span></a>
                    <#include "_left_nav_children.ftl" />
                </li>
            </@shiro.hasPermission>
        </#list>
        </ul>
    </section>
</aside>
