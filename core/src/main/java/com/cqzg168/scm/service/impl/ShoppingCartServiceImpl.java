package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.repository.OrdersRepository;
import com.cqzg168.scm.repository.RebateRepository;
import com.cqzg168.scm.repository.ShopKeeperRepository;
import com.cqzg168.scm.repository.ShoppingCartRepository;
import com.cqzg168.scm.service.RebateService;
import com.cqzg168.scm.service.ShoppingCartService;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.RebateConfig;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * Created by admin on 2017/5/15.
 */
@Service
@Transactional
public class ShoppingCartServiceImpl extends BaseServiceImpl<ShoppingCart, ShoppingCartRepository> implements ShoppingCartService {

    private ShoppingCartRepository repository;

    @Autowired
    @Override
    public void setRepository(ShoppingCartRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    /**
     * 根据商户sid查询购物车列表
     *
     * @param shopKeeperSid
     * @return
     */
    @Override
    public List<ShoppingCart> findShoppingCartByShopKeeperSid(Long shopKeeperSid) {
        return repository.findShoppingCartByShopKeeperSid(shopKeeperSid);
    }

    /**
     * 根据sid查询状态为1 的购物车记录
     *
     * @param sid
     * @return
     */
    @Override
    public ShoppingCart findOneByGoodsAndAndGoodsSpecificationAndShopKeeperSid(Goods goods, GoodsSpecification goodsSpecification, Long shopkeeperSid) {
        return repository.findOneByGoodsAndAndGoodsSpecificationAndShopKeeperSid(goods, goodsSpecification, shopkeeperSid);
    }

    @Override
    public BigDecimal totalPrice(List<ShoppingCart> shoppingCarts) {
        BigDecimal result = new BigDecimal(0);
        for (ShoppingCart shoppingCart : shoppingCarts) {
            Integer amount = shoppingCart.getGoodsAmount();
            BigDecimal tempBigDecimal = shoppingCart.getGoodsSpecification().getPrice();
            result = result.add(tempBigDecimal.multiply(new BigDecimal(amount)));
        }
        result = result.setScale(2, BigDecimal.ROUND_UP);
        return result;
    }
}
