package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.Manager;
import org.springframework.stereotype.Repository;

/**
 * 管理员数据操作接口
 * Created by jackytsu on 2017/3/15.
 */
@Repository
public interface ManagerRepository extends BaseRepository<Manager> {

    /**
     * 根据用户名和密码查询管理员
     *
     * @param username 用户名
     * @param password 密码
     * @return
     */
    Manager findByUsernameAndPassword(String username, String password);
}
