package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;

/**
 * 供应商证照实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "supplier_licence")
public class SupplierLicence extends BaseDomain {
    private static final long serialVersionUID = 4508728986707508148L;
    /**
     * 供应商SID
     */
    @Column(name="supplier_sid", nullable = false)
    private Long supplierSid;
    /**
     * 名称
     */
    @Column(nullable = false)
    private String cname;
    /**
     * 文件地址
     */
    @Column(nullable = false)
    private String url;


    public Long getSupplierSid() {
        return supplierSid;
    }

    public void setSupplierSid(Long supplierSid) {
        this.supplierSid = supplierSid;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
