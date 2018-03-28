package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Storage;
import com.cqzg168.scm.repository.StorageRepository;
import com.cqzg168.scm.service.StorageService;
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
public class StorageServiceImpl extends BaseServiceImpl<Storage, StorageRepository> implements StorageService {
    private StorageRepository repository;

    @Autowired
    @Override
    public void setRepository(StorageRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    /**
     * 分页查询 仓储
     * @param cname
     * @param code
     * @param province
     * @param city
     * @param area
     * @param pageable
     * @return
     */
    @Override
    public Page<Storage> findStoragePage(String cname, String code, String province, String city, String area, Pageable pageable) {
        Specification<Storage> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("status"),1));
            if(!Utils.isEmpty(cname)){
                predicates.add(cb.like(root.get("cname"),"%"+cname+"%"));
            }
            if(!Utils.isEmpty(code)){
                predicates.add(cb.equal(root.get("code"),code));
            }
            if(!Utils.isEmpty(province)){
                predicates.add(cb.equal(root.get("province"),province));
            }
            if(!Utils.isEmpty(city)){
                predicates.add(cb.equal(root.get("city"),city));
            }
            if(!Utils.isEmpty(area)){
                predicates.add(cb.equal(root.get("area"),area));
            }
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };
        return repository.findAll(specification, pageable);
    }
}
