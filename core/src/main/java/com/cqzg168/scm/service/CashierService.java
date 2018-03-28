package com.cqzg168.scm.service;

import java.util.Map;

/**
 * Created by admin on 2017/5/9.
 */
public interface CashierService {
    /**
     * 支付结果生成签名回调
     *
     * @param addtime   时间戳
     * @param pay_type  支付类型：1为微信，2为支付宝
     * @param subject   商户名称
     * @param total_fee 订单金额
     * @return
     */
    Map<String, Object> resultmap(Long sid, Long addtime, String pay_type, String subject, String total_fee);

    /**
     * 支付完成修改订单状态
     *
     * @param orderid    支付订单号
     * @param pay_id     交易流水号
     * @param pay_status 支付状态
     * @param date       支付时间戳
     * @param key        参数签名
     */
    String editOrders(String orderid, String pay_id, Integer pay_status, Integer date, String key);
}
