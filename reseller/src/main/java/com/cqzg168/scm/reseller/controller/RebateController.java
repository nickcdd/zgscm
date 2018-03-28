package com.cqzg168.scm.reseller.controller;

import com.cqzg168.scm.domain.PageInfo;
import com.cqzg168.scm.domain.Reseller;
import com.cqzg168.scm.domain.ResellerRebate;
import com.cqzg168.scm.service.ResellerRebateService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by admin on 2017/6/14.
 */
@Controller
@RequestMapping(value = "/rebate")
public class RebateController extends BaseController {

    @Autowired
    private ResellerRebateService resellerRebateService;

    @RequestMapping(value = "/index")
    public String index(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "5") int size, String startTime, String endTime, Model model) {
        Session session = SecurityUtils.getSubject().getSession();
        Reseller reseller = (Reseller) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        PageRequest pageable = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime"));
        Page<ResellerRebate> resellerRebates = resellerRebateService.findByResellerSidPage(startTime, endTime, 1, reseller.getSid(), pageable);
        model.addAttribute("pageInfo",new PageInfo(resellerRebates));
        model.addAttribute("resellerRebates",resellerRebates.getContent());
        if (startTime == null) {
            model.addAttribute("startTime", "");
        } else {
            model.addAttribute("startTime", startTime);
        }
        if (startTime == null) {
            model.addAttribute("endTime", "");
        } else {
            model.addAttribute("endTime", endTime);
        }
        return "/index";
    }
}
