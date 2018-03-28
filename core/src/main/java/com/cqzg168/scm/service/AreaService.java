package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Area;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface AreaService extends BaseService<Area> {
    /**
     * 查询
     *
     * @param parentSid 上级id
     * @return
     */
    List<Area> findByParentSid(Long parentSid);

    /**
     * 查询省
     *
     * @param cname
     * @param type
     * @return
     */
    Area findProviceByCnameAndType(String cname, int type);

    /**
     * 查询市、区
     *
     * @param parentSid
     * @param cname
     * @param type
     * @return
     */
    Area findAreaByParentIdAndTypeAndCname(Long parentSid, String cname, int type);
}
