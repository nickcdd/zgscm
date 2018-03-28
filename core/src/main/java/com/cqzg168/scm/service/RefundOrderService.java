package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.ShopKeeper;
import org.json.JSONException;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/21 0021.
 */
public interface RefundOrderService {
    /**
     * 退款到支付宝或者微信
     * @return
     */
    Map<String,Object> refundToWeChatOrAlipay(Long ordersSid,BigDecimal amount);

    /**
     * 退款到商户采购余额
     * @return
     */
    Map<String,Object> refundToCredit(Long ordersSid,BigDecimal amount,ShopKeeper shopKeeper);

    /**
     * 通过民生付退款
     * @param billNo
     * @param amount
     * @return
     */
//     Map<String,Object> refundToBankCard(String billNo, BigDecimal amount);
}
