package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.service.SMSService;
import com.cqzg168.scm.shopkeeper.shiro.exception.IncorrectCaptchaException;
import com.cqzg168.scm.utils.Constant;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created by admin on 2017/5/12.
 */
@RequestMapping("/sms")
@Controller
public class SMSController extends BaseController {

    @Autowired
    private SMSService smsService;

    @ResponseBody
    @RequestMapping(value = "/validate")
    public AjaxResult smsValidate(HttpServletRequest request, String captcha, String telephone) {
        String captchaFromSession = (String) request.getSession().getAttribute(Constant.SessionKey.CAPTCHA);
        if (captcha != null && !captchaFromSession.equalsIgnoreCase(captcha)) {
            return AjaxResult.ajaxFailResult("-1", "验证码错误");
        }
        String result = smsService.loginSmsValidate(telephone, "111111");
        System.out.println(result);
        return AjaxResult.ajaxSuccessResult("签名参数", result);
    }
}
