package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;

/**
 * 管理员实体类
 * Created by jackytsu on 2017/3/15.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "inventory")
public class Inventory extends BaseDomain {

    private static final long serialVersionUID = 5419824819674153730L;
    /**
     * 商品规格sid
     */
//    @Column
//    private Long specificationSid;
//    @ManyToOne(cascade = {CascadeType.MERGE,CascadeType.REFRESH }, optional = true)
//    @JoinColumn(name = "specification_sid", nullable = false)
    @ManyToOne(targetEntity = GoodsSpecification.class, cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    @JoinColumn(name = "specification_sid", referencedColumnName = "sid", nullable = false)
    private GoodsSpecification goodsSpecification;
    /**
     * 商品sid
     */
    @ManyToOne(targetEntity = Goods.class, cascade = {CascadeType.MERGE, CascadeType.MERGE})
    @JoinColumn(name = "goods_sid", referencedColumnName = "sid", nullable = false)
    private Goods goods;
    /**
     * 仓储Sid
     */
//    @Column
//    private Long storageSid;
    @ManyToOne(targetEntity = Storage.class, cascade = {CascadeType.MERGE, CascadeType.MERGE})
    @JoinColumn(name = "storage_sid", referencedColumnName = "sid", nullable = false)
    private Storage storage;
    /**
     * 剩余库存
     */
    @Column
    private Integer amount;

//    public Long getSpecificationSid() {
//        return specificationSid;
//    }
//
//    public void setSpecificationSid(Long specificationSid) {
//        this.specificationSid = specificationSid;
//    }

//    public Long getStorageSid() {
//        return storageSid;
//    }
//
//    public void setStorageSid(Long storageSid) {
//        this.storageSid = storageSid;
//    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public Storage getStorage() {
        return storage;
    }

    public void setStorage(Storage storage) {
        this.storage = storage;
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
