package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.GoodsCategory;
import com.cqzg168.scm.repository.GoodsCategoryRepository;
import com.cqzg168.scm.service.GoodsCategoryService;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class GoodsCategoryServiceImpl extends BaseServiceImpl<GoodsCategory, GoodsCategoryRepository> implements GoodsCategoryService {
    private GoodsCategoryRepository repository;

    @Autowired
    @Override
    public void setRepository(GoodsCategoryRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public Page<GoodsCategory> findByPage(String q, int status, Pageable pageable) {
        Specification<GoodsCategory> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("status"), status));


            if (!Utils.isEmpty(q)) {
                predicates.add(cb.like(root.get("cname"), "%" + q + "%"));
            }


            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    @Override
    public List<GoodsCategory> findGoodsCategory(Long sid, Long parentSid, Integer status) {
        Specification<GoodsCategory> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (!Utils.isNull(sid)) {


                predicates.add(cb.equal(root.get("sid"), sid));
            }
            if (!Utils.isNull(parentSid)) {
                predicates.add(cb.equal(root.get("parentSid"), parentSid));
            }

            if (!Utils.isNull(status)) {
                predicates.add(cb.equal(root.get("status"), status));
            }


            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };
        return repository.findAll(specification);
    }

    @Override
    public List<GoodsCategory> findByParentSid(Long parentSid) {
        return repository.findByParentSid(parentSid);
    }

    @Override
    public List<GoodsCategory> findByParentSidAndStatus(Long parentSid, int status) {
        return repository.findByParentSidAndStatus(parentSid, status);
    }

    @Override
    public List<GoodsCategory> findByCname(String cname) {
        return repository.findByCname(cname);
    }


}
