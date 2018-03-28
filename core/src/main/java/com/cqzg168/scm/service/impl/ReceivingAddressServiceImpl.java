package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.ReceivingAddress;
import com.cqzg168.scm.repository.ReceivingAddressRepository;
import com.cqzg168.scm.service.ReceivingAddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class ReceivingAddressServiceImpl extends BaseServiceImpl<ReceivingAddress, ReceivingAddressRepository> implements ReceivingAddressService {
    private ReceivingAddressRepository repository;

    @Autowired
    @Override
    public void setRepository(ReceivingAddressRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    /**
     * 更具地址默认字段查询默认地址
     *
     * @param isDefault
     * @return
     */
    public List<ReceivingAddress> findIsDefaultAddress(Integer isDefault) {
        return repository.findIsDefaultAddress(isDefault);
    }

    @Override
    public List<ReceivingAddress> findbyShopkeperAddressAll(Long sid) {
        return repository.findbyShopkeperAddressAll(sid);
    }
}
