package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.List;

/**
 * 商品规格实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "goods_specification")
public class GoodsSpecification extends BaseDomain {

    private static final long serialVersionUID = 4260738823751021515L;
    /**
     * 商品sid
     */
    @Column(nullable = false)
    private Long goodsSid;

    /**
     * 商品编码
     */
    @Column
    private String goodsBm;
    /**
     * 条码
     */
    @Column
    private String barcode;
    /**
     * 名称
     */
    @Column
    private String cname;
    /**
     * 售价，单位：元
     */
    @Column(nullable = false)
    private BigDecimal price;
    /**
     * 建议售价 单位 元
     */
    @Column(nullable = false)
    private BigDecimal suggestPrice;
    /**
     * 进价，单位：元
     */
    @Column(nullable = false)
    private BigDecimal cost;

    /**
     * 售卖最小单位件数
     * @return
     */
    @Column
    private Integer saleCount;

    /**
     * 库存
     */
//    @OneToMany(cascade = { CascadeType.REFRESH, CascadeType.PERSIST,CascadeType.MERGE, CascadeType.REMOVE },mappedBy ="goodsSpecification")
//    @OneToMany
//    @JoinColumn(name = "specificationSid")
//    private List<Inventory> inventoryList;

    public Long getGoodsSid() {
        return goodsSid;
    }

    public void setGoodsSid(Long goodsSid) {
        this.goodsSid = goodsSid;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getCost() {
        return cost;
    }

    public void setCost(BigDecimal cost) {
        this.cost = cost;
    }

    public BigDecimal getSuggestPrice() {
        return suggestPrice;
    }

    public void setSuggestPrice(BigDecimal suggestPrice) {
        this.suggestPrice = suggestPrice;
    }

    public String getGoodsBm() {
        return goodsBm;
    }

    public void setGoodsBm(String goodsBm) {
        this.goodsBm = goodsBm;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public Integer getSaleCount() {
        return saleCount;
    }

    public void setSaleCount(Integer saleCount) {
        this.saleCount = saleCount;
    }

//    public List<Inventory> getInventoryList() {
//        return inventoryList;
//    }
//
//    public void setInventoryList(List<Inventory> inventoryList) {
//        this.inventoryList = inventoryList;
//    }

    public GoodsSpecification(){};
    public GoodsSpecification(Long sid,String cname,String goodsBm,String barcode) {
        super();
        this.sid=sid;
        this.cname=cname;
        this.goodsBm=goodsBm;
        this.barcode=barcode;
    }
}

