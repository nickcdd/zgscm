package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.PageInfo;
import com.cqzg168.scm.domain.Reseller;
import com.cqzg168.scm.service.ResellerService;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Created by Administrator on 2017/5/27 0027.
 */
@Controller
@RequestMapping("/reseller")
public class ResellerController extends BaseController {
    @Autowired
    ResellerService resellerService;

    /**
     * 分销商列表
     *
     * @param q
     * @param page
     * @param size
     * @param model
     * @return
     */
    @RequiresPermissions("reseller:index")
    @RequestMapping("/index")
    public String index(@RequestParam(required = false) String q, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {


        Page<Reseller> resellerPage = resellerService.findByPage(q, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        if (resellerPage.getContent().size() == 0 && page != 0) {
            resellerPage = resellerService.findByPage(q, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        }
        model.addAttribute("resellers", resellerPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(resellerPage));
        if (Utils.isEmpty(q)) {
            model.addAttribute("q", "");
        } else {
            model.addAttribute("q", q);
        }


        return "/reseller/index";
    }

    /**
     * 分销商详情
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    @RequiresPermissions("reseller:index")
    public AjaxResult detail(Long sid) {

        Reseller reseller = resellerService.findOne(sid);


        if (!Utils.isNull(reseller)) {

            return AjaxResult.ajaxSuccessResult("操作成功", reseller.toMapWithExclude(new String[]{"password"}));
        }

        return AjaxResult.ajaxFailResult("未找到指定商户", null);
    }

    /**
     * 保存分销商信息
     *
     * @param
     * @return
     */
    @RequestMapping("/save")
    @RequiresPermissions("reseller:save")
    public String save(Reseller reseller, final RedirectAttributes redirectAttributes, MultipartFile myavatar, String redirectQ, int redirectPage, int redirectSize) {


        try {
            if (reseller.getSid() != null && reseller.getSid() > 0) {
                Reseller srcReseller = resellerService.findOne(reseller.getSid());
                if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {
                    String avatarUrl = resellerService.uploadAvatar(myavatar);
                    if (Utils.isEmpty(srcReseller.getAvatar())) {
                        srcReseller.setAvatar("/attachment/" + avatarUrl);
                    } else {
                        String[] urlArray = srcReseller.getAvatar().split("/");
                        if (resellerService.deleteAvatar(urlArray[urlArray.length - 1])) {
                            srcReseller.setAvatar("/attachment/" + avatarUrl);
                        }
                    }
                }
                srcReseller.setCname(reseller.getCname());
                srcReseller.setTelephone(reseller.getTelephone());
                resellerService.save(srcReseller);
                WebAuthorizing.refreshSessionPermission();
                redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
            } else {


                if (Utils.isEmpty(reseller.getPassword())) {
                    redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "密码不能为空");

                } else {
                    if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {


                        String avatarUrl = resellerService.uploadAvatar(myavatar);
                        reseller.setAvatar("/attachment/" + avatarUrl);
                    }

                    reseller.setPassword(Utils.getMD5String(reseller.getPassword()));
                    resellerService.save(reseller);


                    redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        } finally {

            redirectAttributes.addAttribute("q", redirectQ);
            redirectAttributes.addAttribute("page", redirectPage);
            redirectAttributes.addAttribute("size", redirectSize);
        }

        return "redirect:/reseller/index";
    }

    /**
     * 启用分销商
     *
     * @param sid
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/enable")
    @RequiresPermissions("reseller:save")
    public AjaxResult enable(Long sid) {
        try {
            resellerService.enable(sid);
            WebAuthorizing.refreshSessionPermission();
            return AjaxResult.ajaxSuccessResult("启用分销商成功", null);
        } catch (Exception e) {
            e.printStackTrace();
            return AjaxResult.ajaxFailResult("启用分销商失败", null);
        }


    }

    /**
     * 禁用分销商
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @ResponseBody
    @RequestMapping("/disable")
    @RequiresPermissions("reseller:save")
    public AjaxResult disable(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            resellerService.disable(sid);
            WebAuthorizing.refreshSessionPermission();
            return AjaxResult.ajaxSuccessResult("禁用分销商成功", null);
        } catch (Exception e) {
            e.printStackTrace();
            return AjaxResult.ajaxFailResult("禁用分销商失败", null);
        }


    }

    /**
     * 删除分销商
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @ResponseBody
    @RequestMapping("/remove")
    @RequiresPermissions("reseller:remove")
    public AjaxResult remove(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            resellerService.remove(sid);
            WebAuthorizing.refreshSessionPermission();
            return AjaxResult.ajaxSuccessResult("删除分销商成功", null);
        } catch (Exception e) {
            e.printStackTrace();
            return AjaxResult.ajaxFailResult("删除分销商失败", null);
        }


    }

    /**
     * 验证手机号是否重复
     *
     * @param telephone
     * @param redirectAttributes
     * @return
     */
    @ResponseBody
    @RequestMapping("/checkTelephone")
    public AjaxResult checkTelephone(String telephone, Long sid, final RedirectAttributes redirectAttributes) {

        if (resellerService.findByTelephone(telephone, sid)) {
            return AjaxResult.ajaxSuccessResult("验证通过", null);
        } else {
            return AjaxResult.ajaxFailResult("验证失败", null);
        }

    }
}