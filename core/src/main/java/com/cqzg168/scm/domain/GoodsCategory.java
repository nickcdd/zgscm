package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

/**
 * 商品类别实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "goods_category")
public class GoodsCategory extends BaseDomain {
    private static final long serialVersionUID = -8301989959673241930L;
    /**
     * 类别名称
     */
    @Column(nullable = false)
    private String cname;
    /**
     * 父级sid
     */
    @Column(nullable = false)
    private Long parentSid;
    /**
     * 备注
     */
    @Column
    private String note;

    /**
     * 排序
     */
    @Column(nullable = false)
    private Integer sort;


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

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }


}
