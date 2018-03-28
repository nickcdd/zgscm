package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Utils;
import org.json.JSONObject;

import javax.persistence.*;
import java.util.Date;
import java.util.Map;

/**
 * 实体类基类
 * Created by jackytsu on 2017/3/14.
 */
@MappedSuperclass
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class BaseDomain implements BaseDomainInterface {

    /**
     * 通用状态
     */
    public enum Status {
        /**
         * 有效数据
         */
        AVAILABLE(1),

        /**
         * 无效数据
         */
        UNAVAILABLE(0),

        /**
         * 已删除数据
         */
        DELETED(-1);

        private Integer status;

        private Status(Integer status) {
            this.status = status;
        }

        public Integer getStatus() {
            return this.status;
        }
    }

    /**
     * 主键
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sid", nullable = false, updatable = false)
    protected Long sid;
    /**
     * 创建时间
     */
    @Column(name = "create_time", nullable = false, updatable = false)
    protected Date createTime;
    /**
     * 更新时间
     */
    @Column(name = "update_time", nullable = false)
    protected Date updateTime;
    /**
     * 状态：-1.已删除；0.无效；1.有效
     */
    @Column(nullable = false)
    protected int status = 1;

    public BaseDomain() {
        this.createTime = new Date();
        this.updateTime = new Date();
    }

    public Long getSid() {
        return sid;
    }

    public void setSid(Long sid) {
        this.sid = sid;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
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
        return Utils.toJSON(this, fields, fields);
    }

    /**
     * 取得实体对象对应的表名
     *
     * @return
     */
    public String getTableName() {
        Table ann = this.getClass().getAnnotation(Table.class);
        if (null != ann) {
            if (!Utils.isEmpty(ann.name())) {
                return ann.name();
            }
        }
        return "";
    }
}
