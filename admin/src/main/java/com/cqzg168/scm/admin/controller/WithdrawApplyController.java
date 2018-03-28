package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.admin.view.WithdrawApplyExcelView;
import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.service.WithdrawApplyService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/5/4 0004.
 */
@Controller
@RequestMapping("/withdrawApply")
public class WithdrawApplyController extends BaseController {
    @Autowired
    WithdrawApplyService withdrawApplyService;


    /**
     * 提现申请列表页
     *
     * @return
     */
    @RequiresPermissions("withdrawApply:index")
    @RequestMapping("/index")
    public String index(@RequestParam(required = false) String q, @RequestParam(required = true, defaultValue = "1") int status, @RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {


        Page<WithdrawApply> withdrawApplyPage = withdrawApplyService.findByPage(q, startDate, endDate, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "shopKeeperCname")));
        if (withdrawApplyPage.getContent().size() == 0 && page != 0) {
            withdrawApplyPage = withdrawApplyService.findByPage(q, startDate, endDate, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "shopKeeperCname")));
        }
        model.addAttribute("withdrawApplys", withdrawApplyPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(withdrawApplyPage));

        if (Utils.isEmpty(q)) {
            model.addAttribute("q", "");
        } else {
            model.addAttribute("q", q);
        }
        if (Utils.isEmpty(startDate)) {
            model.addAttribute("startDate", "");
        } else {
            model.addAttribute("startDate", startDate);
        }
        if (Utils.isEmpty(endDate)) {
            model.addAttribute("endDate", "");
        } else {
            model.addAttribute("endDate", endDate);
        }

        model.addAttribute("status", status);


        return "/withdrawApply/index";
    }

    /**
     * 提现申请详情
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    @RequiresPermissions("withdrawApply:index")
    public AjaxResult detail(Long sid) {

        WithdrawApply withdrawApply = withdrawApplyService.findOne(sid);


        if (!Utils.isNull(withdrawApply)) {


            return AjaxResult.ajaxSuccessResult("操作成功", withdrawApply.toMapWithExclude(null));
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * 审核
     *
     * @param withdrawApply
     * @return
     */
    @RequestMapping("/save")
    @RequiresPermissions("withdrawApply:save")
    public String save(WithdrawApply withdrawApply, final RedirectAttributes redirectAttributes, String redirectStartDate, String redirectEndDate, String redirectQ, int redirectPage, int redirectSize, int redirectStatus) {
        try {
            if (withdrawApply.getSid() != null && withdrawApply.getSid() > 0) {
                WithdrawApply srcWithdrawApply = withdrawApplyService.findOne(withdrawApply.getSid());
                srcWithdrawApply.setStatus(withdrawApply.getStatus());
//                srcWithdrawApply.setStatus(withdrawApply.getReason());
                Session session = SecurityUtils.getSubject().getSession();
                Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
                srcWithdrawApply.setManagerSid(manager.getSid());
                if (!Utils.isEmpty(withdrawApply.getReason())) {
                    srcWithdrawApply.setReason(withdrawApply.getReason());
                }
                withdrawApplyService.save(srcWithdrawApply);
                WebAuthorizing.refreshSessionPermission();
            } else {

            }

            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        } finally {
            redirectAttributes.addAttribute("startDate", redirectStartDate);
            redirectAttributes.addAttribute("endDate", redirectEndDate);
            redirectAttributes.addAttribute("status", redirectStatus);
            redirectAttributes.addAttribute("q", redirectQ);
            redirectAttributes.addAttribute("page", redirectPage);
            redirectAttributes.addAttribute("size", redirectSize);
        }

        return "redirect:/withdrawApply/index";
    }

    /**
     * 提现导出
     *
     * @param exportQ
     * @param exportState
     * @param exportStartDate
     * @param exportEndDate
     * @return
     */
    @RequestMapping("/export")
    public ModelAndView export(@RequestParam(required = false) String exportQ, @RequestParam(required = true, defaultValue = "1") int exportState, @RequestParam(required = false) String exportStartDate, @RequestParam(required = false) String exportEndDate) {

        Map<String, Object> modelMap = new HashMap<>();
        Page<WithdrawApply> withdrawApplyPage = withdrawApplyService.findByPage(exportQ, exportStartDate, exportEndDate, exportState, new PageRequest(0, Integer.MAX_VALUE, new Sort(Sort.Direction.ASC, "shopKeeperCname")));
        List<WithdrawApplyVO> list = withdrawApplyService.getWithdrawApplyVO(withdrawApplyPage.getContent());
//                modelMap.put("withdrawApplyList",withdrawApplyPage.getContent());
        modelMap.put("withdrawApplyList", list);
        return new ModelAndView(new WithdrawApplyExcelView(), modelMap);
    }


}
