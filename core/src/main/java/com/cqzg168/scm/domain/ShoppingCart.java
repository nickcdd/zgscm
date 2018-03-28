package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;
import java.math.BigDecimal;

/**
 * Created by admin on 2017/5/15.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "shopping_cart")
public class ShoppingCart extends BaseDomain {


    private static final long serialVersionUID = -4592577436416351799L;
    /**
     * 商户sid
     */
    @Column(nullable = false)
    private Long shopKeeperSid;

    /**
     * 商品
     */
    @ManyToOne(targetEntity = Goods.class, cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    @JoinColumn(name = "goods_sid", referencedColumnName = "sid", nullable = false)
    private Goods goods;

    /**
     * 规格sid
     */
    @ManyToOne(targetEntity = GoodsSpecification.class, cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    @JoinColumn(name = "specification_sid", referencedColumnName = "sid", nullable = false)
    private GoodsSpecification goodsSpecification;

    /**
     * 商品数量
     */
    @Column(nullable = false)
    private Integer goodsAmount;

    public Long getShopKeeperSid() {
        return shopKeeperSid;
    }

    public void setShopKeeperSid(Long shopKeeperSid) {
        this.shopKeeperSid = shopKeeperSid;
    }

    public Goods getGoods() {
        return goods;
    }

    public void setGoods(Goods goods) {
        this.goods = goods;
    }

    public GoodsSpecification getGoodsSpecification() {
        return goodsSpecification;
    }

    public void setGoodsSpecification(GoodsSpecification goodsSpecification) {
        this.goodsSpecification = goodsSpecification;
    }

    public Integer getGoodsAmount() {
        return goodsAmount;
    }

    public void setGoodsAmount(Integer goodsAmount) {
        this.goodsAmount = goodsAmount;
    }
}
