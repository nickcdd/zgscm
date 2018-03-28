package com.cqzg168.scm.admin;

import com.cqzg168.scm.admin.filter.SiteMeshFilter;
import com.cqzg168.scm.admin.interceptor.GlobalConstantInterceptor;
import com.cqzg168.scm.admin.filter.FreemarkerFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import javax.servlet.DispatcherType;

/**
 * 项目配置类
 * Created by jackytsu on 2017/3/14.
 */
@EnableWebMvc
@Configuration
@EnableTransactionManagement
@EnableAspectJAutoProxy
public class WebConfig extends WebMvcConfigurerAdapter {
    /**
     * 上传路径
     */
    @Value("${upload_path}")
    private String uploadPath;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new GlobalConstantInterceptor());
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/**").addResourceLocations("classpath:/assets/");
        registry.addResourceHandler("/attachment/**").addResourceLocations("file:" + this.uploadPath);
    }

    /**
     * 配置 SiteMesh Filter
     *
     * @return
     */
    @Bean
    public FilterRegistrationBean siteMeshFilter() {
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        SiteMeshFilter         filter           = new SiteMeshFilter();
        registrationBean.setFilter(filter);
        registrationBean.setOrder(2);
        registrationBean.setDispatcherTypes(DispatcherType.REQUEST, DispatcherType.FORWARD);
        registrationBean.addUrlPatterns();
        return registrationBean;
    }

    /**
     * 配置 Freemarker Filter
     *
     * @return
     */
    @Bean
    public FilterRegistrationBean freemarkerFilter(FreeMarkerConfigurer configurer) {
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        FreemarkerFilter       filter           = new FreemarkerFilter();
        registrationBean.setFilter(filter);
        registrationBean.setOrder(3);
        registrationBean.setDispatcherTypes(DispatcherType.REQUEST, DispatcherType.FORWARD);
        return registrationBean;
    }
}
