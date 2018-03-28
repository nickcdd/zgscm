package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Utils;
import org.json.JSONObject;
import org.springframework.data.domain.Page;

import java.util.Map;

/**
 * 分页信息实体类
 * Created by jackytsu on 2017/3/22.
 */
public class PageInfo implements BaseDomainInterface {

    private static final long serialVersionUID = -30646147216539273L;

    /**
     * 记录总数
     */
    private Long total;
    /**
     * 总页数
     */
    private Integer totalPages;
    /**
     * 当前页码
     */
    private Integer page;
    /**
     * 每页记录数
     */
    private Integer pageSize;

    /**
     * 构造函数
     */
    public PageInfo() {
        super();
    }

    /**
     * 构造函数
     *
     * @param page
     */
    public PageInfo(Page<?> page) {
        this();

        this.total = page.getTotalElements();
        this.totalPages = page.getTotalPages();
        this.page = page.getNumber() + 1;
        this.pageSize = page.getSize();
    }

    /**
     * 构造函数
     *
     * @param total
     * @param totalPages
     * @param page
     * @param pageSize
     */
    public PageInfo(Long total, Integer totalPages, Integer page, Integer pageSize) {
        this();

        this.total = total;
        this.totalPages = totalPages;
        this.page = page + 1;
        this.pageSize = pageSize;
    }

    public Long getTotal() {
        return total;
    }

    public Integer getTotalPages() {
        return totalPages;
    }

    public Integer getPage() {
        return page;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    @Override
    public Map<String, Object> toMap() {
        return Utils.toMap(this, null, null);
    }

    @Override
    public Map<String, Object> toMapWithInclude(String[] fields) {
        return Utils.toMap(this, fields, null);
    }

    @Override
    public Map<String, Object> toMapWithExclude(String[] fields) {
        return Utils.toMap(this, null, fields);
    }

    @Override
    public JSONObject toJSON() {
        return Utils.toJSON(this, null, null);
    }

    @Override
    public JSONObject toJSONWithInclude(String[] fields) {
        return Utils.toJSON(this, fields, null);
    }

    @Override
    public JSONObject toJSONWithExclude(String[] fields) {
        return Utils.toJSON(this, null, fields);
    }

    @Override
    public String toString() {
        JSONObject json = new JSONObject();
        try {
            json.putOpt("total", total);
            json.putOpt("totalPages", totalPages);
            json.putOpt("page", page);
            json.putOpt("pageSize", pageSize);
        } catch (Exception e) {
        }

        return json.toString();
    }
}
