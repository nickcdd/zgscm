package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.GoodsLog;

/**
 * Created by think on 2017/4/27.
 */
public interface GoodsLogService extends BaseService<GoodsLog> {
    /**
     *
     * @param managerSid 管理员sid
     * @param srcStatus  原状态
     * @param targetStatus 修改状态
     * @param note 备注
     * @return
     */
    boolean writeGoodsLog(Long managerSid,Long goodsSid,int srcStatus,int targetStatus,String note);
}
