package com.cqzg168.scm.dto;

/**
 * Created by Administrator on 2017/7/28 0028.
 */
public class InventoryVo {
    private String goodsSid;
    private String specificationSid;
    private String inventorySid;
    private String storageSid;
    private Integer amount;
    private String goodsCname;
    private String storageCname;

    public String getGoodsSid() {
        return goodsSid;
    }

    public void setGoodsSid(String goodsSid) {
        this.goodsSid = goodsSid;
    }

    public String getSpecificationSid() {
        return specificationSid;
    }

    public void setSpecificationSid(String specificationSid) {
        this.specificationSid = specificationSid;
    }

    public String getInventorySid() {
        return inventorySid;
    }

    public void setInventorySid(String inventorySid) {
        this.inventorySid = inventorySid;
    }

    public String getStorageSid() {
        return storageSid;
    }

    public void setStorageSid(String storageSid) {
        this.storageSid = storageSid;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public String getGoodsCname() {
        return goodsCname;
    }

    public void setGoodsCname(String goodsCname) {
        this.goodsCname = goodsCname;
    }

    public String getStorageCname() {
        return storageCname;
    }

    public void setStorageCname(String storageCname) {
        this.storageCname = storageCname;
    }
}
