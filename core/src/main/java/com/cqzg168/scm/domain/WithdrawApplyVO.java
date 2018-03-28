package com.cqzg168.scm.domain;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Administrator on 2017/5/17 0017.
 */
public class WithdrawApplyVO {
    private Date createTime;
    private String managerName;
    private Long shopKeeperSid;
    private String shopKeeperCname;
    private String bankName;
    private String cardNo;
    private BigDecimal amount;
    private Integer status;
    private String reason;

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
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

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
