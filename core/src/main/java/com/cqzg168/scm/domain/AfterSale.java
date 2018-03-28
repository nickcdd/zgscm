package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * Created by admin on 2017/5/15.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "after_sale")
public class AfterSale extends BaseDomain {


    private static final long serialVersionUID = 2027927396505947334L;
    /**
     * 订单sid
     */
    @Column(nullable = false)
    private Long ordersSid;

    /**
     * 申请退换货图片
     */
    @Column(nullable = false)
    private String photo;

    public Long getOrdersSid() {
        return ordersSid;
    }

    public void setOrdersSid(Long ordersSid) {
        this.ordersSid = ordersSid;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }
}
