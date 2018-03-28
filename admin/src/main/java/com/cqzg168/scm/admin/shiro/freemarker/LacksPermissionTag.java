package com.cqzg168.scm.admin.shiro.freemarker;

/**
 * 等同于 {@link org.apache.shiro.web.tags.LacksPermissionTag}
 * Created by jackytsu on 2017/3/17.
 */
public class LacksPermissionTag extends PermissionTag {
    protected boolean showTagBody(String p) {
        return !isPermitted(p);
    }
}
