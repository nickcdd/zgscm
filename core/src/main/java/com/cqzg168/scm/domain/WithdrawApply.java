package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.math.BigDecimal;

/**
 * 提现申请实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "withdraw_apply")
public class WithdrawApply extends BaseDomain {
    private static final long serialVersionUID = 3126199960122981208L;
    /**
     * 管理员SID
     */
    @Column
    private Long managerSid;
    /**
     * 审核原因
     */
    @Column
    private String reason;

    /**
     * 商户sid
     *
     * @return
     */
    @Column(nullable = false)
    private Long shopKeeperSid;
    /**
     * 商户名称
     *
     * @return
     */
    @Column(nullable = false)
    private String shopKeeperCname;
    /**
     * 银行名称
     *
     * @return
     */
    @Column(nullable = false)
    private String bankName;
    /**
     * 银行卡号
     *
     * @return
     */
    @Column(nullable = false)
    private String cardNo;
    /**
     * 提现金额
     *
     * @return
     */
    @Column(nullable = false)
    private BigDecimal amount;

    public Long getManagerSid() {
        return managerSid;
    }

    public void setManagerSid(Long managerSid) {
        this.managerSid = managerSid;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Long getShopKeeperSid() {
        return shopKeeperSid;
    }

    public void setShopKeeperSid(Long shopKeeperSid) {
        this.shopKeeperSid = shopKeeperSid;
    }

    public String getShopKeeperCname() {
        return shopKeeperCname;
    }

    public void setShopKeeperCname(String shopKeeperCname) {
        this.shopKeeperCname = shopKeeperCname;
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

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
}
