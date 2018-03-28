package com.cqzg168.scm.repository;


import com.cqzg168.scm.domain.WithdrawApply;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 提现申请数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface WithdrawApplyRepository extends BaseRepository<WithdrawApply> {

    /**
     * 单商户 当天的提现总金额
     * @param startTime
     * @param endTime
     * @param shopkeeperSid
     * @return
     */
    @Query("select sum(w.amount) from WithdrawApply w where w.createTime between ?1 and ?2 and  w.shopKeeperSid = ?3 and w.status = 2")
    BigDecimal todayWithdrawApplyMoney(Date startTime, Date endTime, Long shopkeeperSid);
}
