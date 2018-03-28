package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * 商品附件实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "goods_file")
public class GoodsFile extends BaseDomain {
    private static final long serialVersionUID = -8134559628049012188L;
    /**
     * 商品sid
     */
    @Column(nullable = false)
    private Long goodsSid;
    /**
     * 文件路径
     */
    @Column(nullable = false)
    private String url;
    /**
     * 文件类别：1、封面；2、简介；
     */
    @Column(nullable = false)
    private Integer type = 1;


    public Long getGoodsSid() {
        return goodsSid;
    }

    public void setGoodsSid(Long goodsSid) {
        this.goodsSid = goodsSid;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }
}
