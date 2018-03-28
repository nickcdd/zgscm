package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.OrderPayService;
import com.cqzg168.scm.service.OrdersLogService;
import com.cqzg168.scm.service.OrdersService;
import com.cqzg168.scm.service.ShopKeeperService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.RSAUtils;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;


import java.math.BigDecimal;
import java.util.*;

/**
 * Created by admin on 2017/7/21.
 */
@Service
@Transactional
public class OrderPayServiceImpl implements OrderPayService {

    @Value("${public_key}")
    private String publicKey;
    //支付宝微信 支付 url
    @Value("${order_pay_url}")
    private String url;
    @Value("${order_pay_notify_url}")
    private String notifyUrl;
    @Value("${order_pay_return_url}")
    private String returnUrl;
    @Value("${order_pay_subject}")
    private String subject;
    @Value("${order_pay_body}")
    private String body;
    @Autowired
    private OrdersService ordersService;
    @Autowired
    private OrdersLogService ordersLogService;
    @Autowired
    private ShopKeeperService shopKeeperService;


    @Override
    public String unionpayNotify(String payresult) {
        payresult = RSAUtils.decryptByPublic(payresult,publicKey);
        byte[] resultBytes = RSAUtils.decryptBase64(payresult);
        String result= "";
        try {
            result = new String(resultBytes,"utf-8");
        }catch (Exception e){
            e.printStackTrace();
        }
        String[] resultParmes = result.split("\\|");
        String billNo = resultParmes[0];
        String billstatus = resultParmes[6];
        String orderId = resultParmes[7];
        if("0".equals(billstatus)){
            Orders orders = ordersService.findOne(Long.parseLong(orderId));
            orders.setBillNo(billNo);
            //平台商品付款以后变为待检货状态
            if (orders.getSupplierSid() != null && orders.getSupplierSid() == -1) {
                orders.setStatus(7);
                ordersLogService.saveOrdersLog(-1L, orders.getSid(), 1, 7, "商户付款成功");
            } else {
                orders.setStatus(2);
                ordersLogService.saveOrdersLog(-1L, orders.getSid(), 1, 2, "商户付款成功");
            }
            if (orders.getChildrenOrders() != null && orders.getChildrenOrders().size() > 0) {
                for (Orders chlidrenOrder : orders.getChildrenOrders()) {
                    if (chlidrenOrder.getSupplierSid() == -1) {
                        chlidrenOrder.setStatus(7);
                        ordersLogService.saveOrdersLog(-1L, chlidrenOrder.getSid(), 1, 7, "商户付款成功");
                    } else {
                        chlidrenOrder.setStatus(2);
                        ordersLogService.saveOrdersLog(-1L, chlidrenOrder.getSid(), 1, 2, "商户付款成功");
                    }
                }
            }
            ordersService.save(orders);
        }
        return null;
    }

    /**
     * 微信支付
     * @param payType
     * @param orderid
     * @param totalFee
     * @return
     */
    @Override
    public String wechatPay(Integer payType, Long orderid, BigDecimal totalFee) {
        RestTemplate restTemplate = new RestTemplate();
        MultiValueMap<String, String> paramMap = payParam(payType, orderid, totalFee);
        return restTemplate.postForObject(url, paramMap, String.class);
    }

    /**
     * 生成支付参数
     * @param payType
     * @param orderid
     * @param totalFee
     * @return
     */
    @Override
    public MultiValueMap<String, String> payParam(Integer payType, Long orderid, BigDecimal totalFee) {
        List<String> list = new ArrayList<>();
        list.add("addtime");
        list.add("pay_type");
        list.add("total_fee");
        list.add("orderid");
        list.add("subject");
        list.add("notify_url");
        Collections.sort(list);
        //生成回调数据map
        MultiValueMap<String, String> resultMap = new LinkedMultiValueMap<>();
        resultMap.add("addtime", String.valueOf((System.currentTimeMillis() / 1000)));
        resultMap.add("pay_type", payType.toString());
        resultMap.add("orderid", orderid.toString());
        resultMap.add("subject", subject);
        totalFee = totalFee.setScale(2, BigDecimal.ROUND_HALF_UP);
        resultMap.add("total_fee", totalFee.toString());
        resultMap.add("body", body);
        resultMap.add("notify_url", notifyUrl);
        resultMap.add("return_url", returnUrl + "?type=1");
        //规则拼装键值对
        StringBuffer singSource = new StringBuffer();
        for (String str : list) {
            singSource.append("&" + str + "=" + resultMap.getFirst(str));
        }
        //先MD5加密然后RSA加密生成签名
        String strSource = singSource.toString().substring(1);
        strSource = Utils.getMD5String(strSource);
        String sign = RSAUtils.encryptByPublic(strSource, publicKey);
        resultMap.add("key", sign);

        return resultMap;
    }

