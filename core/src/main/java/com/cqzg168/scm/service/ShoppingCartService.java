package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.GoodsSpecification;
import com.cqzg168.scm.domain.ShoppingCart;

import java.math.BigDecimal;
import java.util.List;

/**
 * Created by admin on 2017/5/15.
 */
public interface ShoppingCartService extends BaseService<ShoppingCart> {
    /**
     * 根据商户sid查询购物车列表
     *
     * @param shopKeeperSid
     * @return
     */
    List<ShoppingCart> findShoppingCartByShopKeeperSid(Long shopKeeperSid);

    /**
     * 计算总金额
     *
     * @param shoppingCarts
     * @return
     */
    BigDecimal totalPrice(List<ShoppingCart> shoppingCarts);

    /**
     * 根据sid查询状态为1 的购物车记录
     *
     * @param goods
     * @return
     */
    ShoppingCart findOneByGoodsAndAndGoodsSpecificationAndShopKeeperSid(Goods goods, GoodsSpecification goodsSpecification, Long shopkeeperSid);
}
