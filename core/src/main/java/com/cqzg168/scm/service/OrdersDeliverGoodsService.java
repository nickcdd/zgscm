package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Orders;

/**
 * Created by admin on 2017/8/9.
 */
public interface OrdersDeliverGoodsService {
    /**
     * 供应商发货
     * @param orders
     * @param status
     * @return
     */
    String suplierDeliverGoods(Orders orders);
}
