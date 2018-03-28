package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.Rebate;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by admin on 2017/5/15.
 */
@Repository
public interface RebateRepository extends BaseRepository<Rebate> {
    /**
     * 返利总金额
     *
     * @return
     */
    @Query("select sum(r.amount) from Rebate r where r.status = 1")
    BigDecimal sumShopKeperRebateAmount();

    /**
     * 商户每一天的返现金额
     *
     * @param startTime
     * @param endTime
     * @param shopKeperSid
     * @return
     */
    @Query("select sum(r.amount) from  Rebate r where r.createTime between ?1 and ?2 and r.shopKeeperSid = ?3 and r.status = 1")
    BigDecimal todayRebateAmount(Date startTime, Date endTime, Long shopKeperSid);
}
