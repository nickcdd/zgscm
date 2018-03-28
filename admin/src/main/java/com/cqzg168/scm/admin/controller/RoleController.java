package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.interceptor.GlobalConstantInterceptor;
import com.cqzg168.scm.admin.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Permission;
import com.cqzg168.scm.domain.Role;
import com.cqzg168.scm.service.RoleService;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by jackytsu on 2017/3/22.
 */
@Controller
@RequestMapping("/role")
public class RoleController extends BaseController {

    @Autowired
    private RoleService roleService;

    /**
     * 角色列表页
     *
     * @return
     */
    @RequiresPermissions("role:index")
    @RequestMapping("/index")
    public String index(Model model) {

        List<Permission> permissions = GlobalConstantInterceptor.getPermissions();
        Map<String, String> permissionMap = new HashMap<>();
        for (Permission permission : permissions) {
            for (Map.Entry<String, String> entry : permission.getPermissions().entrySet()) {
                permissionMap.put(permission.getModule() + ":" + entry.getKey(), entry.getValue());
            }
        }

        model.addAttribute("roles", roleService.findAllByNotStatus(Role.Status.DELETED.getStatus()));
        model.addAttribute("permissionMap", permissionMap);
        model.addAttribute("permissions", permissions);

        return "/role/index";
    }

    /**
     * 角色详情
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    @RequiresPermissions("role:index")
    public AjaxResult detail(Long sid) {
        Role role = roleService.findOne(sid);
        if (!Utils.isNull(role)) {
            return AjaxResult.ajaxSuccessResult("操作成功", role.toMap());
        }

        return AjaxResult.ajaxFailResult("未找到指定角色", null);
    }

    /**
     * 保存角色信息
     *
     * @param role
     * @return
     */
    @RequestMapping("/save")
    @RequiresPermissions("role:save")
    public String save(Role role, final RedirectAttributes redirectAttributes) {
        try {

            roleService.save(role);
            WebAuthorizing.refreshSessionPermission();
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        }

        return "redirect:/role/index";
    }

    /**
     * 删除角色
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/remove")
    @RequiresPermissions("role:remove")
    public String remove(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            roleService.remove(sid);
            WebAuthorizing.refreshSessionPermission();
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.remove.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.remove.fail");
        }

        return "redirect:/role/index";
    }

    /**
     * 启用角色
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/enable")
    @RequiresPermissions("role:save")
    public String enable(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            roleService.enable(sid);
            WebAuthorizing.refreshSessionPermission();
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        }

        return "redirect:/role/index";
    }

    /**
     * 禁用角色
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/disable")
    @RequiresPermissions("role:save")
    public String disable(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            roleService.disable(sid);
            WebAuthorizing.refreshSessionPermission();
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        }

        return "redirect:/role/index";
    }
}
