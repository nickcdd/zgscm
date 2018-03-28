package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 商户银行卡实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "shop_keeper_card")
public class ShopKeeperCard extends BaseDomain {
    private static final long serialVersionUID = 4050826497653624034L;
    /**
     * 商户SID
     */
    @Column(nullable = false)
    private Long shopKeeperSid;
    /**
     * 银行名称
     */
    @Column(nullable = false)
    private String bankName;
    /**
     * 银行卡号
     */
    @Column(nullable = false)
    private String cardNo;

    public Long getShopKeeperSid() {
        return shopKeeperSid;
    }

    public void setShopKeeperSid(Long shopKeeperSid) {
        this.shopKeeperSid = shopKeeperSid;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getCardNo() {
        return cardNo;
    }

    public void setCardNo(String cardNo) {
        this.cardNo = cardNo;
    }
}
