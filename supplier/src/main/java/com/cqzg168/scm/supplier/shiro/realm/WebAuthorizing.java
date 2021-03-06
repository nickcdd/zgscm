package com.cqzg168.scm.supplier.shiro.realm;

import com.cqzg168.scm.domain.Supplier;
import com.cqzg168.scm.service.SupplierService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 身份校验核心类
 * Created by jackytsu on 2017/3/15.
 */
public class WebAuthorizing extends AuthorizingRealm {

    private final static String REALM_NAME = "WEB_LOGIN";

    private static SupplierService supplierService;

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {

        Session session = SecurityUtils.getSubject().getSession();
        Supplier supplier = (Supplier) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        if (supplier != null) {
            SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
            //authorizationInfo.addStringPermissions(supplier.getPermissions());
            return authorizationInfo;
        }

        return null;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        String username = String.valueOf(token.getPrincipal());
        String password = new String((char[]) token.getCredentials());

        Supplier supplier = supplierService.findByTelephoneAndPassword(username, Utils.getMD5String(password));
        if (supplier == null) {
            throw new IncorrectCredentialsException();
        }

        if (supplier.getStatus() != 1) {
            throw new DisabledAccountException();
        }

        SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(username, password, REALM_NAME);

        Session session = SecurityUtils.getSubject().getSession();
        session.setAttribute(Constant.SessionKey.CURRENT_USER, supplier);

        return authenticationInfo;
    }

    @Autowired
    public void setManagerService(SupplierService supplierService) {
        WebAuthorizing.supplierService = supplierService;
    }

    /**
     * 刷新当前用户权限列表
     */
    public static void refreshSessionPermission() {
        // TODO 角色、管理员发生变化后刷新在线用户的权限列表
        //        DefaultWebSecurityManager securityManager = (DefaultWebSecurityManager) SecurityUtils.getSecurityManager();
        //        DefaultWebSessionManager  sessionManager  = (DefaultWebSessionManager) securityManager.getSessionManager();
        //
        //        for (Session session : sessionManager.getSessionDAO().getActiveSessions()) {
        //            sessionManager.getSessionDAO().delete(session);
        //
        //            Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        //            if (manager != null) {
        //                manager = managerService.findOne(manager.getSid());
        //
        //                if (manager.getStatus() != Manager.Status.AVAILABLE.getStatus()) {
        //                }
        //            }
        //        }
    }
}
