package com.cqzg168.scm.dto;

import com.cqzg168.scm.domain.GoodsSpecification;

/**
 * Created by admin on 2017/7/4.
 */
//@Entity
public class GoodsSpecificationDto extends GoodsSpecification {

    /**
     * 库存
     */
    private Long inventory;

    public GoodsSpecificationDto(GoodsSpecification goodsSpecification){
        super();
        this.setCname(goodsSpecification.getCname());
        this.setSid(goodsSpecification.getSid());
        this.setCost(goodsSpecification.getCost());
        this.setCreateTime(goodsSpecification.getCreateTime());
        this.setUpdateTime(goodsSpecification.getUpdateTime());
        this.setGoodsBm(goodsSpecification.getGoodsBm());
        this.setGoodsSid(goodsSpecification.getGoodsSid());
        this.setPrice(goodsSpecification.getPrice());
        this.setStatus(goodsSpecification.getStatus());
        this.setSuggestPrice(goodsSpecification.getSuggestPrice());
        this.setSaleCount(goodsSpecification.getSaleCount());
        this.setBarcode(goodsSpecification.getBarcode());
    }

    public Long getInventory() {
        return inventory;
    }

    public void setInventory(Long inventory) {
        this.inventory = inventory;
    }
}
