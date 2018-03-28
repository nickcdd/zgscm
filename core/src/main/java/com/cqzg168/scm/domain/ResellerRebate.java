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
@Table(name = Constant.TABLE_PREFIX + "reseller_rebate")
public class ResellerRebate extends BaseDomain {


    private static final long serialVersionUID = 8909541084868848971L;
    /**
     * 分销商sid
     */
    @Column(nullable = false)
    private Long resellerSid;

    /**
     * 返现金额
     */
    @Column(nullable = false)
    private BigDecimal amount;

    public Long getResellerSid() {
        return resellerSid;
    }

    public void setResellerSid(Long resellerSid) {
        this.resellerSid = resellerSid;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
}
