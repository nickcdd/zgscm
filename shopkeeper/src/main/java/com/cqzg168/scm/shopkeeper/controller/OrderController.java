package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.PageInfo;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.OrdersService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by admin on 2017/5/5.
 */
@RequestMapping("/order")
@Controller
public class OrderController extends BaseController {

    @Autowired
    private OrdersService ordersService;

    /**
     * 收款订单列表展示
     *
     * @param page
     * @param logisticsNo
     * @param startTime
     * @param endTime
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/gatheringOrders")
    public AjaxResult showOrdersByParame(@RequestParam(defaultValue = "0") int page, Long logisticsNo, String startTime, String endTime) {
        Session     session    = SecurityUtils.getSubject().getSession();
        ShopKeeper  shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        DateFormat  df         = new SimpleDateFormat(Constant.STR_FULL_DATE_TIME);
        PageRequest pagable    = new PageRequest(page, 5, new Sort(Sort.Direction.DESC, "createTime"));
        try {
            Page<Orders> orders = ordersService.findOrdersByShopkeeperGathering(startTime, endTime, logisticsNo, shopKeeper.getSid(), 4, 2, pagable);
            return AjaxResult.ajaxSuccessResult("订单列表", orders);
        } catch (Exception e) {
            e.printStackTrace();
            return AjaxResult.ajaxSuccessResult("订单列表", "时间格式错误");
        }
    }

    /**
     * 采购订单列表展示
     *
     * @param page
     * @param orderNo
     * @param startTime
     * @param endTime
     * @return
     */
    @RequestMapping(value = "/index")
    public String shoppingOrders(Device device, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "5") int size, Integer status, Long orderNo, String startTime, String endTime, Model model) {
        Session      session    = SecurityUtils.getSubject().getSession();
        ShopKeeper   shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        DateFormat   df         = new SimpleDateFormat(Constant.STR_FULL_DATE_TIME);
        PageRequest  pagable    = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime"));
        Page<Orders> orders     = ordersService.findOrdersByShopkeeperShopping(startTime, endTime, orderNo, shopKeeper.getSid(), status, 1, pagable);
        model.addAttribute("pageInfo", new PageInfo(orders));
        model.addAttribute("orders", orders.getContent());
        model.addAttribute("orders_mobile", orders);
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
        model.addAttribute("status", status);
        if (device.isNormal()) {
            return "/shoppingOrders/index";
        } else {
            return "/shoppingOrders/index_mobile";
        }
    }

    @RequestMapping(value = "/page")
    public String page(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "5") int size, Integer status, Long orderNo, String startTime, String endTime, Model model) {
        Session      session    = SecurityUtils.getSubject().getSession();
        ShopKeeper   shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        DateFormat   df         = new SimpleDateFormat(Constant.STR_FULL_DATE_TIME);
        PageRequest  pagable    = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime"));
        Page<Orders> orders     = ordersService.findOrdersByShopkeeperShopping(startTime, endTime, orderNo, shopKeeper.getSid(), status, 1, pagable);
        model.addAttribute("pageInfo", new PageInfo(orders));
        model.addAttribute("orders", orders.getContent());
        model.addAttribute("orders_mobile", orders);
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
        model.addAttribute("status", status);
        return "/shoppingOrders/order_info_fragment";
    }
}
