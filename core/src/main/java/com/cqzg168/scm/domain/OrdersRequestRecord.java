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
@Table(name = Constant.TABLE_PREFIX + "orders_request_record")
public class OrdersRequestRecord extends BaseDomain {


    private static final long serialVersionUID = 7531198346415161942L;
    /**
     * 供应商sid
     */
    @Column(nullable = false)
    private Long supplierSid;

    /**
     * 订单调用结果
     */
    @Column(nullable = false)
    private String result;

    public Long getSupplierSid() {
        return supplierSid;
    }

    public void setSupplierSid(Long supplierSid) {
        this.supplierSid = supplierSid;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }
}
