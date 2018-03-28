package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.ReceivingAddress;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 收货地址数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface ReceivingAddressRepository extends BaseRepository<ReceivingAddress> {

    /**
     * 更具地址默认字段查询默认地址
     *
     * @param isDefault
     * @return
     */
    @Query("select s from ReceivingAddress s where s.isDefault = ?1 and s.status = 1")
    List<ReceivingAddress> findIsDefaultAddress(Integer isDefault);

    /**
     * 查询当前商户下所有收货地址
     *
     * @param isDefault
     * @return
     */
    @Query("select s from ReceivingAddress s where s.shopKeeperSid = ?1 and s.status = 1")
    List<ReceivingAddress> findbyShopkeperAddressAll(Long sid);
}
