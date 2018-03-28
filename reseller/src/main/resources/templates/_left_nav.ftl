<aside class="main-sidebar">
    <section class="sidebar">

    <#assign USER = VIEW_UTILS.getSessionAttribute(SESSION_KEY.CURRENT_USER) />

        <div class="user-panel">
            <div class="pull-left image">
            <#if USER.avatar ??>
                <img src="${USER.avatar!''}" class="img-circle" />
            <#else >
                <img src="" class="img-circle" />
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
    </section>
</aside>
