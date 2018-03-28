package com.cqzg168.scm.supplier.controller;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;

/**
 * Controller 基类
 * Created by jackytsu on 2017/3/14.
 */
public class BaseController {
    /**
     * 请求
     */
    @Autowired
    private HttpServletRequest request;

    protected HttpServletRequest getRequest() {
        return request;
    }

    /**
     * 获取当前会话
     *
     * @return
     */
    protected Session getSession() {
        return SecurityUtils.getSubject().getSession();
    }
}
