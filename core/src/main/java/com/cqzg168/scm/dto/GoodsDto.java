package com.cqzg168.scm.dto;

import com.cqzg168.scm.domain.Goods;

import java.util.List;

/**
 * 用于excel导出
 * Created by Administrator on 2017/7/4 0004.
 */

public class GoodsDto extends Goods {

    /**
     * 原因
     */
    private String reason;
    /**
     * 商品规格Dto
     */
    private List<GoodsSpecificationDto> goodsSpecificationDtos;
    private String price;
    private String cost;
    private String suggestPrice;
    private String goodsBm;
    private String barcode;
    private String specificationName;
    private Integer saleCount;



    public GoodsDto() {
        super();
    }
    public GoodsDto(Goods goods){
        super();
        this.setSid(goods.getSid());
        this.setCname(goods.getCname());
        this.setCreateTime(goods.getCreateTime());
        this.setUpdateTime(goods.getUpdateTime());
        this.setFreeGoods(goods.getFreeGoods());
        this.setUnifiedCode(goods.getUnifiedCode());
        this.setGoodsBarcode(goods.getGoodsBarcode());
        this.setSupplier(goods.getSupplier());
        this.setGoodsCategoryOne(goods.getGoodsCategoryOne());
        this.setGoodsCategoryTwo(goods.getGoodsCategoryTwo());
        this.setStatus(goods.getStatus());
        this.setGoodsSpecifications(goods.getGoodsSpecifications());
        this.setGoodsFiles(goods.getGoodsFiles());
        this.setGoodsLogs(goods.getGoodsLogs());

    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getCost() {
        return cost;
    }

    public void setCost(String cost) {
        this.cost = cost;
    }

    public String getSuggestPrice() {
        return suggestPrice;
    }

    public void setSuggestPrice(String suggestPrice) {
        this.suggestPrice = suggestPrice;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public List<GoodsSpecificationDto> getGoodsSpecificationDtos() {
        return goodsSpecificationDtos;
    }

    public void setGoodsSpecificationDtos(List<GoodsSpecificationDto> goodsSpecificationDtos) {
        this.goodsSpecificationDtos = goodsSpecificationDtos;
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

    public String getSpecificationName() {
        return specificationName;
    }

    public void setSpecificationName(String specificationName) {
        this.specificationName = specificationName;
    }

    public Integer getSaleCount() {
        return saleCount;
    }

    public void setSaleCount(Integer saleCount) {
        this.saleCount = saleCount;
    }
}
