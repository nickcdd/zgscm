package com.cqzg168.scm.supplier.shiro.resolver;

import com.cqzg168.scm.domain.AjaxResult;
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
        if (!(request.getHeader("accept").indexOf("application/json") > -1 || (request.getHeader("X-Requested-With") != null && request.getHeader("X-Requested-With").indexOf("XMLHttpRequest") > -1))) {
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
