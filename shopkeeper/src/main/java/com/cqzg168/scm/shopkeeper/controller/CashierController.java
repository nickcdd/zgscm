package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.CashierService;
import com.cqzg168.scm.service.OrdersService;
import com.cqzg168.scm.service.ShopKeeperService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 收银台
 * Created by jackytsu on 2017/5/4.
 */
@RequestMapping("/cashier")
@Controller
public class CashierController extends BaseController {

    @Autowired
    private        ShopKeeperService shopKeeperService;
    @Autowired
    private        CashierService    cashierService;
    @Autowired
    private        OrdersService     ordersService;
    @Value("${public_key}")
    private static String            publicKey;

    /**
     * 输入付款金额
     *
     * @param sid
     * @param m
     * @return
     */
    @RequestMapping("/index")
    public String index(HttpServletResponse response, HttpServletRequest request, Long sid, Model m) {
        String agent  = request.getHeader("User-Agent").toLowerCase();
        int    payWay = 0;
        if (agent.toLowerCase().indexOf("micromessenger") > 0) {
            //微信访问
            payWay = 1;
        } else if (agent.toLowerCase().indexOf("alipayclient") > 0) {
            payWay = 2;
        } else {
            // m.addAttribute("ERROR_MESSAGE", "不支持当前浏览器访问，请用微信或支付宝支付！");
            // return "/cashier/index";
        }
        if (sid == null || sid < 1L) {
            m.addAttribute("ERROR_MESSAGE", "无效的商户");
            return "/cashier/index";
        }

        ShopKeeper shopKeeper = shopKeeperService.findOne(sid);
        if (shopKeeper == null) {
            m.addAttribute("ERROR_MESSAGE", "商户不存在");
            return "/cashier/index";
        }

        if (shopKeeper.getStatus() != ShopKeeper.Status.AVAILABLE.getStatus()) {
            m.addAttribute("ERROR_MESSAGE", "当前商户被禁用");
            return "/cashier/index";
        }
        m.addAttribute("shopKeeper", shopKeeper);
        m.addAttribute("payWay", payWay);

        return "/cashier/index";
    }

    /**
     * 发起支付
     *
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/pay", method = RequestMethod.POST)
    public AjaxResult pay(Long sid, String total_fee, String pay_type) {
        ShopKeeper shopKeeper = shopKeeperService.findOne(sid);
        //时间戳：秒
        Long                addtime   = System.currentTimeMillis() / 1000;
        String              subject   = shopKeeper.getCname();
        Map<String, Object> resultMap = cashierService.resultmap(shopKeeper.getSid(), addtime, pay_type, subject, total_fee);
        return AjaxResult.ajaxSuccessResult("生成签名", resultMap);
    }

    /**
     * 支付回调
     *
     * @return
     */
    @ResponseBody
    @RequestMapping("/notify")
    public String payNotify(String orderid, String pay_id, Integer pay_status, Integer date, String key) {
        return cashierService.editOrders(orderid, pay_id, pay_status, date, key);
    }

}
