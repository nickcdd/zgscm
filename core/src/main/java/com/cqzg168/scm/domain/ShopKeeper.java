package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 商户实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "shop_keeper")
public class ShopKeeper extends BaseDomain {

    private static final long serialVersionUID = -751989306068164932L;
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
     * 店主姓名
     */
    @Column
    private String realName;
    /**
     * 店主身份证号
     */
    @Column
    private String idCardNo;
    /**
     * 备注
     */
    @Column
    private String note;
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
     * 短信验证码
     */
    @Column
    private String captcha;
    /**
     * 短信验证码过期时间
     */
    @Column
    private Date expiredDate;
    /**
     * 提现余额
     */
    @Column
    private BigDecimal balance;
    /**
     * 采购余额
     */
    @Column
    private BigDecimal credit;
    /**
     * 冻结余额
     */
    @Column
    private BigDecimal frozenBalance;
    /**
     * 商户头像地址
     */
    @Column
    private String avatar;
    /**
     * 分销商sid
     */
    @Column(name = "reseller_sid")
    private Long resellerSid;
    /**
     * 商户等级
     */
    @Column
    private Integer level;

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

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getIdCardNo() {
        return idCardNo;
    }

    public void setIdCardNo(String idCardNo) {
        this.idCardNo = idCardNo;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getCaptcha() {
        return captcha;
    }

    public void setCaptcha(String captcha) {
        this.captcha = captcha;
    }

    public Date getExpiredDate() {
        return expiredDate;
    }

    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public BigDecimal getCredit() {
        return credit;
    }

    public void setCredit(BigDecimal credit) {
        this.credit = credit;
    }

    public BigDecimal getFrozenBalance() {
        return frozenBalance;
    }

    public void setFrozenBalance(BigDecimal frozenBalance) {
        this.frozenBalance = frozenBalance;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Long getResellerSid() {
        return resellerSid;
    }

    public void setResellerSid(Long resellerSid) {
        this.resellerSid = resellerSid;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }
}
