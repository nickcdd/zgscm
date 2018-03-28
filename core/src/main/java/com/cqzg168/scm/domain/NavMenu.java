package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Utils;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 菜单实体类
 * Created by jackytsu on 2017/3/20.
 */
public class NavMenu implements BaseDomainInterface {

    private static final long serialVersionUID = -2140430443312676184L;

    /**
     * 中文名字
     */
    private String cname;
    /**
     * 图标 CSS 类名
     */
    private String icon;
    /**
     * 链接地址
     */
    private String url;
    /**
     * 访问所需权限
     */
    private String permission;
    /**
     * 子菜单列表
     */
    private List<NavMenu> children = new ArrayList<>();

    public NavMenu() {
        super();
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getPermission() {
        return permission;
    }

    public void setPermission(String permission) {
        this.permission = permission;
    }

    public List<NavMenu> getChildren() {
        return children;
    }

    public void setChildren(List<NavMenu> children) {
        this.children = children;
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
