package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.GoodsSpecification;
import com.cqzg168.scm.domain.Inventory;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 库存接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface InventoryRepository extends BaseRepository<Inventory> {
    /**
     * 校验库存是否存在
     * @param goodsSid
     * @param specificationSid
     * @param storageSid
     * @return
     */
    @Query("select i from Inventory i where i.goods.sid=?1 and i.goodsSpecification.sid=?2 and i.storage.sid=?3")
    List<Inventory> checkInventory(Long goodsSid, Long specificationSid, Long storageSid);

    /**
     * 根据商品规格sid 查询 商品库存
     * @param goodsSpecification
     * @return
     */
    @Query("select i from Inventory i where i.goodsSpecification = ?1 and  i.status = 1")
    Inventory findBySpecificationSidInventory(GoodsSpecification goodsSpecification);
}
