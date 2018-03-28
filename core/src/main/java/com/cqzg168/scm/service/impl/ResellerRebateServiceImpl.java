package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.ResellerRebate;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.repository.ResellerRebateRepository;
import com.cqzg168.scm.service.OrdersService;
import com.cqzg168.scm.service.ResellerRebateService;
import com.cqzg168.scm.service.ShopKeeperService;
import com.cqzg168.scm.service.WithdrawApplyService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.Predicate;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by admin on 2017/5/15.
 */
@Service
@Transactional
public class ResellerRebateServiceImpl extends BaseServiceImpl<ResellerRebate, ResellerRebateRepository> implements ResellerRebateService {

    private ResellerRebateRepository repository;

    @Autowired
    private ShopKeeperService shopKeeperService;
    @Autowired
    private OrdersService ordersService;
    @Autowired
    private WithdrawApplyService withdrawApplyService;
    /**
     * 商户提现 分销商返利比
     */
    @Value("${reseller_rebate_rate_by_shop_keeper_withdraw_apply}")
    private String resellerRebateRateByShopKeeperWithdrawApply;
    /**
     * 商户下单 分销商返利比
     */
    @Value("${reseller_rebate_rate_by_shop_keeper_payment}")
    private String resellerRebateRateByShopKeeperPayment;

    @Autowired
    @Override
    public void setRepository(ResellerRebateRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public Page<ResellerRebate> findByResellerSidPage(String startTime, String endTime, int status, Long sid, Pageable pageable) {
        SimpleDateFormat sdf = new SimpleDateFormat(Constant.STR_FULL_DATE_TIME);
        Specification<ResellerRebate> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            try {
                if (!Utils.isEmpty(startTime)) {
                    predicates.add(cb.greaterThanOrEqualTo(root.get("createTime"), sdf.parse(startTime)));
                }
                if (!Utils.isEmpty(endTime)) {
                    predicates.add(cb.lessThanOrEqualTo(root.get("createTime"), sdf.parse(endTime)));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            predicates.add(cb.equal(root.get("resellerSid"), sid));
            predicates.add(cb.equal(root.get("status"), status));
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    /**
     * 分销商返利
     *
     * @return
     */
    @Override
    public void resellerRebate(Long shopkeeperSid) {
        ShopKeeper shopKeeper = shopKeeperService.findOne(shopkeeperSid);
        BigDecimal todayRebateAmount = new BigDecimal(0);
        //单商户  当天提现总金额
        BigDecimal todayShopkeeperWithdrawApplyAmount = withdrawApplyService.todayWithdrawApplyMoney(DateUtil.getCurrentDayStartTime(), DateUtil.getCurrentDayEndTime(), shopkeeperSid);
        //单商户  当前下单付款总金额
        BigDecimal todayShopkeeperOrdersAmount = ordersService.todayOrdersAmountMoney(DateUtil.getCurrentDayStartTime(), DateUtil.getCurrentDayEndTime(), shopKeeper);
        if(todayShopkeeperWithdrawApplyAmount == null){
            todayShopkeeperWithdrawApplyAmount = new BigDecimal(0);
        }
        if(todayShopkeeperOrdersAmount == null){
            todayShopkeeperOrdersAmount = new BigDecimal(0);
        }
        //提现返利
        BigDecimal withdrawRebate = todayShopkeeperWithdrawApplyAmount.multiply(new BigDecimal(resellerRebateRateByShopKeeperWithdrawApply));
        //下单付款返利
        BigDecimal ordersRebate = todayShopkeeperOrdersAmount.multiply(new BigDecimal(resellerRebateRateByShopKeeperPayment));
        todayRebateAmount = todayRebateAmount.add(withdrawRebate);
        todayRebateAmount = todayRebateAmount.add(ordersRebate);
        todayRebateAmount = todayRebateAmount.setScale(2,BigDecimal.ROUND_HALF_UP);
        if(todayRebateAmount.compareTo(new BigDecimal(0)) == 1 && shopKeeper.getResellerSid() != null){
            ResellerRebate resellerRebate = new ResellerRebate();
            resellerRebate.setAmount(todayRebateAmount);
            resellerRebate.setResellerSid(shopKeeper.getResellerSid());
            repository.save(resellerRebate);
        }
    }
}
