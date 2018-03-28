package com.cqzg168.scm.reseller.controller;

import com.cqzg168.scm.reseller.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Manager;
import com.cqzg168.scm.domain.PageInfo;
import com.cqzg168.scm.service.ManagerService;
import com.cqzg168.scm.service.RoleService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Created by jackytsu on 2017/3/21.
 */
@Controller
@RequestMapping("/manager")
public class ManagerController extends BaseController {

    @Autowired
    private ManagerService managerService;

    @Autowired
    private RoleService roleService;

    /**
     * 管理员列表页
     *
     * @return
     */
    @RequestMapping("/index")
    @RequiresPermissions("manager:index")
    public String index(@RequestParam(required = false) String q, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int pageSize, Model model) {

        Page<Manager> managerPage = managerService.findByPage(q, new PageRequest(page, pageSize, new Sort(Sort.Direction.ASC, "username")));
        model.addAttribute("managers", managerPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(managerPage));
        model.addAttribute("roles", roleService.findAllByStatus(Manager.Status.AVAILABLE.getStatus()));

        return "/manager/index";
    }

    /**
     * 管理员详情
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    @RequiresPermissions("manager:index")
    public AjaxResult detail(Long sid) {
        Manager manager = managerService.findOne(sid);
        if (!Utils.isNull(manager)) {
            return AjaxResult.ajaxSuccessResult("操作成功", manager.toMapWithExclude(new String[] {"password"}));
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * 保存管理员信息
     *
     * @param manager
     * @return
     */
    @RequestMapping("/save")
    @RequiresPermissions("manager:save")
    public String save(Manager manager, final RedirectAttributes redirectAttributes) {
        try {
            if (manager.getSid() != null && manager.getSid() > 0) {
                Manager srcManager = managerService.findOne(manager.getSid());
                srcManager.setCname(manager.getCname());
                srcManager.setUsername(manager.getUsername());
                srcManager.setRoleList(manager.getRoleList());

                if (!Utils.isEmpty(manager.getPassword())) {
                    srcManager.setPassword(Utils.getMD5String(manager.getPassword()));
                }
                managerService.save(srcManager);
                WebAuthorizing.refreshSessionPermission();
            } else {
                manager.setPassword(Utils.getMD5String(manager.getPassword()));
                managerService.save(manager);
            }

            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        }

        return "redirect:/manager/index";
    }

    /**
     * 删除管理员
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/remove")
    @RequiresPermissions("manager:remove")
    public String remove(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            managerService.remove(sid);
            WebAuthorizing.refreshSessionPermission();
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.remove.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.remove.fail");
        }

        return "redirect:/manager/index";
    }

    /**
     * 启用管理员
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/enable")
    @RequiresPermissions("manager:save")
    public String enable(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            managerService.enable(sid);
            WebAuthorizing.refreshSessionPermission();
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        }

        return "redirect:/manager/index";
    }

    /**
     * 禁用管理员
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/disable")
    @RequiresPermissions("manager:save")
    public String disable(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            managerService.disable(sid);
            WebAuthorizing.refreshSessionPermission();
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        }

        return "redirect:/manager/index";
    }
}
