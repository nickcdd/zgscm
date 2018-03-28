package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.service.AfterSaleService;
import com.cqzg168.scm.service.OrdersLogService;
import com.cqzg168.scm.service.OrdersService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by admin on 2017/6/28.
 */
@RequestMapping(value = "/afterSale")
@Controller
public class AfterSaleController {

    @Autowired
    private AfterSaleService afterSaleService;
    @Autowired
    private OrdersLogService ordersLogService;
    @Autowired
    private OrdersService    ordersService;

    /**
     * 退/换货
     *
     * @param ordersSid
     * @param afterSaleStatus
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(Device device, Long ordersSid, Integer afterSaleStatus, Model model) {
        Session session = SecurityUtils.getSubject().getSession();
        model.addAttribute("afterSaleStatus", afterSaleStatus);
        model.addAttribute("ordersSid", ordersSid);
        session.setAttribute("after_sale_orderSid", ordersSid);
        if (device.isNormal()) {
            return "/afterSale/index";
        } else {
            return "/afterSale/index_mobile";
        }

    }

    /**
     * 售后处理
     *
     * @param ordersSid
     * @param afterSaleStatus
     * @return
     */
    @RequestMapping(value = "/afterSale")
    public String afterSale(Long ordersSid, Integer afterSaleStatus, String note) {
        Session session = SecurityUtils.getSubject().getSession();
        try {
            Orders orders = ordersService.findOne(ordersSid);
            if (orders.getParentOrderSid() != null) {
                Orders parentOrders = ordersService.findOne(orders.getParentOrderSid());
                parentOrders.setStatus(afterSaleStatus);
                ordersService.save(parentOrders);
                ordersLogService.saveOrdersLog(-1L, parentOrders.getSid(), 3, afterSaleStatus, note);
            }
            orders.setStatus(afterSaleStatus);
            ordersService.save(orders);
            ordersLogService.saveOrdersLog(-1L, ordersSid, 3, afterSaleStatus, note);
            session.removeAttribute("after_sale_orderSid");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/order/index";
    }

    /**
     * 售后文件上传
     *
     * @param myFile
     * @return
     */
    @RequestMapping("/uplode/photo")
    @ResponseBody
    public Map<String, Object> updatePhoto(@RequestParam("myFile") MultipartFile[] myFile) {
        Session             session = SecurityUtils.getSubject().getSession();
        Long                orderid = (Long) session.getAttribute("after_sale_orderSid");
        Map<String, Object> map     = new HashMap<String, Object>();
        try {
            afterSaleService.uplaodPicture(orderid, myFile);
            map.put("code", "1");
        } catch (Exception e) {
            map.put("code", "0");
            e.printStackTrace();
        }
        return map;
    }
}
