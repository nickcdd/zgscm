package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.ShopKeeper;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

/**
 * 商户数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface ShopKeeperRepository extends BaseRepository<ShopKeeper> {

    /**
     * 根据用户名和密码查询商户
     *
     * @param telephone 电话号码
     * @param password  密码
     * @return
     */
    @Query("select s from  ShopKeeper s where s.telephone = ?1 and s.password = ?2 and s.status = 1")
    ShopKeeper findByTelephoneAndPassword(String telephone, String password);

    /**
     * 修改商户号码验证
     * @param sid
     * @param telephone
     * @return
     */
    @Query("select r from ShopKeeper r where r.sid <> ?1 and r.telephone = ?2 and r.status = 1")
    ShopKeeper findByTelephoneAndIsNotSid(Long sid, String telephone);
    /**
     * 根据电话号码查询商户
     *
     * @param telephone 电话号码
     * @return
     */
    @Query("select s from  ShopKeeper s where s.telephone = ?1 and s.status = 1")
    ShopKeeper findShopKeeperByTelephone(String telephone);

    /**
     * 更新商户冻结余额
     *
     * @param frozenBalance
     * @param sid
     */
    @Modifying
    @Query("UPDATE ShopKeeper s SET s.frozenBalance = ?1 WHERE s.sid = ?2")
    void updateFrozenBalance(BigDecimal frozenBalance, Long sid);

    /**
     * 更新商户冻结余额和提现余额
     *
     * @param unfrozenBalance
     * @param sid
     */
    @Modifying
    @Query("UPDATE ShopKeeper s SET s.frozenBalance = s.frozenBalance - ?1, s.balance = s.balance + ?1 WHERE s.sid = ?2")
    void updateFrozenBalanceAndBalance(BigDecimal unfrozenBalance, Long sid);

    /**
     * 根据商户等级统计商户总数
     */
    @Query("select count(s) from ShopKeeper s where s.status = 1 group by s.level order by s.level asc")
    List<Integer> shopKeeperTotalByLevel();

    /**
     * 统计基础商户总数
     */
    @Query("select count(s) from ShopKeeper s where s.status = 1 and s.level = 0")
    Integer shopKeeperTotalByBasis();

    /**
     * 统计标准商户总数
     */
    @Query("select count(s) from ShopKeeper s where s.status = 1 and s.level = 1")
    Integer shopKeeperTotalByStandard();
    /**
     * 验证手机号是否已经注册
     * @param telephone
     * @return
     */
    @Query("select s from ShopKeeper  s where s.telephone = ?1")
    ShopKeeper findByTelephone(String telephone);

    /**
     * 查询所有有效商户
     * @return
     */
    @Query("select s from ShopKeeper  s where s.status = 1")
    List<ShopKeeper> findAllByStatus();
}
