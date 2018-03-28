package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.OrdersRequestRecord;
import com.cqzg168.scm.repository.OrdersRequestRecordRepository;
import com.cqzg168.scm.service.OrdersRequestRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by admin on 2017/5/15.
 */
@Service
@Transactional
public class OrdersRequestRecordServiceImpl extends BaseServiceImpl<OrdersRequestRecord, OrdersRequestRecordRepository> implements OrdersRequestRecordService {

    private OrdersRequestRecordRepository repository;

    @Autowired
    @Override
    public void setRepository(OrdersRequestRecordRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }
}
