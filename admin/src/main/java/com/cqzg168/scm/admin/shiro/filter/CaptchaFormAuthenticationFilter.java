package com.cqzg168.scm.admin.shiro.filter;

import com.cqzg168.scm.admin.shiro.exception.IncorrectCaptchaException;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.apache.shiro.web.util.SavedRequest;
import org.apache.shiro.web.util.WebUtils;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 * Created by jackytsu on 2017/4/28.
 */
public class CaptchaFormAuthenticationFilter extends FormAuthenticationFilter {

    // 验证码校验
    protected void doCaptchaValidate(HttpServletRequest request, AuthenticationToken token) {

        String captchaFromSession = (String) request.getSession().getAttribute(Constant.SessionKey.CAPTCHA);
        String captchaFromRequest = WebUtils.getCleanParam(request, "captcha");

        if (captchaFromRequest != null && !captchaFromSession.equalsIgnoreCase(captchaFromRequest)) {
            throw new IncorrectCaptchaException("验证码错误！");
        }
    }

    // 认证
    @Override
    protected boolean executeLogin(ServletRequest request, ServletResponse response) throws Exception {
        SavedRequest savedRequest = WebUtils.getSavedRequest(request);
        if (savedRequest != null) {
            String url = savedRequest.getRequestUrl();
            if (!Utils.isEmpty(url) && url.equals("/error")) {
                WebUtils.getAndClearSavedRequest(request);
            }
        }

        AuthenticationToken token = createToken(request, response);

        try {
            doCaptchaValidate((HttpServletRequest) request, token);

            Subject subject = getSubject(request, response);
            subject.login(token);

            return onLoginSuccess(token, subject, request, response);
        } catch (AuthenticationException e) {
            return onLoginFailure(token, e, request, response);
        }
    }
}
