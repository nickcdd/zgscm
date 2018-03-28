package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.OrdersGoods;
import com.cqzg168.scm.domain.ShoppingCart;
import com.cqzg168.scm.repository.OrdersGoodsRepository;
import com.cqzg168.scm.service.OrdersGoodsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class OrdersGoodsServiceImpl extends BaseServiceImpl<OrdersGoods, OrdersGoodsRepository> implements OrdersGoodsService {


    private OrdersGoodsRepository repository;

    @Autowired
    @Override
    public void setRepository(OrdersGoodsRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public List<Orders> findByGoodsName(String goodsName) {
        return repository.findByGoodsName(goodsName);
    }

    @Override
    public void saveOrdersGoods(Orders orders, List<ShoppingCart> shoppingCarts) {
        for (ShoppingCart shoppingCart : shoppingCarts) {
            OrdersGoods ordersGoods = new OrdersGoods();
            ordersGoods.setOrders(orders);
            ordersGoods.setGoods(shoppingCart.getGoods());
            ordersGoods.setGoodsCname(shoppingCart.getGoods().getCname());
            ordersGoods.setGoodsCount(shoppingCart.getGoodsAmount());
            ordersGoods.setGoodsSpecificationCname(shoppingCart.getGoodsSpecification().getCname());
            ordersGoods.setGoodsSpecification(shoppingCart.getGoodsSpecification());
            ordersGoods.setGoodsSpecificationCost(shoppingCart.getGoodsSpecification().getCost());
            ordersGoods.setGoodsSpecificationPrice(shoppingCart.getGoodsSpecification().getPrice());
            repository.save(ordersGoods);
        }
    }

    @Override
    public OrdersGoods findByOdersSidAndGoodsBm(Long ordersSid, String goodsBm) {
        return repository.findByOdersSidAndGoodsBm(ordersSid,goodsBm);
    }
}
