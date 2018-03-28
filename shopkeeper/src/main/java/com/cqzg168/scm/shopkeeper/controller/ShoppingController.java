package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by admin on 2017/5/17.
 */
@RequestMapping("/shopping")
@Controller
public class ShoppingController extends BaseController {

    @Autowired
    private ReceivingAddressService   receivingAddressService;
    @Autowired
    private ShoppingCartService       shoppingCartService;
    @Autowired
    private OrdersService             ordersService;
    @Autowired
    private OrdersLogService          ordersLogService;
    @Autowired
    private ShopKeeperService         shopKeeperService;
    @Autowired
    private GoodsService              goodsService;
    @Autowired
    private GoodsSpecificationService goodsSpecificationService;
    @Autowired
    private LongbaiApiService         longbaiApiService;
    @Autowired
    private OrderPayService           orderPayService;
    @Autowired
    private ShoppingService           shoppingService;
    @Autowired
    private InventoryService inventoryService;
    @Value("${orders_no_payment_cancel_time}")
    private String                    ordersNoPaymentCancelTime;
    @Value("${order_pay_url}")
    private String                    orderPayUrl;
    @Value("${order_pay_url_mobile}")
    private String                    orderPayUrlMobile;
    @Value("${orders_total_pirce_estimate}")
    private String                    ordersTotalPirceEstimate;
    @Value("${orders_total_pirce_estimate_special}")
    private String                    ordersTotalPirceEstimateSpecial;

    /**
     * 购买首页
     *
     * @param goodsSids
     * @param model
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(Device device, String[] goodsSids, Long goodsSid, Long specificationSid, Integer goodsAmount, Model model) {
        Session            session       = SecurityUtils.getSubject().getSession();
        ShopKeeper         shopKeeper    = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        List<ShoppingCart> shoppingCarts = new ArrayList<>();
        if (!Utils.isNull(goodsSids)) {
            for (int i = 0; i < goodsSids.length; i++) {
                ShoppingCart shoppingCart = shoppingCartService.findOne(Long.parseLong(goodsSids[i]));
                shoppingCarts.add(shoppingCart);
            }
        } else {
            ShoppingCart       shoppingCart       = new ShoppingCart();
            Goods              goods              = goodsService.findOne(goodsSid);
            GoodsSpecification goodsSpecification = goodsSpecificationService.findOne(specificationSid);
            shoppingCart.setShopKeeperSid(shopKeeper.getSid());
            shoppingCart.setGoods(goods);
            shoppingCart.setGoodsSpecification(goodsSpecification);
            shoppingCart.setGoodsAmount(goodsAmount);
            session.setAttribute("buy_now", shoppingCart);
            shoppingCarts.add(shoppingCart);
        }
        BigDecimal totalPrice = shoppingCartService.totalPrice(shoppingCarts);
        //收货地址
        List<ReceivingAddress> addresses = receivingAddressService.findbyShopkeperAddressAll(shopKeeper.getSid());
        model.addAttribute("shoppingCarts", shoppingCarts);
        model.addAttribute("ordersTotalPrice", totalPrice.doubleValue());
        model.addAttribute("shopKeeper", shopKeeper);
        model.addAttribute("addresses", addresses);
        model.addAttribute("ordersTotalPirceEstimateSpecial", ordersTotalPirceEstimateSpecial);
        model.addAttribute("ordersTotalPirceEstimate", ordersTotalPirceEstimate);
        if (device.isNormal()) {
            return "shopping/index";
        } else {
            return "shopping/index_mobile";
        }
    }

    /**
     * 确认订单
     *
     * @return
     */
    @RequestMapping(value = "/confirmOrder")
    public String pay(Device device, String[] shoppingCartSid, String addressSid, Integer payType) {
        Session            session            = SecurityUtils.getSubject().getSession();
        ShopKeeper         shopKeeper         = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        List<ShoppingCart> shoppingCarts      = new ArrayList<>();
        ShoppingCart       shoppingCartBuyNow = (ShoppingCart) session.getAttribute("buy_now");
        if (!Utils.isNull(shoppingCartSid) && shoppingCartSid.length > 0) {
            for (int i = 0; i < shoppingCartSid.length; i++) {
                ShoppingCart shoppingCart = shoppingCartService.findOne(Long.parseLong(shoppingCartSid[i]));
                shoppingCarts.add(shoppingCart);
            }
        } else if (shoppingCartBuyNow != null) {
            shoppingCarts.add(shoppingCartBuyNow);
        }
        ReceivingAddress receivingAddress = receivingAddressService.findOne(Long.parseLong(addressSid));
        Orders           orders           = ordersService.saveOrders(shopKeeper, shoppingCarts, receivingAddress, null);
        //分单
        ordersService.saveOrdersBySupplier(orders, shopKeeper, shoppingCarts, receivingAddress);
        //删除购物车记录
        List<Long> longSids = new ArrayList<>();
        for (ShoppingCart shoppingCart : shoppingCarts) {
            if (shoppingCart.getSid() != null) {
                longSids.add(shoppingCart.getSid());
            }
        }
        if (longSids.size() > 0) {
            shoppingCartService.remove(longSids);
        }
        session.removeAttribute("buy_now");

        return "redirect:/shopping/pay?ordersSid=" + orders.getSid() + "&payType=" + payType;
    }