    /**
     * 支付回调函数
     * @param orderid
     * @param pay_id
     * @param pay_status
     * @param date
     * @param key
     * @return
     */
    @Override
    public String payNotify(Long orderid, String pay_id, Integer pay_status, String date, String key) {
        List<String> list = new ArrayList<>();
        list.add("orderid");
        list.add("pay_id");
        list.add("pay_status");
        list.add("date");
        Collections.sort(list);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("orderid", orderid);
        resultMap.put("pay_id", pay_id);
        resultMap.put("pay_status", pay_status);
        resultMap.put("date", date);

        //规则拼装键值对
        StringBuffer singSource = new StringBuffer();
        for (String str : list) {
            singSource.append("&" + str + "=" + resultMap.get(str));
        }
        String source = singSource.toString();
        source = source.substring(1);
        //md5加密数据
        source = Utils.getMD5String(source);
        key = key.replaceAll(" ", "+");
        String targetSource = RSAUtils.decryptByPublic(key, publicKey);
        if (targetSource.equals(source)) {
            Orders orders = ordersService.findOne(orderid);
            //平台商品付款以后变为待检货状态
            if (orders.getSupplierSid() != null && orders.getSupplierSid() == -1) {
                orders.setStatus(7);
                ordersLogService.saveOrdersLog(-1L, orders.getSid(), 1, 7, "商户付款成功");
            } else {
                orders.setStatus(2);
                ordersLogService.saveOrdersLog(-1L, orders.getSid(), 1, 2, "商户付款成功");
            }
            if (orders.getChildrenOrders() != null && orders.getChildrenOrders().size() > 0) {
                for (Orders chlidrenOrder : orders.getChildrenOrders()) {
                    if (chlidrenOrder.getSupplierSid() == -1) {
                        chlidrenOrder.setStatus(7);
                        ordersLogService.saveOrdersLog(-1L, chlidrenOrder.getSid(), 1, 7, "商户付款成功");
                    } else {
                        chlidrenOrder.setStatus(2);
                        ordersLogService.saveOrdersLog(-1L, chlidrenOrder.getSid(), 1, 2, "商户付款成功");
                    }
                }
            }
            return "success";
        }
        return "error";
    }

    /**
     * 采购余额支付
     * @param ordersSid
     * @return
     */
    @Override
    public Integer ordersPayByCredit(Long ordersSid) {
        try {
            Orders orders = ordersService.findOne(ordersSid);
            ShopKeeper shopKeeper = shopKeeperService.findOne(orders.getShopKeeper().getSid());
            BigDecimal tempPirce = shopKeeper.getCredit().subtract(orders.getPayAmount());
            tempPirce = tempPirce.setScale(2, BigDecimal.ROUND_HALF_UP);
            shopKeeper.setCredit(tempPirce);
            shopKeeperService.save(shopKeeper);
            //更新session
            Session session = SecurityUtils.getSubject().getSession();
            session.setAttribute(Constant.SessionKey.CURRENT_USER, shopKeeper);
            //平台商品付款以后变为待检货状态
            if (orders.getSupplierSid() != null && orders.getSupplierSid() == -1) {
                orders.setStatus(7);
                ordersLogService.saveOrdersLog(-1L, orders.getSid(), 1, 7, "商户付款成功");
            } else {
                orders.setStatus(2);
                ordersLogService.saveOrdersLog(-1L, orders.getSid(), 1, 2, "商户付款成功");
            }

            if (orders.getChildrenOrders() != null && orders.getChildrenOrders().size() > 0) {
                for (Orders chlidrenOrder : orders.getChildrenOrders()) {
                    if (chlidrenOrder.getSupplierSid() == -1) {
                        chlidrenOrder.setStatus(7);
                        ordersLogService.saveOrdersLog(-1L, chlidrenOrder.getSid(), 1, 7, "商户付款成功");
                    } else {
                        chlidrenOrder.setStatus(2);
                        ordersLogService.saveOrdersLog(-1L, chlidrenOrder.getSid(), 1, 2, "商户付款成功");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 2;
        }
        return 1;
    }

}
