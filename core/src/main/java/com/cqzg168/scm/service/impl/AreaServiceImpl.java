package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Area;
import com.cqzg168.scm.repository.AreaRepository;
import com.cqzg168.scm.service.AreaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class AreaServiceImpl extends BaseServiceImpl<Area, AreaRepository> implements AreaService {
    private AreaRepository repository;

    @Autowired
    @Override
    public void setRepository(AreaRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public List<Area> findByParentSid(Long parentSid) {

        return repository.findByParentSid(parentSid);
    }

    @Override
    public Area findProviceByCnameAndType(String cname, int type) {
        return repository.findProviceByCnameAndType(cname, type);
    }

    @Override
    public Area findAreaByParentIdAndTypeAndCname(Long parentSid, String cname, int type) {
        return repository.findAreaByParentIdAndTypeAndCname(parentSid, cname, type);
    }

}
