package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Role;
import com.cqzg168.scm.repository.RoleRepository;
import com.cqzg168.scm.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by jackytsu on 2017/3/15.
 */
@Service
@Transactional
public class RoleServiceImpl extends BaseServiceImpl<Role, RoleRepository> implements RoleService {

    private RoleRepository repository;

    @Autowired
    @Override
    public void setRepository(RoleRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }
}
