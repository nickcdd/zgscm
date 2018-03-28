package com.cqzg168.scm.supplier.shiro.freemarker;

/**
 * 等同于 {@link org.apache.shiro.web.tags.HasRoleTag}
 * Created by jackytsu on 2017/3/17.
 */
public class HasRoleTag extends RoleTag {
    protected boolean showTagBody(String roleName) {
        return getSubject() != null && getSubject().hasRole(roleName);
    }
}
