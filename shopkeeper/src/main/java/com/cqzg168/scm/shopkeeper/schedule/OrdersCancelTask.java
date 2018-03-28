package com.cqzg168.scm.shopkeeper.schedule;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.service.OrdersService;
import com.cqzg168.scm.utils.DateUtil;
import org.hibernate.criterion.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

/**
 * Created by jackytsu on 2017/7/7.
 */
@Transactional
@Component
public class OrdersCancelTask {

    private final Logger logger = Logger.getLogger(ShopKeeperSettleAccountTask.class.getName());

    @Autowired
    private OrdersService ordersService;
    @Value("${orders_no_payment_cancel_time}")
    private String        ordersNoPaymentCancelTime;

    @Scheduled(cron = "0 * * * * ?")
    public void run() {
        Date       flagTime      = new Date();
        Date       targetTime    = DateUtil.getSubtractTargetTime(flagTime, Integer.parseInt(ordersNoPaymentCancelTime));
        List<Long> ordersSidList = ordersService.deleteByNoPaymentOrders(targetTime);
        if (ordersSidList != null && ordersSidList.size() > 0) {
            ordersService.remove(ordersSidList);
        }
    }
}
