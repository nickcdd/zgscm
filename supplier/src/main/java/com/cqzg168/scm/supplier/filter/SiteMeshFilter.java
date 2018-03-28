package com.cqzg168.scm.supplier.filter;

import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.sitemesh.DecoratorSelector;
import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.sitemesh.config.PathMapper;
import org.sitemesh.content.Content;
import org.sitemesh.webapp.WebAppContext;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * SiteMesh 配置类
 * Created by jackytsu on 2017/3/14.
 */
public class SiteMeshFilter extends ConfigurableSiteMeshFilter implements DecoratorSelector<WebAppContext> {
    private PathMapper<Boolean> excludesMapper = new PathMapper<Boolean>();

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        builder.setCustomDecoratorSelector(this);

        this.excludesMapper.put("/_*.ftl", true);
        this.excludesMapper.put("/index", true);
        this.excludesMapper.put("/login", true);
        this.excludesMapper.put("/login;jsessionid=*", true);
        this.excludesMapper.put("/error", true);
        this.excludesMapper.put("/assets/*", true);
        this.excludesMapper.put("/attachment/*", true);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        super.doFilter(request, response, filterChain);
    }

    @Override
    public String[] selectDecoratorPaths(Content content, WebAppContext context) throws IOException {
        HttpServletRequest request             = context.getRequest();
        Object             exceptionAttr       = request.getAttribute("exception");
        Object             disableDecorateAttr = request.getAttribute(Constant.RequestKey.DISABLE_DECORATE);
        boolean            hasException        = exceptionAttr != null && exceptionAttr instanceof Exception;
        boolean            disableDecorate     = Boolean.valueOf(String.valueOf(disableDecorateAttr));

        String requestUri  = request.getRequestURI();
        String contextPath = request.getContextPath();
        String url         = requestUri.substring(contextPath.length());
        String test        = this.excludesMapper.getPatternInUse(url);

        if (!Utils.isEmpty(test) || disableDecorate || hasException) {
            return new String[] {};
        } else {
            return new String[] {"/_root.ftl"};
        }
    }
}
