package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Rebate;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.repository.OrdersRepository;
import com.cqzg168.scm.repository.RebateRepository;
import com.cqzg168.scm.repository.ShopKeeperRepository;
import com.cqzg168.scm.service.RebateService;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.RebateConfig;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * Created by admin on 2017/5/15.
 */
@Service
@Transactional
public class RebateServiceImpl extends BaseServiceImpl<Rebate, RebateRepository> implements RebateService {

    private RebateRepository repository;
    @Autowired
    private ShopKeeperRepository shopKeeperRepository;
    @Autowired
    private RebateConfig rebateConfig;
    @Autowired
    private OrdersRepository ordersRepository;

    @Autowired
    @Override
    public void setRepository(RebateRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public void rebateLogic(ShopKeeper shopKeeper) {
        //商户总数
        Integer shopKeeperTotal = 0;
        if (shopKeeper.getLevel() == 0) {
            shopKeeperTotal = shopKeeperRepository.shopKeeperTotalByBasis();
        } else if (shopKeeper.getLevel() == 1) {
            shopKeeperTotal = shopKeeperRepository.shopKeeperTotalByStandard();
        }
        //返现总金额上限比例额度
        BigDecimal maxProportion = rebateConfig.getMax()[shopKeeper.getLevel()];
        //商户返现总金额上限
        BigDecimal max = maxProportion.multiply(new BigDecimal(shopKeeperTotal));
        //返现比例
        BigDecimal rate = rebateConfig.getRate()[shopKeeper.getLevel()];
        //每天返现上限
        BigDecimal perDayLimit = rebateConfig.getPerDayLimit()[shopKeeper.getLevel()];
        //每个商户返现上限
        BigDecimal perShopKepper = rebateConfig.getPerShopKepper()[shopKeeper.getLevel()];
        //所有商户返现总金额
        BigDecimal shopKeperRebateTotalAmount;
        BigDecimal bdRebateTotalAmount = repository.sumShopKeperRebateAmount();
        if (Utils.isNull(bdRebateTotalAmount)) {
            bdRebateTotalAmount = new BigDecimal(0);
        }
        shopKeperRebateTotalAmount = bdRebateTotalAmount;
        //当天单商户应返现总金额
        BigDecimal todayRebateAmount;
        //当天商户所收款总金额
        BigDecimal bdTodayRebateAmount = ordersRepository.todayOrdersTotalAmount(DateUtil.getCurrentDayStartTime(), DateUtil.getCurrentDayEndTime(), shopKeeper);
        if (Utils.isNull(bdTodayRebateAmount)) {
            bdTodayRebateAmount = new BigDecimal(0);
        }
        todayRebateAmount = bdTodayRebateAmount.multiply(rate);
        //当前商户返现总金额
        BigDecimal credit;
        if (Utils.isNull(shopKeeper.getCredit())) {
            credit = new BigDecimal(0);
        } else {
            credit = shopKeeper.getCredit();
        }

        if ((max.subtract(shopKeperRebateTotalAmount)).compareTo(todayRebateAmount) == -1) {
            todayRebateAmount = max.subtract(shopKeperRebateTotalAmount);
        }
        if ((perShopKepper.subtract(credit)).compareTo(todayRebateAmount) == -1) {
            todayRebateAmount = perShopKepper.subtract(credit);
        }
        if (perDayLimit.compareTo(todayRebateAmount) == -1) {
            todayRebateAmount = perDayLimit;
        }
        if (todayRebateAmount.compareTo(BigDecimal.ZERO) == 1) {
            updateRebateAmount(shopKeeper, todayRebateAmount);
        }
    }

    /**
     * 修改商户返现金额
     *
     * @param shopKeeper
     * @param todayRebateAmount
     */
    private void updateRebateAmount(ShopKeeper shopKeeper, BigDecimal todayRebateAmount) {
        Rebate rebate = new Rebate();
        BigDecimal tempAmount = todayRebateAmount;
        //商户应返现采购余额
        BigDecimal rebateCreditPrice = tempAmount.divide(new BigDecimal(2));
        //商户应返现提现余额
        BigDecimal rebateBalancePrice = tempAmount.divide(new BigDecimal(2));
        //商户采购余额
        BigDecimal creditPrice = shopKeeper.getCredit();
        //商户提现余额
        BigDecimal balancePrice = shopKeeper.getBalance();
        tempAmount = tempAmount.setScale(2, BigDecimal.ROUND_HALF_UP);
        rebate.setShopKeeperSid(shopKeeper.getSid());
        rebate.setAmount(tempAmount);
        if (Utils.isNull(creditPrice)) {
            creditPrice = new BigDecimal(0);
        }
        if(Utils.isNull(balancePrice)){
            creditPrice = new BigDecimal(0);
        }
        BigDecimal tempCreditPrice = creditPrice.add(rebateCreditPrice);
        BigDecimal tempBalancePrice = balancePrice.add(rebateBalancePrice);
        tempCreditPrice = tempCreditPrice.setScale(2, BigDecimal.ROUND_HALF_UP);
        tempBalancePrice = tempBalancePrice.setScale(2, BigDecimal.ROUND_HALF_UP);
        shopKeeper.setCredit(tempCreditPrice);
        shopKeeper.setBalance(tempBalancePrice);
        shopKeeperRepository.save(shopKeeper);
        repository.save(rebate);
    }
}
