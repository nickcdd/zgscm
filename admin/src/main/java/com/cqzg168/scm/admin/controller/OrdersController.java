package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.view.RefundOrdersExcelView;
import com.cqzg168.scm.admin.view.SendOrdersExcelView;
import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Manager;
import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.PageInfo;
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/5/16 0016.
 */
@Controller
@RequestMapping("/orders")
public class OrdersController extends BaseController {
    @Autowired
    OrdersService ordersService;
    @Autowired
    OrdersLogService ordersLogService;

    @RequestMapping("/index")
    @RequiresPermissions("orders:index")
    public String index(@RequestParam(required = false) String shopKeeperName, @RequestParam(required = false) String goodsName, @RequestParam(required = false) Integer status, @RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {


        Page<Orders> ordersPage = ordersService.findByPage(shopKeeperName, goodsName, startDate, endDate, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "createTime")));

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
        return "/orders/index";
    }

    @RequestMapping("/detail")
    @RequiresPermissions("orders:index")
    public String detail(Long sid, Model model, String redirectStartDate, String redirectEndDate, String redirectShopKeeperName, String redirectGoodsName, int redirectPage, int redirectSize, Integer redirectStatus) {

        Orders orders = ordersService.findOne(sid);

        model.addAttribute("orders", orders);
        model.addAttribute("orders", orders);
        model.addAttribute("redirectStartDate", redirectStartDate);
        model.addAttribute("redirectEndDate", redirectEndDate);
        model.addAttribute("redirectShopKeeperName", redirectShopKeeperName);
        model.addAttribute("redirectGoodsName", redirectGoodsName);
        model.addAttribute("redirectPage", redirectPage);
        model.addAttribute("redirectSize", redirectSize);
        model.addAttribute("redirectStatus", redirectStatus);
        return "/orders/detail";
    }

    @RequestMapping("/refund/index")
    @RequiresPermissions("orders:reviewRefund")
    public String refundIndex(@RequestParam(required = false) String shopKeeperName, @RequestParam(required = false) String goodsName, @RequestParam(required = false) Integer status, @RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(5);
        defaultStatus.add(6);
        Page<Orders> ordersPage = ordersService.findRefundOrdersByPage(-1l,defaultStatus, shopKeeperName, goodsName, startDate, endDate, status, new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime")));
        if (ordersPage.getContent().size() == 0 && page != 0) {
            ordersPage = ordersService.findRefundOrdersByPage(-1l,defaultStatus, shopKeeperName, goodsName, startDate, endDate, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.DESC, "createTime")));
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
        return "/orders/refund/index";
    }

    @RequestMapping("/refund/detail")
    @RequiresPermissions("orders:reviewRefund")
    public String refundDetail(Long sid, Model model, String redirectStartDate, String redirectEndDate, String redirectShopKeeperName, String redirectGoodsName, int redirectPage, int redirectSize, Integer redirectStatus) {
        Orders orders = ordersService.findOne(sid);

        model.addAttribute("orders", orders);
        model.addAttribute("redirectStartDate", redirectStartDate);
        model.addAttribute("redirectEndDate", redirectEndDate);
        model.addAttribute("redirectShopKeeperName", redirectShopKeeperName);
        model.addAttribute("redirectGoodsName", redirectGoodsName);
        model.addAttribute("redirectPage", redirectPage);
        model.addAttribute("redirectSize", redirectSize);
        model.addAttribute("redirectStatus", redirectStatus);
        return "/orders/refund/detail";
    }

    /**
     * 单个审核
     *
     * @param ordersSid
     * @param flag
     * @return
     */
    @ResponseBody
    @RequestMapping("/refund/singleReviewRefund")
    public AjaxResult singleReviewRefund(Long ordersSid, boolean flag) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        Long[] ordersSids = new Long[]{ordersSid};


        HashMap<String, Object> map = ordersService.handleRefundOrders(ordersSids, null, manager);
        if ((boolean) map.get("resultFlag")) {
            return AjaxResult.ajaxSuccessResult("执行成功,，退款成功" + map.get("successCount") + "笔，退款失败" + map.get("failCount") + "笔", "");
        } else {
            return AjaxResult.ajaxFailResult("", "操作失败，请联系管理员");
        }
    }

    /**
     * 批量审核
     *
     * @param ordersSids
     * @param flag
     * @return
     */
    @ResponseBody
    @RequestMapping("/refund/batchReviewRefund")
    public AjaxResult batchReviewRefund(Long[] ordersSids, boolean flag) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);

        HashMap<String, Object> map = ordersService.handleRefundOrders(ordersSids, null, manager);
        if ((boolean) map.get("resultFlag")) {
            return AjaxResult.ajaxSuccessResult("执行成功,，退款成功" + map.get("successCount") + "笔，退款失败" + map.get("failCount") + "笔", "");
        } else {
            return AjaxResult.ajaxFailResult("", "操作失败，请联系管理员");
        }

    }

    @RequestMapping("/refund/export")
    public ModelAndView export(@RequestParam(required = false) String exportShopKeeperName, @RequestParam(required = false) String exportGoodsName, @RequestParam(required = false) Integer exportState, @RequestParam(required = false) String exportStartDate, @RequestParam(required = false) String exportEndDate) {
        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(5);
        defaultStatus.add(6);
        Map<String, Object> modelMap = new HashMap<>();
        Page<Orders> ordersPage = ordersService.findRefundOrdersByPage(-1l,defaultStatus, exportShopKeeperName, exportGoodsName, exportStartDate, exportEndDate, exportState, new PageRequest(0, Integer.MAX_VALUE, new Sort(Sort.Direction.DESC, "createTime")));


        modelMap.put("ordersList", ordersPage.getContent());
        modelMap.put("typeFlag",true);
        return new ModelAndView(new RefundOrdersExcelView(), modelMap);
    }
}
