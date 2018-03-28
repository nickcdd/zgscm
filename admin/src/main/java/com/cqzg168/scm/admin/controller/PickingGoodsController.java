package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.view.HXHKPickingGoodsExcelView;
import com.cqzg168.scm.admin.view.PickingGoodsExcelView;
import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.dto.GoodsDto;
import com.cqzg168.scm.service.OrdersLogService;
import com.cqzg168.scm.service.OrdersService;
import com.cqzg168.scm.service.UploadPickingGoodsExcelService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.session.Session;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/16 0016.
 */
@Controller
@RequestMapping("/pickingGoods")
public class PickingGoodsController extends BaseController {
    @Autowired
    OrdersService ordersService;
    @Autowired
    OrdersLogService ordersLogService;
    @Autowired
    UploadPickingGoodsExcelService uploadPickingGoodsExcelService;
    @Value("${orders_total_pirce_estimate}")
    String systemTotalPrice;

    @RequestMapping("/index")
    @RequiresPermissions("orders:pickingGoods")
    public String index(@RequestParam(required = false) String shopKeeperName, @RequestParam(required = false) String goodsName, @RequestParam(required = false) Integer status, @RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        Page<Orders> ordersPage = ordersService.findSendOrdersByPage(-1l,shopKeeperName, goodsName, startDate, endDate, 7, new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime")));
        if (ordersPage.getContent().size() == 0 && page != 0) {

            ordersPage = ordersService.findSendOrdersByPage(-1l,shopKeeperName, goodsName, startDate, endDate, 7, new PageRequest(page - 1, size, new Sort(Sort.Direction.DESC, "createTime")));
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

//        model.addAttribute("status", status);
        return "/pickingGoods/index";
    }

    /**
     * 批量拣货
     *
     * @param ordersSids
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/batchPickingGoods")
    public AjaxResult batchCommitReview(Long[] ordersSids, Integer flagStatus) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);


        HashMap<String, Object> map = ordersService.pickingGoods(ordersSids, flagStatus, manager);
        if ((boolean) map.get("resultFlag")) {
            return AjaxResult.ajaxSuccessResult("执行成功,待发货" + map.get("sendCount") + "笔，退款成功" + map.get("successCount") + "笔，退款失败" + map.get("failCount") + "笔", "");
        } else {
            return AjaxResult.ajaxFailResult("", "批量拣货失败");
        }

    }

    /**
     * 执行拣货操作
     *
     * @param
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/pickingGoods")
    public AjaxResult pickingGoods(Long[] orderGoodsSids, Long ordersSid) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);

//        System.out.println(">>>>>>>>>>>>>>>"+orderGoodsSids.length);
        if (Utils.isNull(orderGoodsSids)) {
            orderGoodsSids = new Long[0];
        }

        Map<String, Object> map = ordersService.sliptOrders(orderGoodsSids, ordersSid, manager);
        boolean flag = (boolean) map.get("flag");
        if (flag) {
            return AjaxResult.ajaxSuccessResult(map.get("msg").toString(), "");
        } else {
            return AjaxResult.ajaxFailResult("", map.get("msg"));
        }


    }

    /**
     * 订单详细信息
     *
     * @param
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/detail", produces = "application/json;charset=UTF-8")
    public String detail(Long ordersSid) throws JSONException {
        Orders orders = ordersService.findOne(ordersSid);
//      System.out.println(orders.getOrdersGoodsList().size());
        JSONArray orderGoodsArrar = new JSONArray();
        if (orders.getOrdersGoodsList().size() > 0) {
            for (OrdersGoods ordersGoods : orders.getOrdersGoodsList()) {
                OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                orderGoodsVO.setOrderGoodsSid(ordersGoods.getSid());
                orderGoodsVO.setGoodsCname(ordersGoods.getGoodsCname());
                orderGoodsVO.setGoodsSpecificationCname(ordersGoods.getGoodsSpecificationCname());
                orderGoodsVO.setCount(ordersGoods.getGoodsCount().toString());
                JSONObject json = new JSONObject(orderGoodsVO);
                orderGoodsArrar.put(json);
            }
        }
        JSONObject json = new JSONObject();
        json.put("flag", true);

        json.put("orderGoods", orderGoodsArrar);

        return json.toString();
    }

    /**
     * 单个检货
     *
     * @param sid
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/singlePickingGoods")
    public AjaxResult singleSendOrders(Long sid, Integer flagStatus) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);


        Long[] ordersSids = new Long[]{sid};
        HashMap<String, Object> map = ordersService.pickingGoods(ordersSids, flagStatus, manager);
        if ((boolean) map.get("resultFlag")) {
            return AjaxResult.ajaxSuccessResult("执行成功,待发货" + map.get("sendCount") + "笔，退款成功" + map.get("successCount") + "笔，退款失败" + map.get("failCount") + "笔", "");
        } else {
            return AjaxResult.ajaxFailResult("", "拣货失败");
        }

    }

    @RequestMapping("/export")
    public ModelAndView export(@RequestParam(required = false) String exportShopKeeperName, @RequestParam(required = false) String exportGoodsName, @RequestParam(required = false) Integer exportState, @RequestParam(required = false) String exportStartDate, @RequestParam(required = false) String exportEndDate) {

        Map<String, Object> modelMap = new HashMap<>();
        Page<Orders> ordersPage = ordersService.findSendOrdersByPage(-1l,exportShopKeeperName, exportGoodsName, exportStartDate, exportEndDate, 7, new PageRequest(0, Integer.MAX_VALUE, new Sort(Sort.Direction.DESC, "createTime")));

//                modelMap.put("withdrawApplyList",withdrawApplyPage.getContent());
        modelMap.put("ordersList", ordersPage.getContent());
        return new ModelAndView(new HXHKPickingGoodsExcelView(), modelMap);
    }

    @ResponseBody
    @RequestMapping(value = "/uploadFile", produces = "application/json;charset=UTF-8")
    public String uploadFile(@RequestParam(value = "excelFile", required = false) MultipartFile excelFile) throws JSONException, IOException {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        JSONObject json = new JSONObject();
        if (excelFile != null && excelFile.getOriginalFilename() != null && excelFile.getOriginalFilename().length() > 0) {
            HashMap<String, Object> map = uploadPickingGoodsExcelService.uploadExcelFile(excelFile, manager);
            json.put("flag", map.get("flag"));
            json.put("msg", map.get("msg"));

            return json.toString();
        } else {
            json.put("flag", false);
            json.put("msg", "上传失败，文件为空");

            return json.toString();
        }
    }
}
