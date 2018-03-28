package com.cqzg168.scm.shopkeeper.shiro.resolver;

import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.authz.UnauthorizedException;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 访问未授权页面异常处理
 * Created by jackytsu on 2017/3/16.
 */
@Component
public class UnauthorizedExceptionResolver extends SimpleMappingExceptionResolver {

    @Override
    protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        String accept       = request.getHeader("accept");
        String requestdWith = request.getHeader("X-Requested-With");

        if (Utils.isEmpty(accept)) {
            accept = "";
        }

        if (Utils.isEmpty(requestdWith)) {
            requestdWith = "";
        }

        if (!(accept.indexOf("application/json") > -1 || requestdWith.indexOf("XMLHttpRequest") > -1)) {
            if (ex instanceof UnauthorizedException) {
                applyStatusCodeIfPossible(request, response, 403);
                request.setAttribute("status", 403);
                request.setAttribute("exception", ex);
            }
            return getModelAndView("/error", ex, request);
        } else {// JSON格式返回
            ServletOutputStream out = null;
            try {
                out = response.getOutputStream();
                out.println(AjaxResult.ajaxFailResult("403", ex.getLocalizedMessage()).toString());
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
    }
}