    /**
     * 订单提交前验证
     *
     * @param shoppingCartSid
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/orderSubmitVerification")
    public Map<String, String> orderSubmitVerification(String[] shoppingCartSid, Long addressSid) {
        Map<String, String> jsonObject = new HashMap<>();
        //判断库存
        String flagInventory = shoppingService.inventoryIsSufficient(shoppingCartSid);
        //判断平台订单总金额
        Integer status = shoppingService.orderTotalPirceEstimate(shoppingCartSid, addressSid);

        if (!"success".equals(flagInventory)) {
            jsonObject.put("code", "0");
            jsonObject.put("msg", flagInventory);
            return jsonObject;
        }
        if(status == 1){
            jsonObject.put("code", "1");
            jsonObject.put("msg", "主城九区以内的地区，金额不满足要求。有其它非平台商品。");
            return jsonObject;
        }else if(status == 2){
            jsonObject.put("code", "2");
            jsonObject.put("msg", "主城九区以内的地区，金额不满足要求。没有其它非平台商品。");
            return jsonObject;
        }else if(status == 3){
            jsonObject.put("code", "3");
            jsonObject.put("msg", "主城九区以外的地区，金额不满足要求。有其它非平台商品。");
            return jsonObject;
        }else if(status == 4){
            jsonObject.put("code", "4");
            jsonObject.put("msg", "主城九区以外的地区，金额不满足要求。没有其它非平台商品。");
            return jsonObject;
        }
        jsonObject.put("code", "6");
        jsonObject.put("msg", "success");
        return jsonObject;
    }

    /**
     * 订单支付
     *
     * @param ordersSid
     * @param model
     * @param payType
     * @return
     */
    @RequestMapping(value = "/pay")
    public String confirmPay(Device device, Long ordersSid, Model model, Integer payType) {
        Orders orders = ordersService.findOne(ordersSid);
        orders.setChannel(payType);
        ordersService.save(orders);
        if (payType == 1) {
            String resultStr = orderPayService.wechatPay(payType, orders.getSid(), orders.getPayAmount());
            try {
                JSONObject jsonObject = new JSONObject(resultStr);
                String     return_msg = jsonObject.getString("return_msg");
                String     code_url   = "";
                if ("OK".equals(return_msg)) {
                    code_url = jsonObject.getString("code_url");
                }
                model.addAttribute("urlPay", code_url);
            } catch (Exception e) {
                model.addAttribute("urlPay", "");
                e.printStackTrace();
            }
        } else if (payType == 2 || payType == 3) {
            MultiValueMap multiValueMap = orderPayService.payParam(payType, orders.getSid(), orders.getPayAmount());
            model.addAttribute("multiValueMap", multiValueMap);
        } else if (payType == 4) {
            ShopKeeper shopKeeper = shopKeeperService.findOne(orders.getShopKeeper().getSid());
            model.addAttribute("shopKeeper", shopKeeper);
        }
        model.addAttribute("orders", orders);
        model.addAttribute("payType", payType);
        model.addAttribute("ordersNoPaymentCancelTime", ordersNoPaymentCancelTime);
        if (device.isNormal()) {
            model.addAttribute("orderPayUrl", orderPayUrl);
            return "/shopping/confirmPay";
        } else {
            model.addAttribute("orderPayUrl", orderPayUrlMobile);
            return "/shopping/confirmPay_mobile";
        }
    }

