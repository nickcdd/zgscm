package com.cqzg168.scm.service;

import org.springframework.util.MultiValueMap;

import java.math.BigDecimal;

/**
 * Created by Administrator on 2017/6/21 0021.
 */
public interface OrderPayService {
    /**
     * 银联支付异步回调
     * @param payresult
     * @return
     */
    String unionpayNotify(String payresult);

    /**
     * 微信支付
     * @param payType
     * @param orderid
     * @param totalFee
     */
    String wechatPay(Integer payType, Long orderid, BigDecimal totalFee);

    /**
     * 生成订单支付参数
     * @param payType
     * @param orderid
     * @param totalFee
     * @return
     */
    MultiValueMap<String, String> payParam(Integer payType, Long orderid, BigDecimal totalFee);
    /**
     * 支付回调方法
     * @param orderid
     * @param pay_id
     * @param pay_status
     * @param key
     * @return
     */
    String payNotify(Long orderid, String pay_id, Integer pay_status, String date, String key);

    /**
     * 采购余额支付
     * @param ordersSid
     */
    Integer ordersPayByCredit(Long ordersSid);
}
