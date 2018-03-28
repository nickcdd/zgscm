package com.cqzg168.scm.supplier.filter;

import com.cqzg168.scm.utils.Utils;
import org.springframework.context.ApplicationContext;
import org.springframework.util.StringUtils;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;
import java.io.IOException;
import java.util.Locale;

/**
 * Freemarker 渲染过滤器
 * Created by jackytsu on 2017/3/14.
 */
public class FreemarkerFilter implements Filter {

    private Locale             locale;
    private ApplicationContext ctx;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String localeStr = filterConfig.getInitParameter("locale");
        if (StringUtils.hasText(localeStr)) {
            locale = new Locale(localeStr);
        } else {
            locale = Locale.getDefault();
        }
    }

    @Override
    @Transactional
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest  req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        if (ctx == null) {
            ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(req.getSession().getServletContext());
            if (null == ctx) {
                throw new ExceptionInInitializerError("spring context is not loaded!");
            }
        }

        String name  = req.getRequestURI();
        String cPath = req.getContextPath();
        if (!Utils.isEmpty(cPath) && cPath.length() > 1) {
            name = name.replace(cPath.substring(1), "");
        }

        if (name.endsWith(".ftl")) {
            try {
                FreeMarkerViewResolver viewResolver = ctx.getBean(FreeMarkerViewResolver.class);
                name = name.substring(1, name.lastIndexOf(".ftl"));
                View view = viewResolver.resolveViewName(name, locale);
                view.render(null, req, res);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
                chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
    }
}
