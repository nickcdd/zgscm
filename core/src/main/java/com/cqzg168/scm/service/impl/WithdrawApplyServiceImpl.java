package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.WithdrawApply;
import com.cqzg168.scm.domain.WithdrawApplyVO;
import com.cqzg168.scm.repository.WithdrawApplyRepository;
import com.cqzg168.scm.service.ManagerService;
import com.cqzg168.scm.service.WithdrawApplyService;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.Predicate;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class WithdrawApplyServiceImpl extends BaseServiceImpl<WithdrawApply, WithdrawApplyRepository> implements WithdrawApplyService {
    private WithdrawApplyRepository repository;

    @Autowired
    ManagerService managerService;

    @Autowired
    @Override
    public void setRepository(WithdrawApplyRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public Page<WithdrawApply> findByPage(String q, String startDate, String endDate, int status, Pageable pageable) {

        DateUtil timeUtil = new DateUtil();

        Specification<WithdrawApply> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("status"), status));
            if (!Utils.isEmpty(startDate) && !Utils.isEmpty(endDate)) {
                try {
                    Date dateStrat = DateUtil.stringToDate(startDate, "yyyy-MM-dd HH:mm");
                    Date dateEnd = DateUtil.stringToDate(endDate, "yyyy-MM-dd HH:mm");
                    predicates.add(cb.between(root.get("createTime"), dateStrat, dateEnd));

                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }

            if (!Utils.isEmpty(q)) {
                predicates.add(cb.like(root.get("shopKeeperCname"), "%" + q + "%"));
            }


            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    @Override
    public Page<WithdrawApply> findByCashRecordPage(String startTime, String endTime, int status, Long sid, Pageable pageable) {
        SimpleDateFormat sdf = new SimpleDateFormat(Constant.STR_FULL_DATE_TIME);
        Specification<WithdrawApply> specification = (root, query, cb) -> {
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
            predicates.add(cb.equal(root.get("shopKeeperSid"), sid));
            predicates.add(cb.equal(root.get("status"), status));
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    @Override
    public List<WithdrawApplyVO> getWithdrawApplyVO(List<WithdrawApply> list) {
        List<WithdrawApplyVO> resultList = new ArrayList<>();
        for (WithdrawApply wa : list) {
            WithdrawApplyVO withdrawApplyVO = new WithdrawApplyVO();
            withdrawApplyVO.setAmount(wa.getAmount());
            withdrawApplyVO.setBankName(wa.getBankName());
            withdrawApplyVO.setCardNo(wa.getCardNo());
            withdrawApplyVO.setCreateTime(wa.getCreateTime());
            withdrawApplyVO.setReason(wa.getReason());
            withdrawApplyVO.setShopKeeperSid(wa.getSid());
            withdrawApplyVO.setStatus(wa.getStatus());
            withdrawApplyVO.setShopKeeperCname(wa.getShopKeeperCname());
            if (!Utils.isNull(wa.getManagerSid())) {
                withdrawApplyVO.setManagerName(this.managerService.findOne(wa.getManagerSid()).getUsername());
            } else {
                withdrawApplyVO.setManagerName("");
            }
            resultList.add(withdrawApplyVO);
        }
        return resultList;
    }

    /**
     * 单商户 当天的提现总金额
     *
     * @param startTime
     * @param endTime
     * @param shopkeeperSid
     * @return
     */
    @Override
    public BigDecimal todayWithdrawApplyMoney(Date startTime, Date endTime, Long shopkeeperSid) {
        return repository.todayWithdrawApplyMoney(startTime, endTime, shopkeeperSid);
    }
}
