package com.cqzg168.scm.controller;

import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import com.cqzg168.scm.vcode.Captcha;
import com.cqzg168.scm.vcode.SpecCaptcha;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Created by jackytsu on 2017/4/28.
 */
@Controller("CoreUtilsController")
public class UtilsController {

    /**
     * 图形验证码
     *
     * @param response
     * @param request
     */
    @RequestMapping(value = "/captcha", method = RequestMethod.GET)
    public void getGifCode(HttpServletResponse response, HttpServletRequest request) {
        try {
            String widthStr  = request.getParameter("width");
            String heightStr = request.getParameter("height");

            int width  = 160;
            int height = 40;

            if (!Utils.isEmpty(widthStr)) {
                width = Integer.valueOf(widthStr);
            }

            if (!Utils.isEmpty(heightStr)) {
                height = Integer.valueOf(heightStr);
            }

            response.setHeader("Pragma", "No-cache");
            response.setHeader("Cache-Control", "no-cache");
            response.setDateHeader("Expires", 0);
            response.setContentType("image/gif");
            /**
             * gif格式动画验证码
             * 宽，高，位数。
             */
            Captcha captcha = new SpecCaptcha(width, height, 4);

            captcha.out(response.getOutputStream());
            HttpSession session = request.getSession(true);
            session.setAttribute(Constant.SessionKey.CAPTCHA, captcha.text().toLowerCase());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
