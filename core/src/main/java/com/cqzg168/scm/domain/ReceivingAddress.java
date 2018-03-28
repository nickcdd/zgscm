package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 收货地址实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "receiving_address")
public class ReceivingAddress extends BaseDomain {
    private static final long serialVersionUID = 166586801518765098L;

    /**
     * 商户SID
     */
    @Column(nullable = false)
    private Long shopKeeperSid;
    /**
     * 省
     */
    @Column(nullable = false)
    private String province;
    /**
     * 市
     */
    @Column(nullable = false)
    private String city;
    /**
     * 区
     */
    @Column(nullable = false)
    private String area;
    /**
     * 收货地址
     */
    @Column(nullable = false)
    private String address;

    /**
     * 是否默认
     */
    @Column(nullable = false)
    private Integer isDefault;

    /**
     * 收货人
     */
    @Column(nullable = false)
    private String name;

    /**
     * 收货人电话号码
     */
    @Column(nullable = false)
    private String telephone;

    public Long getShopKeeperSid() {
        return shopKeeperSid;
    }

    public void setShopKeeperSid(Long shopKeeperSid) {
        this.shopKeeperSid = shopKeeperSid;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getIsDefault() {
        return isDefault;
    }

    public void setIsDefault(Integer isDefault) {
        this.isDefault = isDefault;
    }

    public String getName() {
        return name;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setTelephone(String telephoto) {
        this.telephone = telephoto;
    }
}
