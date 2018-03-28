<#if CHILDREN?? && (CHILDREN?size > 0) >
<ul class="treeview-menu">
    <#assign MENU=CHILDREN />
    <#list MENU as m>
        <@shiro.hasPermission name=m.permission!''>
            <#assign CHILDREN=m.children />
            <#if CHILDREN?? && (CHILDREN?size > 0) >
                <#assign cls="treeview" />
                <#assign arrow="<i class='fa fa-angle-left pull-right'></i>" />
            <#else>
                <#assign cls="" />
                <#assign arrow="" />
            </#if>
            <li class="${cls!''}">
                <a href="${m.url!''}"><i class="${m.icon!''}"></i><span>${m.cname}</span>${arrow}</a>
                <#include "_left_nav_children.ftl" />
            </li>
        </@shiro.hasPermission>
    </#list>
</ul>
</#if>