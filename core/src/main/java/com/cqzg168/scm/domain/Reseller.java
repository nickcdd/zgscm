package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;
import java.util.List;

/**
 * 创客码分销商实体类
 * Created by think on 2017/4/27.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "reseller")
public class Reseller extends BaseDomain {
    private static final long serialVersionUID = -5964461406591316429L;
    /**
     * 电话号码
     */
    @Column(nullable = false)
    private String telephone;
    /**
     * 姓名
     */
    @Column(nullable = false)
    private String cname;
    /**
     * 登录密码
     */
    @Column(nullable = false)
    private String     password;

    /**
     * 头像
     */
    @Column(nullable = false)
    private String avatar;

    @OneToMany
    @JoinColumn(name = "reseller_sid")
    private List<ShopKeeper> shopKeeperList;

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public List<ShopKeeper> getShopKeeperList() {
        return shopKeeperList;
    }

    public void setShopKeeperList(List<ShopKeeper> shopKeeperList) {
        this.shopKeeperList = shopKeeperList;
    }
}
