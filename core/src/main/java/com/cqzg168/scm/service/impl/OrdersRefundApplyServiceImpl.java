package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.OrdersRefundApply;
import com.cqzg168.scm.repository.OrdersRefundApplyRepository;
import com.cqzg168.scm.service.OrdersRefundApplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class OrdersRefundApplyServiceImpl extends BaseServiceImpl<OrdersRefundApply, OrdersRefundApplyRepository> implements OrdersRefundApplyService {
    private OrdersRefundApplyRepository repository;

    @Autowired
    @Override
    public void setRepository(OrdersRefundApplyRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }
}
