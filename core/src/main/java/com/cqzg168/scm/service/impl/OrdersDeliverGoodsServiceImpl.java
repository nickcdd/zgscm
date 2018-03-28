package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.service.OrdersDeliverGoodsService;
import com.cqzg168.scm.service.OrdersLogService;
import com.cqzg168.scm.service.OrdersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by admin on 2017/8/9.
 */
@Service
@Transactional
public class OrdersDeliverGoodsServiceImpl implements OrdersDeliverGoodsService {
    @Autowired
    private OrdersService    ordersService;
    @Autowired
    private OrdersLogService ordersLogService;

    /**
     * 供应商发货
     * @param orders
     * @param status
     * @return
     */
    @Override
    public String suplierDeliverGoods(Orders orders) {
        Long parentOrderSid = orders.getParentOrderSid();
        if (parentOrderSid != null) {
            boolean flag         = true;
            Orders  parentOrders = ordersService.findOne(parentOrderSid);
            for (Orders tempOrders : parentOrders.getChildrenOrders()) {
                if (tempOrders.getStatus() == 2) {
                    flag = false;
                }
            }
            if (flag) {
                parentOrders.setStatus(3);
                ordersService.save(parentOrders);
                ordersLogService.saveOrdersLog(-1L, parentOrders.getSid(), 2, 3, "供应商发货，子订单全部没有待付款状态。");
            }
        }
        return null;
    }
}
