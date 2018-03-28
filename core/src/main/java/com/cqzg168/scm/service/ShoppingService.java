package com.cqzg168.scm.service;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

/**
 * Created by admin on 2017/7/4.
 */
public interface ShoppingService {
    /**
     * 判断库存是否足够
     * @param shoppingCartSid
     * @return
     */
    String inventoryIsSufficient(String[] shoppingCartSid);
    /**
     * 判断订单总金额是否大于1000
     *
     * @param shoppingCartSid
     * @return
     */
    Integer orderTotalPirceEstimate(String[] shoppingCartSid,Long addressSid);
}
