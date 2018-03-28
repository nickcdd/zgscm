package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 地区实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "area")
public class Area extends BaseDomain {
    private static final long serialVersionUID = -4166076748313820892L;
    /**
     * 名称
     */
    @Column(nullable = false)
    private String cname;
    /**
     * 父id
     */
    @Column(nullable = false)
    private Long parentSid;
    /**
     * 类型：1省；2市；3区县
     */
    @Column(nullable = false)
    private Integer type;
    /**
     * 排序
     */
    @Column(nullable = false)
    private Integer sort;
    /**
     * 是否开放：0否；1是
     */
    @Column(nullable = false)
    private Integer open;

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public Long getParentSid() {
        return parentSid;
    }

    public void setParentSid(Long parentSid) {
        this.parentSid = parentSid;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getOpen() {
        return open;
    }

    public void setOpen(Integer open) {
        this.open = open;
    }
}
