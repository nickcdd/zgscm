package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.OrdersLog;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.RSAUtils;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;

/**
 * Created by admin on 2017/5/9.
 */
@Service
@Transactional
public class CashierServiceImpl implements CashierService {
    @Value("${public_key}")
    private String publicKey;
    @Value("${notify_url}")
    private String notifyUrl;
    @Value("${show_url}")
    private String showUrl;
    @Value("${return_url}")
    private String returnUrl;
    @Value("${close_window}")
    private String closeWindow;
    @Value("${body}")
    private String body;

    @Autowired
    private OrdersService ordersService;
    @Autowired
    private ShopKeeperService shopKeeperService;
    @Autowired
    private SMSService smsService;
    @Autowired
    private OrdersLogService ordersLogService;

    @Override
    public Map<String, Object> resultmap(Long sid, Long addtime, String pay_type, String subject, String total_fee) {

        //发起支付生成待付款订单
        Orders orders = new Orders();
        orders.setStatus(1);
        ShopKeeper shopKeeper = shopKeeperService.findOne(sid);
        orders.setShopKeeper(shopKeeper);
//        orders.setShopKeeperSid(sid);
        orders.setPayAmount(new BigDecimal(total_fee.substring(1)));
        orders.setTotalAmount(new BigDecimal(total_fee.substring(1)));
        orders.setType(2);
        orders.setChannel(Integer.parseInt(pay_type));
        orders.setProvince("");
        orders.setCity("");
        orders.setArea("");
        orders.setAddress("");
        ordersService.save(orders);

        //生成回调数据map
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("addtime", addtime);
        resultMap.put("pay_type", pay_type);
        resultMap.put("orderid", orders.getSid());
        resultMap.put("subject", subject);
        //注意此处多了一个“￥”，需要去掉
        resultMap.put("total_fee", total_fee.substring(1));
        resultMap.put("body", body);
        resultMap.put("notify_url", notifyUrl);
        resultMap.put("return_url", returnUrl);
        resultMap.put("show_url", showUrl + "?sid=" + orders.getSid());
        resultMap.put("close_window", closeWindow);

        //升序排列key值
        List<String> list = new ArrayList<>();
        list.add("addtime");
        list.add("pay_type");
        list.add("total_fee");
        list.add("orderid");
        list.add("subject");
        list.add("notify_url");
        list.add("return_url");
        Collections.sort(list);

        //规则拼装键值对
        StringBuffer singSource = new StringBuffer();
        for (String str : list) {
            singSource.append("&" + str + "=" + resultMap.get(str));
        }

        //先MD5加密然后RSA加密生成签名
        String strSource = singSource.toString().substring(1);
        strSource = Utils.getMD5String(strSource);
        String sign = RSAUtils.encryptByPublic(strSource, publicKey);
        resultMap.put("sign", sign);
        return resultMap;
    }

    @Override
    public String editOrders(String orderid, String pay_id, Integer pay_status, Integer date, String key) {
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
        if (source.equals(targetSource)) {
            if (pay_status == 1) {
                Orders orders = ordersService.findOne(Long.parseLong(orderid));
                orders.setStatus(4);
                orders.setFreeze(1);
                ordersService.save(orders);
                //订单操作日志
                ordersLogService.saveOrdersLog(-1L, orders.getSid(), 1, 4, "商户收款成功");
                smsService.gatheringSmsPush(orders.getShopKeeper().getTelephone(), orders.getPayAmount().doubleValue());
                return "success";
            }
        }
        return "error";

    }

}
