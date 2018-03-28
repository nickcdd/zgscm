package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Manager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * Created by jackytsu on 2017/3/15.
 */
public interface ManagerService extends BaseService<Manager> {

    /**
     * 根据用户名和密码查询管理员
     *
     * @param username
     * @param password
     * @return
     */
    Manager findByUsernameAndPassword(String username, String password);

    /**
     * 分页查询管理员列表
     *
     * @param q
     * @param pageable
     * @return
     */
    Page<Manager> findByPage(String q, Pageable pageable);
}
