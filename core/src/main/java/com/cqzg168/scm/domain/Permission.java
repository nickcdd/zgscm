package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Utils;
import org.json.JSONObject;

import java.util.Map;

/**
 * 权限实体类
 * Created by jackytsu on 2017/3/20.
 */
public class Permission implements BaseDomainInterface {
    private static final long serialVersionUID = 3918917584972673912L;

    /**
     * 模块标识
     */
    private String module;
    /**
     * 模块名称
     */
    private String cname;

    /**
     * 权限列表
     * key: 权限标识
     * value: 权限名称
     */
    private Map<String, String> permissions;

    public Permission() {
        super();
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public Map<String, String> getPermissions() {
        return permissions;
    }

    public void setPermissions(Map<String, String> permissions) {
        this.permissions = permissions;
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
}
