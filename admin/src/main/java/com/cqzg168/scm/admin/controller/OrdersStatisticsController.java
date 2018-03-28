package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.view.OrderStatisticsExcelView;
import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.PageInfo;
import com.cqzg168.scm.service.OrdersService;
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
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/1 0001.
 */
@Controller
@RequestMapping("/ordersStatistics")
public class OrdersStatisticsController extends BaseController {
    @Autowired
    OrdersService ordersService;

    @RequestMapping("/index")
    @RequiresPermissions("orders:ordersStatistics")
    public String index(@RequestParam(required = false) Long supplierSid, @RequestParam(required = false) Integer status, @RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate, @RequestParam(defaultValue = "0") int page, @RequestParam(required = false) String totalAmount, @RequestParam(required = false) String totalQuantity, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {

        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(2);
        defaultStatus.add(3);
        defaultStatus.add(4);
        supplierSid = -1l;

        //分页查询数据
        Page<Orders> ordersPage = ordersService.findBySupplier(supplierSid, startDate, endDate, status, defaultStatus, new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime")));

        if (Utils.isEmpty(totalAmount) && Utils.isEmpty(totalQuantity)) {
            //查询所有满足条件的数据，进行统计
            if (!Utils.isNull(supplierSid)) {
                Page<Orders> allOrdersPage = ordersService.findBySupplier(supplierSid, startDate, endDate, status, defaultStatus, new PageRequest(page, Integer.MAX_VALUE, new Sort(Sort.Direction.DESC, "createTime")));
                Map<String, Object> countMap = ordersService.countOrders(allOrdersPage.getContent());
                model.addAttribute("totalAmount", countMap.get("totalAmount"));
                model.addAttribute("totalQuantity", countMap.get("totalQuantity"));

            } else {
                model.addAttribute("totalAmount", "");
                model.addAttribute("totalQuantity", "");
            }
        } else {
            model.addAttribute("totalAmount", totalAmount);
            model.addAttribute("totalQuantity", totalQuantity);

        }
        model.addAttribute("orders", ordersPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(ordersPage));
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
        if (Utils.isNull(supplierSid)) {
            model.addAttribute("checkSupplierSid", "");
        } else {
            model.addAttribute("checkSupplierSid", supplierSid);
        }
        model.addAttribute("status", status);
        return "/ordersStatistics/index";
    }

    /**
     * 订单导出
     *
     * @param exportSupplierSid
     * @param exportState
     * @param exportStartDate
     * @param exportEndDate
     * @return
     */
    @RequestMapping("/export")
    public ModelAndView export(@RequestParam(required = false) Long exportSupplierSid, @RequestParam(required = false) Integer exportState, @RequestParam(required = false) String exportStartDate, @RequestParam(required = false) String exportEndDate) {
        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(2);
        defaultStatus.add(3);
        defaultStatus.add(4);
        Map<String, Object> modelMap = new HashMap<>();

        Page<Orders> allOrdersPage = ordersService.findBySupplier(exportSupplierSid, exportStartDate, exportEndDate, exportState, defaultStatus, new PageRequest(0, Integer.MAX_VALUE, new Sort(Sort.Direction.ASC, "supplierSid")));
        Map<String, Object> countMap = ordersService.countOrders(allOrdersPage.getContent());

        modelMap.put("ordersList", allOrdersPage.getContent());
        modelMap.put("countMap", countMap);

        return new ModelAndView(new OrderStatisticsExcelView(), modelMap);
    }
}
