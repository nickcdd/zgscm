package com.cqzg168.scm.admin.shiro.freemarker;

import freemarker.template.ObjectWrapper;
import freemarker.template.SimpleHash;

/**
 * Shiro 集成 Freemarker 标签
 * Created by jackytsu on 2017/3/17.
 */
public class ShiroTags extends SimpleHash {

    public ShiroTags(ObjectWrapper wrapper) {
        super(wrapper);

        put("authenticated", new AuthenticatedTag());
        put("guest", new GuestTag());
        put("hasAnyRoles", new HasAnyRolesTag());
        put("hasPermission", new HasPermissionTag());
        put("hasRole", new HasRoleTag());
        put("lacksPermission", new LacksPermissionTag());
        put("lacksRole", new LacksRoleTag());
        put("notAuthenticated", new NotAuthenticatedTag());
        put("principal", new PrincipalTag());
        put("user", new UserTag());
    }
}
