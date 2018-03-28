package com.cqzg168.scm.dto;

/**
 * Created by Administrator on 2017/7/14 0014.
 */
public class OrdersGoodsDto {
    private Long ordersSid;
    private String goodsBm;
    private String barcode;
    private Integer status;

    public Long getOrdersSid() {
        return ordersSid;
    }

    public void setOrdersSid(Long ordersSid) {
        this.ordersSid = ordersSid;
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

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}
