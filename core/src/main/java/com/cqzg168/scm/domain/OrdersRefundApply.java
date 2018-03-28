package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 订单退款申请
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "orders_refund_apply")
public class OrdersRefundApply extends BaseDomain {
    private static final long serialVersionUID = 3117555422764382228L;
    /**
     * 订单SID
     */
    @Column(nullable = false)
    private Long orderSid;
    /**
     * 原因
     */
    @Column(nullable = false)
    private String reason;
    /**
     * 管理员SID
     */
    @Column
    private Long managerSid;
    /**
     * 反馈回复
     */
    @Column(name = "feedback")
    private String feedBack;

    public Long getOrderSid() {
        return orderSid;
    }

    public void setOrderSid(Long orderSid) {
        this.orderSid = orderSid;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Long getManagerSid() {
        return managerSid;
    }

    public void setManagerSid(Long managerSid) {
        this.managerSid = managerSid;
    }

    public String getFeedBack() {
        return feedBack;
    }

    public void setFeedBack(String feedBack) {
        this.feedBack = feedBack;
    }
}
