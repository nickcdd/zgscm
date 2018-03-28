package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.repository.GoodsRepository;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class GoodsServiceImpl extends BaseServiceImpl<Goods, GoodsRepository> implements GoodsService {
    @Autowired
    private GoodsLogService           goodsLogService;

    private GoodsRepository repository;

    @PersistenceContext
    private EntityManager em;

    @Autowired
    @Override
    public void setRepository(GoodsRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public Page<Goods> findGoodsByPage(Long supplierSid, String q, String bigCategory, String smallCategory, String price, Integer freeGoods, List<Integer> defaultStatus, Integer status, Pageable pageable) {

        Specification<Goods> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (!Utils.isNull(status)) {
                predicates.add(cb.equal(root.get("status"), status));
            } else {
                if (!Utils.isEmpty(defaultStatus) && defaultStatus.size() > 0) {
                    CriteriaBuilder.In<Integer> in = cb.in(root.get("status"));
                    for (Integer integer : defaultStatus) {
                        in.value(integer);
                    }
                    predicates.add(in);
                }
            }
            if (!Utils.isNull(freeGoods)) {
                predicates.add(cb.equal(root.get("freeGoods"), freeGoods));
            }

            if (!Utils.isEmpty(q)) {
                predicates.add(cb.like(root.get("cname"), "%" + q + "%"));
            }
            if (!Utils.isEmpty(bigCategory)) {
                Path<GoodsCategory> goodsCategoryOne = root.get("goodsCategoryOne");
                predicates.add(cb.equal(goodsCategoryOne.get("sid"), bigCategory));
            }
            if (!Utils.isEmpty(smallCategory)) {
                Path<GoodsCategory> goodsCategoryTwo = root.get("goodsCategoryTwo");
                predicates.add(cb.equal(goodsCategoryTwo.get("sid"), smallCategory));
            }
            if (!Utils.isNull(supplierSid)) {
                Path<Supplier> supplierPath = root.get("supplier");
                predicates.add(cb.equal(supplierPath.get("sid"), supplierSid));
            }

            return query.where(predicates.toArray(new Predicate[] {})).getRestriction();
        };
        return repository.findAll(specification, pageable);
    }

    @Override
    public Page<Goods> findAllGoodsPage(String cname, String bigCategory, String smallCategory, Integer status, Pageable pageable) {
        Specification<Goods> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("status"), status));
            if (!Utils.isEmpty(cname)) {
                predicates.add(cb.like(root.get("cname"), "%" + cname + "%"));
            }
            if (!Utils.isEmpty(bigCategory)) {
                Path<GoodsCategory> goodsCategoryBig = root.get("goodsCategoryOne");
                predicates.add(cb.equal(goodsCategoryBig.get("sid"), Long.parseLong(bigCategory)));
            }
            if (!Utils.isEmpty(smallCategory)) {
                Path<GoodsCategory> goodsCategoryBig = root.get("goodsCategoryTwo");
                predicates.add(cb.equal(goodsCategoryBig.get("sid"), Long.parseLong(smallCategory)));
            }
            return query.where(predicates.toArray(new Predicate[] {})).getRestriction();
        };
        return repository.findAll(specification, pageable);
    }

    @Override
    public Page<Goods> findBySuppliergoodsPage(String cname, Long supplierSid, Integer status, Pageable pageable) {
        Specification<Goods> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("status"), status));
            Path<Supplier> supplierPath = root.get("supplier");
            predicates.add(cb.equal(supplierPath.get("sid"), supplierSid));
            if (!Utils.isEmpty(cname)) {
                predicates.add(cb.like(root.get("cname"), "%" + cname + "%"));
            }
            return query.where(predicates.toArray(new Predicate[] {})).getRestriction();
        };
        return repository.findAll(specification, pageable);
    }

    @Override
    public Page<Goods> findBycategorySid(String cname, Long categorySid, Integer status, Pageable pageable) {
        Specification<Goods> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("status"), status));
            if (!Utils.isEmpty(cname)) {
                predicates.add(cb.like(root.get("cname"), "%" + cname + "%"));
            }
            if (!Utils.isNull(categorySid)) {
                Path<GoodsCategory> goodsCategoryTwo = root.get("goodsCategoryTwo");
                predicates.add(cb.equal(goodsCategoryTwo.get("sid"), categorySid));
            }
            return query.where(predicates.toArray(new Predicate[] {})).getRestriction();
        };
        return repository.findAll(specification, pageable);
    }

    @Override
    public boolean batchUpdateStatus(Long managerSid, List<Long> goodsSids, Integer status, String note) {
        try {
            List<Goods> goodsList = repository.findAll(goodsSids);
            if (!Utils.isEmpty(goodsList)) {
                for (Goods goods : goodsList) {
                    Integer srcStatus = goods.getStatus();
                    goods.setStatus(status);
                    repository.save(goods);
                    goodsLogService.writeGoodsLog(managerSid, goods.getSid(), srcStatus, status, note);
                }
            }
        } catch (Exception e) {

        }
        return false;
    }

    @Override
    public List<Goods> findByUnifiedCode(String unifiedCode) {
        return repository.findByUnifiedCode(unifiedCode);
    }


    @Override
    public List<Goods> findByGoodsName(String goodsName) {
        return repository.findByGoodsName(goodsName);
    }

    @Override
    public List<Goods> findByLikeGoodsName(String goodsName,Long supplierSid) {

        return repository.findByLikeGoodsName(goodsName,supplierSid);
    }

    @Override
    public Goods findBySid(Long sid) {
        return repository.findBySid(sid);
    }

    @Override
    public List<Goods> findByCname(String cname) {
        return repository.findByCname(cname);
    }

}
