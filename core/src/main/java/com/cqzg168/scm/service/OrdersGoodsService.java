package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.OrdersGoods;
import com.cqzg168.scm.domain.ShoppingCart;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface OrdersGoodsService extends BaseService<OrdersGoods> {
    /**
     * 根据商品名模糊查询
     *
     * @param goodsName
     * @return
     */
    List<Orders> findByGoodsName(String goodsName);


    void saveOrdersGoods(Orders orders, List<ShoppingCart> shoppingCart);

    OrdersGoods findByOdersSidAndGoodsBm(Long ordersSid,String goodsBm);
}
