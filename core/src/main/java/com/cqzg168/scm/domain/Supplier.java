package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 供应商实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "supplier")
public class Supplier extends BaseDomain {
    private static final long serialVersionUID = 5886441354608084163L;
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
     * 地址
     */
    @Column
    private String address;
    /**
     * 名称
     */
    @Column(nullable = false)
    private String cname;
    /**
     * 备注
     */
    @Column
    private String note;
    /**
     * 联系人
     */
    @Column(nullable = false)
    private String contact;
    /**
     * 联系电话
     */
    @Column(nullable = false)
    private String telephone;
    /**
     * 登录密码
     */
    @Column(nullable = false)
    private String password;
    /**
     * 头像
     */
    @Column
    private String avatar;

    /**
     * 供应商对接标识
     */
    @Column
    private String api;

    /**
     * 商品
     */
//    @OneToMany(cascade = { CascadeType.REFRESH, CascadeType.PERSIST,CascadeType.MERGE, CascadeType.REMOVE },mappedBy ="supplier")
//    private List<Goods> goodsList;
    @OneToMany
    @JoinColumn(name = "supplier_sid")
    private List<SupplierLicence> licencesList = new ArrayList<>();

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

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }


    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public List<SupplierLicence> getLicencesList() {
        return licencesList;
    }

    public void setLicencesList(List<SupplierLicence> licencesList) {
        this.licencesList = licencesList;
    }

    public String getApi() {
        return api;
    }

    public void setApi(String api) {
        this.api = api;
    }

//    public List<Goods> getGoodsList() {
//        return goodsList;
//    }
//
//    public void setGoodsList(List<Goods> goodsList) {
//        this.goodsList = goodsList;
//    }
}
