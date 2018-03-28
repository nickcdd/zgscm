package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.GoodsSpecification;
import com.cqzg168.scm.domain.ShoppingCart;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Created by admin on 2017/5/15.
 */
@Repository
public interface ShoppingCartRepository extends BaseRepository<ShoppingCart> {

    /**
     * 根据商户sid查询购物车列表
     *
     * @param shopKeeperSid
     * @return
     */
    @Query("select s from ShoppingCart s where s.shopKeeperSid = ?1 and s.status = 1")
    List<ShoppingCart> findShoppingCartByShopKeeperSid(Long shopKeeperSid);

    /**
     * 根据商户sid、商品、规格查询状态为1 的购物车记录
     *
     * @param shopkeeperSid
     * @return
     */
    @Query("select s from ShoppingCart s where s.goods = ?1 and s.goodsSpecification = ?2 and s.shopKeeperSid = ?3 and s.status = 1")
    ShoppingCart findOneByGoodsAndAndGoodsSpecificationAndShopKeeperSid(Goods goods, GoodsSpecification goodsSpecification, Long shopkeeperSid);
}
