package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.annotation.AvoidDuplicateSubmit;
import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Area;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.AreaService;
import com.cqzg168.scm.service.SMSService;
import com.cqzg168.scm.service.ShopKeeperCardService;
import com.cqzg168.scm.service.ShopKeeperService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.RebateConfig;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.util.List;

import static com.cqzg168.scm.shopkeeper.util.ClassUtils.combineSydwCore;

/**
 * 根路径 Controller
 * Created by jackytsu on 2017/3/14.
 */
@RequestMapping("/")
@Controller
public class RootController extends BaseController {
    @Autowired
    private ShopKeeperService     shopKeeperService;
    @Autowired
    private AreaService           areaService;
    @Autowired
    private ShopKeeperCardService shopKeeperCardService;
    @Autowired
    private RebateConfig          rebateConfig;
    @Autowired
    private SMSService            smsService;

    /**
     * 短信验证码过期时间
     */
    @Value("${sms_captcha_expired}")
    private Integer smsCaptchaExpired;

    /**
     * 首页
     *
     * @return
     */
    @RequestMapping({"/", "/index"})
    public String index(HttpServletResponse response) {

        ShopKeeper shopKeeper = (ShopKeeper) getSession().getAttribute(Constant.SessionKey.CURRENT_USER);
        Cookie     cookie     = new Cookie("cookie_username", shopKeeper.getTelephone());
        response.addCookie(cookie);

        return "redirect:/goods/index";
    }

    /**
     * 账户密码登录页
     *
     * @param response
     * @return
     */
    @RequestMapping(value = "/login")
    public String login(Device device, Model m, HttpServletResponse response) {
        if (getSession() != null && getSession().getAttribute(Constant.SessionKey.CURRENT_USER) != null) {
            return "redirect:/index";
        }

        String cookieUsername = "";
        if (getRequest().getCookies() != null) {
            for (Cookie cookie : getRequest().getCookies()) {
                if ("cookie_username".equals(cookie.getName())) {
                    cookieUsername = cookie.getValue();
                    break;
                }
            }
        }
        m.addAttribute("cookieUsername", cookieUsername);

        String acceptHeader  = getRequest().getHeader("accept");
        String requestedWith = getRequest().getHeader("X-Requested-With");

        if (acceptHeader.indexOf("application/json") > -1 || (requestedWith != null && requestedWith.indexOf("XMLHttpRequest") > -1)) {
            Writer out = null;
            try {
                response.setCharacterEncoding("UTF-8");
                response.setContentType("application/json; charset=utf-8");
                out = response.getWriter();
                out.write(AjaxResult.ajaxFailResult("401", "尚未登录，或者登录超时！").toString());
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

        Object shiroLoginFailureObj = getRequest().getAttribute("shiroLoginFailure");
        if (shiroLoginFailureObj != null) {
            String shiroLoginFailure = String.valueOf(shiroLoginFailureObj);
            switch (shiroLoginFailure) {
                case "org.apache.shiro.authc.IncorrectCredentialsException":
                    getRequest().setAttribute("ERROR_MESSAGE", "用户名或者密码错误");
                    break;
                case "org.apache.shiro.authc.DisabledAccountException":
                    getRequest().setAttribute("ERROR_MESSAGE", "当前用户已被系统禁用");
                    break;
                case "com.cqzg168.scm.shopkeeper.shiro.exception.IncorrectCaptchaException":
                    getRequest().setAttribute("ERROR_MESSAGE", "请输入正确的验证码");
                    break;
                default:
                    getRequest().setAttribute("ERROR_MESSAGE", "登录发生错误，请与管理员联系");
                    break;
            }
        }

        if (device.isNormal()) {
            return "/login";
        } else {
            return "/login_mobile";
        }
    }

    /**
     * 修改商户信息页面
     */
    @AvoidDuplicateSubmit(needSaveToken = true)
    @RequestMapping(value = "/baseInfo")
    public String baseInfo(Device device, Model model) {
        Session    session    = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        model.addAttribute("shopKeeper", shopKeeperService.findOne(shopKeeper.getSid()));
        if (device.isNormal()) {
            return "/baseInfo";
        } else {
            return "/baseInfo_mobile";
        }
    }

    /**
     * 修改商户信息
     *
     * @return
     */
    @AvoidDuplicateSubmit(needRemoveToken = true)
    @RequestMapping(value = "/save")
    public String save(ShopKeeper shopKeeper, final RedirectAttributes redirectAttributes) {
        ShopKeeper shopKeeperTemp = shopKeeperService.findByTelephoneAndIsNotSid(shopKeeper.getSid(), shopKeeper.getTelephone());
        if (shopKeeperTemp != null) {
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.update.telepone.repetition");
            return "redirect:/baseInfo";
        }
        Session    session       = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeperOld = shopKeeperService.findOne(shopKeeper.getSid());
        shopKeeper.setSid(shopKeeperOld.getSid());
        combineSydwCore(shopKeeper, shopKeeperOld);
        shopKeeperService.save(shopKeeperOld);
        session.setAttribute(Constant.SessionKey.CURRENT_USER, shopKeeperOld);
        return "redirect:/index";
    }

    /**
     * 地区信息 根据父级sid加载
     *
     * @return
     */
    @RequestMapping(value = "/area")
    @ResponseBody
    public AjaxResult area(String sid) {
        List<Area> areaList = areaService.findByParentSid(Long.parseLong(sid));
        return AjaxResult.ajaxSuccessResult("地域对象列表", areaList);
    }

    /**
     * 头像上传
     */
    @RequestMapping(value = "/upAvatar")
    public String upAvatar(MultipartFile avatar, Long sid) {
        Session    session    = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = shopKeeperService.findOne(sid);
        try {
            shopKeeperService.upAvatar(shopKeeper, avatar);
        } catch (Exception e) {
            e.printStackTrace();
        }
        session.setAttribute(Constant.SessionKey.CURRENT_USER, shopKeeper);
        return "redirect:/baseInfo";
    }

    /**
     * 修改密码页面
     */
    @RequestMapping(value = "/password")
    public String toEditPassword(Device device) {
        if (device.isNormal()) {
            return "/password";
        } else {
            return "/password_mobile";
        }
    }

    /**
     * 修改密码
     */
    @RequestMapping(value = "/updatePassword")
    public String editPassword(String oldPassword, String newPassword1, final RedirectAttributes redirectAttributes) {
        Session    session    = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        oldPassword = Utils.getMD5String(oldPassword);
        if (!shopKeeper.getPassword().equals(oldPassword)) {
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.update.password.different");
            return "redirect:/password";
        } else {
            shopKeeper.setPassword(Utils.getMD5String(newPassword1));
            shopKeeperService.save(shopKeeper);
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.update.password.success");
        }
        return "/passwordUpdateSuccess";
    }
}
