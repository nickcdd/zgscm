package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.GoodsCategory;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 商品分类数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface GoodsCategoryRepository extends BaseRepository<GoodsCategory> {
    /**
     * @param parentSid 上级id
     * @return
     */
    @Query("select c from  GoodsCategory c where c.parentSid = ?1  ")
    List<GoodsCategory> findByParentSid(Long parentSid);

    /**
     * 根据上级id和状态查询
     *
     * @param parentSid
     * @param status
     * @return
     */
    @Query("select c from  GoodsCategory c where c.parentSid = ?1 and c.status =?2 ")
    List<GoodsCategory> findByParentSidAndStatus(Long parentSid, int status);

    List<GoodsCategory> findByCname(String cname);
}
