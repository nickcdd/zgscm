package com.cqzg168.scm.interceptor;

import com.cqzg168.scm.annotation.AvoidDuplicateSubmit;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.util.UUID;

/**
 * Created by jackytsu on 2017/5/23.
 */
public class AvoidDuplicateSubmitInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        if (handler instanceof HandlerMethod) {
            HandlerMethod        handlerMethod = (HandlerMethod) handler;
            Method               method        = handlerMethod.getMethod();
            AvoidDuplicateSubmit annotation    = method.getAnnotation(AvoidDuplicateSubmit.class);

            if (annotation != null) {
                String url = "/";
                if (!Utils.isNull(request.getHeader("referer"))) {
                    url = request.getHeader("referer");
                }

                if (url.contains("?")) {
                    url += "&ERROR_MESSAGE=";
                } else {
                    url += "?ERROR_MESSAGE=";
                }

                boolean needSaveSession = annotation.needSaveToken();
                if (needSaveSession) {
                    String uuid = UUID.randomUUID().toString();
                    request.getSession(false).setAttribute(Constant.SessionKey.FORM_TOKEN, uuid);

                    Cookie cookie = new Cookie(Constant.SessionKey.FORM_TOKEN, uuid);
                    cookie.setMaxAge(-1);
                    response.addCookie(cookie);
                }

                boolean needRemoveSession = annotation.needRemoveToken();
                if (needRemoveSession) {
                    String tokenFromSession = (String) request.getSession(false).getAttribute(Constant.SessionKey.FORM_TOKEN);
                    String tokenFromCookie  = null;

                    request.getSession(false).removeAttribute(Constant.SessionKey.FORM_TOKEN);

                    for (Cookie cookie : request.getCookies()) {
                        if (cookie.getName().equals(Constant.SessionKey.FORM_TOKEN)) {
                            tokenFromCookie = cookie.getValue();
                        }
                    }

                    if (Utils.isEmpty(tokenFromSession) || Utils.isEmpty(tokenFromCookie)) {
                        url += URLEncoder.encode("请勿重复提交表单。", "UTF-8");
                        response.sendRedirect(url);
                        return false;
                    }

                    if (!tokenFromCookie.equals(tokenFromSession)) {
                        url += URLEncoder.encode("请勿重复提交表单。", "UTF-8");
                        response.sendRedirect(url);
                        return false;
                    }
                }
            }
        }

        return super.preHandle(request, response, handler);
    }
}
