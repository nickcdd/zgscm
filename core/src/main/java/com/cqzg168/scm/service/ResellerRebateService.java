package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.ResellerRebate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * Created by admin on 2017/5/15.
 */
public interface ResellerRebateService extends BaseService<ResellerRebate> {

    /**
     * 分销商返利记录
     *
     * @param startTime
     * @param endTime
     * @param status
     * @param pageable
     * @return
     */
    Page<ResellerRebate> findByResellerSidPage(String startTime, String endTime, int status, Long sid, Pageable pageable);

    void resellerRebate(Long shopkeeperSid);

}
