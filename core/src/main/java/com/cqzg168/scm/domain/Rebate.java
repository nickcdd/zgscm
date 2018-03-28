package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.math.BigDecimal;

/**
 * Created by admin on 2017/5/15.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "rebate")
public class Rebate extends BaseDomain {

    private static final long serialVersionUID = -5287584458709925835L;

    /**
     * 商户sid
     */
    @Column(nullable = false)
    private Long shopKeeperSid;

    /**
     * 返现金额
     */
    @Column(nullable = false)
    private BigDecimal amount;

    public Long getShopKeeperSid() {
        return shopKeeperSid;
    }

    public void setShopKeeperSid(Long shopKeeperSid) {
        this.shopKeeperSid = shopKeeperSid;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
}
