package com.cqzg168.scm.supplier.controller;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.service.InventoryService;
import com.cqzg168.scm.service.OrdersDeliverGoodsService;
import com.cqzg168.scm.service.OrdersLogService;
import com.cqzg168.scm.service.OrdersService;
import com.cqzg168.scm.supplier.view.OrdersExcelView;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.json.JSONArray;
import org.json.JSONObject;
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

import javax.servlet.http.HttpServletRequest;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by admin on 2017/5/5.
 */
@RequestMapping("/orders")
@Controller
public class OrderController extends BaseController {

    @Autowired
    private OrdersService             ordersService;
    @Autowired
    private InventoryService          inventoryService;
    @Autowired
    private OrdersDeliverGoodsService ordersDeliverGoodsService;
    @Autowired
    private OrdersLogService ordersLogService;
    /**
     * 订单列表展示
     *
     * @param page
     * @param status
     * @param startTime
     * @param endTime
     * @return
     */
    @RequestMapping(value = "/index")
    public String showOrdersByParame(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "5") int size, Integer status, String startTime, String endTime, Model model) {
        Session     session  = SecurityUtils.getSubject().getSession();
        Supplier    supplier = (Supplier) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        PageRequest pagable  = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime"));
        try {
            Page<Orders> orders = ordersService.findOrdersByShopKepperProcurementPage(supplier.getSid(), startTime, endTime, 1, status, pagable);
            model.addAttribute("pageInfo", new PageInfo(orders));
            model.addAttribute("orders", orders.getContent());
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        if (!Utils.isNull(status)) {
            model.addAttribute("status", status);
        }
        return "/orders/index";
    }

    /**
     * 订单详情
     *
     * @param sid
     * @param model
     * @return
     */
    @RequestMapping(value = "/details")
    public String orderDetails(Long sid, Model model) {
        Orders orders = ordersService.findOne(sid);
        model.addAttribute("order", orders);
        return "/orders/details";
    }

    /***
     * 单个发货动作
     * @param sid
     * @return
     */
    @RequestMapping(value = "/deliverGoods")
    public String deliverGoods(Long sid, String logisticsCompany, String logisticsNo) {
        Orders orders = ordersService.findOne(sid);
        for (OrdersGoods ordersGoods : orders.getOrdersGoodsList()) {
            Inventory inventory = inventoryService.findBySpecificationSidInventory(ordersGoods.getGoodsSpecification());
            Integer   amount    = inventory.getAmount();
            inventory.setAmount(amount - ordersGoods.getGoodsCount());
            inventoryService.save(inventory);
        }
        orders.setLogisticsCompany(logisticsCompany);
        orders.setLogisticsNo(logisticsNo);
        orders.setStatus(3);
        ordersService.save(orders);
        ordersLogService.saveOrdersLog(-1L, orders.getSid(), 2, 3, "供应商发货。");
        //修改父订单状态
        if(orders.getParentOrderSid() != null){
            ordersDeliverGoodsService.suplierDeliverGoods(orders);
        }
        return "redirect:/orders/index";
    }

    /***
     * 批量发货动作
     * @param
     * @return
     */
    @RequestMapping(value = "/deliverMultiGoods")
    public String deliverMultiGoods(String paramArray) {
        try {
            JSONArray jsonArray = new JSONArray(paramArray);

            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObject       = jsonArray.getJSONObject(i);
                Long       sid              = jsonObject.getLong("sid");
                String     logisticsCompany = jsonObject.getString("logisticsCompany");
                String     logisticsNo      = jsonObject.getString("logisticsNo");
                Orders     orders           = ordersService.findOne(sid);
                for (OrdersGoods ordersGoods : orders.getOrdersGoodsList()) {
                    Inventory inventory = inventoryService.findBySpecificationSidInventory(ordersGoods.getGoodsSpecification());
                    Integer   amount    = inventory.getAmount();
                    inventory.setAmount(amount - ordersGoods.getGoodsCount());
                    inventoryService.save(inventory);
                }
                orders.setLogisticsCompany(logisticsCompany);
                orders.setLogisticsNo(logisticsNo);
                orders.setStatus(3);
                ordersService.save(orders);
                ordersLogService.saveOrdersLog(-1L, orders.getSid(), 2, 3, "供应商发货。");
                //修改父订单状态
                if(orders.getParentOrderSid() != null){
                    ordersDeliverGoodsService.suplierDeliverGoods(orders);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/orders/index";
    }

    /**
     * 单个订单库存验证
     *
     * @return
     */
    @ResponseBody
    @RequestMapping("/goodsInventoryValidate")
    public AjaxResult goodsInventoryValidate(Long sid) {
        Orders orders = ordersService.findOne(sid);
        for (OrdersGoods ordersGoods : orders.getOrdersGoodsList()) {
            Inventory inventory = inventoryService.findBySpecificationSidInventory(ordersGoods.getGoodsSpecification());
            if (inventory != null) {
                Integer amount = inventory.getAmount();
                if (amount < ordersGoods.getGoodsCount()) {
                    return AjaxResult.ajaxSuccessResult("error", ordersGoods.getGoodsCname() + " " + ordersGoods.getGoodsSpecificationCname() + " 库存不足。");
                }
            } else {
                return AjaxResult.ajaxSuccessResult("error", "请添加 " + ordersGoods.getGoodsCname() + " " + ordersGoods.getGoodsSpecificationCname() + " 的库存。");
            }
        }
        return AjaxResult.ajaxSuccessResult("success", "");
    }

    /**
     * 多个订单库存验证
     *
     * @return
     */
    @ResponseBody
    @RequestMapping("/batchGoodsInventoryValidate")
    public AjaxResult batchGoodsInventoryValidate(String paramArray) {
        try {
            JSONArray jsonArray = new JSONArray(paramArray);
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                Long       sid        = jsonObject.getLong("sid");
                Orders     orders     = ordersService.findOne(sid);
                for (OrdersGoods ordersGoods : orders.getOrdersGoodsList()) {
                    Inventory inventory = inventoryService.findBySpecificationSidInventory(ordersGoods.getGoodsSpecification());
                    if (inventory != null) {
                        Integer amount = inventory.getAmount();
                        if (amount < ordersGoods.getGoodsCount()) {
                            return AjaxResult.ajaxSuccessResult("error", ordersGoods.getGoodsCname() + " " + ordersGoods.getGoodsSpecificationCname() + " 库存不足。");
                        }
                    } else {
                        return AjaxResult.ajaxSuccessResult("error", "请添加 " + ordersGoods.getGoodsCname() + " " + ordersGoods.getGoodsSpecificationCname() + " 的库存。");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return AjaxResult.ajaxSuccessResult("success", "");
    }

    @RequestMapping(value = "/export")
    public ModelAndView export(String startTimeXLS, String endTimeXLS, Integer statusXLS) {
        Session             session  = SecurityUtils.getSubject().getSession();
        Supplier            supplier = (Supplier) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        PageRequest         pagable  = new PageRequest(0, Integer.MAX_VALUE, new Sort(Sort.Direction.DESC, "createTime"));
        Page<Orders>        orders   = ordersService.findOrdersByShopKepperProcurementPage(supplier.getSid(), startTimeXLS, endTimeXLS, 1, statusXLS, pagable);
        Map<String, Object> modelMap = new HashMap<>();
        modelMap.put("OrdersList", orders.getContent());
        return new ModelAndView(new OrdersExcelView(), modelMap);
    }
}
