package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;
import java.math.BigDecimal;

/**
 * 订单商品详情实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "orders_goods")
public class OrdersGoods extends BaseDomain {

    private static final long serialVersionUID = -3284150727193029391L;
    /**
     * 订单SID
     */
    @ManyToOne(optional = true, fetch = FetchType.EAGER)
    @JoinColumn(name = "order_sid", nullable = false)
    private Orders orders;
    //    /**
//     * 商品SID
//     */
//    @Column(nullable = false)
//    private Long goodsSid;
    @ManyToOne(targetEntity = Goods.class, cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    @JoinColumn(name = "goods_sid", referencedColumnName = "sid", nullable = false)
    private Goods goods;
    /**
     * 商品数量
     */
    @Column(nullable = false)
    private Integer goodsCount;
    /**
     * 商品名称
     */
    @Column(nullable = false)
    private String goodsCname;

    /**
     * 商品规格SID
     */
//    @Column(nullable = false)
//    private Long goodsSpecificationSid;
    @ManyToOne(targetEntity = GoodsSpecification.class, cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    @JoinColumn(name = "goods_specification_sid", referencedColumnName = "sid", nullable = false)
    private GoodsSpecification goodsSpecification;
    /**
     * 商品规格名称
     */
    @Column(nullable = false)
    private String goodsSpecificationCname;
    /**
     * 售价，单位：元
     */
    @Column(nullable = false)
    private BigDecimal goodsSpecificationPrice;
    /**
     * 进价，单位：元
     */
    @Column(nullable = false)
    private BigDecimal goodsSpecificationCost;

    public Orders getOrders() {
        return orders;
    }

    public void setOrders(Orders orders) {
        this.orders = orders;
    }

//    public Long getGoodsSid() {
//        return goodsSid;
//    }
//
//    public void setGoodsSid(Long goodsSid) {
//        this.goodsSid = goodsSid;
//    }

    public Integer getGoodsCount() {
        return goodsCount;
    }

    public void setGoodsCount(Integer goodsCount) {
        this.goodsCount = goodsCount;
    }

    public String getGoodsCname() {
        return goodsCname;
    }

    public void setGoodsCname(String goodsCname) {
        this.goodsCname = goodsCname;
    }

//    public Long getGoodsSpecificationSid() {
//        return goodsSpecificationSid;
//    }
//
//    public void setGoodsSpecificationSid(Long goodsSpecificationSid) {
//        this.goodsSpecificationSid = goodsSpecificationSid;
//    }

    public String getGoodsSpecificationCname() {
        return goodsSpecificationCname;
    }

    public void setGoodsSpecificationCname(String goodsSpecificationCname) {
        this.goodsSpecificationCname = goodsSpecificationCname;
    }

    public BigDecimal getGoodsSpecificationPrice() {
        return goodsSpecificationPrice;
    }

    public void setGoodsSpecificationPrice(BigDecimal goodsSpecificationPrice) {
        this.goodsSpecificationPrice = goodsSpecificationPrice;
    }

    public BigDecimal getGoodsSpecificationCost() {
        return goodsSpecificationCost;
    }

    public void setGoodsSpecificationCost(BigDecimal goodsSpecificationCost) {
        this.goodsSpecificationCost = goodsSpecificationCost;
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
}
