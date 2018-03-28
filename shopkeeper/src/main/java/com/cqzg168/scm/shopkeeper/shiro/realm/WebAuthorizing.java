package com.cqzg168.scm.shopkeeper.shiro.realm;

import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.ShopKeeperService;
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

    private static ShopKeeperService shopKeeperService;

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {

        Session    session    = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        if (shopKeeper != null) {
            return new SimpleAuthorizationInfo();
        }

        return null;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        String     telephone  = String.valueOf(token.getPrincipal());
        String     password   = new String((char[]) token.getCredentials());
        ShopKeeper shopKeeper = shopKeeperService.findByTelephoneAndPassword(telephone, Utils.getMD5String(password));

        if (shopKeeper == null) {
            throw new IncorrectCredentialsException();
        }

        if (shopKeeper.getStatus() != 1) {
            throw new DisabledAccountException();
        }

        SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(telephone, password, REALM_NAME);

        Session session = SecurityUtils.getSubject().getSession();
        session.setAttribute(Constant.SessionKey.CURRENT_USER, shopKeeper);

        return authenticationInfo;
    }

    @Autowired
    public void setShopKeeperService(ShopKeeperService shopKeeperService) {
        WebAuthorizing.shopKeeperService = shopKeeperService;
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
