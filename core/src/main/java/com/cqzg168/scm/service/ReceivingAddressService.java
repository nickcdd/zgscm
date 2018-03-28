package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.ReceivingAddress;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface ReceivingAddressService extends BaseService<ReceivingAddress> {
    /**
     * 更具地址默认字段查询默认地址
     *
     * @param isDefault
     * @return
     */
    List<ReceivingAddress> findIsDefaultAddress(Integer isDefault);

    /**
     * 查询当前商户下面所有收货地址
     *
     * @param sid
     * @return
     */
    List<ReceivingAddress> findbyShopkeperAddressAll(Long sid);
}
