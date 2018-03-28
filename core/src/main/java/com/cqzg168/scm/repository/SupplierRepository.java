package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.Supplier;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 供应商数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface SupplierRepository extends BaseRepository<Supplier> {
    @Query("select s from  Supplier s order by  s.cname ")
    List<Supplier> findAllSupplier();

    /**
     * 根据用户名和密码查询供应商
     *
     * @param telephone 电话号码
     * @param password  密码
     * @return
     */
    @Query("select s from  Supplier s where s.telephone = ?1 and s.password = ?2 and s.status = 1")
    Supplier findByTelephoneAndPassword(String telephone, String password);

    /**
     * 验证手机号是否已经注册
     * @param telephone
     * @return
     */
    @Query("select s from Supplier  s where s.telephone = ?1")
    Supplier findByTelephone(String telephone);
}
