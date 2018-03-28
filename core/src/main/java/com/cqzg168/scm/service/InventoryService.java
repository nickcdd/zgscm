package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.GoodsSpecification;
import com.cqzg168.scm.domain.Inventory;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface InventoryService extends BaseService<Inventory> {

    /**
     * 分页查询
     * @param goodsName
     * @param storageSid
     * @param pageable
     * @return
     */
    Page<Inventory> findEnventoryByPage(Long supplierSid,String goodsName, String storageSid, Pageable pageable);

    /**
     * 校验重复
     * @param goodsSid
     * @param specificationSid
     * @param storageSid
     * @return
     */
    List<Inventory> checkInventory(Long goodsSid, Long specificationSid, Long storageSid);

    /**
     * 根据商品规格sid 查询 商品库存
     * @param goodsSpecification
     * @return
     */
    Inventory findBySpecificationSidInventory(GoodsSpecification goodsSpecification);
    /**
     * 获得商品库存
     *
     * @param goodsBm
     * @return
     */
    Long getGoodsInventory(String goodsBm, Long goodsSpecificationSid);

}
