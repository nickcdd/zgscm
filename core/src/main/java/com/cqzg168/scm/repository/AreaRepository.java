package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.Area;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


/**
 * 地区数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface AreaRepository extends BaseRepository<Area> {
    /**
     * @param parentSid 上级id
     * @return
     */
    @Query("select a from  Area a where a.parentSid = ?1 and a.status =1 and a.open = 1 ")
    List<Area> findByParentSid(Long parentSid);

    /**
     * 查询省
     *
     * @param cname
     * @param type
     * @return
     */
    @Query("select a from  Area a where a.cname = ?1 and a.status =1 and a.type= ?2")
    Area findProviceByCnameAndType(String cname, int type);

    /**
     * 查询市、区
     *
     * @param parentSid
     * @param cname
     * @param type
     * @return
     */
    @Query("select a from  Area a where a.parentSid= ?1 and a.cname = ?2 and a.status =1 and a.type= ?3")
    Area findAreaByParentIdAndTypeAndCname(Long parentSid, String cname, int type);

}
