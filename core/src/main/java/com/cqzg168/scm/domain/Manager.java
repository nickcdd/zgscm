package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;

import javax.persistence.*;
import java.util.*;

/**
 * 管理员实体类
 * Created by jackytsu on 2017/3/15.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "manager")
public class Manager extends BaseDomain {

    private static final long serialVersionUID = -5388078003465468426L;

    /**
     * 用户名
     */
    @Column
    private String username;
    /**
     * 密码
     */
    @Column
    private String password;
    /**
     * 姓名
     */
    @Column
    private String cname;

    /**
     * 角色列表
     */
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = Constant.TABLE_PREFIX + "manager_role", joinColumns = {@JoinColumn(name = "manager_sid")}, inverseJoinColumns = {@JoinColumn(name = "role_sid")})
    private List<Role> roleList = new ArrayList<>();

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public List<Role> getRoleList() {
        return roleList;
    }

    public void setRoleList(List<Role> roleList) {

        List<Role> list = new ArrayList<>();
        for (Role role : roleList) {
            if (!Utils.isNull(role.getSid())) {
                list.add(role);
            }
        }

        this.roleList = list;
    }

    /**
     * 获取角色名称
     *
     * @return
     */
    public String getRoleNames() {
        StringJoiner roleNames = new StringJoiner("、");

        for (Role r : roleList) {
            roleNames.add(r.getCname());
        }

        return roleNames.toString();
    }

    /**
     * 获取权限列表
     *
     * @return
     */
    public List<String> getPermissions() {
        List<String> permissions   = new ArrayList<>();
        Set<String>  permissionSet = new HashSet<>();

        for (Role role : roleList) {
            if (role.getStatus() == Status.AVAILABLE.getStatus()) {
                permissionSet.addAll(Arrays.asList(role.getPermissions().split(",")));
            }
        }

        permissions.addAll(permissionSet);
        return permissions;
    }
}