    /**
     * 支付回调方法
     *
     * @param orderid
     * @param pay_id
     * @param pay_status
     * @param date
     * @param key
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/notify", method = RequestMethod.POST)
    public String notify(Long orderid, String pay_id, Integer pay_status, String date, String key) {
        return orderPayService.payNotify(orderid, pay_id, pay_status, date, key);
    }


    /**
     * 支付成功页面
     *
     * @param orderid
     * @return
     */
    @RequestMapping(value = "/paySuccess")
    public String paySuccess(Device device, Long orderid, Integer status, Model model) {
        Orders orders = ordersService.findOne(orderid);
        //发起相关供应商订单请求
        longbaiApiService.result(orders);
        model.addAttribute("orders", orders);
        model.addAttribute("status", status);
        if (device.isNormal()) {
            return "/shopping/paySuccess";
        } else {
            return "/shopping/paySuccess_mobile";
        }
    }

    /**
     * 微信支付结果验证
     *
     * @param orderid
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/wechatPayResultVerification")
    public AjaxResult wechatPayResultVerification(Long orderid) {
        Orders orders = ordersService.findOne(orderid);
        if (orders.getChildrenOrders() != null && orders.getChildrenOrders().size() > 0) {
            Integer status = orders.getChildrenOrders().get(0).getStatus();
            if (status == 2 || status == 3 || status == 7) {
                return AjaxResult.ajaxSuccessResult("paySuccess", "");
            }
        } else {
            Integer status = orders.getStatus();
            if (status == 2 || status == 3 || status == 7) {
                return AjaxResult.ajaxSuccessResult("paySuccess", "");
            }
        }
        return AjaxResult.ajaxSuccessResult("payError", "");
    }

    /**
     * 采购余额支付
     *
     * @param orderSid
     * @return
     */
    @RequestMapping(value = "/creditPay")
    public String creditPay(Long orderSid) {
        Integer result = orderPayService.ordersPayByCredit(orderSid);
        return "redirect:/shopping/paySuccess?orderid=" + orderSid + "&status=" + result;
    }

    /**
     * 收货
     *
     * @param orderid
     * @return
     */
    @RequestMapping(value = "/takeGoods")
    public String takeGoods(Long orderid) {
        Orders orders = ordersService.findOne(orderid);
        orders.setStatus(4);
        ordersService.save(orders);
        ordersLogService.saveOrdersLog(-1L, orders.getSid(), 3, 4, "商户确认收货");
        if (orders.getParentOrderSid() != null) {
            ordersService.parentOrdersTakeGoods(orders.getParentOrderSid());
        }
        return "redirect:/order/index";
    }
    /**
     * 获取商品库存
     * @param specificationSid
     * @return
     */
    @ResponseBody
    @RequestMapping("/getInvertory")
    public AjaxResult getInvertory(Long specificationSid){
        GoodsSpecification goodsSpecification = goodsSpecificationService.findOne(specificationSid);
        Long resultInventory = inventoryService.getGoodsInventory(goodsSpecification.getGoodsBm(),specificationSid);
        return AjaxResult.ajaxSuccessResult("",resultInventory);
    }
}
