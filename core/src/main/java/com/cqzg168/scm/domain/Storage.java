package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;

import javax.persistence.*;
import java.util.*;

/**
 * 管理员实体类
 * Created by jackytsu on 2017/3/15.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "storage")
public class Storage extends BaseDomain {

    private static final long serialVersionUID = 1440274756001802545L;
    /**
     * 仓储名称
     */
    @Column
    private String cname;
    /**
     * 仓储编码
     */
    @Column
    private String code;
    /**
     * 仓储联系人
     */
    @Column
    private String realName;
    /**
     * 仓储联系电话
     */
    @Column
    private String telephone;
    /**
     * 省
     */
    @Column
    private String province;
    /**
     * 市
     */
    @Column
    private String city;
    /**
     * 区
     */
    @Column
    private String area;
    /**
     * 地址
     */
    @Column
    private String address;

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
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
}
