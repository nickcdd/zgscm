package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 商品操作日志实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "goods_log")
public class GoodsLog extends BaseDomain {

    private static final long serialVersionUID = -423374162670643997L;
    /**
     * 管理员SID
     */
    @Column(nullable = false)
    private Long managerSid;
    /**
     * 商品SID
     */
    @Column(nullable = false)
    private Long goodsSid;
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

    public Long getGoodsSid() {
        return goodsSid;
    }

    public void setGoodsSid(Long goodsSid) {
        this.goodsSid = goodsSid;
    }
}
