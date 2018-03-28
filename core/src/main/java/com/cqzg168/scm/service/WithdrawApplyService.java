package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.WithdrawApply;
import com.cqzg168.scm.domain.WithdrawApplyVO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface WithdrawApplyService extends BaseService<WithdrawApply> {
    /**
     * 分页提现申请列表
     *
     * @param q
     * @param pageable
     * @return
     */
    Page<WithdrawApply> findByPage(String q, String stareDate, String endDate, int status, Pageable pageable);


    /**
     * 提现申请记录
     *
     * @param startTime
     * @param endTime
     * @param status
     * @param pageable
     * @return
     */
    Page<WithdrawApply> findByCashRecordPage(String startTime, String endTime, int status, Long sid, Pageable pageable);

    List<WithdrawApplyVO> getWithdrawApplyVO(List<WithdrawApply> list);

    /**
     * 单商户 当天的提现总金额
     * @param startTime
     * @param endTime
     * @param shopkeeperSid
     * @return
     */
    BigDecimal todayWithdrawApplyMoney(Date startTime, Date endTime, Long shopkeeperSid);
}
