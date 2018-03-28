package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.view.PickingGoodsExcelView;
import com.cqzg168.scm.admin.view.SendOrdersExcelView;
import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.service.OrdersLogService;
import com.cqzg168.scm.service.OrdersService;
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

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/6 0006.
 */
@Controller
@RequestMapping("/sendOrders")
public class SendOrdersController extends BaseController {
    @Autowired
    OrdersService ordersService;
    @Autowired
    OrdersLogService ordersLogService;

    @RequestMapping("/index")
    @RequiresPermissions("orders:sendOrders")
    public String index(@RequestParam(required = false) String shopKeeperName, @RequestParam(required = false) String goodsName, @RequestParam(required = false) Integer status, @RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        Page<Orders> ordersPage = ordersService.findSendOrdersByPage(-1l,shopKeeperName, goodsName, startDate, endDate, status, new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime")));
        if (ordersPage.getContent().size() == 0 && page != 0) {
            ordersPage = ordersService.findSendOrdersByPage(-1l,shopKeeperName, goodsName, startDate, endDate, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.DESC, "createTime")));
        }
        model.addAttribute("orders", ordersPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(ordersPage));

        if (Utils.isEmpty(shopKeeperName)) {
            model.addAttribute("shopKeeperName", "");
        } else {
            model.addAttribute("shopKeeperName", shopKeeperName);
        }
        if (Utils.isEmpty(goodsName)) {
            model.addAttribute("goodsName", "");
        } else {
            model.addAttribute("goodsName", goodsName);
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
        return "/sendOrders/index";
    }

    @RequestMapping("/detail")
    @RequiresPermissions("orders:sendOrders")
    public String detail(Long sid, Model model, String redirectStartDate, String redirectEndDate, String redirectShopKeeperName, String redirectGoodsName, int redirectPage, int redirectSize, Integer redirectStatus) {
        Orders orders = ordersService.findOne(sid);

        model.addAttribute("orders", orders);
        model.addAttribute("redirectStartDate", redirectStartDate);
        model.addAttribute("redirectEndDate", redirectEndDate);
        model.addAttribute("redirectShopKeeperName", redirectShopKeeperName);
        model.addAttribute("redirectGoodsName", redirectGoodsName);
        model.addAttribute("redirectPage", redirectPage);
        model.addAttribute("redirectSize", redirectSize);
        model.addAttribute("redirectStatus", redirectStatus);

        return "/sendOrders/detail";
    }

    /**
     * 批量发货
     *
     * @param ordersSids
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/batchSendOrders")
    public AjaxResult batchCommitReview(Long[] ordersSids) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);


        boolean resultFlag = ordersService.sendOrders(ordersSids, manager, "", "");
        if (resultFlag) {
            return AjaxResult.ajaxSuccessResult("执行成功", "");
        } else {
            return AjaxResult.ajaxFailResult("", "批量执行失败");
        }
    }

    /**
     * 单个发货
     *
     * @param sid
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/singleSendOrders")
    public AjaxResult singleSendOrders(Long sid, String logisticsNo, String logisticsCompany, boolean flag) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        logisticsNo = logisticsNo.replaceAll("；", ";");
        if (flag) {
            Long[] ordersSids = new Long[]{sid};
            boolean resultFlag = ordersService.sendOrders(ordersSids, manager, logisticsNo, logisticsCompany);
            if (resultFlag) {
                return AjaxResult.ajaxSuccessResult("发货成功", "");
            } else {
                return AjaxResult.ajaxFailResult("", "发货失败");
            }
        } else {
            Orders orders = ordersService.findOne(sid);
            if (!Utils.isNull(orders)) {
                orders.setLogisticsNo(logisticsNo);
                orders.setLogisticsCompany(logisticsCompany);
                ordersService.save(orders);
                return AjaxResult.ajaxSuccessResult("修改成功", "");
            } else {
                return AjaxResult.ajaxFailResult("", "没有找到订单" + sid);
            }
        }

    }

    @RequestMapping("/export")
    public ModelAndView export(@RequestParam(required = false) String exportShopKeeperName, @RequestParam(required = false) String exportGoodsName, @RequestParam(required = false) Integer exportState, @RequestParam(required = false) String exportStartDate, @RequestParam(required = false) String exportEndDate) {

        Map<String, Object> modelMap = new HashMap<>();
        Page<Orders> ordersPage = ordersService.findSendOrdersByPage(-1l,exportShopKeeperName, exportGoodsName, exportStartDate, exportEndDate, exportState, new PageRequest(0, Integer.MAX_VALUE, new Sort(Sort.Direction.DESC, "createTime")));

//                modelMap.put("withdrawApplyList",withdrawApplyPage.getContent());
        modelMap.put("ordersList", ordersPage.getContent());
        return new ModelAndView(new SendOrdersExcelView(), modelMap);
    }
}
