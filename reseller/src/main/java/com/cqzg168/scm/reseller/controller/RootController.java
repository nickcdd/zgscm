package com.cqzg168.scm.reseller.controller;

import com.cqzg168.scm.annotation.AvoidDuplicateSubmit;
import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.RebateConfig;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import static com.cqzg168.scm.reseller.util.ClassUtils.combineSydwCore;

/**
 * 根路径 Controller
 * Created by jackytsu on 2017/3/14.
 */
@RequestMapping("/")
@Controller
public class RootController extends BaseController {
    @Autowired
    private ResellerService resellerService;
    @Autowired
    private AreaService areaService;
    @Autowired
    private SMSService smsService;

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
    public String index() {
        Session session = SecurityUtils.getSubject().getSession();
        Reseller reseller = (Reseller) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        Reseller reseller1 = resellerService.findOne(reseller.getSid());
        reseller1.setCname("123");
        resellerService.save(reseller1);
        System.out.println(123);
        session.setAttribute("reseller", reseller);
        return "redirect:/rebate/index";
    }

    /**
     * 账户密码登录页
     *
     * @param response
     * @return
     */
    @RequestMapping(value = "/login")
    public String login(HttpServletResponse response) {
        String acceptHeader = getRequest().getHeader("accept");
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

        return "/login";
    }

    /**
     * 短信登录
     * @return
     */
    /*@RequestMapping(value = "/smsLogin")
    public String smsLogin(String telephone, String smsCode) {
        Session session = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = shopKeeperService.findShopKeeperByTelephone(telephone);
        Date expireDate = shopKeeper.getExpiredDate();
        String captcha = shopKeeper.getCaptcha();
        Date nowDate = new Date();
        Object shiroLoginFailureObj = getRequest().getAttribute("shiroLoginFailure");
        if (expireDate == null || captcha == null) {
            if (shiroLoginFailureObj != null) {
                getRequest().setAttribute("ERROR_MESSAGE", "登录失败，请先发送短信验证码！");
            }
            return "/login";
        }
        if (expireDate.getTime() < nowDate.getTime()) {
            if (shiroLoginFailureObj != null) {
                getRequest().setAttribute("ERROR_MESSAGE", "登录失败，短信验证码过期，请重新发送！");
            }
            return "/login";
        }
        if(!captcha.equals(smsCode)){
            if (shiroLoginFailureObj != null) {
                getRequest().setAttribute("ERROR_MESSAGE", "登录失败，短信验证码错误！");
            }
            return "/login";
        }
        session.setAttribute(Constant.SessionKey.CURRENT_USER, shopKeeper);
        return "redirect:/index";
    }
*/
   /* @ResponseBody
    @RequestMapping(value = "/validate")
    public AjaxResult smsValidate(HttpServletRequest request, String captcha, String telephone) {
        String captchaFromSession = (String) request.getSession().getAttribute(Constant.SessionKey.CAPTCHA);
        if (captcha != null && !captchaFromSession.equalsIgnoreCase(captcha)) {
            return AjaxResult.ajaxFailResult("-1", "验证码错误!");
        }
        Integer random = (int) ((Math.random() * 9 + 1) * 100000);
        ShopKeeper shopKeeper = shopKeeperService.findShopKeeperByTelephone(telephone);
        if (shopKeeper == null) {
            return AjaxResult.ajaxFailResult("-1", "账号不存在!");
        }
        String result = smsService.loginSmsValidate(telephone, random.toString());
        shopKeeper.setCaptcha(random.toString());
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MINUTE, calendar.get(Calendar.MINUTE)+smsCaptchaExpired);
        shopKeeper.setExpiredDate(calendar.getTime());
        shopKeeperService.save(shopKeeper);
        return AjaxResult.ajaxSuccessResult("签名参数", result);
    }*/

    /**
     * 修改分销商信息页面
     *
     * @return
     */
    @AvoidDuplicateSubmit(needSaveToken = true)
    @RequestMapping(value = "/baseInfo")
    public String baseInfo(Model model) {
        Session session = SecurityUtils.getSubject().getSession();
        Reseller reseller = (Reseller) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        model.addAttribute("reseller", resellerService.findOne(reseller.getSid()));
        return "/baseInfo";
    }

    /**
     * 修改分销商信息
     *
     * @return
     */
    @AvoidDuplicateSubmit(needRemoveToken = true)
    @RequestMapping(value = "/save")
    public String save(Reseller reseller, final RedirectAttributes redirectAttributes) {
        Reseller resellerTemp = resellerService.findByTelephoneAndIsNotSid(reseller.getSid(),reseller.getTelephone());
        if(resellerTemp != null){
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.update.telepone.repetition");
            return "redirect:/baseInfo";
        }
        Session session = SecurityUtils.getSubject().getSession();
        Reseller resellerOld = resellerService.findOne(reseller.getSid());
        reseller.setSid(resellerOld.getSid());
        combineSydwCore(reseller, resellerOld);
        resellerService.save(resellerOld);
        session.setAttribute(Constant.SessionKey.CURRENT_USER, resellerOld);
        return "redirect:/index";
    }


    /**
     * 头像上传
     */
    @RequestMapping(value = "/upAvatar")
    public String upAvatar(MultipartFile avatar, Long sid) {
        Session session = SecurityUtils.getSubject().getSession();
        Reseller reseller = resellerService.findOne(sid);
        try {
            resellerService.upAvatar(reseller, avatar);
        } catch (Exception e) {
            e.printStackTrace();
        }
        session.setAttribute(Constant.SessionKey.CURRENT_USER, reseller);
        return "redirect:/baseInfo";
    }

    /**
     * 修改密码页面
     */
    @RequestMapping(value = "/password")
    public String password() {
        return "/password";
    }

    /**
     * 修改密码
     */
    @RequestMapping(value = "/updatePassword")
    public String updatePassword(String oldPassword, String newPassword1, final RedirectAttributes redirectAttributes) {
        Session session = SecurityUtils.getSubject().getSession();
        Reseller reseller = (Reseller) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        oldPassword = Utils.getMD5String(oldPassword);
        if (!reseller.getPassword().equals(oldPassword)) {
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.update.password.different");
            return "redirect:/password";
        } else {
            reseller.setPassword(Utils.getMD5String(newPassword1));
            resellerService.save(reseller);
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.update.password.success");
        }
        return "/passwordUpdateSuccess";
    }
}
