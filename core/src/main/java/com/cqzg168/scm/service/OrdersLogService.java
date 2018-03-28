package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.OrdersLog;

/**
 * Created by think on 2017/4/27.
 */
public interface OrdersLogService extends BaseService<OrdersLog> {

    /**
     * 订单操作日志保存
     * @param manageSid
     * @param ordersSid
     * @param srcStatus
     * @param targetStatus
     * @param note
     */
    void saveOrdersLog(Long manageSid, Long ordersSid, Integer srcStatus, Integer targetStatus, String note);
}
