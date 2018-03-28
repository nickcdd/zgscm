package com.cqzg168.scm.reseller.shiro.freemarker;

/**
 * 等同于 {@link org.apache.shiro.web.tags.AuthenticatedTag}
 * Created by jackytsu on 2017/3/17.
 */
public class LacksRoleTag extends RoleTag {
    protected boolean showTagBody(String roleName) {
        boolean hasRole = getSubject() != null && getSubject().hasRole(roleName);
        return !hasRole;
    }
}
