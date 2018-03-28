package com.cqzg168.scm.shopkeeper.interceptor;

import com.cqzg168.scm.domain.NavMenu;
import com.cqzg168.scm.domain.Permission;
import com.cqzg168.scm.shopkeeper.shiro.freemarker.ShiroTags;
import com.cqzg168.scm.shopkeeper.util.ViewUtils;
import com.cqzg168.scm.utils.Constant;
import com.esotericsoftware.yamlbeans.YamlReader;
import freemarker.ext.beans.BeansWrapper;
import freemarker.ext.beans.BeansWrapperBuilder;
import freemarker.template.Configuration;
import freemarker.template.TemplateHashModel;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import static com.cqzg168.scm.utils.Constant.BANK_NAME_MAP;

/**
 * 全局变量拦截器
 * Created by jackytsu on 2017/3/14.
 */
@Component
public class GlobalConstantInterceptor implements HandlerInterceptor {

    private final static Object sessionKey;
    private final static Object viewUtils;
    private final static ShiroTags shiroTags = new ShiroTags(null);

    private final static List<Permission> permissions = new ArrayList<>();
    private final static List<NavMenu>    navMenus    = new ArrayList<>();

    private static Boolean debugMode;

    static {
        BeansWrapper w = new BeansWrapperBuilder(Configuration.VERSION_2_3_23).build();
        sessionKey = getConstantClass(w, Constant.SessionKey.class.getName());
        viewUtils = getConstantClass(w, ViewUtils.class.getName());

        try {
            YamlReader yamlReader = new YamlReader(new InputStreamReader(GlobalConstantInterceptor.class.getResourceAsStream("/shiro-permissions.yml")));
            permissions.addAll((List<Permission>) yamlReader.read());

            yamlReader = new YamlReader(new InputStreamReader(GlobalConstantInterceptor.class.getResourceAsStream("/nav-menus.yml")));
            navMenus.addAll((List<NavMenu>) yamlReader.read());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Value("${spring.profiles.active}")
    public void setDebugMode(String profile) {
        debugMode = "dev".equalsIgnoreCase(profile);
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        request.setAttribute("CURRENT_URL", request.getServletPath());
        request.setAttribute("SESSION_KEY", sessionKey);
        request.setAttribute("DEBUG_MODE", debugMode);
        request.setAttribute("NAV_MENUS", navMenus);
        request.setAttribute("VIEW_UTILS", viewUtils);
        request.setAttribute("shiro", shiroTags);
        request.setAttribute("BANK_NAME_MAP", BANK_NAME_MAP);
        request.setAttribute("DEVICE", DeviceUtils.getCurrentDevice(request));

        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
    }

    public static List<Permission> getPermissions() {
        return permissions;
    }

    public static List<NavMenu> getNavMenus() {
        return navMenus;
    }

    private static Object getConstantClass(BeansWrapper w, String clsName) {
        try {
            TemplateHashModel statics = w.getStaticModels();
            return statics.get(clsName);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
