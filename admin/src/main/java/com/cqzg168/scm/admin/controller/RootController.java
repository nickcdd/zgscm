package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.utils.Constant;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;

/**
 * 根路径 Controller
 * Created by jackytsu on 2017/3/14.
 */
@RequestMapping("/")
@Controller
public class RootController extends BaseController {

    /**
     * 首页
     *
     * @return
     */
    @RequestMapping({"/", "/index"})
    public String index() {

        return "/index";
    }

    /**
     * 登录页
     *
     * @param response
     * @return
     */
    @RequestMapping(value = "/login")
    public String login(HttpServletResponse response) {
        if (getSession() != null && getSession().getAttribute(Constant.SessionKey.CURRENT_USER) != null) {
            return "redirect:/index";
        }

        String acceptHeader = getRequest().getHeader("accept");
        String requestedWith = getRequest().getHeader("X-Requested-With");

        if (acceptHeader.indexOf("application/json") > -1 || (requestedWith != null && requestedWith.indexOf("XMLHttpRequest") > -1)) {
            Writer out = null;
            try {
                response.setCharacterEncoding("UTF-8");
                response.setContentType("application/json; charset=utf-8");
                out = response.getWriter();
                out.write(AjaxResult.ajaxFailResult("401", "尚未登录，或者登录超时！").toString());
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (out != null) {
                    try {
                        out.close();
                    } catch (Exception e) {
                    }
                }
            }
            return null;
        }

        Object shiroLoginFailureObj = getRequest().getAttribute("shiroLoginFailure");
        if (shiroLoginFailureObj != null) {
            String shiroLoginFailure = String.valueOf(shiroLoginFailureObj);
            switch (shiroLoginFailure) {
                case "org.apache.shiro.authc.IncorrectCredentialsException":
                    getRequest().setAttribute("ERROR_MESSAGE", "用户名或者密码错误");
                    break;
                case "org.apache.shiro.authc.DisabledAccountException":
                    getRequest().setAttribute("ERROR_MESSAGE", "当前用户已被系统禁用");
                    break;
                case "com.cqzg168.scm.admin.shiro.exception.IncorrectCaptchaException":
                    getRequest().setAttribute("ERROR_MESSAGE", "请输入正确的验证码");
                    break;
                default:
                    getRequest().setAttribute("ERROR_MESSAGE", "登录发生错误，请与管理员联系");
                    break;
            }
        }

        return "/login";
    }
}
