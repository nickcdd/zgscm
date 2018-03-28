package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.OrdersLog;
import com.cqzg168.scm.repository.OrdersLogRepository;
import com.cqzg168.scm.service.OrdersLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class OrdersLogServiceImpl extends BaseServiceImpl<OrdersLog, OrdersLogRepository> implements OrdersLogService {
    private OrdersLogRepository repository;

    @Autowired
    @Override
    public void setRepository(OrdersLogRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    /**
     * 订单操作日志
     * @param manageSid
     * @param ordersSid
     * @param srcStatus
     * @param targetStatus
     * @param note
     */
    @Override
    public void saveOrdersLog(Long manageSid, Long ordersSid, Integer srcStatus, Integer targetStatus, String note){
        OrdersLog ordersLog = new OrdersLog();
        ordersLog.setManagerSid(manageSid);
        ordersLog.setSrcStatus(srcStatus);
        ordersLog.setTargetStatus(targetStatus);
        ordersLog.setOrdersSid(ordersSid);
        ordersLog.setNote(note);
        repository.save(ordersLog);
    }
}
