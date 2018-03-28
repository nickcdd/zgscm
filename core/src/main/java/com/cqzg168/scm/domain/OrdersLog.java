package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "orders_log")
public class OrdersLog extends BaseDomain {
    private static final long serialVersionUID = -8649376706187985279L;
    /**
     * 管理员SID
     */
    @Column(nullable = false)
    private Long managerSid;
    /**
     * 订单SID
     */
    @Column(nullable = false)
    private Long ordersSid;
    /**
     * 原状态
     */
    @Column(nullable = false)
    private Integer srcStatus;
    /**
     * 修改状态
     */
    @Column(nullable = false)
    private Integer targetStatus;
    /**
     * 操作说明
     */
    @Column
    private String note;

    public Long getManagerSid() {
        return managerSid;
    }

    public void setManagerSid(Long managerSid) {
        this.managerSid = managerSid;
    }

    public Integer getSrcStatus() {
        return srcStatus;
    }

    public void setSrcStatus(Integer srcStatus) {
        this.srcStatus = srcStatus;
    }

    public Integer getTargetStatus() {
        return targetStatus;
    }

    public void setTargetStatus(Integer targetStatus) {
        this.targetStatus = targetStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Long getOrdersSid() {
        return ordersSid;
    }

    public void setOrdersSid(Long ordersSid) {
        this.ordersSid = ordersSid;
    }
}
