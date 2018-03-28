package com.cqzg168.scm.reseller.shiro.freemarker;

import org.apache.shiro.subject.Subject;

/**
 * 等同于 {@link org.apache.shiro.web.tags.HasAnyRolesTag}
 * Created by jackytsu on 2017/3/17.
 */
public class HasAnyRolesTag extends RoleTag {
    private static final String ROLE_NAMES_DELIMETER = ",";

    protected boolean showTagBody(String roleNames) {
        boolean hasAnyRole = false;
        Subject subject    = getSubject();

        if (subject != null) {
            // Iterate through roles and check to see if the user has one of the roles
            for (String role : roleNames.split(ROLE_NAMES_DELIMETER)) {
                if (subject.hasRole(role.trim())) {
                    hasAnyRole = true;
                    break;
                }
            }
        }

        return hasAnyRole;
    }
}
