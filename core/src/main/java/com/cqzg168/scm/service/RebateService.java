package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Rebate;
import com.cqzg168.scm.domain.ShopKeeper;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by admin on 2017/5/15.
 */
public interface RebateService extends BaseService<Rebate> {

    /**
     * 商户返利逻辑
     *
     * @param
     */
    void rebateLogic(ShopKeeper shopKeeper);
}
