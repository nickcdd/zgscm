package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.Reseller;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * 创客码分销商数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface ResellerRepository extends BaseRepository<Reseller> {
    /**
     * 验证手机号是否已经注册
     *
     * @param telephone
     * @return
     */
    @Query("select r from Reseller  r where r.telephone = ?1")
    Reseller findByTelephone(String telephone);

    /**
     * 根据用户名和密码查询商户
     *
     * @param telephone 电话号码
     * @param password  密码
     * @return
     */
    @Query("select s from  Reseller s where s.telephone = ?1 and s.password = ?2 and s.status = 1")
    Reseller findByTelephoneAndPassword(String telephone, String password);

    /**
     * 修改分销商号码验证
     * @param sid
     * @param telephone
     * @return
     */
    @Query("select r from Reseller r where r.sid <> ?1 and r.telephone = ?2 and r.status = 1")
    Reseller findByTelephoneAndIsNotSid(Long sid, String telephone);
}
