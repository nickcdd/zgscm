package com.cqzg168.scm.reseller.util;

import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;

/**
 * Created by jackytsu on 2017/5/2.
 */
public class ViewUtils {

    /**
     * 获取 Session 属性
     *
     * @param key
     * @return
     */
    public static Object getSessionAttribute(String key) {
        Session session = SecurityUtils.getSubject().getSession();
        Object  attr    = session.getAttribute(key);
        if (!Utils.isNull(attr)) {
            return session.getAttribute(key);
        } else {
            return "";
        }
    }
}
