package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.annotation.AvoidDuplicateSubmit;
import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Manager;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.ManagerService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import org.apache.shiro.session.Session;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Created by Administrator on 2017/6/2 0002.
 */
@Controller
@RequestMapping("/personInfo")
public class PersonInfoController extends BaseController {
    @Autowired
    ManagerService managerService;

    /**
     * 修改管理员个人信息页面
     *
     * @return
     */
    @AvoidDuplicateSubmit(needSaveToken = true)
    @RequestMapping(value = "/baseInfo")
    public String baseInfo(Model model) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        model.addAttribute("manager", managerService.findOne(manager.getSid()));
        return "/personInfo/baseInfo";
    }

    /**
     * 管理员详情
     *
     * @param
     * @return
     */
    @RequestMapping("/save")
    public String save(Manager manager, final RedirectAttributes redirectAttributes) {
//        Manager manager = managerService.findOne(sid);
//        if (!Utils.isNull(manager)) {
//            return AjaxResult.ajaxSuccessResult("操作成功", manager.toMapWithExclude(new String[] {"password"}));
//        }
//
        Session session = (Session) SecurityUtils.getSubject().getSession();
        if (!Utils.isNull(manager.getSid())) {
            Manager srcManager = managerService.findOne(manager.getSid());
            if (!Utils.isNull(srcManager)) {

                srcManager.setCname(manager.getCname());
                managerService.save(srcManager);
                session.setAttribute(Constant.SessionKey.CURRENT_USER, srcManager);
                redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
            } else {
                redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "没有找到相关用户，请联系后台");
            }
        } else {
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "用户sid为空，请联系后台");
        }

        return "redirect:/";
    }

    /**
     * 跳转修改密码页面
     */
    @RequestMapping(value = "/password")
    public String password() {
        return "/personInfo/password";
    }


    /**
     * 验证密码是否正确
     *
     * @param
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/checkPassword")
    public AjaxResult checkPassword(String oldPassword) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);

        oldPassword = Utils.getMD5String(oldPassword);

        if (manager.getPassword().equals(oldPassword)) {
            return AjaxResult.ajaxSuccessResult("验证通过", null);
        } else {
            return AjaxResult.ajaxFailResult("验证失败", null);
        }


    }

    /**
     * 修改密码
     */
    @RequestMapping(value = "/updatePassword")
    public String updatePassword(String oldPassword, String newPassword1, final RedirectAttributes redirectAttributes) {
        Session session = SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        oldPassword = Utils.getMD5String(oldPassword);
        if (!manager.getPassword().equals(oldPassword)) {
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.update.password.different");
            return "redirect:/password";
        } else {
            manager.setPassword(Utils.getMD5String(newPassword1));
            managerService.save(manager);
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.update.password.success");
        }
        return "redirect:/logout";
    }
}
