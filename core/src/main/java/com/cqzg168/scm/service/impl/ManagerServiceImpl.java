package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Manager;
import com.cqzg168.scm.domain.Role;
import com.cqzg168.scm.repository.ManagerRepository;
import com.cqzg168.scm.service.ManagerService;
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
 * Created by jackytsu on 2017/3/15.
 */
@Service
@Transactional
public class ManagerServiceImpl extends BaseServiceImpl<Manager, ManagerRepository> implements ManagerService {

    private ManagerRepository repository;

    @Override
    public Manager findByUsernameAndPassword(String username, String password) {
        return repository.findByUsernameAndPassword(username, password);
    }

    @Override
    public Page<Manager> findByPage(String q, Pageable pageable) {
        Specification<Manager> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (!Utils.isEmpty(q)) {
                Predicate username = cb.like(root.get("username"), "%" + q + "%");
                Predicate cname    = cb.like(root.get("cname"), "%" + q + "%");
                predicates.add(cb.or(username, cname));
            }

            return query.where(predicates.toArray(new Predicate[] {})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    @Override
    public Manager save(Manager manager) {
        List<Role> roleList = new ArrayList<>();
        for (Role role : manager.getRoleList()) {
            if (role.getSid() != null) {
                roleList.add(role);
            }
        }

        manager.setRoleList(roleList);

        return super.save(manager);
    }

    @Autowired
    @Override
    public void setRepository(ManagerRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }
}
