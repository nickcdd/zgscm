package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Arrays;
import java.util.List;

/**
 * 角色实体类
 * Created by jackytsu on 2017/3/15.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "role")
public class Role extends BaseDomain {

    private static final long serialVersionUID = -2234246621259841381L;

    /**
     * 角色名称
     */
    @Column
    private String cname;
    /**
     * 备注
     */
    @Column
    private String note;
    /**
     * 权限列表
     */
    @Column
    private String permissions;

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getPermissions() {
        return permissions;
    }

    public void setPermissions(String permissions) {
        this.permissions = permissions;
    }

    /**
     * 获取权限列表
     *
     * @return
     */
    public List<String> getPermissionList() {
        return Arrays.asList(getPermissions().split(","));
    }
}
