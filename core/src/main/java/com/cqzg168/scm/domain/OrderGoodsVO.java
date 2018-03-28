package com.cqzg168.scm.domain;

/**
 * Created by Administrator on 2017/6/27 0027.
 */
public class OrderGoodsVO {
    private Long orderGoodsSid;
    private  String goodsCname;
    private String goodsSpecificationCname;
    private String count;

    public String getGoodsCname() {
        return goodsCname;
    }

    public void setGoodsCname(String goodsCname) {
        this.goodsCname = goodsCname;
    }

    public String getGoodsSpecificationCname() {
        return goodsSpecificationCname;
    }

    public void setGoodsSpecificationCname(String goodsSpecificationCname) {
        this.goodsSpecificationCname = goodsSpecificationCname;
    }

    public Long getOrderGoodsSid() {
        return orderGoodsSid;
    }

    public void setOrderGoodsSid(Long orderGoodsSid) {
        this.orderGoodsSid = orderGoodsSid;
    }

    public String getCount() {
        return count;
    }

    public void setCount(String count) {
        this.count = count;
    }
}
